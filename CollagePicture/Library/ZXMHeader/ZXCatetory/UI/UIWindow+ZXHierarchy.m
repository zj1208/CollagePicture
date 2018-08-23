//
//  UIWindow+ZXHierarchy.m
//  YiShangbao
//
//  Created by simon on 2018/4/24.
//  Copyright © 2018年 com.Microants. All rights reserved.
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
    while ([currentViewController isKindOfClass:[UITabBarController class]])
    {
        currentViewController = [(UITabBarController *)currentViewController selectedViewController];
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
@end





