//
//  UITabBarController+ZXCategory.m
//  MerchantBusinessClient
//
//  Created by 朱新明 on 2020/2/3.
//  Copyright © 2020 com.Chs. All rights reserved.
//

#import "UITabBarController+ZXCategory.h"


@implementation UITabBarController (ZXCategory)


- (void)zx_tabBarController_tabBarItem_ImageArray:(nullable NSArray *)aArray selectImages:(nullable NSArray *)selectArray slectedItemTintColor:(nullable UIColor *)aSleColor unselectedItemTintColor:(nullable UIColor *)unSleColor;
{
    NSMutableArray *imgArray = [NSMutableArray arrayWithCapacity:4];
    for(int i =0;i<aArray.count;i++)
    {
        UIImage *firstImgs = [UIImage imageNamed:[aArray objectAtIndex:i]];
        [imgArray addObject:firstImgs];
    }
    
    NSMutableArray *selectImgsArray = [NSMutableArray arrayWithCapacity:4];
    for(int i =0;i<selectArray.count;i++)
    {
        UIImage *firstImgs = [UIImage imageNamed:[selectArray objectAtIndex:i]];
        [selectImgsArray addObject:firstImgs];
    }

    
    UITabBarController *tabBarController =(UITabBarController *)self;
    NSArray *array = tabBarController.viewControllers;
    for (int i =0; i<array.count; i++)
    {
        UIViewController *vc = (UIViewController *)[array objectAtIndex:i];
        vc.tabBarItem.selectedImage = [selectImgsArray[i] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.tabBarItem.image =[imgArray[i] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: aSleColor,NSForegroundColorAttributeName, nil];
        [vc.tabBarItem setTitleTextAttributes:dic forState:UIControlStateSelected];
    }
    UITabBar *tabBar = tabBarController.tabBar;
    tabBar.tintColor = aSleColor;
    if (@available(iOS 10.0, *))
    {
        tabBar.unselectedItemTintColor = unSleColor;
    }else{

    }
}

@end
