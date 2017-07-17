//
//  UIViewController+ZXSystemBackButtonAction.m
//  YiShangbao
//
//  Created by simon on 2017/7/13.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "UIViewController+ZXSystemBackButtonAction.h"

@implementation UIViewController (ZXSystemBackButtonAction)


@end

@implementation UINavigationController (ZXPopBackButton)

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    //手势滑动过去的时候，当前控制器会从navigationController移除；
    if (self.viewControllers.count<navigationBar.items.count)
    {
        return YES;
    }
    BOOL shouldPop = YES;
    UIViewController *vc = self.topViewController;
    if ([vc respondsToSelector:@selector(navigationShouldPopOnBackButton)])
    {
        shouldPop = [vc navigationShouldPopOnBackButton];
    }
    if (shouldPop)
    {
        [self popViewControllerAnimated:YES];
    }
    else
    {
        for(UIView *subview in [navigationBar subviews])
        {
            if (0.f<subview.alpha && subview.alpha <1.)
            {
                [UIView animateWithDuration:0.2 animations:^{
                    subview.alpha = 1.f;
                }];
            }
        }
    }
    return NO;
}


@end
