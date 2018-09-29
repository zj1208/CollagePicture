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

// 在呈现过渡即将开始的时候被调用
- (void)presentationTransitionWillBegin
{
    [self.visualView addGestureRecognizer:self.tapGestureRecognizer];
    [self.containerView addSubview:self.visualView];
}

//在呈现过渡结束时被调用
- (void)presentationTransitionDidEnd:(BOOL)completed
{
    if (!completed)
    {
        [self.visualView removeGestureRecognizer:self.tapGestureRecognizer];
        [self.visualView removeFromSuperview];
    }
}

//添加淡出动画并且在它消失后移除它
- (void)dismissalTransitionWillBegin
{
    self.visualView.alpha = 0;
}

- (void)dismissalTransitionDidEnd:(BOOL)completed
{
    if (completed)
    {
        [self.visualView removeGestureRecognizer:self.tapGestureRecognizer];
        [self.visualView removeFromSuperview];
    }
}

- (CGRect)frameOfPresentedViewInContainerView
{
    self.presentedView.frame = self.frameOfPresentedView;
//    CGFloat windowH = [UIScreen mainScreen].bounds.size.height;
//    CGFloat windowW = [UIScreen mainScreen].bounds.size.width;
//    self.presentedView.frame = CGRectMake(0, windowH - 300, windowW, 300);
    return self.presentedView.frame;
}

- (UIVisualEffectView *)visualView
{
    if (!_visualView)
    {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectView.frame = self.containerView.bounds;
        effectView.alpha = 0.3;
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
