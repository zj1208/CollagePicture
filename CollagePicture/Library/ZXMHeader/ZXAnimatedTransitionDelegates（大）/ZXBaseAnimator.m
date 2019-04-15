//
//  ZXBaseAnimator.m
//  ZXControllerTransition
//
//  Created by simon on 15/11/10.
//  Copyright © 2015年 simon. All rights reserved.
//

#import "ZXBaseAnimator.h"

@implementation ZXBaseAnimator

#pragma mark - UIViewControllerAnimatedTransitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    NSAssert(NO, @"animateTransition: should be handled by subclass of ZXBaseAnimator");
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 1.0;
}

-(void)handlePinch:(UIPinchGestureRecognizer *)pinch {
    NSAssert(NO, @"handlePinch: should be handled by a subclass of ZXBaseAnimator");
}

@end
