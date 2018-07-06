//
//  ZXMenuIconCollectionView.m
//  YiShangbao
//
//  Created by simon on 2017/10/23.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXMenuIconCollectionView.h"
#import "UIImageView+WebCache.h"

#ifndef SCREEN_WIDTH
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#endif

#ifndef SCREEN_MAX_LENGTH
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#endif

//设置iphone6尺寸比例/竖屏,UI所有设备等比例缩放
#ifndef LCDScale_iPhone6_Width
#define LCDScale_iPhone6_Width(X)    ((X)*SCREEN_MIN_LENGTH/375)
#endif


static CGFloat const ZXMinimumInteritemSpacing = 12.f;//item之间最小间隔
static CGFloat const ZXMinimumLineSpacing = 12.f; //最小行间距
static CGFloat const ZXItemWidth = 45.f;
static CGFloat const ZXItemHeight = 45.f;
static NSString * const reuseTagsCell = @"Cell";

@implementation ZXMenuIconCollectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit];
    }
    return self;
}
// 会执行2次，有问题；
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.backgroundColor = [UIColor whiteColor];
    self.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    self.minimumInteritemSpacing = ZXMinimumInteritemSpacing;
    self.minimumLineSpacing = ZXMinimumLineSpacing;
    self.itemSize = CGSizeMake(LCDScale_iPhone6_Width(ZXItemWidth), LCDScale_iPhone6_Width(ZXItemHeight));
    [self addSubview:self.collectionView];
    self.clipsToBounds = YES;
    self.clearsContextBeforeDrawing = YES;
    
//    self.collectionView.backgroundColor = [UIColor orangeColor];
}

#pragma mark - layoutSubviews

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}


- (NSMutableArray *)dataMArray {
    if (_dataMArray == nil) {
        _dataMArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataMArray;
}

- (void)setSectionInset:(UIEdgeInsets)sectionInset
{
    _sectionInset = sectionInset;
    self.collectionFlowLayout.sectionInset = sectionInset;
}

- (void)setMinimumLineSpacing:(CGFloat)minimumLineSpacing
{
    _minimumLineSpacing = minimumLineSpacing;
    self.collectionFlowLayout.minimumLineSpacing = minimumLineSpacing;
}


#pragma mark - UICollectionView

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.sectionInset = self.sectionInset;
        self.collectionFlowLayout = flowLayout;
        
        UICollectionView *collection = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        collection.backgroundColor = [UIColor clearColor];
        collection.delegate = self;
        collection.dataSource = self;
        
        [collection registerNib:[UINib nibWithNibName:NSStringFromClass([ZXMenuIconCell class]) bundle:nil] forCellWithReuseIdentifier:reuseTagsCell];
        collection.scrollEnabled = NO;
        
        _collectionView = collection;
    }
    return _collectionView;
}



#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataMArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZXMenuIconCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseTagsCell forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor redColor];
    if (indexPath.item<self.dataMArray.count)
    {
        id data = [self.dataMArray objectAtIndex:indexPath.item];
        if ([self.delegate respondsToSelector:@selector(zx_menuIconView: cell:forItemSetData:cellForItemAtIndexPath:)])
        {
            [self.delegate zx_menuIconView:self  cell:cell forItemSetData:data cellForItemAtIndexPath:indexPath];
        }
        else if([data isKindOfClass:[ZXMenuIconModel class]])
        {
            [cell setData:data placeholderImage:self.placeholderImage];
        }
        else
        {
            NSLog(@"传的数据不对应显示");
        }
    }
    return cell;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return self.sectionInset;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return self.minimumLineSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return self.minimumInteritemSpacing;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.flowLayoutDelegate respondsToSelector:@selector(zx_menuIconCollectionView:layout:sizeForItemAtIndexPath:)])
    {
        return [self.flowLayoutDelegate zx_menuIconCollectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    }
    return self.itemSize;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{    
    if ([self.delegate respondsToSelector:@selector(zx_menuIconView:collectionView:didSelectItemAtIndexPath:)])
    {
        [self.delegate zx_menuIconView:self collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
}

- (CGFloat)getItemAverageWidthInTotalWidth:(CGFloat)totalWidth columnsCount:(NSUInteger)count sectionInset:(UIEdgeInsets)inset minimumInteritemSpacing:(CGFloat)minimumInteritemSpacing
{
    CGFloat itemWidth =  (totalWidth - (count-1)*minimumInteritemSpacing-inset.left-inset.right)/count;
    return floorf(itemWidth);
}

#pragma mark - 计算方法

- (NSInteger)getRowsWithDataCount:(NSInteger)count
{
    if (count ==0)
    {
        return 0;
    }
    NSInteger rows = 0; // 行数
    //计算有几行的简单方法
    if (count%self.columnsCount>0)
    {
        NSInteger totalItems = count+(self.columnsCount-(count%self.columnsCount));
        rows = totalItems /self.columnsCount;
    }
    else
    {
        rows = count/self.columnsCount;
    }
    return  rows;
}

- (CGFloat)getCellHeightWithContentData:(NSArray *)data
{
    if ([data count]==0)
    {
        return 0.f;
    }
    CGFloat height = 0;
    NSInteger rows = [self getRowsWithDataCount:data.count];
    //计算高度
    height = rows * self.itemSize.height + (rows - 1) * self.minimumLineSpacing +self.sectionInset.top+self.sectionInset.bottom;
    NSLog(@"个数= %@,高度 = %@",@(data.count), @(height));
    
    return ceilf(height);
}


- (void)setData:(NSArray *)data
{
    if (![self.dataMArray isEqualToArray:data])
    {
        [self.dataMArray removeAllObjects];
        [self.dataMArray addObjectsFromArray:data];
        [self.collectionView reloadData];
    }
}


@end
