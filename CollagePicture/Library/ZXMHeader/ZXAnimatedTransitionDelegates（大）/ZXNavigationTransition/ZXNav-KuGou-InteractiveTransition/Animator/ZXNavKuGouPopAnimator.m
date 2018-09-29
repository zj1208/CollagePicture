//
//  ZXNavKuGouPopAnimator.m
//  YiShangbao
//
//  Created by simon on 2018/8/14.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "ZXNavKuGouPopAnimator.h"

@implementation ZXNavKuGouPopAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.4;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];

    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    // 添加整个控制器的view，且让它是透明的；
    [containerView addSubview:toView];
    
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    [containerView addSubview:fromView];

    
    //动画 仿射变换动画
    float centerX = fromView.bounds.size.width *0.5;
    float centerY = fromView.bounds.size.height *0.5;
    float x = fromView.bounds.size.width *0.5;
    float y = fromView.bounds.size.height *1.8;
    
    //起始位置: 原始位置
    fromView.transform = CGAffineTransformIdentity;
    
    
    CGAffineTransform transf = [self getCGAffineTransformRotateAroundCenterX:centerX centerY:centerY x:x y:y angle:45.0/180.0*M_PI];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        //终止位置: 原始位置绕x,y旋转45º后的位置
        fromView.transform = transf;
        
    } completion:^(BOOL finished) {
//        如果手势返回被取消了，不应该回调完成转场；
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        if (!wasCancelled) {
            
            [fromView removeFromSuperview];
        }
        [transitionContext completeTransition:!wasCancelled];
    }];
}

- (void)animationEnded:(BOOL)transitionCompleted
{
    
}

/**
 仿射变换
 
 @param centerX     view的中心点X坐标
 @param centerY     view的中心点Y坐标
 @param x           旋转中心x坐标
 @param y           旋转中心y坐标
 @param angle       旋转的角度
 @return            CGAffineTransform对象
 */
- (CGAffineTransform)getCGAffineTransformRotateAroundCenterX:(float)centerX centerY:(float)centerY x:(float)x y:(float)y angle:(float)angle
{
    CGFloat l = y - centerY;
    CGFloat h = l * sin(angle);
    CGFloat b = l * cos(angle);
    CGFloat a = l - b;
    CGFloat x1 = h;
    CGFloat y1 = a;
    
    CGAffineTransform  trans = CGAffineTransformMakeTranslation(x1, y1);
    trans = CGAffineTransformRotate(trans,angle);
    
    return trans;
}

@end

