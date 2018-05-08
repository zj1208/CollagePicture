//
//  UIView+XMAnimation.h
//  YiShangbao
//
//  Created by simon on 2018/5/4.
//  Copyright © 2018年 com.Microants. All rights reserved.
//
//  5.07  修改代码

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (XMAnimation)

// 让选中的独立tableViewCell 作为快照 换算指定坐标后 添加到 控制器view上；
- (void)xm_showSnapshotSelectedCell:(UITableView *)tableView selectIndexPath:(NSIndexPath *)indexPath onTransformBgViewScaleSuperView:(UIView *)superView;

// 仿射view视图动画；
+ (void)xm_transformScaleAndRotationWithView:(UIView *)view;


//使用Core Animation Transitions(过渡，翻页)/使用CATransition只针对图层
//首先要在framework中引入QuatrtzCore.framework,在头文件中需要
//#import <QuartzCore/QuartzCore.h>

//animation.type = kCATransitionReveal//揭开
//animation.type = kCATransitionPush//推挤
//animation.type = kCATransitionMoveIn;覆盖
//animation.type = KCATransitionFade;// 淡化
// @"cube" 立方体
// @"suckEffect" 吸收
// @"oglFlip" 翻转
// @"rippleEffect" 波纹
// @"pageCurl" 翻页
// @"pageUnCurl" 反翻页
// @"cameraIrisHollowOpen" 镜头开
// @"cameraIrisHollowClose" 镜头关
/**
 @param kCATransitionType 动画类型
 @param layer 什么图的图层
 */
+ (void)xm_customDirectionFromTopAnimationType:(NSString *)kCATransitionType layer:(CALayer *)layer;

+ (void)xm_customDirectionFromBottomAnimationType:(NSString *)kCATransitionType layer:(CALayer *)layer;

@end

NS_ASSUME_NONNULL_END

