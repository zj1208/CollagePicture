//
//  ZXModalKuGouTransitionDelegate.m
//  YiShangbao
//
//  Created by simon on 2018/8/14.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "ZXModalKuGouTransitionDelegate.h"

#import "ZXNavKuGouPushAnimator.h"
#import "ZXNavKuGouPopAnimator.h"
#import "ZXModalKuGouDrivenInteractiveTransition.h"

@interface ZXModalKuGouTransitionDelegate ()

@property (nonatomic, strong) ZXNavKuGouPushAnimator *kuGouPushAnimator;
@property (nonatomic, strong) ZXNavKuGouPopAnimator *kuGouPopAnimator;

@property (nonatomic, strong) ZXModalKuGouDrivenInteractiveTransition *drivenInteractiveTransition;

@end

@implementation ZXModalKuGouTransitionDelegate

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

//- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
//{
//    if (operation == UINavigationControllerOperationPush)
//    {
//        return self.kuGouPushAnimator;
//    }
//    else if (operation == UINavigationControllerOperationPop)
//    {
//        return self.kuGouPopAnimator;
//    }
//    return nil;
//}

//- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
//{
//    if (self.customInteractivePopGestureRecognizer)
//    {
//        return self.drivenInteractiveTransition;
//    }
//    else
//    {
//        self.drivenInteractiveTransition = nil;
//        return nil;
//    }
//}

//1
- (nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self.kuGouPushAnimator;
}

//4－如果返回nil，就默认用系统的方式－向下移动dismiss了
- (nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self.kuGouPopAnimator;
}

//2
- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator
{
    self.drivenInteractiveTransition = nil;
    return nil;
}
//3
- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator
{
      return self.drivenInteractiveTransition;
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


- (ZXModalKuGouDrivenInteractiveTransition *)drivenInteractiveTransition
{
    if (!_drivenInteractiveTransition)
    {
        _drivenInteractiveTransition = [[ZXModalKuGouDrivenInteractiveTransition alloc] initWithGestureRecognizer:self.customInteractivePopGestureRecognizer];
    }
    return _drivenInteractiveTransition;
}
@end




