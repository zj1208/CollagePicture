//
//  ZXCeilingFlowLayout.h
//  YiShangbao
//
//  Created by simon on 17/1/23.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
// 2017.12.27
// 注释添加

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//吸顶效果；主要用于卡片等效果；判断布局属性frame小于布局顶部的y值，就将布局属性的frame的y值设置为顶部的y值就行

@interface ZXCeilingFlowLayout : UICollectionViewFlowLayout

@end

NS_ASSUME_NONNULL_END

/*
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    
    cell.backgroundColor = UIColorFromRGB([NSString zhGetRandomNumberWithFrom:0.f to:255.f], [NSString zhGetRandomNumberWithFrom:0.f to:255.f], 255);
    [cell setCornerRadius:5.f borderWidth:1 borderColor:nil];
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
