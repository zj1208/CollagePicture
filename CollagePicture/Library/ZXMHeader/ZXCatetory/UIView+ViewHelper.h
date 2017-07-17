//
//  UIView+ViewHelper.h
//  ShiChunTang
//
//  Created by zhuxinming on 14/11/1.
//  Copyright (c) 2014年 ZhuXinMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ViewHelper)
/**
 * @brief 设置UIView的圆角
 * @param radius  圆角度数;
 * @param width   边框宽度。
 * @param color   边框颜色
 */

- (void)setCornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color;

//设置半圆；
- (void)zhSetRoundItem;

//设置阴影
- (void)zhSetShadowColor:(UIColor *)color shadowOffset:(CGSize)offset shadowOpacity:(CGFloat)opacity;

/**
 * @brief 兼容－tabBarController下，选中图片和默认图片 在ios6和ios7的不同方法；
 */

- (void)zhCompatible_TabBarItem_viewController:(UIViewController *)vc image:(UIImage *)image selectedImage:(UIImage *)selectedImage;

/**
 * @brief 获取UIView的对应controller
 */

- (UIViewController *)zhMyViewController;


- (void)zhCallPhone:(NSString *)phone;

- (void)zhCallPhoneApplication:(NSString *)phone;


/**
  递归获取所有子视图
例如： [UIView zhNSLogGetSubFromView:self.navigationController.navigationBar andLevel:1];
 @param view 要遍历的view
 @param level 从第几级开始遍历
 */
+ (void)zhNSLogSubviewsFromView:(UIView *)view andLevel:(NSInteger)level;
#pragma mark-dissmissKeyboard
/**
 * @brief 关闭键盘方法；
 * @param aClass  父视图
 */
-(void)zhu_keyboardDismissWithClass:(Class)aClass;



#pragma mark-UIViewGeometry

-(float)zhuValueFortapGestureOnSliderObject:(UISlider*)slider  withGesture:(UITapGestureRecognizer*)gesture;



/**
 * @brief 多行动态文本，宽度，高度根据文本多少自适应改变；－－宽度一般固定死,高度肯定是自适应的；
 
 */

-(void)zhuLabel_dynamicTextWithLabel:(UILabel *)titleLab title:(NSString *)title;


@end

/****************************************************/

@interface UIView (initView)



-(CGRect)zhuContainSize_LCDWHaveNumItem_MarginX:(CGFloat)MarginX MaginXBool:(BOOL)hasMaginX width:(CGFloat)aWidth widthBool:(BOOL)hasWidth numItems:(NSInteger)i  totalItems:(NSInteger)aTotal orginY:(CGFloat)aY height:(CGFloat)aHeight equealHW:(BOOL)aEqueal;



- (CGRect)zhuContainSize_LCDWHaveNumItem_middle2Margin_MarginX:(CGFloat)MarginX  totalWidth:(CGFloat)aWidth numItems:(NSInteger)i  totalItems:(NSInteger)aTotal orginY:(CGFloat)aOrginY height:(CGFloat)aHeight;


@end







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
