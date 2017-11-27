//
//  ZXModalAnimation.m
//  ZXControllerTransition
//
//  Created by simon on 15/11/10.
//  Copyright © 2015年 zhuxinming. All rights reserved.
//

#import "ZXModalAnimation.h"

@interface ZXModalAnimation ()

@property (nonatomic, strong)UIView *coverView;

@end

@implementation ZXModalAnimation
{
    NSArray *_constraints;
}
#pragma mark - Animated Transitioning


- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (self.type ==ZXAnimationTypePresent)
    {
        return 0.3f;
    }
    else if (self.type ==ZXAnimationTypeDismiss)
    {
        return 0.2;
    }
    else return [super transitionDuration:transitionContext];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{

    UIView *containerView = [transitionContext containerView];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    if (self.type ==ZXAnimationTypePresent)
    {
        /**
         *  先加遮图
         */
        if (!_coverView)
        {
            _coverView = [[UIView alloc] initWithFrame:containerView.frame];
            _coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
            _coverView.alpha = 0;
        }
        else
        {
            _coverView.frame = containerView.frame;
            _coverView.alpha = 0;
        }
        [containerView addSubview:_coverView];
        
        /**
         *  加入切入图
         */

//        toVC.view.translatesAutoresizingMaskIntoConstraints = NO;
        //添加整个控制器的view，且让它是透明的；
        [containerView addSubview:toVC.view];
        if (!CGSizeEqualToSize(CGSizeZero, self.contentSize))
        {
            toVC.view.layer.cornerRadius = 4.f;
            toVC.view.layer.masksToBounds = YES;
            [self addConstraintsView:containerView withView:toVC.view];
        }
        else
        {
            toVC.view.frame =containerView.frame;
            toVC.view.backgroundColor = [UIColor clearColor];
        }
        //控制用户交互
        toVC.view.alpha = 0.f;
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            _coverView.alpha = 1.0f;
            toVC.view.alpha = 1.f;

        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];

        }];
        //设置frame的原点位置，在屏幕外

//        CGRect endFrame = toVC.view.frame;
//        NSLog(@"%@",NSStringFromCGRect(endFrame));
//        toVC.view.frame = CGRectMake(0, -CGRectGetHeight(endFrame), CGRectGetWidth(endFrame), CGRectGetHeight(endFrame));
   
        //这个从上往下走的动画，是整个控制器view弹簧动画的，所以背景半透明要自己自定义一个背景view，额外加上，不然效果不好；
//        [UIView animateWithDuration:2.0f delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:0.3f options:UIViewAnimationOptionLayoutSubviews animations:^{
//            
//            toVC.view.frame = endFrame;
//            _coverView.alpha = 1.0f;
//            
//        } completion:^(BOOL finished) {
//            
//            [transitionContext completeTransition:YES];
//            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
//
//        }];
       
    }
    else if (self.type ==ZXAnimationTypeDismiss)
    {
        UIView *modalView = fromVC.view;
//       也可以直接使用modalView.
        //Grab a snapshot of the modal view for animating
        UIView *snapshot = [modalView snapshotViewAfterScreenUpdates:NO];
        snapshot.frame = modalView.frame;
        [containerView addSubview:snapshot];
        [containerView bringSubviewToFront:snapshot];
        [modalView removeFromSuperview];
        
        //Set the snapshot's anchor point for CG transform 设置anchorPoint是为了CG 转换用的;
//        CGRect originalFrame = snapshot.frame;
//        snapshot.layer.anchorPoint = CGPointMake(0, 1);
//        snapshot.frame = originalFrame;
//
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];

        [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext] delay:0 options:0 animations:^{
            
            [self addUIViewKeyFrameAnimations:snapshot];
            
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
            [_coverView removeFromSuperview];
            [containerView removeConstraints:_constraints];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }];
    }
    
}


//containerView父视图，modalView：展示的子视图

- (void)addConstraintsView:(UIView *)containerView withView:(UIView *)modalView
{
    modalView.translatesAutoresizingMaskIntoConstraints = NO;

    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:modalView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [containerView addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:modalView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:self.contentSize.height];
    [modalView addConstraint:constraint4];

    
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:modalView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    [containerView addConstraint:constraint1];

    NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:modalView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:self.contentSize.width];
    [modalView addConstraint:constraint2];

//    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:modalView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeTop multiplier:1 constant:100];
//    [containerView addConstraint:constraint4];
//
//    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:modalView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:400];
//    [modalView addConstraint:constraint3];

//    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:modalView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:modalView attribute:NSLayoutAttributeWidth multiplier:1.3 constant:0];
//    [modalView addConstraint:constraint3];

}
- (void)addUIViewKeyFrameAnimations:(UIView *)view
{
    [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1.0 animations:^{
        //90 degrees (clockwise)
        view.transform = CGAffineTransformMakeScale(0, 0);
        view.alpha = 0;
    }];
//    [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.15 animations:^{
//        //90 degrees (clockwise)
//        view.transform = CGAffineTransformMakeRotation(M_PI*-1.5);
//    }];

//    [UIView addKeyframeWithRelativeStartTime:0.15 relativeDuration:0.15 animations:^{
//        //180 degrees
//        view.transform = CGAffineTransformMakeRotation(M_PI);
//    }];
//
//    [UIView addKeyframeWithRelativeStartTime:0.3 relativeDuration:0.2 animations:^{
//        //Swing past, ~225 degrees
//        view.transform = CGAffineTransformMakeRotation(M_PI*1.3);
//    }];
//    
//    [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.20 animations:^{
//        //Swing back, ~140 degrees
//        view.transform = CGAffineTransformMakeRotation(M_PI * 0.8);
//    }];

//    [UIView addKeyframeWithRelativeStartTime:0.7
//                            relativeDuration:0.3 animations:^{
//                                //旋转后掉落
//                                //最后一步，视图淡出并消失
//                                //方向移100距离，y方向0距离；
//                                CGAffineTransform shift =CGAffineTransformMakeTranslation(180.0, 0.0);
//                                //按照顺时针方向旋转的，而且旋转中心是原始ImageView的中心
//                                CGAffineTransform rotate = CGAffineTransformMakeRotation(M_PI * 0.3);
//                                view.transform = CGAffineTransformConcat(shift,rotate);
//                                coverView.alpha = 0.0;
//                            }];
}

@end
