//
//  UIViewController+ZXNavBarCustom.h
//  MusiceFate
//
//  Created by simon on 14/11/1.
//  Copyright (c) 2014年 yinyuetai.com. All rights reserved.
//
//  9.12  弃用减小barButtonItem与屏幕的边距 偏门方法； 不但所有系统和屏幕无法统一间距，而且不符合逻辑，在iOS11上毫无效果，只是iOS11以前系统的一个bug而已；
//  2019.1.10  添加例子
//  2019.12.7  移动部分方法到UINavigationController分类；

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ZXNavBarCustom)

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

-(void)zx_navigationItem_leftBarButtonItem_CustomView_imageName:(nullable NSString*)imageName highImageName:(nullable NSString *)imageName2 title:(nullable NSString *)backTitle action:(nullable SEL)action;

# pragma mark - 减小left／rightBarButtonItem与屏幕的边距 - 弃用,也绝不能用修改内部约束的方法；
/**
 弃用：
 根据ui设计，如果需要减小leftBarButtonItem／right 与屏幕边界之间的默认距离，就得用这个方法解决；item与item之间默认20间距，也是最小20间距，大一点，但比较合理；
 NSArray *items = [self zx_navigationItem_leftOrRightItemReducedSpaceToMagin:-7 withItems:@[self.backButtonItem]];
 self.navigationItem.leftBarButtonItems = items;
 文本按钮之系统初始化：-没有经过验证数字准确
 iOS11以前 边距 = 10
 iOS11以后 边距 = 15
 图片按钮之系统初始化：-没有经过验证数字准确
 iOS11以前 边距 = 5 || 10
 iOS11以后 边距 = 12 || 17
 自定义视图按钮之初始化：-经过验证数字准确
 所有系统 边距 = 16 || 20
 
 注意：在iOS11设置无效果，这种偏门方法本来就不该起作用，不推荐使用；
 为了统一效果，在任何系统都不要使用；
 @param magin 要减少的边距
 @param barButtonItems barButtonItems 原生的或者storyboard默认的系统barButtonItem数组
 @return 返回一个添加了UIBarButtonSystemItemFixedSpace的items；
 */
//- (NSArray *)zx_navigationItem_leftOrRightItemReducedSpaceToMagin:(CGFloat)magin withItems:(NSArray *)barButtonItems;






















# pragma mark - 其他

/**
 * @brief 自定义模态页面barButtonItem按钮，也是为了适应ios6和ios7兼容；默认自动加载了点击事件，加载dismissViewController；
 * @param flag ：YES＝ leftBarItem； NO＝ rightBarItem
 */
- (void)zx_navigationBar_presentedViewController_leftOrRightBarItem:(BOOL)flag   title:(NSString *)aTitle;

- (void)modelLeftButtonClickHandler;







#pragma mark - 设置NavigationBar的透明度

/**
 设置导航栏背景透明，用alpha方法在切换控制器的时候不会有闪屏bug；
 
 @param alpha navigationBar的子视图的透明度；
 */
- (void)zx_navigationBar_BackgroundAlpah:(CGFloat)alpha;

- (void)zx_navigationBar_BackgroundAlpah:(CGFloat)alpha navigationBar:(UINavigationBar *)navigationBar;


// lingh add
- (void)linNavigationBar_Right_Button:(NSString *)title action:(SEL)action;






/**
 * @brief 自定义设置tabBarController中tabBarItem选择状态的图片,因为用的是原图绘画模式，所以系统的tintColor自动着色无法改变图片颜色，只能改变title文本颜色。用2种颜色的原图片，不用tintColor改变，这是一种更有效的做法；
 
 * @param aArray  图片数组，要求图片必须是着色的，用于直接显示的；
 * @param aSleColor  用于显示tabBarItem选中文字颜色;因为图片用的是原图，所以无法改变图片颜色；
 系统的自动着色:如果是统一的颜色,可以用tabBar的tintColor方法
 UITabBarController *tab =(UITabBarController *)self.window.rootViewController;
 ZX_UITabBar_TintColor(tab.tabBar) = [UIColor redColor];
 如果不是统一颜色:可以用tabBarItem分别对图片文字设置,而且可以针对不同状态如选择前,选择后;
 */

- (void)zx_tabBarController_tabBarItem_ImageArray:(nullable NSArray *)aArray selectImages:(nullable NSArray *)selectArray slectedItemTintColor:(nullable UIColor *)aSleColor unselectedItemTintColor:(nullable UIColor *)unSleColor;


@end

NS_ASSUME_NONNULL_END

/*
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initTabBar];
    [self setApperanceForSigleNavController];
    [self setApperanceForAllController];
    
    [self addNoticationCenter];
    
    [self requestNewFansAndVisitor];
    [self updateMessageBadge:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginIn:) name:kNotificationUserLoginIn object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginOut:) name:kNotificationUserLoginOut object:nil];
}
#pragma mark-
//设置基本数据：返回按钮，item文字颜色
- (void)setApperanceForSigleNavController
{
    [self.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [obj zx_navigationBar_Single_BackIndicatorImage:@"back_onlyImage" isOriginalImage:YES];
        [obj zx_navigationBar_barItemColor:UIColorFromRGB_HexValue(0x222222)];
        
    }];
}
//设置基本数据：navigationBar的背景及title颜色/font大小
- (void)setApperanceForAllController
{
    [UINavigationController zx_navigationBar_appearance_backgroundImageName:nil ShadowImageName:nil orBackgroundColor:[UIColor whiteColor] titleColor:UIColorFromRGB_HexValue(0x222222) titleFont:[UIFont boldSystemFontOfSize:17.f]];
    
    [[UIBarButtonItem appearance]setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.f]} forState:UIControlStateNormal];
    [[UIBarButtonItem appearance]setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.f]} forState:UIControlStateHighlighted];
    
    
    [UINavigationController zx_navigationBar_UIBarButtonItem_appearance_systemBack_noTitle];

    [[UIButton appearance]setExclusiveTouch:YES];

}

- (void)initTabBar
{
    NSArray *imgSelectArray = @[@"toolbar_shangpu_sel",@"toolbar_message_sel",@"toolbar_fuwu-sel",@"toolbar_myCenter_sel"];
    NSArray *imgArray = @[@"toolbar_shangpu-nor",@"toolbar_message",@"toolbar_fuwu-nor",@"toolbar_myCenter_nor"];
    
    [self zx_tabBarController_tabBarItem_ImageArray:imgArray selectImages:imgSelectArray slectedItemTintColor:nil unselectedItemTintColor:nil];
    self.tabBar.translucent = NO;
    UIImage *tabImage = [UIImage zh_imageWithColor:UIColorFromRGB_HexValue(0xFAFAFA) andSize:self.tabBar.frame.size];
    self.tabBar.backgroundImage = tabImage;
    UIImage *shadowImage = [UIImage zh_imageWithColor:UIColorFromRGB_HexValue(0xD8D8D8) andSize:CGSizeMake(self.tabBar.frame.size.width, 0.5)];
    self.tabBar.shadowImage = shadowImage;
}
*/
