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

@interface ZXWXBigImageTransitionDelegate ()

@property (nonatomic, strong) ZXWXBigImageAppearAnimator *appearAnimator;
@property (nonatomic, strong) ZXWXBigImageDisappearAnimator *disappearAnimator;

@end

@implementation ZXWXBigImageTransitionDelegate

//1
- (nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self.appearAnimator;
}

//4－如果返回nil，就默认用系统的方式－向下移动dismiss了
- (nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self.disappearAnimator;
}


- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush)
    {
        return self.appearAnimator;
    }
    else if (operation == UINavigationControllerOperationPop)
    {
        return self.disappearAnimator;
    }
    return nil;
}


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


/** 转场过渡的图片 */
- (void)setTransitionImage:(UIImage *)transitionImage{
    self.appearAnimator.transitionImage = transitionImage;
    self.disappearAnimator.transitionImage = transitionImage;
}

/** 转场前的图片frame */
- (void)setTransitionBeforeImgFrame:(CGRect)frame{
    self.appearAnimator.transitionBeforeImgFrame = frame;
    self.disappearAnimator.transitionBeforeImgFrame = frame;
}

/** 转场后的图片frame */
- (void)setTransitionAfterImgFrame:(CGRect)frame{
    self.appearAnimator.transitionAfterImgFrame = frame;
    self.disappearAnimator.transitionAfterImgFrame = frame;
}

@end
