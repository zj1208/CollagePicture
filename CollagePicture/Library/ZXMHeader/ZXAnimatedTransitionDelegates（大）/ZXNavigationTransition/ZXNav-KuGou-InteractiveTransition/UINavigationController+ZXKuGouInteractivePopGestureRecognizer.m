//
//  UINavigationController+ZXKuGouInteractivePopGestureRecognizer.m
//  YiShangbao
//
//  Created by simon on 2018/8/23.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "UINavigationController+ZXKuGouInteractivePopGestureRecognizer.h"


@implementation UINavigationController (ZXKuGouInteractivePopGestureRecognizer)


static char InteractivePopGestureRecognizerKey;

- (ZXNavKuGouTransitionDelegate *)kuGouTransitionDelegate
{
    if (!objc_getAssociatedObject(self, &InteractivePopGestureRecognizerKey))
    {
        ZXNavKuGouTransitionDelegate *transitionDelegate = [[ZXNavKuGouTransitionDelegate alloc] init];
        [self setKuGouTransitionDelegate:transitionDelegate];
    }
    return objc_getAssociatedObject(self, &InteractivePopGestureRecognizerKey);
}
//- (ZXNavKuGouTransitionDelegate *)navKuGouTransitionDelegate
//{
//    if (!_navKuGouTransitionDelegate) {
//        _navKuGouTransitionDelegate = [[ZXNavKuGouTransitionDelegate alloc] init];
//    }
//    return _navKuGouTransitionDelegate;
//}

- (void)setKuGouTransitionDelegate:(ZXNavKuGouTransitionDelegate *)kuGouTransitionDelegate
{
    objc_setAssociatedObject(self, &InteractivePopGestureRecognizerKey, kuGouTransitionDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)zx_setNavigatonKuGouTransitionWithAnimationTransition:(BOOL)flag interactivePopGestureTransition:(BOOL)interactiveFlag
{
    if (flag)
    {
        self.delegate = self.kuGouTransitionDelegate;
    }
    if (flag && interactiveFlag)
    {
        UIPanGestureRecognizer *interactiveTransitionRecognizer;
        interactiveTransitionRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(interactiveTransitionRecognizerAction:)];
        [self.view addGestureRecognizer:interactiveTransitionRecognizer];
    }
}



- (void)interactiveTransitionRecognizerAction:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    CGFloat width = UIScreen.mainScreen.bounds.size.width;
    CGFloat scale = 1 - fabs(translation.x / width);
    scale = scale < 0 ? 0 : scale;
    
    NSLog(@"nav_滑动后还剩下百分比 = %f", scale);
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStatePossible:
            break;
        case UIGestureRecognizerStateBegan:{
            
            //2. 传值
            self.kuGouTransitionDelegate.customInteractivePopGestureRecognizer = gestureRecognizer;
            
            //3. pop跳转
            [self popViewControllerAnimated:YES];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            
            break;
        }
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            
            self.kuGouTransitionDelegate.customInteractivePopGestureRecognizer = nil;
        }
    }
}


@end
