//
//  ZXAlphaAnimatedTranstion.m
//  lovebaby
//
//  Created by simon on 16/6/28.
//  Copyright © 2016年 . All rights reserved.
//

#import "ZXAlphaAnimatedTranstion.h"

@interface ZXAlphaAnimatedTranstion ()

@property (nonatomic, strong)UIView *coverView;

@end

@implementation ZXAlphaAnimatedTranstion

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (self.type ==ZXAnimationTypePresent)
    {
        return 0.3f;
    } else if (self.type ==ZXAnimationTypeDismiss)
    {
        return 0.2f;
    }
    else return [super transitionDuration:transitionContext];
}

//3
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    
    if (self.type ==ZXAnimationTypePresent)
    {
        self.coverView.frame = containerView.frame;
        self.coverView.alpha = 0;
        [containerView addSubview:self.coverView];
        
        [self zx_presentAnimateTransition:transitionContext withContainerView:containerView];
    }
    else if (self.type ==ZXAnimationTypeDismiss)
    {
        [self zx_dismissAnimateTransition:transitionContext withContainerView:containerView];
    }
}

#pragma mark - 弹出动画处理
- (void)zx_presentAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext withContainerView:(UIView *)containerView
{
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    //    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    // 添加整个控制器的view，且让它是透明的；
    [containerView addSubview:toView];
    // 如果设置contentSize，则整个控制器view的大小就设置约束控制width，height；
    if (!CGSizeEqualToSize(CGSizeZero, self.contentSize))
    {
        [self addConstraintsView:containerView withContentSizeView:toView];
        toView.layer.cornerRadius = 4.f;
        toView.layer.masksToBounds = YES;
    }
    else
    {
        toView.frame =containerView.frame;
        toView.backgroundColor = [UIColor clearColor];
    }
    
    toView.alpha = 0.f;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.coverView.alpha = 1.0f;
        toView.alpha = 1.f;
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
}

#pragma mark - 消失动画处理

- (void)zx_dismissAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext withContainerView:(UIView *)containerView
{
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    NSTimeInterval duration = [self transitionDuration:transitionContext];

    UIView *snapshot = [fromView snapshotViewAfterScreenUpdates:NO];
    snapshot.frame = fromView.frame;
    [containerView addSubview:snapshot];
    [containerView bringSubviewToFront:snapshot];
    [fromView removeFromSuperview];
    
    //        CGRect originalFrame = snapshot.frame;
    //        snapshot.layer.anchorPoint = CGPointMake(0.0, 1.0);
    //        snapshot.frame = originalFrame;
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    [UIView animateKeyframesWithDuration:duration delay:0 options:0 animations:^{
        
        [self addUIViewKeyFrameAnimations:snapshot];
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
        [self.coverView removeFromSuperview];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
}


- (UIView *)coverView
{
    if (!_coverView)
    {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    }
    return _coverView;
}

// containerView父视图，fromView：展示的子视图

- (void)addConstraintsView:(UIView *)containerView withContentSizeView:(UIView *)itemView
{
    itemView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:itemView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    constraint3.active = YES;
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:itemView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:self.contentSize.height];
    constraint4.active = YES;
    
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:itemView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    constraint1.active = YES;
    
    NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:itemView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:self.contentSize.width];
    constraint2.active = YES;
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

//边旋转边缩放行不通；
//- (void)transformImageView
//{
//    CGAffineTransform t = CGAffineTransformMakeScale(scale * previousScale,
//                                                     scale * previousScale);
//    t = CGAffineTransformRotate(t, rotation + previousRotation);
//    self.imageView.transform = t;
//}

// 当transition context的方法[transitionContext completeTransition:YES]被调用的时候，这个便利实现方法就会通过系统回调；
- (void)animationEnded:(BOOL) transitionCompleted
{
    
}
@end
