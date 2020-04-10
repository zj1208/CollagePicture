//
//  UINavigationController+ZXCaterory.m
//  MobileCaiLocal
//
//  Created by simon on 2019/11/19.
//  Copyright © 2019 com.Chs. All rights reserved.
//

#import "UINavigationController+ZXCaterory.h"


@implementation UINavigationController (ZXCaterory)


- (UIViewController *)zx_rootViewController
{
    return self.childViewControllers?[self.childViewControllers firstObject]:nil;
}


- (nullable NSArray<__kindof UIViewController *> *)zx_popToViewControllerClass:(nullable Class)childViewControllerClass animated:(BOOL)animated
{
    __block NSArray *array = nil;
    [self.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:childViewControllerClass])
        {
           array = [[self popToViewController:obj animated:animated] copy];
           *stop = YES;
        }
    }];
    return array;
}


- (void)zx_navigationBar_removeShadowImage
{
    self.navigationBar.shadowImage = [UIImage new];
}



- (void)zx_navigationItem_titleCenter
{
    if (self.viewControllers.count>=2)
    {
        UIViewController *previousVC = [self.viewControllers objectAtIndex:self.viewControllers.count-2];
        previousVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                       initWithTitle:@""
                                                       style:UIBarButtonItemStylePlain
                                                       target:self
                                                       action:nil];
    }
}


//- (void)zx_navigationBar_UIBarButtonItem_appearance_systemBack_background_Test
//{
//    UIImage *backImage = [UIImage zh_imageWithColor:[UIColor orangeColor] andSize:CGSizeMake(10, 10)];
//    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//}


/**
 *  @brief set all navigationBar 's 系统返回按钮为没有文字； 把文字移至看不到; 注意: storyboard中遇到很长文字的时候，中间标题会受影响，必须改变前面控制器返回按钮的文字为空，才能解决；
 *
 */
+ (void)zx_navigationBar_UIBarButtonItem_appearance_systemBack_noTitle
{
    if(@available(iOS 11.0, *))
    {
            
    }
    else
    {
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                                 forBarMetrics:UIBarMetricsDefault];
            //横屏
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                                 forBarMetrics:UIBarMetricsCompact];
    }
}


/**
 *
 *
 *  @param aName aName description
 */
- (void)zx_navigationBar_allBackIndicatorImage:(nullable NSString *)aName isOriginalImage:(BOOL)originalImage
{
    UIImage *backImage = [UIImage imageNamed:aName];
    if (originalImage)
    {
        backImage= [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    self.navigationBar.backIndicatorImage =backImage;
    self.navigationBar.backIndicatorTransitionMaskImage =backImage;
}



- (void)zx_navigationBar_barItemColor:(nullable UIColor *)tintColor
{
    self.navigationBar.tintColor = tintColor;
//    else if ([self isKindOfClass:[UITabBarController class]])
//    {
//        UITabBarController *tabControler = (UITabBarController *)self;
//        [tabControler.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//            if ([obj isKindOfClass:[UINavigationController class]])
//            {
//                UINavigationController *nav = (UINavigationController *)obj;
//                nav.navigationBar.tintColor = tintColor;
//            }
//        }];
//    }
//    else
//    {
//        self.navigationController.navigationBar.tintColor =tintColor;
//    }
    
}

- (void)zx_navigationBar_titleColor:(nullable UIColor *)aColor
                                     titleFont:(UIFont *)aFont
{
    UIFont *tiFont = aFont?aFont:[UIFont systemFontOfSize:17];
    UIColor *color = aColor?aColor:[UIColor whiteColor];
    //设置中间title标题文本;
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:color,NSFontAttributeName:tiFont}];
}

- (void)zx_navigationBar_backgroundImageName:(nullable NSString *)bagImgName
                                       ShadowImageName:(nullable NSString *)aShadowName
                                     orBackgroundColor:(nullable UIColor *)backgoundColor
{
    if (bagImgName)//背景图片如果有透明效果，那么显示导航的时候也会有透明效果的；默认是毛玻璃效果
    {
        UIImage *navBgImg  =[UIImage imageNamed:bagImgName];
        [self.navigationBar setBackgroundImage:navBgImg forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
    }
    if (!bagImgName && backgoundColor)
    {
        [self.navigationBar setBarTintColor:backgoundColor];
    }
    if (aShadowName)
    {
        UIImage *navLineImg = [UIImage imageNamed:aShadowName];
        self.navigationBar.shadowImage =navLineImg;
    }
}



#pragma mark-设定所有导航条背景

+ (void)zx_navigationBar_appearance_titleColor:(nullable UIColor *)aColor
                                     titleFont:(UIFont *)aFont
{
    UIFont *tiFont = aFont?aFont:[UIFont systemFontOfSize:17];
    UIColor *color = aColor?aColor:[UIColor whiteColor];
    //设置中间title标题文本;
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:color,NSFontAttributeName:tiFont}];
}




+ (void)zx_navigationBar_appearance_backgroundImageName:(nullable NSString *)bagImgName
                                       ShadowImageName:(nullable NSString *)aShadowName
                                     orBackgroundColor:(nullable UIColor *)backgoundColor
{
    if (bagImgName)//背景图片如果有透明效果，那么显示导航的时候也会有透明效果的；默认是毛玻璃效果
    {
        UIImage *navBgImg  =[UIImage imageNamed:bagImgName];
        if ([UINavigationBar  instancesRespondToSelector:@selector(setBackgroundImage:forBarPosition:barMetrics:)])
        {
            [[UINavigationBar appearance] setBackgroundImage:navBgImg forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
        }
        else
        {
            [[UINavigationBar appearance]setBackgroundImage:navBgImg forBarMetrics:UIBarMetricsDefault];
        }
    }
    if (!bagImgName &&backgoundColor)
    {
        [[UINavigationBar appearance]setBarTintColor:backgoundColor];
    }
    if (aShadowName)
    {
        UIImage *navLineImg = [UIImage imageNamed:aShadowName];
        [UINavigationBar appearance].shadowImage =navLineImg;
    }
}


/**
 *  @brief set all navigationBar 's 返回《指示图标，appearance功能设置系统返回指示图；
 *
 */

- (void)zx_navigationBar_UIBarButtonItem_appearance_systemBack_BackgroundImage:(nullable NSString *)aName highlightImage:(nullable NSString *)highlightName
{
    UIBarButtonItem *item =nil;
    if ([UIBarButtonItem instancesRespondToSelector:@selector(appearanceWhenContainedInInstancesOfClasses:)])
    {
        item= [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UINavigationController class]]];
    }
    UIImage *backImage = [UIImage imageNamed:aName];
    backImage= [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    backImage = [backImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, backImage.size.width, 0, 0)];
    
    UIImage *highlightImage = [[UIImage imageNamed:highlightName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    highlightImage =  [highlightImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, highlightImage.size.width, 0, 0)];
    
    [item setBackButtonBackgroundImage:backImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:highlightImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    //横屏
    [item setBackButtonBackgroundImage:backImage forState:UIControlStateNormal barMetrics:UIBarMetricsCompact];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:highlightImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsCompact];

}
@end
