//
//  CALayer+ZXTransitionAnimation.m
//  YiShangbao
//
//  Created by simon on 2018/8/13.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "CALayer+ZXTransitionAnimation.h"

@implementation CALayer (ZXTransitionAnimation)

- (void)zx_customDirectionFromTopAnimationType:(NSString *)kCATransitionType
{
    CATransition * animation = [CATransition animation];
    animation.duration = 0.5f;
    //    animation.delegate = self;
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //    animation.timingFunction = UIViewAnimationCurveEaseInOut;//调速功能
    animation.type = kCATransitionType;//动画模式-4选一
    animation.subtype = kCATransitionFromTop; //动画方向-对于淡化，不需要可以所以省略
    //这里可以添加要转变的uiview，变化动作
    [self addAnimation:animation forKey:@"alpha"];
}

- (void)zx_customDirectionFromBottomAnimationType:(NSString *)kCATransitionType
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
    [self addAnimation:animation forKey:@"alpha"];
}

- (void)zx_addCATansitionWithAnimationType:(NSString *)kCATransitionType directionOfTransitionSubtype:(NSString *)subtype
{
    CATransition * animation = [CATransition animation];
    animation.duration = 0.5f;
    //    animation.delegate = self;
    //    2种方法是不同的，但意思是一样的。这里不能用，得区分
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //    animation.timingFunction = UIViewAnimationCurveEaseInOut;//调速功能
    animation.type = kCATransitionType;
    animation.subtype = subtype;
    [self addAnimation:animation forKey:nil];
}
@end
