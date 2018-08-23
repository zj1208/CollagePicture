//
//  ZXWXBigImageAppearAnimator.m
//  YiShangbao
//
//  Created by simon on 2018/8/15.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "ZXWXBigImageAppearAnimator.h"

@interface ZXWXBigImageAppearAnimator ()

@property (nonatomic, strong)UIView *bgView;

@end

@implementation ZXWXBigImageAppearAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    
    //ToVC,实际的展示效果最后显示；中间写动画过渡，先把结果展示隐藏，等过渡完效果再展示toView；
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    // 添加整个控制器的view，且让它是透明的；
    [containerView addSubview:toView];
    toView.hidden = YES;

    // 把原来的图片的展示区域 给覆盖掉(设置成fromViewController的view的背景颜色一样），自己再加一个可以控制移动的imageView
    UIView *imgBgWhiteView = [[UIView alloc] initWithFrame:self.transitionBeforeImgFrame];
    imgBgWhiteView.backgroundColor = [UIColor whiteColor];
    [containerView addSubview:imgBgWhiteView];
    
    //有渐变的黑色背景,遮住fromViewController的view
    [containerView addSubview:self.bgView];
    self.bgView.frame = containerView.bounds;
    self.bgView.alpha = 0.3;

    //过渡的图片
    UIImageView *transitionImgView = [[UIImageView alloc] initWithImage:self.transitionImage];
    transitionImgView.frame = self.transitionBeforeImgFrame;
    [transitionContext.containerView addSubview:transitionImgView];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        transitionImgView.frame = self.transitionAfterImgFrame;
        self.bgView.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        toView.hidden = NO;
        
        [imgBgWhiteView removeFromSuperview];
        [self.bgView removeFromSuperview];
        [transitionImgView removeFromSuperview];
        
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
    }];
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

- (void)animationEnded:(BOOL)transitionCompleted
{
    
}
@end
