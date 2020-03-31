//
//  UINavigationController+ZXCaterory.h
//  MobileCaiLocal
//
//  Created by simon on 2019/11/19.
//  Copyright © 2019 com.Chs. All rights reserved.
//
//  2020.1.20 优化代码；

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (ZXCaterory)


/// 获取root view controller；数组中的第一个视图控制器是root view controller，代表堆栈的底部。
@property (nullable, nonatomic, readonly, strong) UIViewController *zx_rootViewController;


/// 进化系统的popToViewController: animated:方法；Pops视图控制器，直到指定的视图控制器位于导航堆栈的顶部。
/// @param childViewControllerClass 子控制器的类名
/// @param animated animated description
//  这个数组包含从堆栈中popped的所有视图控制器。
- (nullable NSArray<__kindof UIViewController *> *)zx_popToViewControllerClass:(nullable Class)childViewControllerClass animated:(BOOL)animated;


// 默认shadowImage = nil，是没有阴影线的；在UINavigationController管理的navigationBar才设置了shadowImage线条；
//设置透明阴影image；(只设置阴影图属性在iOS13上可用；不知道是SDK更新了，还是其它系统需要设置背景图，待验证？)
- (void)zx_navigationBar_removeShadowImage;



/**
 设置当前控制器navigationItem的title始终保持居中；
 解决当上个控制器页面的title文本太长，导致下一级的控制器title不居中问题；
 */
- (void)zx_navigationItem_titleCenter;


/**
 设置返回按钮背景－测试使用；可以有效的观察到返回按钮的大小区域；
 */
//- (void)zx_navigationBar_UIBarButtonItem_appearance_systemBack_background_Test;

//iOS 11 开始无效，待测试；
/**
 *  @brief set all navigationBar 's 系统返回按钮为没有文字； 把文字移至看不到; iOS11无法移出title，只能小范围运动一点距离；
 这个全局方法有缺点：虽然返回按钮文字向左移动到屏幕外了，但是按钮实际大小并没有改变，在计算这个barItem的宽度的时候，依然会以图片＋文字的宽度计算；甚至会影响中间标题；
 需要调用zx_navigationItem_titleCenter方法解决返回按钮文本为空；按钮宽度也会变小；
 *
 */
+ (void)zx_navigationBar_UIBarButtonItem_appearance_systemBack_noTitle;


#pragma mark - 设置UINavigationController管理的UINavigationBar返回指示图
/**
 设置一个navigationController的navigationBar里的所有返回《指示图标；
 appearance没有效果，storyboard也是如此；
 如果leftBarButtonItem设置了，则此方法会无效；
 只是navigationBar的返回指示，如果设置会替换默认的返回展示； 如果上个页面设置了backBarButtonItem，则2个同时会显示；
 注意：为了达到 系统返回按钮图标与屏幕间距  约等于 自定义leftBarButtonItem返回button按钮与屏幕间距，需要设计3个图标，自定义leftBarButtonItem用实际大小的icon，系统返回按钮图标用plus屏幕尺寸的icon1（左边预留26像素）和非plus屏幕尺寸的icon2（左边预留18像素）
 @param aName 返回图的name
 @param originalImage 是否原图颜色显示；
 */
- (void)zx_navigationBar_allBackIndicatorImage:(nullable NSString *)aName isOriginalImage:(BOOL)originalImage;


#pragma mark - 设置UINavigationController管理的navigationBar上的UIBarButtonItem系统按钮颜色
/**
 *  @brief set 一个navigationBar上UIBarButtonItem的文本颜色和按钮图片颜色;(只能设置系统按钮)
 */
//每个navigationController有一个navigationBar，会影响某个navigationController上的所有barButtonItem的color;
- (void)zx_navigationBar_barItemColor:(nullable UIColor *)tintColor;



- (void)zx_navigationBar_titleColor:(nullable UIColor *)aColor
                                     titleFont:(UIFont *)aFont;

/// 给当前导航条设置背景及阴影；
/// @param bagImgName 背景图名
/// @param aShadowName 阴影图名
/// @param backgoundColor 背景颜色
- (void)zx_navigationBar_backgroundImageName:(nullable NSString *)bagImgName
                             ShadowImageName:(nullable NSString *)aShadowName
                           orBackgroundColor:(nullable UIColor *)backgoundColor;

#pragma mark - 统一全局设置UINavigationBar背景及标题属性--尽量不要用


/// set appearance With all navigationBar's 标题
/// @param aColor title的颜色
/// @param aFont title的font
+ (void)zx_navigationBar_appearance_titleColor:(nullable UIColor *)aColor
                                     titleFont:(UIFont *)aFont;

/**
 * @brief set appearance With all navigationBar's background
 appearance方法不适用于 多个模块不同主题色的ui设计； 当遇到不同的时候，只能每个navigationController独立设置；
 * 注意：设置navigationBar背景色用navigationBarTintColor 时候，默认情况下会与真实实际颜色有所不同；因为navigationBar默认Translucent = YES,会改变；
 */
+ (void)zx_navigationBar_appearance_backgroundImageName:(nullable NSString *)bagImgName
                                       ShadowImageName:(nullable NSString *)aShadowName
                                     orBackgroundColor:(nullable UIColor *)backgoundColor;


#pragma mark - 设置UINavigationBar返回按钮的背景图／文字偏移


  /**
 *  set all navigationBar 's 系统默认返回按钮的背景图；也可以用于测试；
 注意：系统默认的时候，返回按钮图片很靠近边缘，如果你想增大一点点边距，可以用25*40尺寸，周边虚像的图片；图片宽度越大，那么边距就越大；
   
   缺点：这种方法不适用于多种某块不同返回按钮的设计；而且不能有返回按钮title；
   bug：默认返回按钮的返回图标不会显示；直接顶替系统按钮的返回图标；
   [navigationController.navigationBar setBackIndicatorImage:backImage];设置的返回指示图也不会显示；
 *
 *  @param aName         返回按钮图片
 *  @param highlightName 返回按钮高亮图片--没有效果 不懂？
 */
- (void)zx_navigationBar_UIBarButtonItem_appearance_systemBack_BackgroundImage:(nullable NSString *)aName highlightImage:(nullable NSString *)highlightName;
@end

NS_ASSUME_NONNULL_END
