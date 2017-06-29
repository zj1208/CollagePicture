//
//  ZXAddBigPicCollectionView.m
//  YiShangbao
//
//  Created by simon on 17/5/19.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXAddBigPicCollectionView.h"


#define DeleteBtnWidth  36.f
#define DeleteBtnHeight 36.f
#define Section1InsetMagin   89.f
#define Section2InsetMagin   26.f
#define Section2PicToPicMangin 50.f
#define Section1HeaderHeight   18.f
#define Section2HeaderHeight   32.f

#ifndef UIColorFromRGB_HexValue
#define UIColorFromRGB_HexValue(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbValue & 0xFF))/255.0f alpha:1.f]
#endif

static NSString * const reuseIdentifier = @"Cell";



@interface ZXAddBigPicCollectionView ()

@property (nonatomic, strong)NSMutableArray *section1MArray;
@property (nonatomic, strong)NSMutableArray *section2MArray;

@property (nonatomic, strong)NSIndexPath *editIndexPath;
@end

@implementation ZXAddBigPicCollectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib
{
    self.delegate = self;
    self.dataSource = self;
    
    NSMutableArray *mArr = [NSMutableArray array];
    self.section1MArray = mArr;
    
    NSMutableArray *mArr2 = [NSMutableArray array];
    self.section2MArray = mArr2;

    [super awakeFromNib];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (section ==0)
    {
        return 1;
    }
    return 4;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0)
    {
        CGFloat width = floorf(LCDW-LCDScale_iphone6_Width(Section1InsetMagin)*2);
        return CGSizeMake(width, width);
    }
    CGFloat picToPicWidth =(Section2PicToPicMangin-DeleteBtnWidth/2);
    CGFloat width2 = floorf((LCDW-2*Section2InsetMagin+DeleteBtnWidth/2-picToPicWidth)/2);
    return CGSizeMake(width2, width2);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section ==1)
    {
        return CGSizeMake(0, Section2HeaderHeight-DeleteBtnWidth/2);
    }
    //最小应该是一半删除按钮的高度；
    CGFloat headerHeight = Section1HeaderHeight-DeleteBtnWidth/2;
    if (headerHeight<0)
    {
        headerHeight = 0.1f;
    }
    return CGSizeMake(0, headerHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section ==0)
    {
        CGFloat magin =floorf(LCDScale_iphone6_Width(Section1InsetMagin));
        return UIEdgeInsetsMake(0, magin+DeleteBtnWidth/4, 0, magin-DeleteBtnWidth/4);
    }
    return UIEdgeInsetsMake(0, Section2InsetMagin, 0, Section2InsetMagin-DeleteBtnWidth/2);;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZXAddProPicCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (indexPath.section ==0)
    {
        if (self.section1MArray.count >indexPath.item)
        {
            [cell setData:[self.section1MArray objectAtIndex:indexPath.item]];
        }
        else
        {
            [cell setData:[NSNull null]];
        }
        cell.itemView.origTitleLab.text = @"上传主图";
    }
    else
    {
        if (self.section2MArray.count>indexPath.item)
        {
            [cell setData:[self.section2MArray objectAtIndex:indexPath.item]];
        }
        else
        {
            [cell setData:[NSNull null]];
        }
        cell.itemView.origTitleLab.text = @"上传细节图";
    }
    
    [cell.itemView.picBtn addTarget:self action:@selector(uploadPic:) forControlEvents:UIControlEventTouchUpInside];
    cell.itemView.delegate = self;
    // Configure the cell
    cell.backgroundColor = [UIColor redColor];
    return cell;
}


- (void)zxDeleteBtnAction:(UIButton *)sender
{
    NSLog(@"删除照片1");
    NSIndexPath *indexPath = [sender zh_getIndexPathWithBtnInCellFromTableViewOrCollectionView:self];
    if (indexPath.section ==0)
    {
        [_section1MArray removeAllObjects];
        //        [_section1MArray replaceObjectAtIndex:0 withObject:[NSNull null]];
    }
    else
    {
        [_section2MArray removeObjectAtIndex:indexPath.item];
        //        [_section2MArray replaceObjectAtIndex:indexPath.item withObject:[NSNull null]];
    }
    [self reloadData];

}

- (void)reloadData
{
    if ([self.zxdataSource respondsToSelector:@selector(ZXAddBigPicCollectionViewSection1Marray)])
    {
        self.section1MArray = [self.zxdataSource ZXAddBigPicCollectionViewSection1Marray];
    }
    if ([self.zxdataSource respondsToSelector:@selector(ZXAddBigPicCollectionViewSection2Marray)])
    {
        self.section2MArray = [self.zxdataSource ZXAddBigPicCollectionViewSection2Marray];
    }
    [super reloadData];
}

- (void)uploadPic:(UIButton *)sender
{
    NSIndexPath *index = [sender zh_getIndexPathWithBtnInCellFromTableViewOrCollectionView:self];
    self.editIndexPath = index;
    NSLog(@"indexPath =%@,section:%ld,row=%ld",self.editIndexPath,(long)self.editIndexPath.section,self.editIndexPath.item);
    if (_uploadPicBtnActionBlock)
    {
        _uploadPicBtnActionBlock(self.editIndexPath);
    }
//    [self.morePickerVCManager zxPresentActionSheetToMoreUIImagePickerControllerFromSourceController:self];
}


@end
