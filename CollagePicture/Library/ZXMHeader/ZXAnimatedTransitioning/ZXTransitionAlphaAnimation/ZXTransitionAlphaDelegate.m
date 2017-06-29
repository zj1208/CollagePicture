//
//  ZXTransitionAlphaDelegate.m
//  lovebaby
//
//  Created by simon on 16/6/28.
//  Copyright © 2016年 . All rights reserved.
//

#import "ZXTransitionAlphaDelegate.h"
#import "ZXPresentAlphaTransitioning.h"

@implementation ZXTransitionAlphaDelegate

//1
- (nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    ZXPresentAlphaTransitioning *transition = [[ZXPresentAlphaTransitioning alloc] init];
    transition.type = ZXAnimationTypePresent;
    return transition;
}

//4－如果返回nil，就默认用系统的方式－向下移动dismiss了
- (nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    ZXPresentAlphaTransitioning *transition = [[ZXPresentAlphaTransitioning alloc] init];
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
