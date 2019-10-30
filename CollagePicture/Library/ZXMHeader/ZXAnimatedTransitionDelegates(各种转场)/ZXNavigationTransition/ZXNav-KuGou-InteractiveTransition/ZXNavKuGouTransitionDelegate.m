//
//  ZXNavKuGouTransitionDelegate.m
//  YiShangbao
//
//  Created by simon on 2018/8/14.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "ZXNavKuGouTransitionDelegate.h"

#import "ZXNavKuGouPushAnimator.h"
#import "ZXNavKuGouPopAnimator.h"
#import "ZXNavKuGouDrivenInteractiveTransition.h"

@interface ZXNavKuGouTransitionDelegate ()

@property (nonatomic, strong) ZXNavKuGouPushAnimator *kuGouPushAnimator;
@property (nonatomic, strong) ZXNavKuGouPopAnimator *kuGouPopAnimator;

@property (nonatomic, strong) ZXNavKuGouDrivenInteractiveTransition *drivenInteractiveTransition;

@end

@implementation ZXNavKuGouTransitionDelegate

+ (instancetype)sharedInstance
{
    static id singletonInstance = nil;
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        
        if (!singletonInstance)
        {
            singletonInstance = [[super allocWithZone:NULL] init];
        }
    });
    return singletonInstance;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush)
    {
        return self.kuGouPushAnimator;
    }
    else if (operation == UINavigationControllerOperationPop)
    {
        return self.kuGouPopAnimator;
    }
    return nil;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    if (self.customInteractivePopGestureRecognizer)
    {
        return self.drivenInteractiveTransition;
    }
    else
    {
        self.drivenInteractiveTransition = nil;
        return nil;
    }
}

- (ZXNavKuGouPushAnimator *)kuGouPushAnimator
{
    if (!_kuGouPushAnimator)
    {
        _kuGouPushAnimator = [[ZXNavKuGouPushAnimator alloc] init];
    }
    return _kuGouPushAnimator;
}

- (ZXNavKuGouPopAnimator *)kuGouPopAnimator
{
    if (!_kuGouPopAnimator)
    {
        _kuGouPopAnimator = [[ZXNavKuGouPopAnimator alloc] init];
    }
    return _kuGouPopAnimator;
}


- (ZXNavKuGouDrivenInteractiveTransition *)drivenInteractiveTransition
{
    if (!_drivenInteractiveTransition)
    {
        _drivenInteractiveTransition = [[ZXNavKuGouDrivenInteractiveTransition alloc] initWithGestureRecognizer:self.customInteractivePopGestureRecognizer];
    }
    return _drivenInteractiveTransition;
}
@end




