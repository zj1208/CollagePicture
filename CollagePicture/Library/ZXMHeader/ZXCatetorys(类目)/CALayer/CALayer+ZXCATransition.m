//
//  CALayer+ZXCATransition.m
//  YiShangbao
//
//  Created by simon on 2018/8/13.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "CALayer+ZXCATransition.h"

@implementation CALayer (ZXCATransition)

- (void)zx_customDirectionFromTopAnimationType:(NSString *)kCATransitionType
{
    CATransition * transitionAnimation = [CATransition animation];
    transitionAnimation.duration = 0.5f;
    //animation.delegate = self;
    CAMediaTimingFunction *timingFuncation = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transitionAnimation.timingFunction = timingFuncation;
    transitionAnimation.type = kCATransitionType;//动画模式-4选一
    transitionAnimation.subtype = kCATransitionFromTop; //动画方向-对于淡化，不需要可以所以省略
    [self addAnimation:transitionAnimation forKey:@"alpha"];    
}

- (void)zx_customDirectionFromBottomAnimationType:(NSString *)kCATransitionType
{
    CATransition * transitionAnimation = [CATransition animation];
    transitionAnimation.duration = 0.5f;
    //animation.delegate = self;
    CAMediaTimingFunction *timingFuncation = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transitionAnimation.timingFunction = timingFuncation;
    transitionAnimation.type = kCATransitionType;
    transitionAnimation.subtype = kCATransitionFromBottom; //对于淡化，不需要动画方向，所以省略
    [self addAnimation:transitionAnimation forKey:@"alpha"];
}
// Core Animation自身并不是一个绘图系统。它只是一个负责在硬件上合成和操纵应用内容的基础构件。CoreAnimation的核心是图层，图层管理位图的状态信息，就是一个模型对象；Core Animation将实际的绘图任务交给了图形硬件处理，图形硬件会加速图形渲染的速度，使用硬件帮你完成每一帧的绘制工作;
//  （1）图层对象用于管理和操控你的视图内容，根本上图层用于捕获视图内容并缓存到位图中;（2）当你改变一个图层的属性值，你做的所有只是改变了与图层对象相关联的状态信息。当你的更改触发了一个动画，Core Animation传递图层的位图和图层的状态给图形处理硬件；（3）图形处理器把获得的信息渲染到位图上。
- (void)zx_addCATansitionWithAnimationType:(NSString *)kCATransitionType directionOfTransitionSubtype:(NSString *)subtype
{
    CATransition * transitionAnimation = [CATransition animation];
    transitionAnimation.duration = 0.5f;
    transitionAnimation.delegate = self;
    CAMediaTimingFunction *timingFuncation = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transitionAnimation.timingFunction = timingFuncation;
    transitionAnimation.type = kCATransitionType;
    transitionAnimation.subtype = subtype;
    transitionAnimation.startProgress = 0;
    transitionAnimation.endProgress = 1.f;
    [self addAnimation:transitionAnimation forKey:nil];
}

- (void)animationDidStart:(CAAnimation *)anim
{
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
}
@end
