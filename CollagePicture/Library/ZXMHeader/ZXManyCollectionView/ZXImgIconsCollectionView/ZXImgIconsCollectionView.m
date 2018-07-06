//
//  ZXImgIconsCollectionView.m
//  YiShangbao
//
//  Created by simon on 2017/11/28.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXImgIconsCollectionView.h"
#import "ZXImgIconsCell.h"
#import "UIImageView+WebCache.h"

static NSInteger const ZXMaxItemCount = 10;


static CGFloat const ZXMinimumInteritemSpacing = 8.f;//item之间最小间隔
static CGFloat const ZXMinimumLineSpacing = 12.f; //最小行间距

static CGFloat const ZXAddPicItemWidth = 15.f;
static CGFloat const ZXAddPicItemHeight = 15.f;

static NSString * const reuseCell = @"Cell";


@interface ZXImgIconsCollectionView ()

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionFlowLayout;

@end

@implementation ZXImgIconsCollectionView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

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
    self.backgroundColor = [UIColor clearColor];
    self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.minimumInteritemSpacing = ZXMinimumInteritemSpacing;
    self.minimumLineSpacing = ZXMinimumLineSpacing;
    self.maxItemCount = ZXMaxItemCount;
    self.apportionsItemWidthsByContent = YES;
    self.itemSameSize = CGSizeMake(15.f, 15.f);
    self.iconWidth = ZXAddPicItemWidth;
    self.iconHeight = ZXAddPicItemHeight;
    self.clipsToBounds = YES;
    //    self.backgroundColor = [UIColor greenColor];
    //    self.collectionView.backgroundColor = [UIColor orangeColor];
}



#pragma mark - layoutSubviews

- (void)layoutSubviews
{
    [super layoutSubviews];
//    NSLog(@"self.bounds =%@",NSStringFromCGRect(self.bounds));
}


- (NSMutableArray *)dataMArray {
    if (_dataMArray == nil) {
        _dataMArray = [NSMutableArray array];
    }
    return _dataMArray;
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
        [self addSubview:collection];
        
        [collection registerNib:[UINib nibWithNibName:nibName_ZXImgIconsCell bundle:nil] forCellWithReuseIdentifier:reuseCell];
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
    ZXImgIconsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseCell forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor blueColor];
    ZXImgIcons *icon = [self.dataMArray objectAtIndex:indexPath.item];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:icon.original_pic]];
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeZero;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.apportionsItemWidthsByContent)
    {
        static ZXImgIconsCell *cell =  nil;
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            
            if (cell == nil) {
                cell = [[NSBundle mainBundle]loadNibNamed:nibName_ZXImgIconsCell owner:nil options:nil][0];
            }
        });
        if (self.dataMArray.count>indexPath.item)
        {
            ZXImgIcons *icon = [self.dataMArray objectAtIndex:indexPath.item];
            CGFloat iconWidth = self.iconHeight*(icon.width/icon.height);
            return CGSizeMake(ceilf(iconWidth), self.iconHeight);
        }
    }
    return self.itemSameSize;
}


// 计算collectionView的总高度;前提是self.frame必须有值，不然无法计算；
- (CGSize)sizeWithContentData:(nullable NSArray *)data
{
    if (!data || [data count]==0)
    {
        self.collectionView.frame =CGRectZero;
        return CGSizeZero;
    }
    [self setData:data];

    NSInteger maxIndex = [self.dataMArray count]-1;
    NSIndexPath *itemIndexPath = [NSIndexPath indexPathForItem:maxIndex inSection:0];
    UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:itemIndexPath];
    CGFloat height = CGRectGetMaxY(attributes.frame)+self.sectionInset.bottom;
    CGFloat width = CGRectGetMaxX(attributes.frame) +self.sectionInset.right;
    CGSize size = CGSizeMake(ceilf(width), ceilf(height));
//    NSLog(@"sizeWithContentData:%@",NSStringFromCGSize(size));

    self.collectionView.frame = CGRectMake(0, 0, width, height);
    return size;
}

- (void)setData:(nullable NSArray *)data
{
    if (![self.dataMArray isEqualToArray:data])
    {
        [self.dataMArray removeAllObjects];
        
        if ([data count] > self.maxItemCount)
        {
            NSRange range = NSMakeRange(0, self.maxItemCount);
            NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
            data = [NSMutableArray arrayWithArray:[data objectsAtIndexes:set]];
        };
        
        [self.dataMArray addObjectsFromArray:data];
        self.collectionView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [self.collectionView reloadData];
        
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
