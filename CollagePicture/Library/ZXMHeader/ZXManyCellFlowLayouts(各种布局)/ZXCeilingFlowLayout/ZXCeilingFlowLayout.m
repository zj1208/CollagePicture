//
//  ZXCeilingFlowLayout.m
//  YiShangbao
//
//  Created by simon on 17/1/23.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXCeilingFlowLayout.h"

@implementation ZXCeilingFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
//    UIEdgeInsets inset = self.collectionView.contentInset;
//    self.itemSize = CGSizeMake(kCollectionViewWidth - inset.right - inset.left, kCellHeight);
    self.minimumLineSpacing = [self getMinimumInteritemSpacingForSectionAtIndex:0];
}
- (CGFloat)getMinimumInteritemSpacingForSectionAtIndex:(NSInteger)sectionIndex
{
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)])
    {
        id<UICollectionViewDelegateFlowLayout>delegate = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
        return [delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:sectionIndex];
    }
    return -10;
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *mAttributes = [super layoutAttributesForElementsInRect:rect];
    //    NSLog(@"%@",attributes);
    __weak __typeof(self)weakSelf = self;
    [mAttributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [weakSelf recomputeCellAttributesFrame:obj];
    }];
    return mAttributes;
}
//由于cell在滑动过程中会不断修改cell的位置，所以需要不断重新计算所有布局属性的信息
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (void)recomputeCellAttributesFrame:(UICollectionViewLayoutAttributes *)attributes
{
    //   {{0, -64}, {375, 667}}, {{0, 0}, {375, 667}}
    //    NSLog(@"%@,%@",NSStringFromCGRect(self.collectionView.bounds) ,NSStringFromCGRect(self.collectionView.frame));
    
    // 吸顶效果，当一个item滑到顶部最小Y值时候，固定frame大小，不让移动，大于最小Y值顶部的时候，效果不变；
    
    CGFloat minY = CGRectGetMinY(self.collectionView.bounds) + self.collectionView.contentInset.top;
    //拿到布局属性应该出现的位置；
    CGFloat finalY = MAX(minY, attributes.frame.origin.y);
    
    CGPoint origin = attributes.frame.origin;
    origin.y = finalY;
    
    attributes.frame = (CGRect){origin,attributes.frame.size};
    
    // 下一个item覆盖上一个item之上； 根据IndexPath设置zIndex能确立顶部悬停的cell被后来的cell覆盖的层级关系
    attributes.zIndex = attributes.indexPath.item;
}


@end
