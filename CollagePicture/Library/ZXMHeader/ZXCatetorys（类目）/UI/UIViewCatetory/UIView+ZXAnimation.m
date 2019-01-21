//
//  UIView+ZXAnimation.m
//  YiShangbao
//
//  Created by simon on 2018/5/4.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "UIView+ZXAnimation.h"

@implementation UIView (ZXAnimation)


- (void)zx_showSnapshotSelectedCell:(UITableView *)tableView selectIndexPath:(NSIndexPath *)indexPath onTransformBgViewScaleSuperView:(UIView *)superView
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
        view.transform = CGAffineTransformMakeScale(1, [[UIScreen mainScreen] bounds].size.height/clipFrame.size.height*2);
    } completion:^(BOOL finished) {
        [clipView removeFromSuperview];
        [view removeFromSuperview];
    }];
}


+ (void)zx_transformScaleAndRotationWithView:(UIView *)view
{
    CGAffineTransform transformA = CGAffineTransformMakeScale(0.1, 0.1);
    CGAffineTransform transformB = CGAffineTransformMakeRotation(M_PI_2);
    view.transform = CGAffineTransformConcat(transformA, transformB);
    [UIView animateWithDuration:0.5 animations:^{
        
        view.transform = CGAffineTransformIdentity;
    }];
}


- (void)zx_addMotionEffectXAxisWithValue:(CGFloat)xValue YAxisWithValue:(CGFloat)yValue
{
    if ((xValue>=0) && (yValue>=0))
    {
        UIInterpolatingMotionEffect *motionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        motionEffect.minimumRelativeValue = [NSNumber numberWithFloat:-xValue];
        motionEffect.maximumRelativeValue = [NSNumber numberWithFloat:xValue];
//        [self addMotionEffect:motionEffect];
        
        UIInterpolatingMotionEffect *motionEffectY = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        motionEffectY.minimumRelativeValue = [NSNumber numberWithFloat:-yValue];
        motionEffectY.maximumRelativeValue = [NSNumber numberWithFloat:yValue];
//        [self addMotionEffect:motionEffectY];
        
        UIMotionEffectGroup *group = [[UIMotionEffectGroup alloc] init];
        group.motionEffects = @[motionEffect, motionEffectY];
        [self addMotionEffect:group];
    }
}

- (void)zx_removeMotionEffect
{
    NSArray *effects = [self motionEffects];
    for (UIMotionEffect *effect in effects) {
        [self removeMotionEffect:effect];
    }
}

@end
