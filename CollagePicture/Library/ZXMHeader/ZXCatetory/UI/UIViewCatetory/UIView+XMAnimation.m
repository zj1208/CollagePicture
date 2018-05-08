//
//  UIView+XMAnimation.m
//  YiShangbao
//
//  Created by simon on 2018/5/4.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "UIView+XMAnimation.h"

@implementation UIView (XMAnimation)


- (void)xm_showSnapshotSelectedCell:(UITableView *)tableView selectIndexPath:(NSIndexPath *)indexPath onTransformBgViewScaleSuperView:(UIView *)superView
{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    UIView *clipView = [selectedCell snapshotViewAfterScreenUpdates:NO];
    CGRect clipFrame =[selectedCell convertRect:selectedCell.bounds toView:superView];
    clipView.frame = clipFrame;
    
    UIView *view  = [[UIView alloc] initWithFrame:clipFrame];
    view.backgroundColor = [UIColor redColor];
    [superView addSubview:view];
    [superView addSubview:clipView];
    [UIView animateWithDuration:1 animations:^{
        view.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:.3];
        view.transform = CGAffineTransformMakeScale(1, LCDH/clipFrame.size.height*2);
    } completion:^(BOOL finished) {
        [clipView removeFromSuperview];
        [view removeFromSuperview];
    }];
}


+ (void)xm_transformScaleAndRotationWithView:(UIView *)view
{
    CGAffineTransform transformA = CGAffineTransformMakeScale(0.1, 0.1);
    CGAffineTransform transformB = CGAffineTransformMakeRotation(M_PI_2);
    view.transform = CGAffineTransformConcat(transformA, transformB);
    [UIView animateWithDuration:0.5 animations:^{
        
        view.transform = CGAffineTransformIdentity;
    }];
}


+ (void)xm_customDirectionFromTopAnimationType:(NSString *)kCATransitionType layer:(CALayer *)layer
{
    CATransition * animation = [CATransition animation];
    animation.duration = 0.5f;
//    animation.delegate = self;
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    animation.timingFunction = UIViewAnimationCurveEaseInOut;//调速功能
    animation.type = kCATransitionType;//动画模式-4选一
    animation.subtype = kCATransitionFromTop; //动画方向-对于淡化，不需要可以所以省略
    //这里可以添加要转变的uiview，变化动作
    [layer addAnimation:animation forKey:@"alpha"];
}

+ (void)xm_customDirectionFromBottomAnimationType:(NSString *)kCATransitionType layer:(CALayer *)layer
{
    CATransition * animation = [CATransition animation];
    animation.duration = 0.5f;
//    animation.delegate = self;
//    2种方法是不同的，但意思是一样的。这里不能用，得区分
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    animation.timingFunction = UIViewAnimationCurveEaseInOut;//调速功能
    animation.type = kCATransitionType;
    animation.subtype = kCATransitionFromBottom; //对于淡化，不需要动画方向，所以省略
    //这里可以添加要转变的uiview，变化动作
    [layer addAnimation:animation forKey:@"alpha"];
}

@end
