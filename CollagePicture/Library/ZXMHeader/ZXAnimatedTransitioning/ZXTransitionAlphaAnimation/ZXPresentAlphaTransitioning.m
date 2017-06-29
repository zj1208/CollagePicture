//
//  ZXPresentAlphaTransitioning.m
//  lovebaby
//
//  Created by simon on 16/6/28.
//  Copyright © 2016年 . All rights reserved.
//

#import "ZXPresentAlphaTransitioning.h"

@implementation ZXPresentAlphaTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (self.type ==ZXAnimationTypePresent)
    {
        return 0.8f;
    } else if (self.type ==ZXAnimationTypeDismiss)
    {
        return 0.5f;
    }
    else return [super transitionDuration:transitionContext];
}

//3
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//    NSLog(@"%@,%@",NSStringFromClass([fromVC class]),NSStringFromClass([toVC class]));
    NSTimeInterval duration = [self transitionDuration:transitionContext];

//    if (self.type ==ZXAnimationTypePresent)
//    {
//        [containerView addSubview:toVC.view];
//        
//        CGRect endFrame = toVC.view.frame;
//        CGRect screenRect = [[UIScreen mainScreen]bounds];
//        toVC.view.frame = CGRectMake(0, CGRectGetHeight(screenRect), CGRectGetWidth(fromVC.view.frame), CGRectGetHeight(fromVC.view.frame));
//        [UIView animateWithDuration:0.5f animations:^{
//            
//            toVC.view.frame = endFrame;
//            
//        } completion:^(BOOL finished) {
//            
//            [transitionContext completeTransition:YES];
//            
//        }];
//
//    }
//   放大缩小会让controller里的图片控件压缩；
    if (self.type ==ZXAnimationTypePresent)
    {
        toVC.view.transform = CGAffineTransformMakeScale(0.f, 0.f);
        [containerView insertSubview:toVC.view aboveSubview:fromVC.view];
//        [containerView addSubview:toVC.view];
        
        [UIView animateWithDuration:duration animations:^{
            
            toVC.view.transform = CGAffineTransformMakeScale(1.0f,1.f);
            
        } completion:^(BOOL finished) {
            
            [transitionContext completeTransition:YES];
            
        }];
        
    }
    else
    {
        [UIView animateWithDuration:duration animations:^{
            
            fromVC.view.transform = CGAffineTransformMakeScale(0.f, 0.f);
            
        } completion:^(BOOL finished) {
            
            [transitionContext completeTransition:YES];
            
        }];

    }
}

//边旋转边缩放行不通；
//- (void)transformImageView
//{
//    CGAffineTransform t = CGAffineTransformMakeScale(scale * previousScale,
//                                                     scale * previousScale);
//    t = CGAffineTransformRotate(t, rotation + previousRotation);
//    self.imageView.transform = t;
//}

//转场完成动画
- (void)animationEnded:(BOOL) transitionCompleted
{
    
}
@end
