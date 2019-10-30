//
//  ZXCeilingFlowLayout.h
//  YiShangbao
//
//  Created by simon on 17/1/23.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  简介：吸顶效果和覆盖效果；
//  吸顶效果：当第一个item滑到顶部最小Y值时候，会固定frame大小在那个位置，不让移动；大于最小Y值顶部的第二个item覆盖第一个item往上滑，直到也遇到最小Y值时候，固定frame大小在顶部，后面的item一样；
//  覆盖效果，后一个item一部分高度覆盖上一个item；
//  主要用于卡片等效果；判断布局属性frame小于布局顶部的y值，就将布局属性的frame的y值设置为顶部的y值固定；

// 2017.12.27 注释添加
// 2019.3.28  优化代码；

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface ZXCeilingFlowLayout : UICollectionViewFlowLayout

@end

NS_ASSUME_NONNULL_END

/*
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    
    cell.backgroundColor = UIColorFromRGB([NSString zhGetRandomNumberWithFrom:0.f to:255.f], [NSString zhGetRandomNumberWithFrom:0.f to:255.f], 255);
    [cell zx_setCornerRadius:5 borderWidth:1 borderColor:nil];
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return -6;
}
#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(LCDW, 100);
}
*/
