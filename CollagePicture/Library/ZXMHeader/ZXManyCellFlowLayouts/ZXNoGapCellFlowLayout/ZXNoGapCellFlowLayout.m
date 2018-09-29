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
    
    NSArray *mAttributes = [super layoutAttributesForElementsInRect:rect];
//    NSLog(@"%@",mAttributes);
    __weak __typeof(self)weakSelf = self;

    [mAttributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([self.delegate respondsToSelector:@selector(ZXNoGapCellFlowLayout:shouldNoGapAtIndexPath:)] && obj.representedElementCategory == UICollectionElementCategoryCell)
        {
            if ([self.delegate ZXNoGapCellFlowLayout:self shouldNoGapAtIndexPath:obj.indexPath])
            {
                [weakSelf recomputeCellAttributesFrame:obj index:idx layoutAttributes:mAttributes];
            }
        }
//        NSLog(@"obj = %@",obj);
       }];
    return mAttributes;
}


- (void)recomputeCellAttributesFrame:(UICollectionViewLayoutAttributes *)attributes index:(NSUInteger)index  layoutAttributes:(NSArray *)mlayoutAttributes
{
    
    UICollectionViewLayoutAttributes *currentLayoutAttributes = attributes;
    UICollectionViewLayoutAttributes *preLayoutAtrributes = [mlayoutAttributes objectAtIndex:index-1];
    NSInteger maximumSpacing = 0;
    NSInteger preX = CGRectGetMaxX(preLayoutAtrributes.frame);
    NSInteger col_idx = currentLayoutAttributes.indexPath.row%self.columnsCount;
    CGFloat itemWidth = CGRectGetWidth(self.collectionView.bounds)/self.columnsCount;
    //如果当前一个cell的最右边加上我们想要的间距加上当前cell的宽度依然在contentSize中，我们改变当前cell的原点位置
    if(preX + maximumSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width)
    {
        CGRect frame = currentLayoutAttributes.frame;
        frame.origin.x = col_idx * itemWidth;
        currentLayoutAttributes.frame = frame;
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
