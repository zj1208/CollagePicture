//
//  ZXCustomCellCollectionView.m
//  YiShangbao
//
//  Created by simon on 2018/1/8.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "ZXCustomCellCollectionView.h"



@interface ZXCustomCellCollectionView ()

@property (nonatomic, strong) NSMutableArray *dataMArray;

@property (strong, nonatomic)  UICollectionViewFlowLayout *collectionFlowLayout;

@property (nonatomic, copy) NSString *customCellReuse;
@end

@implementation ZXCustomCellCollectionView

static CGFloat const ZXMinimumInteritemSpacing = 10.f;//item之间最小间隔
static CGFloat const ZXMinimumLineSpacing = 10.f; //最小行间距

static NSString *const cellReuse_defaultCell = @"Cell";
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

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}


- (void)commonInit
{
    self.backgroundColor = [UIColor whiteColor];
    self.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
    self.minimumInteritemSpacing = ZXMinimumInteritemSpacing;
    self.minimumLineSpacing = ZXMinimumLineSpacing;
    self.itemSize = CGSizeMake(45, 45);
    
    [self addSubview:self.collectionView];
    
    self.scrollEnabled = NO;
    
    self.clipsToBounds = YES;
    self.clearsContextBeforeDrawing = YES;
    self.collectionView.scrollEnabled = self.scrollEnabled;
//    self.collectionView.backgroundColor = [UIColor orangeColor];
}

- (void)registerClassWithCollectionViewCell:(ZXCustomCollectionBaseCell <ZXCustomCollectionBaseCellProtocol>*)collectionViewCell forCellWithReuseIdentifier:(NSString *)identifier
{
    [self.collectionView registerClass:collectionViewCell.class forCellWithReuseIdentifier:identifier];
    self.customCellReuse = identifier;
}

- (void)registerNib:(nullable UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier
{
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
    self.customCellReuse = identifier;
}

- (NSMutableArray *)dataMArray
{
    if (!_dataMArray)
    {
        _dataMArray = [NSMutableArray array];
    }
    return _dataMArray;
}

- (void)setScrollEnabled:(BOOL)scrollEnabled
{
    _scrollEnabled = scrollEnabled;
    self.collectionView.scrollEnabled = scrollEnabled;
}

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection
{
    _scrollDirection = scrollDirection;
    self.collectionFlowLayout.scrollDirection = scrollDirection;
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
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.collectionFlowLayout = flowLayout;
        
        UICollectionView *collection = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        collection.alwaysBounceVertical = YES;
        collection.directionalLockEnabled = YES;
        collection.backgroundColor = [UIColor clearColor];
        
        collection.delegate = self;
        collection.dataSource = self;
        
        collection.showsVerticalScrollIndicator = NO;
        collection.showsHorizontalScrollIndicator = NO;
        [collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellReuse_defaultCell];
        
        _collectionView = collection;

    }
    return _collectionView;
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 8;
    return self.dataMArray.count;
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

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.customCellReuse)
    {
        ZXCustomCollectionBaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.customCellReuse forIndexPath:indexPath];
        if ([cell respondsToSelector:@selector(setData:)] && indexPath.item<self.dataMArray.count)
        {
            [cell setData:[self.dataMArray objectAtIndex:indexPath.item]];
        }
        if ([cell respondsToSelector:@selector(setData:withIndexPath:)]&& indexPath.item<self.dataMArray.count)
        {
            [cell setData:[self.dataMArray objectAtIndex:indexPath.item] withIndexPath:indexPath];
        }
        return cell;
    }
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuse_defaultCell forIndexPath:indexPath];
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.dataMArray.count>0)
//    {
//        CGSize size = CGSizeMake((CGRectGetWidth(self.bounds)-self.sectionInset.left-self.sectionInset.right)/2, (CGRectGetHeight(self.bounds)-self.sectionInset.top-self.sectionInset.bottom-self.minimumLineSpacing*(self.dataMArray.count-1))/self.dataMArray.count);
//        if (CGSizeEqualToSize(self.itemSize, CGSizeZero))
//        {
//            return size;
//        }
//    }
    return self.itemSize;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(zx_customCellCollectionView:collectionView:didSelectItemAtIndexPath:)])
    {
        [self.delegate zx_customCellCollectionView:self collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
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
