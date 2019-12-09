//
//  UIViewController+ZXKuGouInteractiveDismissGestureRecognizer.h
//  YiShangbao
//
//  Created by simon on 2018/8/23.
//  Copyright © 2018年 com.Microants. All rights reserved.
//
//  简介：给viewController添加自定义prensent/dismiss切换转场-酷狗音乐效果，自定义交互式转场手势返回效果；只要用这个UIViewController类目就行；
//  适用场景：单独打开某个页面功能-卡片式过渡整体；

#import <UIKit/UIKit.h>
#import "ZXModalKuGouTransitionDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ZXKuGouInteractiveDismissGestureRecognizer)

@property (nonatomic, strong) ZXModalKuGouTransitionDelegate * modalKuGouTransitionDelegate;

// 是否开启自定义push/pop切换转场,是否开启自定义交互式转场手势返回
- (void)zx_setTransitionDelegatePresentKuGouWithAnimationTransition:(BOOL)flag interactivePopGestureTransition:(BOOL)interactiveFlag;

@end

NS_ASSUME_NONNULL_END

//例如：在presentedViewController上设置；

/*
#import "UIViewController+ZXKuGouInteractivePopGestureRecognizer.h"

#pragma mark 搜索
- (IBAction)searchAction:(UIBarButtonItem *)sender {
    
    [MobClick event:kUM_b_pd_search];
    ProductSearchController *vc = (ProductSearchController *)[self zx_getControllerWithStoryboardName:storyboard_ShopStore controllerWithIdentifier:SBID_ProductSearchController];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [nav zx_navigationBar_allBackIndicatorImage:@"back_onlyImage" isOriginalImage:YES];
    [nav zx_navigationBar_barItemColor:UIColorFromRGB_HexValue(0x222222)];
    [nav zx_setTransitionDelegatePresentKuGouWithAnimationTransition:YES interactivePopGestureTransition:YES];
    [self presentViewController:nav animated:YES completion:nil];
    
}
*/
