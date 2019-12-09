//
//  ZXRightSecondLeveMenuListView.m
//  MobileCaiLocal
//
//  Created by simon on 2019/11/27.
//  Copyright © 2019 timtian. All rights reserved.
//

#import "ZXRightSecondLeveMenuListView.h"
#import "ZXRightSecondLevelCollectionCell.h"

@implementation ZXRightSecondLeveMenuListView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initUIAndData];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initUIAndData];
    }
    return self;
}


- (void)initUIAndData
{
    [self addSubview:self.collectionView];
    self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.minimumInteritemSpacing = 10;
    self.minimumLineSpacing = 10;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

- (CGFloat)getItemAverageWidthInTotalWidth:(CGFloat)totalWidth columnsCount:(NSUInteger)count sectionInset:(UIEdgeInsets)inset minimumInteritemSpacing:(CGFloat)minimumInteritemSpacing
{

    CGFloat itemWidth =  (totalWidth - (count-1)*minimumInteritemSpacing-inset.left-inset.right)/count;
    return floorf(itemWidth);
}


- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//        flowLayout.sectionInset = self.sectionInset;
//        flowLayout.minimumInteritemSpacing = self.minimumInteritemSpacing;
//        flowLayout.minimumLineSpacing = self.minimumLineSpacing;
//        flowLayout.itemSize = self.itemSize;
        
        UICollectionView *collection = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        collection.backgroundColor = [UIColor whiteColor];
        collection.delegate = self;
        collection.dataSource = self;
        collection.alwaysBounceVertical = YES;
        
        [collection registerClass:[ZXRightSecondLevelCollectionCell class] forCellWithReuseIdentifier:@"Cell"];

        _collectionView = collection;
    }
    return _collectionView;
}


#pragma  mark -

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([self.dataSource respondsToSelector:@selector(zx_rightSecondLeveMenuListView:numberOfRowsInSection:)]) {
        return [self.dataSource zx_rightSecondLeveMenuListView:self numberOfRowsInSection:section];
    }
    return  0;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZXRightSecondLevelCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if ([self.dataSource respondsToSelector:@selector(zx_rightSecondLeveMenuListView:titleForRowAtIndexPath:)]) {
       NSString *title = [self.dataSource zx_rightSecondLeveMenuListView:self titleForRowAtIndexPath:indexPath];
        cell.titleLabel.text =title;
    }
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(zx_rightSecondLeveMenuListView:isSelectItemAtIndexPath:)]) {
        cell.selected = [self.delegate zx_rightSecondLeveMenuListView:self isSelectItemAtIndexPath:indexPath];
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.itemSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return self.sectionInset;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return self.minimumLineSpacing;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(zx_rightSecondLeveMenuListView:didSelectItemAtIndexPath:)])
    {
        [self.delegate zx_rightSecondLeveMenuListView:self didSelectItemAtIndexPath:indexPath];
    }
}

@end
