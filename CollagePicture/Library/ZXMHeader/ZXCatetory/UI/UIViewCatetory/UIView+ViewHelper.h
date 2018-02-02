//
//  UIView+ViewHelper.h
//  ShiChunTang
//
//  Created by zhuxinming on 14/11/1.
//  Copyright (c) 2014年 ZhuXinMing. All rights reserved.
//
// 2018.1.24  新增方法
// 2018.1.29 新增方法：可以同时设置圆角和阴影

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ViewHelper)



#pragma mark - setter

/**
 * @brief 设置UIView的圆角
 * @param radius  圆角度数;
 * @param width   线条宽度；
 * @param borderColor   边框颜色
 */

- (void)setCornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(nullable UIColor *)borderColor;

- (void)zhSetCornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(nullable UIColor *)borderColor;

//设置半圆；
- (void)zhSetRoundItem;


/**
 设置阴影；如果clipsToBounds设置为YES,则阴影效果消失；

 @param shadowColor color 一般默认都是黑色
 @param opacity 设置图层阴影不透明度；系统默认0,无阴影；
 @param offset 设置图层阴影偏移量；系统默认（0,-3） 如果offset是CGSizeMake(0, 0)，则4周都有阴影
 @param shadowRadius 设置图层阴影圆角；系统默认3.0；
 */
- (void)zhSetShadowColor:(nullable UIColor *)shadowColor shadowOpacity:(CGFloat)opacity shadowOffset:(CGSize)offset shadowRadius:(CGFloat)shadowRadius;


/**
 同时设置阴影和圆角；

 @param radius 拐角圆角度数;
 @param width 线条宽度；
 @param borderColor 边框颜色
 @param shadowColor 阴影颜色，一般默认都是黑色
 @param opacity 设置图层阴影不透明度；系统默认0,无阴影；
 @param offset 设置图层阴影偏移量；系统默认（0,-3） 如果offset是CGSizeMake(0, 0)，则4周都有阴影
 @param shadowRadius 设置图层阴影圆角；系统默认3.0；
 例如： [self.cardContainerView zhSetShadowAndCornerRadius:12.f borderWidth:0 borderColor:nil shadowColor:[UIColor blackColor] shadowOpacity:0.2 shadowOffset:CGSizeMake(0, 0) shadowRadius:5.f];
 */
- (void)zhSetShadowAndCornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(nullable UIColor *)borderColor shadowColor:(nullable UIColor *)shadowColor shadowOpacity:(CGFloat)opacity shadowOffset:(CGSize)offset shadowRadius:(CGFloat)shadowRadius;
/**
 给某个view，指定哪几边设置边框线；

 @param top top description
 @param left left description
 @param bottom bottom description
 @param right right description
 @param color 图层画线颜色
 @param width 画笔宽度
 */
- (void)zhSetBorderWithTop:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width;


#pragma mark - getter


/**
 * @brief 获取UIView的对应controller
 */

- (nullable UIViewController *)zhGetMyResponderViewController;



- (float)zhGetValueFortapGestureOnSliderObject:(UISlider *)slider  withGesture:(UITapGestureRecognizer *)gesture;




#pragma mark - perform

/**
 * @brief 关闭键盘方法；
 * @param aClass  父视图
 */
- (void)zhPerformKeyboardDismissWithClass:(Class)aClass;



/**
 拨打电话1-webView请求的方式

 @param phone 电话号码
 */
- (void)zhPerformCallPhone:(NSString *)phone;


/**
 拨打电话2-UIApplication openURL方式；
 这个方式是上面方式的根本；
 @param phone 电话号码
 */
- (void)zhPerformCallPhoneApplication:(NSString *)phone;




/**
  递归获取所有子视图
 例如：[UIView zhNSLogSubviewsFromView:self.navigationController.navigationBar andLevel:1];
 @param view 要遍历的view
 @param level 从第几级开始遍历
 */
+ (void)zhNSLogSubviewsFromView:(UIView *)view andLevel:(NSInteger)level;


@end


NS_ASSUME_NONNULL_END




/*
 *********************************************************************
 */
#pragma mark  animation
/******************************
 animation
 新工程中需要添加：框架－QuartzCore
 ******************************/
//使用Core Animation Transitions(过渡，翻页)/使用CATransition只针对图层
//首先要在framework中引入QuatrtzCore.framework,在头文件中需要
//#import <QuartzCore/QuartzCore.h>

/*
@interface UIView (animation)
//
- (void)zhuCustomDirectionFromTopAnimationType:(NSString*)kCATransitionType layer:(CALayer*)layer;//type：动画类型，layer：什么图的图层

- (void)zhuCustomDirectionFromBottomAnimationType:(NSString*)kCATransitionType layer:(CALayer*)layer;

@end
*/
