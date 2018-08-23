//
//  ZXAlphaTransitionDelegate.m
//  lovebaby
//
//  Created by simon on 16/6/28.
//  Copyright © 2016年 . All rights reserved.
//

#import "ZXAlphaTransitionDelegate.h"

#import "ZXAlphaAnimatedTranstion.h"

@implementation ZXAlphaTransitionDelegate

//1
- (nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    ZXAlphaAnimatedTranstion *transition = [[ZXAlphaAnimatedTranstion alloc] init];
    transition.type = ZXAnimationTypePresent;
    transition.contentSize = self.contentSize;
    return transition;
}

//4－如果返回nil，就默认用系统的方式－向下移动dismiss了
- (nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    ZXAlphaAnimatedTranstion *transition = [[ZXAlphaAnimatedTranstion alloc] init];
    transition.type = ZXAnimationTypeDismiss;
    return transition;
}


// 返回交互
- (nullable id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return nil;
}

- (nullable id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return nil;
}
@end
