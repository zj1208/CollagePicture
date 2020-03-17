//
//  UIViewController+ZXKuGouInteractiveDismissGestureRecognizer.m
//  YiShangbao
//
//  Created by simon on 2018/8/23.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "UIViewController+ZXKuGouInteractiveDismissGestureRecognizer.h"


@implementation UIViewController (ZXKuGouInteractiveDismissGestureRecognizer)

static char InteractivePopGestureRecognizerKey2;

- (ZXModalKuGouTransitionDelegate *)modalKuGouTransitionDelegate
{
    if (!objc_getAssociatedObject(self, &InteractivePopGestureRecognizerKey2))
    {
        ZXModalKuGouTransitionDelegate *transitionDelegate = [[ZXModalKuGouTransitionDelegate alloc] init];
        [self setModalKuGouTransitionDelegate:transitionDelegate];
    }
    return objc_getAssociatedObject(self, &InteractivePopGestureRecognizerKey2);
}


- (void)setModalKuGouTransitionDelegate:(ZXModalKuGouTransitionDelegate *)modalKuGouTransitionDelegate
{
    objc_setAssociatedObject(self, &InteractivePopGestureRecognizerKey2, modalKuGouTransitionDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)zx_setTransitionDelegatePresentKuGouWithAnimationTransition:(BOOL)flag interactivePopGestureTransition:(BOOL)interactiveFlag
{
    if (flag)
    {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self.modalKuGouTransitionDelegate;
    }
    if (flag && interactiveFlag)
    {
        UIPanGestureRecognizer *interactiveTransitionRecognizer;
        interactiveTransitionRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(modalInteractiveTransitionRecognizerAction:)];
        [self.view addGestureRecognizer:interactiveTransitionRecognizer];
    }
}



- (void)modalInteractiveTransitionRecognizerAction:(UIPanGestureRecognizer *)gestureRecognizer
{    
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    CGFloat width = UIScreen.mainScreen.bounds.size.width;
    CGFloat scale = 1 - fabs(translation.x / width);
    scale = scale < 0 ? 0 : scale;
    
//    NSLog(@"modal_滑动后还剩下百分比 = %f", scale);
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStatePossible:
            break;
        case UIGestureRecognizerStateBegan:
        {
          //  传值
          self.modalKuGouTransitionDelegate.customInteractivePopGestureRecognizer = gestureRecognizer;
          //3. 返回
          [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            
            break;
        }
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            
        self.modalKuGouTransitionDelegate.customInteractivePopGestureRecognizer = nil;
        }
    }
}


@end
