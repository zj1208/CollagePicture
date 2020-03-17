//
//  UIWindow+ZXHierarchy.m
//  YiShangbao
//
//  Created by simon on 2017/4/24.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "UIWindow+ZXHierarchy.h"

@implementation UIWindow (ZXHierarchy)
/*
while循环就是循环结构的一种，当事先不知道循环该执行多少次，就要用到while循环
当while循环主体有且只有一个语句时，可以将大括号省去。
在while循环语句中只有一个判断条件，它可以是任何表达式。
当判断条件的值为真，循环就会执行一次，再重复测试判断条件，执行循环主体，知道判断条件为假（false），才会跳离while循环。
 */
- (UIViewController*)zx_topMostWindowController
{
    UIViewController *topController = [self rootViewController];
    while ([topController presentedViewController])
    {
        topController = [topController presentedViewController];
    }
    //  Returning topMost ViewController
    return topController;
}


- (UIViewController*)zx_currentViewController;
{
    UIViewController *currentViewController = [self zx_topMostWindowController];
    
    if([currentViewController isKindOfClass:[UITabBarController class]])
    {
        //返回tabBarController的选中控制器
        if ([(UITabBarController *)currentViewController selectedViewController]) {
            currentViewController = [(UITabBarController *)currentViewController selectedViewController];
        }
        else
        {
            //如果当前没有选中的viewControoller，则返回tabBarController的第一个控制器
            UITabBarController *tabBarController = (UITabBarController *)currentViewController;
            currentViewController = [tabBarController.viewControllers firstObject];
        }
    }
    while ([currentViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)currentViewController topViewController])
        currentViewController = [(UINavigationController*)currentViewController topViewController];
    return currentViewController;
}


+ (nullable UIWindow *)zx_getRemoteKeyboardWindow
{
    __block UIWindow* tempWindow = nil;
    NSArray* windows = [[UIApplication sharedApplication] windows];
    [windows enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *str =  [[obj class] description];
        
        if ([str isEqualToString:@"UIRemoteKeyboardWindow"])
        {
            tempWindow = (UIWindow *)obj;
        }
    }];
    return tempWindow;
}

+ (nullable UIWindow *)zx_getFrontVisibleWindow
{
    if ([UIWindow zx_getRemoteKeyboardWindow])
    {
        return [UIWindow zx_getRemoteKeyboardWindow];
    }
    return  [[UIApplication sharedApplication]keyWindow];
}


+ (nullable UIWindow *)zx_getFrontWindow
{
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows)
    {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal);
        if(windowOnMainScreen && windowIsVisible && windowLevelSupported) {
            return window;
            break;
        }
    }
    return nil;
}


- (CGFloat)zx_safeAreaStatusBarHeight
{
    CGFloat statusBarHeight = 0;
    if (@available(iOS 13.0, *)) {
        statusBarHeight = [[UIApplication sharedApplication] delegate].window.windowScene.statusBarManager.statusBarFrame.size.height;
    }
    else
    {
        statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    }
    return statusBarHeight;
}

- (CGFloat)zx_safeAreaBottomHeight
{
    CGFloat tmp = 0;
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets areaInset = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
        if (areaInset.bottom >0) {
            tmp = areaInset.bottom;
        }
    }
    return tmp;
}
@end





