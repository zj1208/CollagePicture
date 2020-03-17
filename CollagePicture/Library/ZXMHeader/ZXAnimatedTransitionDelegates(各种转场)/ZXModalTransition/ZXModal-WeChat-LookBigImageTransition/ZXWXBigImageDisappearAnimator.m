//
//  ZXWXBigImageDisappearAnimator.m
//  YiShangbao
//
//  Created by simon on 2018/8/15.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "ZXWXBigImageDisappearAnimator.h"

@interface ZXWXBigImageDisappearAnimator ()

@property (nonatomic, strong) UIView *sourceImageBackgroundWhiteView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *transitionImageView;

@end

@implementation ZXWXBigImageDisappearAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    //  containerView上已经有弹出时候添加的toView；
    //  <UIView: 0x7f86c7f4e9e0; frame = (0 0; 375 812); autoresize = W+H; gestureRecognizers = <NSArray: 0x600000e4fa20>; layer = <CALayer: 0x600000c2b100>>
//    NSLog(@"%@",containerView.subviews);

    // ToVC,在fromViewController大图的view之上加原小头像视图toViewController的view,再加黑色view盖住+过渡大图；等于一点击大图，当前控制器大图控制器就看不到了，接着构造一个和大图控制器类似的UI布局，处理被放大的过渡imageView渐渐缩小到原小图的frame；背景bgView透明度渐渐变透明；给人一种是在原大图上渐渐变成小头像的视图；
    // 最后转场结束的时候，真正的toViewController就会显示的；
    UIView *tempToView = [transitionContext viewForKey:UITransitionContextToViewKey];
    // 添加整个控制器的view，且让它是隐藏的；
    [containerView addSubview:tempToView];

    // 把原来的图片的展示区域 给覆盖掉(设置成fromViewController的view的背景颜色一样），自己再加一个可以控制移动的imageView

    [containerView addSubview:self.sourceImageBackgroundWhiteView];
    
    // 有渐变的黑色背景,遮住ToViewController的view
    self.bgView.frame = containerView.bounds;
    [containerView addSubview:self.bgView];
     self.bgView.alpha = 1;

    // 默认过渡的图片-frame = afterImageFrame大图frame
    self.transitionImageView.frame = self.transitionAfterImgFrame;
    [containerView addSubview:self.transitionImageView];

    NSTimeInterval duration = [self transitionDuration:transitionContext];
    // 从transitionAfterImgFrame 移动到 transitonBeforeImgFrame
    [UIView animateWithDuration:duration animations:^{
        
        self.bgView.alpha = 0;
        self.transitionImageView.frame = self.transitionBeforeImgFrame;
        
    } completion:^(BOOL finished) {

        [self.sourceImageBackgroundWhiteView removeFromSuperview];
        [self.bgView removeFromSuperview];
        [self.transitionImageView removeFromSuperview];

        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
//        回调完成转场后，present添加的toView 和 当前使用的fromView都会被移除，即凡是toView和fromView都会被移除；
//        NSLog(@"%@",containerView.subviews);
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
//        transitionImageView.image = nil;
//        transitionImageView.backgroundColor = [UIColor redColor];
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
    }
    return _bgView;
}

//- (id <UIViewImplicitlyAnimating>) interruptibleAnimatorForTransition:(id <UIViewControllerContextTransitioning>)transitionContext NS_AVAILABLE_IOS(10_0)
//{
//    
//}
- (void)animationEnded:(BOOL)transitionCompleted
{
    
}
@end
