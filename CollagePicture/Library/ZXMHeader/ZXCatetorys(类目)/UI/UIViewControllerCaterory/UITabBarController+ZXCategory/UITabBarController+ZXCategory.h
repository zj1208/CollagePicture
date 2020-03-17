//
//  UITabBarController+ZXCategory.h
//  MerchantBusinessClient
//
//  Created by 朱新明 on 2020/2/3.
//  Copyright © 2020 com.Chs. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBarController (ZXCategory)


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
