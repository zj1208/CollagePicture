//
//  ZXNoGapCellFlowLayout.m
//  YiShangbao
//
//  Created by simon on 2017/8/29.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXNoGapCellFlowLayout.h"

static NSInteger const ZXColumnsCount = 4;


@implementation ZXNoGapCellFlowLayout


- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setInit];
    }
    return self;
}

- (void)setInit
{
    self.columnsCount = ZXColumnsCount;
}


- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    NSArray *originalAttributes = [super layoutAttributesForElementsInRect:rect];
//    NSLog(@"%@",mAttributes);
    __weak __typeof(self)weakSelf = self;

    [originalAttributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([self.delegate respondsToSelector:@selector(ZXNoGapCellFlowLayout:shouldNoGapAtIndexPath:)] && obj.representedElementCategory == UICollectionElementCategoryCell)
        {
            if ([self.delegate ZXNoGapCellFlowLayout:self shouldNoGapAtIndexPath:obj.indexPath])
            {
                [weakSelf recomputeCellAttributesFrame:obj index:idx layoutAttributes:originalAttributes];
            }
        }
//        NSLog(@"obj = %@",obj);
       }];
    return originalAttributes;
}


- (void)recomputeCellAttributesFrame:(UICollectionViewLayoutAttributes *)currentAttributes index:(NSUInteger)index  layoutAttributes:(NSArray *)originalAttributes
{
//  当前layoutAttributes
    UICollectionViewLayoutAttributes *currentItemAttributes = currentAttributes;
    UICollectionViewLayoutAttributes *previousItemLayoutAtrributes = [originalAttributes objectAtIndex:index-1];
    
    NSInteger maximumSpacing = 0;
    CGFloat previousFrameRightPoint = CGRectGetMaxX(previousItemLayoutAtrributes.frame);
////  当前item是第几列
//    NSInteger column_idx = currentItemAttributes.indexPath.row%self.columnsCount;
//    CGFloat itemWidth = CGRectGetWidth(self.collectionView.bounds)/self.columnsCount;
//  判断上一个item和当前item是否在同一行，如果上一个item的最右边+我们想要的间距+当前cell的宽度依然在contentSize中的同一行，则我们改变当前item的原点位置
    if(previousFrameRightPoint + maximumSpacing + currentItemAttributes.frame.size.width < self.collectionViewContentSize.width)
    {
        CGRect frame = currentItemAttributes.frame;
//        frame.origin.x = column_idx * itemWidth;
        frame.origin.x = previousFrameRightPoint + maximumSpacing;
        currentItemAttributes.frame = frame;
    }
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGRect oldBounds = self.collectionView.bounds;
    if (!CGRectEqualToRect(oldBounds, newBounds))
    {
        return YES;
    }
    return NO;
}

@end
