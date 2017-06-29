//
//  ZXTransitionModalDelegate.m
//  YiShangbao
//
//  Created by simon on 17/3/9.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXTransitionModalDelegate.h"
#import "ZXModalAnimation.h"

@implementation ZXTransitionModalDelegate
//1
- (nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    ZXModalAnimation *transition = [[ZXModalAnimation alloc] init];
    transition.type = ZXAnimationTypePresent;
    return transition;
}

//4－如果返回nil，就默认用系统的方式－向下移动dismiss了
- (nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    ZXModalAnimation *transition = [[ZXModalAnimation alloc] init];
    transition.type = ZXAnimationTypeDismiss;
    return transition;
}


//2
- (nullable id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return nil;
}

- (nullable id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return nil;
}
@end
