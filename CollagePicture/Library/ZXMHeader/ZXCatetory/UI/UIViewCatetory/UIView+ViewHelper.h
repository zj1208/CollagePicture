//
//  UIView+ViewHelper.h
//  ShiChunTang
//
//  Created by zhuxinming on 14/11/1.
//  Copyright (c) 2014年 ZhuXinMing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ViewHelper)



#pragma mark - setter

/**
 * @brief 设置UIView的圆角
 * @param radius  圆角度数;
 * @param width   边框宽度。
 * @param color   边框颜色
 */

- (void)setCornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(nullable UIColor *)color;

//设置半圆；
- (void)zhSetRoundItem;

//设置阴影
- (void)zhSetShadowColor:(nullable UIColor *)color shadowOffset:(CGSize)offset shadowOpacity:(CGFloat)opacity;



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
