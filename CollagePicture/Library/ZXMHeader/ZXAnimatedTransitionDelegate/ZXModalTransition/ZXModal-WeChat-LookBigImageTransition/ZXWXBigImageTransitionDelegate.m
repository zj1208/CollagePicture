//
//  ZXWXBigImageTransitionDelegate.m
//  YiShangbao
//
//  Created by simon on 2018/8/15.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "ZXWXBigImageTransitionDelegate.h"

#import "ZXWXBigImageAppearAnimator.h"
#import "ZXWXBigImageDisappearAnimator.h"
#import "ZXModalWeChatDrivenInteractiveTransition.h"

@interface ZXWXBigImageTransitionDelegate ()

@property (nonatomic, strong) ZXWXBigImageAppearAnimator *appearAnimator;
@property (nonatomic, strong) ZXWXBigImageDisappearAnimator *disappearAnimator;
@property (nonatomic, strong) ZXModalWeChatDrivenInteractiveTransition *drivenInteractiveTransition;
@end

@implementation ZXWXBigImageTransitionDelegate

//1
- (nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self.appearAnimator;
}

//2
- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator
{
//    self.drivenInteractiveTransition = nil;
    return nil;
}

// 调用dismissViewController后的回调响应：
// 第一步－dismiss转场动画； 如果返回nil，就默认用系统的方式向下移动dismiss；
- (nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self.disappearAnimator;
}

// 第二步-dismiss交互回调
- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator
{
    if (self.customInteractivePopGestureRecognizer)
    {
        return self.drivenInteractiveTransition;
    }
    return nil;
}

//- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
//{
//    if (operation == UINavigationControllerOperationPush)
//    {
//        return self.appearAnimator;
//    }
//    else if (operation == UINavigationControllerOperationPop)
//    {
//        return self.disappearAnimator;
//    }
//    return nil;
//}


- (ZXWXBigImageAppearAnimator *)appearAnimator
{
    if (!_appearAnimator)
    {
        _appearAnimator = [[ZXWXBigImageAppearAnimator alloc] init];
    }
    return _appearAnimator;
}

- (ZXWXBigImageDisappearAnimator *)disappearAnimator
{
    if (!_disappearAnimator)
    {
        _disappearAnimator = [[ZXWXBigImageDisappearAnimator alloc] init];
    }
    return _disappearAnimator;
}

- (ZXModalWeChatDrivenInteractiveTransition *)drivenInteractiveTransition
{
    if (!_drivenInteractiveTransition)
    {
        _drivenInteractiveTransition = [[ZXModalWeChatDrivenInteractiveTransition alloc] initWithGestureRecognizer:self.customInteractivePopGestureRecognizer];
    }
    return _drivenInteractiveTransition;
}

/** 转场过渡的图片 */
- (void)setTransitionImage:(UIImage *)transitionImage
{
    self.appearAnimator.transitionImage = transitionImage;
    self.disappearAnimator.transitionImage = transitionImage;
}

// 初始化三个属性
/** 转场前的图片frame */
- (void)setTransitionBeforeImgFrame:(CGRect)frame
{
    self.appearAnimator.transitionBeforeImgFrame = frame;
    self.disappearAnimator.transitionBeforeImgFrame = frame;
//    self.drivenInteractiveTransition.transitionBeforeImgFrame = frame;
}

/** 转场后的图片frame */
- (void)setTransitionAfterImgFrame:(CGRect)frame
{
    self.appearAnimator.transitionAfterImgFrame = frame;
    self.disappearAnimator.transitionAfterImgFrame = frame;
}



- (void)setInteractiveBeforeImageViewFrame:(CGRect)interactiveBeforeImageViewFrame
{
    _interactiveBeforeImageViewFrame = interactiveBeforeImageViewFrame;
    self.drivenInteractiveTransition.transitionBeforeImgFrame = interactiveBeforeImageViewFrame;
}

- (void)setInteractiveCurrentImageViewFrame:(CGRect)interactiveCurrentImageViewFrame
{
    _interactiveCurrentImageViewFrame = interactiveCurrentImageViewFrame;
    self.drivenInteractiveTransition.transitionCurrentImgFrame = interactiveCurrentImageViewFrame;
}
- (void)setInteractiveCurrentImage:(UIImage *)interactiveCurrentImage
{
    _interactiveCurrentImage = interactiveCurrentImage;
    self.drivenInteractiveTransition.transitionImage = interactiveCurrentImage;
}
@end
