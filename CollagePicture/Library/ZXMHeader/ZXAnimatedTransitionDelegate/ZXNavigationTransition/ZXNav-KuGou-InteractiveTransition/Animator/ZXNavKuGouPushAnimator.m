//
//  ZXNavKuGouPushAnimator.m
//  YiShangbao
//
//  Created by simon on 2018/8/14.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "ZXNavKuGouPushAnimator.h"

@implementation ZXNavKuGouPushAnimator

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
    
    //动画 仿射变换动画
    float centerX = toView.bounds.size.width *0.5;
    float centerY = toView.bounds.size.height *0.5;
    float x = toView.bounds.size.width *0.5;
    float y = toView.bounds.size.height *1.8;
    
    //起始位置: 原始位置绕x,y旋转45º后的位置
    CGAffineTransform trans = [self getCGAffineTransformRotateAroundCenterX:centerX centerY:centerY x:x y:y angle:45.0/180.0*M_PI];
    toView.transform = trans;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        //终止位置: 原始位置
        toView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
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
