//
//  UIView+ZXHelper.h
//  ShiChunTang
//
//  Created by simon on 13/11/1.
//  Copyright (c) 2013年 yinyuetai.com. All rights reserved.
//
// 2018.1.29 新增方法：可以同时设置圆角和阴影
// 2018.3.19  新增xib方法
// 2019.3.12  增加设置遮罩方法；
// 2019.3.28  增加设置哪个圆角的二种方法；
// 2019.11.26 添加DEBUG打印判断
// 2020.01.02 openURL方法增加兼容
// 2020.02.05 拨打电话方法抽离
// 2020.03.13 去除webView loadRequest的拨打电话方法；2020.4月开始会审核不过；
// 2020.04.28 优化

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ZXHelper)



#pragma mark - setter

// 注意：设置masksToBounds，主要是为了应用到layer有contents内容-image的情况，比如imageView渲染image图像，UIButton渲染image图像的情况，做image的遮罩处理；普通view不设置也能正常设置圆角渲染;


/**
 * @brief 设置UIView的边框bound为圆角，将mask遮罩应用到边界为止；边框颜色默认是黑色的；
 * @param radius  圆角度数;
 * @param width   线条宽度；
 * @param borderColor  边框颜色；边框颜色默认是黑色的，如果传nil，则用clearColor赋值；
 */

- (void)zx_setBorderWithCornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(nullable UIColor *)borderColor;


/**
   设置UIView的边框及圆角，将mask遮罩应用到边界；
   支持设置图层4个角中哪几个角接收cornerRadius属性；只支持iOS11；

 * @param radius  圆角度数;
 * @param width   线条宽度；
 * @param borderColor  边框颜色；边框颜色默认是黑色的，如果传nil，则用clearColor赋值；
 * @param maskedCorners 设置图层4个圆角中哪几个角接收cornerRadius属性;
 例如：
 if #available(iOS 11.0, *) {
 self.titleLab?.zx_setCornerRadius(8, borderWidth: 1, borderColor: nil, maskedCorners: [CACornerMask.layerMinXMinYCorner, CACornerMask.layerMaxXMinYCorner])
 } else {
 // Fallback on earlier versions
 };
 */
- (void)zx_setBorderWithCornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(nullable UIColor *)borderColor maskedCorners:(CACornerMask) maskedCorners API_AVAILABLE(macos(10.13), ios(11.0), watchos(4.0), tvos(11.0));


/**
在设置阴影的同时，设置圆角；不能用于imageView有image，或者layer有content的情况，imageView渲染image图像设置的时候mask遮罩效果没有；

@param radius 圆角度数;
@param borderColor 边框颜色
*/
- (void)zx_setBorderWithShadowWithCornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(nullable UIColor *)borderColor;

/**
 设置UIView的边框及圆角,支持设置图层4个角中哪几个角接收cornerRadius属性; 利用显示边框及透明layer+maskLayer技术；
 由于此方法是根据rect重新绘画的，所以如果是size会变化的nib文件的控件，则需要在layoutSubViews中调用；
 注意：borderWidth有问题？需要优化，不知道是显示的layer出问题，还是mask的layer出问题；
 @param cornersType 设置图层4个圆角中哪几个角接收cornerRadius属性
 例如：
 override func layoutSubviews() {
 super.layoutSubviews();
 self.titleLab.zx_setBorder(withCornerRadius: 8, borderWidth: 1, borderColor: nil, byRoundingCorners:[UIRectCorner.topLeft, UIRectCorner.topRight]);
 }
 */
- (void)zx_setBorderWithCornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(nullable UIColor *)borderColor byRoundingCorners:(UIRectCorner) cornersType;

/**
 * @brief 直接设置当前view为一个圆型展示，利用设置bounds的圆角方法；
          注意：需要在layoutSubViews中调用；
 */
- (void)zx_setBorderWithRoundItem;

/**
 * @brief 设置UIView圆形头像展示；利用设置mask遮罩间接设置圆,只有CAShapeLayer的path区域能正常展示；
          注意：需要在layoutSubViews中调用；
 * @param rect  view的bounds大小;
 */
- (void)zx_setMasksToBoundsRoundedCornerWithBounds:(CGRect)rect;

/**
 设置添加阴影；
 注意：如果masksToBounds设置为YES,则阴影效果消失；

 @param shadowColor color 阴影颜色，一般默认都是黑色
 @param opacity 设置图层阴影不透明度；系统默认0,无阴影；如果设置1，则阴影不透明完全展示；
 @param offset 设置图层阴影偏移量；系统默认（0,-3） 如果offset是CGSizeMake(0, 0)，则4周都有阴影
 @param shadowRadius 设置阴影模糊半径shadowRadius；可以理解为阴影的宽度；系统默认3.0；
 
 The advantage of using this method is that 不用导入QuartzCore框架头；
 这不会添加阴影路径，当接收方的边界发生变化，并且在设置初始帧之后，可以调用updateShadowPathToBounds添加。
 */
- (void)zx_setShadowColor:(nullable UIColor *)shadowColor shadowOpacity:(CGFloat)opacity shadowOffset:(CGSize)offset shadowRadius:(CGFloat)shadowRadius;


/**
 给某个view，指定哪几边设置边框线；
 需要在layoutSubViews中调用；

 @param top top description
 @param left left description
 @param bottom bottom description
 @param right right description
 @param color 图层画线颜色
 @param width 画笔宽度
 */
- (void)zx_setBorderWithTop:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width;


- (void)zx_updateShadowPathToBounds:(CGRect)bounds withDuration:(NSTimeInterval)duration;





#pragma mark - getter


/**
 * @brief 获取UIView的对应controller
 */

- (nullable UIViewController *)zx_getResponderViewController;



- (float)zx_getValueFortapGestureOnSliderObject:(UISlider *)slider  withGesture:(UITapGestureRecognizer *)gesture;



/**
 递归获取所有子视图
 例如：[UIView zx_NSLogSubviewsFromView:self.navigationController.navigationBar andLevel:1];
 @param view 要遍历的view
 @param level 从第几级开始遍历
 */
+ (void)zx_NSLogSubviewsFromView:(UIView *)view andLevel:(NSInteger)level;



+ (id)zx_viewFromNib;


#pragma mark - perform

/**
 * @brief 关闭键盘方法；
 * @param aClass  父视图
 */
- (void)zx_performKeyboardDismissWithClass:(Class)aClass;


/**
 通过遍历view的父视图查找到cell，再根据cell获取NSIndexPath

 @param view tableview/collectionview
 @return 未找到父视图为cell(tableViewCell、collectionviewCell) 则return nil
 */
- (nullable NSIndexPath *)jl_getIndexPathWithViewInCellFromTableViewOrCollectionView:(UIScrollView *)view;

@end


NS_ASSUME_NONNULL_END

