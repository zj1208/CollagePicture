//
//  UIViewController+XMNavBarCustom.h
//  ShiChunTang
//
//  Created by zhuxinming on 14/11/1.
//  Copyright (c) 2014年 ZhuXinMing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (XMNavBarCustom)

#pragma mark
#pragma mark NavigationBar有关
/******************************
 NavigationBar有关
 ******************************/

#pragma mark-LeftBarBut

/**
 * @brief 自定义leftBarButtonItem按钮-可以当返回按钮使用
 * @param imageName ： 自定义的图片名；
 */

-(void)xm_navigationItem_leftBarButtonItem_CustomView_imageName:(nullable NSString*)imageName highImageName:(nullable NSString *)imageName2 title:(nullable NSString *)backTitle action:(nullable SEL)action;

# pragma mark - 减小left／rightBarButtonItem与屏幕的边距

/**
 *   根据ui设计，如果需要减小leftBarButtonItem／right 与屏幕边界之间的默认距离，就得用这个方法解决；item与item之间默认20间距，也是最小20间距，大一点，但比较合理；

 * @param barButtonItems 原生的或者storyboard默认的系统barButtonItem数组
 * @return 返回一个添加了UIBarButtonSystemItemFixedSpace的items；
 * 例如： 控制item显示及边距：
    self.navigationItem.leftBarButtonItems = [self xm_navigationItem_leftOrRightItemReducedSpaceToMaginWithItems:@[self.personCenterBarItem]];

 *
 */
- (NSArray *)xm_navigationItem_leftOrRightItemReducedSpaceToMaginWithItems:(NSArray *)barButtonItems;


/**
 NSArray *items = [self xm_navigationItem_leftOrRightItemReducedSpaceToMagin:-7 withItems:@[self.backButtonItem]];
 self.navigationItem.leftBarButtonItems = items;

 @param magin 要减少的边距
 @param barButtonItems barButtonItem数组
 @return 返回数组
 */
- (NSArray *)xm_navigationItem_leftOrRightItemReducedSpaceToMagin:(CGFloat)magin withItems:(NSArray *)barButtonItems;


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
- (void)xm_navigationBar_UIBarButtonItem_appearance_systemBack_BackgroundImage:(nullable NSString *)aName highlightImage:(nullable NSString *)highlightName;


/**
 设置返回按钮背景－测试使用；可以有效的观察到返回按钮的大小区域；
 */
//- (void)xm_navigationBar_UIBarButtonItem_appearance_systemBack_background_Test;

/**
 *  @brief set all navigationBar 's 系统返回按钮为没有文字； 把文字移至看不到; iOS11无法移出title，只能小范围运动一点距离；
 这个全局方法有缺点：虽然返回按钮文字向左移动到屏幕外了，但是按钮实际大小并没有改变，在计算这个barItem的宽度的时候，依然会以图片＋文字的宽度计算；甚至会影响中间标题；
 需要调用xm_navigationItem_titleCenter方法解决返回按钮文本为空；按钮宽度也会变小；
 *
 */
+ (void)xm_navigationBar_UIBarButtonItem_appearance_systemBack_noTitle;



#pragma mark - UINavigationBar返回指示图
/**
 设置一个navigationController的navigationBar里的所有返回《指示图标；
 appearance没有效果，storyboard也是如此；
 如果leftBarButtonItem设置了，则此方法会无效；
 只是navigationBar的返回指示，如果设置会替换默认的返回展示； 如果上个页面设置了backBarButtonItem，则2个同时会显示；
 @param aName 返回图的name
 @param originalImage 是否原图颜色显示；
 */
- (void)xm_navigationBar_Single_BackIndicatorImage:(nullable NSString *)aName isOriginalImage:(BOOL)originalImage;



#pragma mark - navigationBar上系统按钮颜色
/**
 *  @brief set 一个navigationBar上UIBarButtonItem的文本颜色和按钮图片颜色;(只能设置系统按钮)
 */
- (void)xm_navigationBar_tintColor:(UIColor *)tintColor;






#pragma mark - backBarButtonItem
/**
 *  @brief 自定义系统下一个页面的返回按钮文字title,如果aTitle==nil,only arrow;
 *
 */
