//
//  ZXCollectionViewLeftAlignedLayout.m
//  YZL
//
//  Created by simon on 2019/1/29.
//  Copyright © 2019 YZL. All rights reserved.
//

#import "ZXCollectionViewLeftAlignedLayout.h"

@implementation ZXCollectionViewLeftAlignedLayout


- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *originalAttributesArray = [super layoutAttributesForElementsInRect:rect];
    
    NSMutableArray *updatedAttributesMArray = [NSMutableArray arrayWithArray:originalAttributesArray];
    
    for (UICollectionViewLayoutAttributes *layoutAttributes in originalAttributesArray)
    {
//      如果是cell
        if (!layoutAttributes.representedElementKind)
        {
            NSUInteger index = [updatedAttributesMArray indexOfObject:layoutAttributes];
            UICollectionViewLayoutAttributes *currentItemAttributs = [self layoutAttributesForItemAtIndexPath:layoutAttributes.indexPath];
            [updatedAttributesMArray setObject:currentItemAttributs atIndexedSubscript:index];
        }
    }
    return updatedAttributesMArray;
}


- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *currentItemAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    UIEdgeInsets sectionInset = [self getSectionInsetForItemAtIndex:indexPath.section];
    BOOL isFirstItemInSection = indexPath.item == 0;
//  第一个item重新设置frame,保证是最左边开始布局
    if (isFirstItemInSection)
    {
        [self leftAlignFrameWithLayoutAttributes:currentItemAttributes sectionInset:sectionInset];
        return currentItemAttributes;
    }
    
    CGFloat layoutWidth = CGRectGetWidth(self.collectionView.frame)- sectionInset.left - sectionInset.right;
    NSIndexPath *previousIndexPath =  [NSIndexPath indexPathForItem:indexPath.item-1 inSection:indexPath.section];
    CGRect previousFrame = [self layoutAttributesForItemAtIndexPath:previousIndexPath].frame;
    CGFloat previousFrameRightPoint = CGRectGetMaxX(previousFrame);
    CGRect currentFrame = currentItemAttributes.frame;
    CGRect strecthedCurrentFrame = CGRectMake(sectionInset.left, currentFrame.origin.y, layoutWidth, currentFrame.size.height);
    //    如果当前帧(左对齐到左并延伸到完整集合视图宽度)与前一帧相交，则它们在同一条线上;Y坐标是否相同在同一行；
    BOOL isTowItemsTheSameLine = CGRectIntersectsRect(previousFrame, strecthedCurrentFrame);
//    如果不在同一行,当前这个item左对齐
    if (!isTowItemsTheSameLine)
    {
        [self leftAlignFrameWithLayoutAttributes:currentItemAttributes sectionInset:sectionInset];
        return currentItemAttributes;
    }
    
    CGRect frame = currentItemAttributes.frame;
    frame.origin.x = previousFrameRightPoint + [self getMinimumInteritemSpacingForSectionAtIndex:indexPath.section];
    currentItemAttributes.frame = frame;
    return currentItemAttributes;
}

// 获取minimumInteritemSpacing
- (CGFloat)getMinimumInteritemSpacingForSectionAtIndex:(NSInteger)sectionIndex
{
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)])
    {
        id<UICollectionViewDelegateFlowLayout>delegate = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
        return [delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:sectionIndex];
    }
    return self.minimumInteritemSpacing;
}

// 获取sectionInset
- (UIEdgeInsets)getSectionInsetForItemAtIndex:(NSInteger)index
{
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)])
    {
        id<UICollectionViewDelegateFlowLayout>delegate = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
        return [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:index];
    }
    return self.sectionInset;
}


- (void)leftAlignFrameWithLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes sectionInset:(UIEdgeInsets)sectionInset
{
    CGRect frame = layoutAttributes.frame;
    frame.origin.x = sectionInset.left;
    layoutAttributes.frame = frame;
}
@end
