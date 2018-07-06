//
//  UIView+XMHelper.h
//  ShiChunTang
//
//  Created by zhuxinming on 14/11/1.
//  Copyright (c) 2014年 ZhuXinMing. All rights reserved.
//
// 2018.1.29 新增方法：可以同时设置圆角和阴影
// 2018.3.19  新增xib方法
// 5.07  修改代码

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (XMHelper)



#pragma mark - setter

/**
 * @brief 设置UIView的圆角，边框颜色默认是黑色的；
 * @param radius  圆角度数;
 * @param width   线条宽度；
 * @param borderColor  边框颜色；边框颜色默认是黑色的，如果传nil，则用clearColor赋值；
 */

- (void)setCornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(nullable UIColor *)borderColor;

- (void)xm_setCornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(nullable UIColor *)borderColor;

//  直接设置半圆；
- (void)xm_setRoundItem;


/**
 设置添加阴影；
 注意：如果clipsToBounds设置为YES,则阴影效果消失；

 @param shadowColor color 一般默认都是黑色
 @param opacity 设置图层阴影不透明度；系统默认0,无阴影；
 @param offset 设置图层阴影偏移量；系统默认（0,-3） 如果offset是CGSizeMake(0, 0)，则4周都有阴影
 @param shadowRadius 设置图层阴影圆角；系统默认3.0；
 
 The advantage of using this method is that 不用导入QuartzCore框架头；
 这不会添加阴影路径，当接收方的边界发生变化，并且在设置初始帧之后，可以调用updateShadowPathToBounds添加。
 */
- (void)xm_setShadowColor:(nullable UIColor *)shadowColor shadowOpacity:(CGFloat)opacity shadowOffset:(CGSize)offset shadowRadius:(CGFloat)shadowRadius;


/**
 同时设置阴影和圆角；

 @param radius 拐角圆角度数;
 @param width 线条宽度；
 @param borderColor 边框颜色
 @param shadowColor 阴影颜色，一般默认都是黑色
 @param opacity 设置图层阴影不透明度；系统默认0,无阴影；
 @param offset 设置图层阴影偏移量；系统默认（0,-3） 如果offset是CGSizeMake(0, 0)，则4周都有阴影
 @param shadowRadius 设置图层阴影圆角；系统默认3.0；
 例如： [self.cardContainerView xm_setShadowAndCornerRadius:12.f borderWidth:0 borderColor:nil shadowColor:[UIColor blackColor] shadowOpacity:0.2 shadowOffset:CGSizeMake(0, 0) shadowRadius:5.f];
 */
- (void)xm_setShadowAndCornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(nullable UIColor *)borderColor shadowColor:(nullable UIColor *)shadowColor shadowOpacity:(CGFloat)opacity shadowOffset:(CGSize)offset shadowRadius:(CGFloat)shadowRadius;


/**
 给某个view，指定哪几边设置边框线；这个方法只适用于纯代码frame设置；

 @param top top description
 @param left left description
 @param bottom bottom description
 @param right right description
 @param color 图层画线颜色
 @param width 画笔宽度
 */
- (void)xm_setBorderWithTop:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width;


- (void)xm_updateShadowPathToBounds:(CGRect)bounds withDuration:(NSTimeInterval)duration;





#pragma mark - getter


/**
 * @brief 获取UIView的对应controller
 */

- (nullable UIViewController *)xm_getResponderViewController;



- (float)xm_getValueFortapGestureOnSliderObject:(UISlider *)slider  withGesture:(UITapGestureRecognizer *)gesture;



/**
 递归获取所有子视图
 例如：[UIView xm_NSLogSubviewsFromView:self.navigationController.navigationBar andLevel:1];
 @param view 要遍历的view
 @param level 从第几级开始遍历
 */
+ (void)xm_NSLogSubviewsFromView:(UIView *)view andLevel:(NSInteger)level;



+ (id)xm_viewFromNib;


#pragma mark - perform

/**
 * @brief 关闭键盘方法；
 * @param aClass  父视图
 */
- (void)xm_performKeyboardDismissWithClass:(Class)aClass;



/**
 拨打电话1-webView请求的方式

 @param phone 电话号码
 */
- (void)xm_performCallPhone:(NSString *)phone;


/**
 拨打电话2-UIApplication openURL方式；
 这个方式是上面方式的根本；
 @param phone 电话号码
 */
- (void)xm_performCallPhoneApplication:(NSString *)phone;






/**
 通过遍历view的父视图查找到cell，再根据cell获取NSIndexPath

 @param view tableview/collectionview
 @return 未找到父视图为cell(tableViewCell、collectionviewCell) 则return nil
 */
- (nullable NSIndexPath *)jl_getIndexPathWithViewInCellFromTableViewOrCollectionView:(UIScrollView *)view;

@end


NS_ASSUME_NONNULL_END

