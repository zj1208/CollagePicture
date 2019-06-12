//
//  ZXModalPresentaionController.m
//  YiShangbao
//
//  Created by simon on 2018/9/26.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "ZXModalPresentaionController.h"

@interface ZXModalPresentaionController ()

@property (nonatomic, strong) UIVisualEffectView *visualView;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation ZXModalPresentaionController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController
{
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    if (self)
    {
        self.dimmingViewAlpha = 0.3;
    }
    return self;
}

// 在呈现过渡即将开始的时候被调用;在弹框即将显示时执行所需要的操作;
- (void)presentationTransitionWillBegin
{
    [self.visualView addGestureRecognizer:self.tapGestureRecognizer];
    [self.containerView addSubview:self.visualView];
    
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    self.visualView.alpha = 0;
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.visualView.alpha = self.dimmingViewAlpha;
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    }];
}

//在呈现过渡结束时被调用;在弹框显示完毕时执行所需要的操作
- (void)presentationTransitionDidEnd:(BOOL)completed
{
    if (!completed)
    {
        [self.visualView removeGestureRecognizer:self.tapGestureRecognizer];
        [self.visualView removeFromSuperview];
    }
}

//在弹框即将消失时执行所需要的操作;添加淡出动画并且在它消失后移除它;
- (void)dismissalTransitionWillBegin
{
    self.visualView.alpha = 0;
}

//在弹框消失之后执行所需要的操作；
- (void)dismissalTransitionDidEnd:(BOOL)completed
{
    if (completed)
    {
        [self.visualView removeGestureRecognizer:self.tapGestureRecognizer];
        [self.visualView removeFromSuperview];
    }
}

// 当在presentedViewController（A）上设置过自定义frame，A再用presentViewController:方法弹起B，A会被移除，当Bdismiss的时候，会重新添加A控制器且frame为全屏；
- (nullable UIView *)presentedView
{
    UIView *view  = [super presentedView];
    view.frame = self.frameOfPresentedView;
    return view;
}

- (CGRect)frameOfPresentedViewInContainerView
{
//    self.presentedView.frame = self.frameOfPresentedView;
//    CGFloat windowH = [UIScreen mainScreen].bounds.size.height;
//    CGFloat windowW = [UIScreen mainScreen].bounds.size.width;
//    self.presentedView.frame = CGRectMake(0, windowH - 300, windowW, 300);
    return self.frameOfPresentedView;
}

- (BOOL)shouldPresentInFullscreen
{
    return YES;
}
- (BOOL)shouldRemovePresentersView
{
    return NO;
}

- (void)containerViewWillLayoutSubviews
{
//    self.presentedView.frame = self.frameOfPresentedView;
}

- (void)containerViewDidLayoutSubviews
{
    
}

- (UIVisualEffectView *)visualView
{
    if (!_visualView)
    {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectView.frame = self.containerView.bounds;
        effectView.alpha = self.dimmingViewAlpha;
        effectView.backgroundColor = [UIColor blackColor];
        _visualView = effectView;
    }
    return _visualView;
}

- (UITapGestureRecognizer *)tapGestureRecognizer
{
    if (!_tapGestureRecognizer)
    {
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissView:)];
//        tap.delegate = self;
        _tapGestureRecognizer = tap;
    }
    return _tapGestureRecognizer;
}

- (void)dismissView:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

//- (BOOL)shouldRemovePresentersView
//{
//    return YES;
//}
@end
