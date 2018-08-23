//
//  ZXModalTransitionDelegate.m
//  YiShangbao
//
//  Created by simon on 17/3/9.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXModalTransitionDelegate.h"


@implementation ZXModalTransitionDelegate
//1
- (nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    ZXModalAnimatedTranstion *transition = [[ZXModalAnimatedTranstion alloc] init];
    transition.type = ZXAnimationTypePresent;
    transition.contentSize = self.contentSize;
    return transition;
}

//4－如果返回nil，就默认用系统的方式－向下移动dismiss了
- (nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    ZXModalAnimatedTranstion *transition = [[ZXModalAnimatedTranstion alloc] init];
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