- (void)xm_navigationItem_backBarButtonItem_title:(nullable NSString *)aTitle font:(NSInteger)aFont;

/**
 解决当上个控制器页面的title文本太长，导致下一级的控制器title不居中问题；
 */
- (void)xm_navigationItem_titleCenter;


# pragma mark - 其他

/**
 * @brief 自定义模态页面barButtonItem按钮，也是为了适应ios6和ios7兼容；默认自动加载了点击事件，加载dismissViewController；
 * @param flag ：YES＝ leftBarItem； NO＝ rightBarItem
 */
- (void)xm_navigationBar_presentedViewController_leftOrRightBarItem:(BOOL)flag   title:(NSString *)aTitle;

- (void)modelLeftButtonClickHandler;




#pragma mark - 统一全局设置UINavigationBar背景及标题属性
/**
 * @brief set appearance With all navigationBar's background and 标题
 appearance方法不适用于 多个模块不同主题色的ui设计； 当遇到不同的时候，只能每个navigationController独立设置；
 */
+ (void)xm_navigationBar_appearance_backgroundImageName:(nullable NSString *)bagImgName
                                       ShadowImageName:(nullable NSString *)aShadowName
                                     orBackgroundColor:(nullable UIColor *)backgoundColor
                                            titleColor:(nullable UIColor *)aColor
                                             titleFont:(UIFont *)aFont;

//每个navigationController有一个navigationBar，会影响某个navigationController上的所有barButtonItem的color;
- (void)xm_navigationBar_barItemColor:(nullable UIColor *)tintColor;


#pragma mark - 设置NavigationBar的透明度

/**
 设置导航栏背景透明，用alpha方法在切换控制器的时候不会有闪屏bug；
 
 @param alpha navigationBar的子视图的透明度；
 */
- (void)xm_navigationBar_BackgroundAlpah:(CGFloat)alpha;

- (void)xm_navigationBar_BackgroundAlpah:(CGFloat)alpha navigationBar:(UINavigationBar *)navigationBar;


// lingh add
- (void)linNavigationBar_Right_Button:(NSString *)title action:(SEL)action;





#pragma mark-add logo-titleView

/*给navigationBar上添加 logo-titleView的imageView,Label的title
 如果是统一的，就用[[UINavigationBar appearance] setTitleTextAttributes 等方法。如首页需要logo，或者title和TabbarItem不一样。
 */
/**
 * @brief add logo--titleView's imageView。
 * @param imageName  图片名字
 */
- (void)xm_navigationBar_titleView_Logo_imageName:(nullable NSString*)imageName;



/**
 * @brief add logo---titleView's Label with title。
 * @param aTitle  文字内容。
 * @param aFont   文字字体；
 * @param aColor  文字颜色
 */
- (void)xm_navigationBar_titleView_Logo_Label_title:(nullable NSString*)aTitle font:(NSInteger)aFont titleColor:(UIColor*)aColor;



/**
 * @brief 自定义设置tabBarController中tabBarItem选择状态的图片,因为用的是原图绘画模式，所以系统的tintColor自动着色无法改变图片颜色，只能改变title文本颜色。用2种颜色的原图片，不用tintColor改变，这是一种更有效的做法；
 
 * @param aArray  图片数组，要求图片必须是着色的，用于直接显示的；
 * @param aSleColor  用于显示tabBarItem选中文字颜色;因为图片用的是原图，所以无法改变图片颜色；
 系统的自动着色:如果是统一的颜色,可以用tabBar的tintColor方法
 UITabBarController *tab =(UITabBarController *)self.window.rootViewController;
 ZX_UITabBar_TintColor(tab.tabBar) = [UIColor redColor];
 如果不是统一颜色:可以用tabBarItem分别对图片文字设置,而且可以针对不同状态如选择前,选择后;
 */

- (void)xm_tabBarController_tabBarItem_ImageArray:(nullable NSArray *)aArray selectImages:(nullable NSArray *)selectArray slectedItemTintColor:(nullable UIColor *)aSleColor unselectedItemTintColor:(nullable UIColor *)unSleColor;


@end

NS_ASSUME_NONNULL_END
