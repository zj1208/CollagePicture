//
//  ZXModalKuGouDrivenInteractiveTransition.m
//  YiShangbao
//
//  Created by simon on 2018/8/22.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "ZXModalKuGouDrivenInteractiveTransition.h"

@interface ZXModalKuGouDrivenInteractiveTransition()

@property (nonatomic, strong, readonly) UIPanGestureRecognizer *customInteractivePopGestureRecognizer;

@end

@implementation ZXModalKuGouDrivenInteractiveTransition


// 实现 UIViewControllerInteractiveTransitioning 协议的方法（必须实现）
// 相当于走到 Animator 中的代理方法去了，那里实现了具体的动画
- (void)startInteractiveTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    [super startInteractiveTransition:transitionContext];
}


- (instancetype)initWithGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer
{
    self = [super init];
    if (self)
    {
        _customInteractivePopGestureRecognizer = gestureRecognizer;
        [_customInteractivePopGestureRecognizer addTarget:self action:@selector(gestureRecognizeDidUpdate:)];
    }
    return self;
}

- (void)dealloc
{
    [self.customInteractivePopGestureRecognizer removeTarget:self action:@selector(gestureRecognizeDidUpdate:)];
}

- (CGFloat)percentForGesture:(UIPanGestureRecognizer *)gesture
{
    CGPoint translation = [gesture translationInView:gesture.view];
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat scale = 1- (translation.x / screenWidth);    scale = scale<0?0:scale;
    scale = scale>1?1:scale;
    return scale;
}

- (void)gestureRecognizeDidUpdate:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGFloat scale = 1-[self percentForGesture:gestureRecognizer];

    switch (gestureRecognizer.state)
    {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
//            更新百分比
            [self updateInteractiveTransition:scale];
            break;
        case UIGestureRecognizerStateCancelled:
            [self cancelInteractiveTransition];
            break;
        case UIGestureRecognizerStateEnded:
            if (scale <0.3)
            {
//                取消转场
                [self cancelInteractiveTransition];
            }
            else
            {
//                完成转场
                [self finishInteractiveTransition];
            }
            break;
        default:
            [self cancelInteractiveTransition];
            break;
    }
}
@end
