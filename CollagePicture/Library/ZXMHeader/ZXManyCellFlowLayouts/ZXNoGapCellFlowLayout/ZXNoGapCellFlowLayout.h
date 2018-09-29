//
//  ZXNoGapCellFlowLayout.h
//  YiShangbao
//
//  Created by simon on 2017/8/29.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

// collectionViewCell之间无间隙的collectionView布局；解决一个屏幕宽度需要无间隙的排列n个平均宽度的item；
// plus模拟器上还能看到分割线，真机上看不到的；

// 2017.12.27
// 注释添加

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class ZXNoGapCellFlowLayout;

@protocol ZXNoGapCellFlowLayoutDelegate <NSObject>

@required
/**
 回调哪组是需要重新设置排列X轴无间隙的；

 @param noGapFlowLayout noGapFlowLayout description
 @param indexPath 指定索引，某组，或某行；
 @return YES:表示指定indexPath需要重新设置排列X轴无间隙；
 */
- (BOOL)ZXNoGapCellFlowLayout:(ZXNoGapCellFlowLayout *)noGapFlowLayout shouldNoGapAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface ZXNoGapCellFlowLayout : UICollectionViewFlowLayout

// 多少列
@property (nonatomic, assign) NSInteger columnsCount;

// 设置代理
@property (nonatomic, weak) id<ZXNoGapCellFlowLayoutDelegate>delegate;

@end

NS_ASSUME_NONNULL_END

//宽度有余数处理，高度舍去余数；
/*
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat width = LCDW/4;
    return CGSizeMake(width, floorf(width));
}
 
 #pragma mark - ZXNoGapCellFlowLayoutDelegate
 
 - (BOOL)ZXNoGapCellFlowLayout:(ZXNoGapCellFlowLayout *)noGapFlowLayout shouldNoGapAtIndexPath:(NSIndexPath *)indexPath
 {
     if (indexPath.section ==2)
     {
         return YES;
     }
     return NO;
 }

*/
