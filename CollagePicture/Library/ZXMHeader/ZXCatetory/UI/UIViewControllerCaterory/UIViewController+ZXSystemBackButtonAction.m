//
//  UIViewController+ZXSystemBackButtonAction.m
//  YiShangbao
//
//  Created by simon on 2017/7/13.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "UIViewController+ZXSystemBackButtonAction.h"

@implementation UIViewController (ZXSystemBackButtonAction)

+ (void)load
{
   [super load];
   zxSwizzling_exchangeMethod([self class], @selector(viewDidLoad), @selector(addViewDidLoad));
}

- (void)addViewDidLoad
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
}

@end

//如果你隐藏了当前页面NavigationCotroller的navigationBar，则对应当前页面的navigationItem会被移除，代理方法也就不会执行了；
// storyboard 过来的不会调用pushviewController：方法，所以不会触发这写navigationBar的代理回调；
@implementation UINavigationController (ZXPopBackButton)

// pushViewController的时候，controller已经push过去了；再来pushNatigationItem；
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item
{
//    NSLog(@"item.title=%@,topController:%@",item.title,self.topViewController);
//    NSLog(@"topItem=%@,backItem:%@",navigationBar.topItem,navigationBar.backItem);
//    如果上一页导航条隐藏，当前页“我接的生意”，下一页“生意”；
//topItem=<<UINavigationItem: 0x7fe2e77408f0>: title:'我接的生意'>,backItem:<<UINavigationItem: 0x7fe2e752e9b0>: title:'(null)'>
//   navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    return YES;
}

- (void)navigationBar:(UINavigationBar *)navigationBar didPushItem:(UINavigationItem *)item
{
    
}

// 重写UINavigationBarDelegate代理方法；是否pop回上一页的navigationItem；
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{

    // 手势滑动过去的时候，当前控制器会从navigationController移除；
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
