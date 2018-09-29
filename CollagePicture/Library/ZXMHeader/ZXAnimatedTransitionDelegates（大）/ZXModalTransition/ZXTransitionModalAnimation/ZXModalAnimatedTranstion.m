//
//  ZXModalAnimatedTranstion.m
//  ZXControllerTransition
//
//  Created by simon on 15/11/10.
//  Copyright © 2015年 zhuxinming. All rights reserved.
//

#import "ZXModalAnimatedTranstion.h"

@interface ZXModalAnimatedTranstion ()

@property (nonatomic, strong)UIView *coverView;

@end

@implementation ZXModalAnimatedTranstion


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
//    BOOL isAnimated = transitionContext.isAnimated;
//    BOOL isInteractive = transitionContext.isInteractive;
//    BOOL transitionWasCanclled = transitionContext.transitionWasCancelled;
//    UIModalPresentationStyle presentationStyle = transitionContext.presentationStyle;
//    CGAffineTransform targetTransform = transitionContext.targetTransform;
  
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
//    NSTimeInterval duration = [self transitionDuration:transitionContext];
//    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
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
    //控制用户交互
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    //设置frame的原点位置，在屏幕外
    CGRect endFrame = toView.frame;
    toView.frame = CGRectMake(0, -CGRectGetHeight(endFrame), CGRectGetWidth(endFrame), CGRectGetHeight(endFrame));
    //        这个从上往下走的动画，是整个控制器view弹簧动画的，所以背景半透明要自己自定义一个背景view，额外加上，不然效果不好；
    WS(weakSelf);
    [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:0.2f options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        toView.frame = endFrame;
        weakSelf.coverView.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:YES];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
//        NSLog(@"%@",containerView.subviews);

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
//    <__NSArrayM 0x60000291c720>(
//    <UIView: 0x7ffdcc4f31a0; frame = (0 0; 375 812); layer = <CALayer: 0x6000021ebe60>>,
//    <_UIReplicantView: 0x7ffdce8720f0; frame = (40 202.667; 295 407); layer = <_UIReplicantLayer: 0x60000231cf60>>
//    )
    //        CGRect originalFrame = snapshot.frame;
    //        snapshot.layer.anchorPoint = CGPointMake(0.0, 1.0);
    //        snapshot.frame = originalFrame;
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
//    bug：这个动画由于设置snapshot.transform = CGAffineTransformMakeScale(0, 0);或 self.coverView.alpha = 0.f;导致全部无动画过渡效果；
//    [UIView animateWithDuration:2.5 animations:^{
////        无效，不会有2.5秒执行过程，还导致全部无动画效果，2.5秒后才回调completion，是不是这个图层有问题？
////        snapshot.transform = CGAffineTransformMakeScale(0, 0);
//////        这个alpha动画有效
////        snapshot.alpha = 0;
////        无效，不会有2.5秒执行过程，还导致全部无动画效果，2.5秒后才回调completion
//        self.coverView.alpha = 0.f;
//
//    } completion:^(BOOL finished) {
//
//        [self.coverView removeFromSuperview];
//        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
//        BOOL wasCancelled = [transitionContext transitionWasCancelled];
//        [transitionContext completeTransition:!wasCancelled];
//    }];
    
    //  bug:这个动画设置self.coverView.alpha = 0.f;无动画过渡效果，其它有；
    [UIView animateKeyframesWithDuration:duration delay:0 options:0 animations:^{

        [self addUIViewKeyFrameAnimations:snapshot totalDuration:duration];

    } completion:^(BOOL finished) {
        [self.coverView removeFromSuperview];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
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


- (void)addUIViewKeyFrameAnimations:(UIView *)view totalDuration:(NSTimeInterval)duration
{
    [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:duration animations:^{
        //有效
        view.transform = CGAffineTransformMakeScale(0, 0);
        //有效
        view.alpha = 0;
//        无效
        self.coverView.alpha = 0.f;
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

// 当transition context的方法[transitionContext completeTransition:YES]被调用的时候，这个便利实现方法就会通过系统回调；
- (void)animationEnded:(BOOL) transitionCompleted
{
    
}
@end
