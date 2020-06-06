//
//  UIView+ZXAnimation.h
//  Baby
//
//  Created by simon on 2015/11/4.
//  Copyright © 2015年 sina. All rights reserved.
//
// 6.26  修改代码
// 8.13  CATransition转场动画移除到新的类目；


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ZXAnimation)

// 让选中的独立tableViewCell 作为快照 换算指定坐标后 添加到 控制器view上；
- (void)zx_showSnapshotSelectedCell:(UITableView *)tableView selectIndexPath:(NSIndexPath *)indexPath onTransformBgViewScaleSuperView:(UIView *)superView;

// 仿射view视图动画；
+ (void)zx_transformScaleAndRotationWithView:(UIView *)view;

// 添加陀螺仪效果；
- (void)zx_addMotionEffectXAxisWithValue:(CGFloat)xValue YAxisWithValue:(CGFloat)yValue;

- (void)zx_removeMotionEffect;


@end

NS_ASSUME_NONNULL_END

