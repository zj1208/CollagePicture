//
//  ZXWXBigImageAppearAnimator.m
//  YiShangbao
//
//  Created by simon on 2018/8/15.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "ZXWXBigImageAppearAnimator.h"

@interface ZXWXBigImageAppearAnimator ()

@property (nonatomic, strong) UIView *sourceImageBackgroundWhiteView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *transitionImageView;
@end

@implementation ZXWXBigImageAppearAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
//   如果present之前不设置self.modalPresentationStyle = UIModalPresentationCustom;就会多一个UILayoutContainerView,就是UITransitionContextFromViewKey的view;不过在回调completeTransition:完成转场之后，只剩下你添加的toView,UILayoutContainerView会被移除；
//    <UILayoutContainerView: 0x7fcd88e321b0; frame = (0 0; 375 812); autoresize = W+H; layer = <CALayer: 0x608000438fc0>>
    NSLog(@"%@",containerView.subviews);

    
    // ToVC,实际的展示效果最后显示；中间写动画过渡，先把结果展示隐藏，等过渡完效果再展示toView；
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    // 添加整个控制器的view，且让它是隐藏的；
    [containerView addSubview:toView];
    toView.hidden = YES;

    // 第一添加：把原来的图片的展示区域 给覆盖掉，放在最底下不影响黑色背景view(设置成fromViewController的view的背景颜色一样），自己再加一个可以控制移动的imageView
    [containerView addSubview:self.sourceImageBackgroundWhiteView];
    
    // 第二添加： 有渐变的黑色背景,遮住fromViewController的view
    self.bgView.frame = containerView.bounds;
    [containerView addSubview:self.bgView];
    self.bgView.alpha = 0.1;

    // 第三添加： 可以控制移动的imageView
    [containerView addSubview:self.transitionImageView];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        
        self.transitionImageView.frame = self.transitionAfterImgFrame;
        self.bgView.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        toView.hidden = NO;
//        (
//         <UIView: 0x7f86c7f4e9e0; frame = (0 0; 375 812); autoresize = W+H; gestureRecognizers = <NSArray: 0x600000e52e10>; layer = <CALayer: 0x600000a28d20>>,
//         <UIView: 0x7fcd906a6da0; frame = (10 135.1; 44 44); layer = <CALayer: 0x60c001232f00>>,
//         <UIView: 0x7fcd906a70c0; frame = (0 0; 375 812); layer = <CALayer: 0x60c001232fa0>>,
//         <UIImageView: 0x7fcd906a73e0; frame = (0 216.625; 375 378.75); opaque = NO; userInteractionEnabled = NO; layer = <CALayer: 0x60c001233040>>
//         )
        NSLog(@"%@",containerView.subviews);

        [self.sourceImageBackgroundWhiteView removeFromSuperview];
        [self.bgView removeFromSuperview];
        [self.transitionImageView removeFromSuperview];
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
//        回调完成转场之后，只剩下你添加的toView
//        (
//         <UIView: 0x7f86c7f4e9e0; frame = (0 0; 375 812); autoresize = W+H; gestureRecognizers = <NSArray: 0x600000e52e10>; layer = <CALayer: 0x600000a28d20>>
//         )
        NSLog(@"%@",containerView.subviews);

    }];
}

- (UIView *)sourceImageBackgroundWhiteView
{
    if (!_sourceImageBackgroundWhiteView)
    {
        UIView *sourceImageBackgroundWhiteView = [[UIView alloc] initWithFrame:self.transitionBeforeImgFrame];
        sourceImageBackgroundWhiteView.backgroundColor = [UIColor whiteColor];
        _sourceImageBackgroundWhiteView = sourceImageBackgroundWhiteView;
    }
    return _sourceImageBackgroundWhiteView;
}

- (UIImageView *)transitionImageView
{
    if (!_transitionImageView)
    {
        //过渡的图片
        UIImageView *transitionImageView = [[UIImageView alloc] initWithImage:self.transitionImage];
        transitionImageView.frame = self.transitionBeforeImgFrame;
        _transitionImageView = transitionImageView;
    }
    return _transitionImageView;
}

- (UIView *)bgView
{
    if (!_bgView)
    {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor blackColor];
//        _bgView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.3];
    }
    return _bgView;
}

- (void)animationEnded:(BOOL)transitionCompleted
{
    
}
@end
