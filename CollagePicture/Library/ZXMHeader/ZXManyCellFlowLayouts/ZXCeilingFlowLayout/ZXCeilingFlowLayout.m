//
//  ZXCeilingFlowLayout.m
//  YiShangbao
//
//  Created by simon on 17/1/23.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXCeilingFlowLayout.h"

@implementation ZXCeilingFlowLayout

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
    CGFloat minY = CGRectGetMinY(self.collectionView.bounds) + self.collectionView.contentInset.top;
    //拿到布局属性应该出现的位置；
    CGFloat finalY = MAX(minY, attributes.frame.origin.y);
    
    CGPoint origin = attributes.frame.origin;
    origin.y = finalY;
    
    attributes.frame = (CGRect){origin,attributes.frame.size};
    //     根据IndexPath设置zIndex能确立顶部悬停的cell被后来的cell覆盖的层级关系
    attributes.zIndex = attributes.indexPath.row;
}


@end
