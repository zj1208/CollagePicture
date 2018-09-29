//
//  ZXModalWeChatDrivenInteractiveTransition.m
//  YiShangbao
//
//  Created by simon on 2018/8/24.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "ZXModalWeChatDrivenInteractiveTransition.h"

@interface ZXModalWeChatDrivenInteractiveTransition()

@property (nonatomic, strong, readonly) UIPanGestureRecognizer *customInteractivePopGestureRecognizer;

@property (nonatomic, weak) id<UIViewControllerContextTransitioning> transitionContext;

@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *fromView;

@property (nonatomic, strong) UIView *sourceImageBackgroundWhiteView;
@property (nonatomic, strong) UIImageView *transitionImageView;

@end

@implementation ZXModalWeChatDrivenInteractiveTransition

// 当系统需要设置视图控制器转换的交互部分并启动动画时调用；
// 如果启用了手势交互，animateTransition:就不会回调；
- (void)startInteractiveTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    self.transitionContext = transitionContext;
}


- (instancetype)initWithGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer
{
    self = [super init];
    if (self)
    {
        self.isFirst = YES;
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
    //    translation-Y：往上移动-20，往下移动+20； 往上下2边方向缩小
    CGFloat scale = 1 - fabs(translation.y / LCDH);
    scale = scale<0?0:scale;
    scale = translation.y<0?1:scale;
    return scale;
}

- (void)gestureRecognizeDidUpdate:(UIPanGestureRecognizer *)gestureRecognizer
{
//    还剩下多少比例 在屏幕上显示
    CGFloat scale = [self percentForGesture:gestureRecognizer];
    
    if (self.isFirst)
    {
        [self beginInteractivePercentTransition];
        self.isFirst = NO;
    }
    switch (gestureRecognizer.state)
    {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
        {
            //  更新bgView显示百分比
            [self updateInteractiveTransition:scale];
            [self updateInteractivePercentTransition:scale];
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            if (scale >0.9)
            {
                //  取消转场
                [self cancelInteractiveTransition];
                [self cancelInteractivePercentTransition];
            }
            else
            {
                //  完成转场
                [self finishInteractiveTransition];
                [self finishInteractivePercentTransition:scale];
            }
            break;
        }
        default:
        {
            [self cancelInteractiveTransition];
            [self cancelInteractivePercentTransition];
            break;
        }
    }
}

//添加toView，fromView，self.sourceImageBackgroundWhiteView，self.bgView
- (void)beginInteractivePercentTransition
{
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    //  containerView上已经有弹出时候添加的大图toView；
    //  <UIView: 0x7f86c7f4e9e0; frame = (0 0; 375 812); autoresize = W+H; gestureRecognizers = <NSArray: 0x600000e4fa20>; layer = <CALayer: 0x600000c2b100>>
    UIView *containerView = [transitionContext containerView];
    
    // 在dismiss时候，更换toView和fromView身份；添加大图fromViewController下面的各种假象底图：
    // 1.ToVC,实际的展示效果最后显示；中间写动画过渡，先把结果展示隐藏，等过渡完效果再展示toView；
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    [containerView addSubview:toView];
  
    // 2.把原来的图片的展示区域 给覆盖掉(设置成fromViewController的view的背景颜色一样），自己再加一个可以控制移动的imageView
    
    [containerView addSubview:self.sourceImageBackgroundWhiteView];
    
    // 3.有渐变的黑色背景,遮住ToViewController的view
    self.bgView.alpha = 1;
    self.bgView.frame = containerView.bounds;
    [containerView addSubview:self.bgView];
    
    
    // 因为原来的大图fromViewController在手势中已经被dismiss了，所以需要你自己再添加新的fromViewController在最上层,即你目前在交互的ZXPhotoBrowser的view，达到ZXPhotoBrowser中的imageView交互； 因为在拖动大图中的imageView，所以背景需要透明，才能看到bgView的alpha改变；

    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    fromView.backgroundColor = [UIColor clearColor];
    [containerView addSubview:fromView];
    self.fromView = fromView;
}

- (void)updateInteractivePercentTransition:(CGFloat)scale
{
    self.fromView.backgroundColor = [UIColor clearColor];
    self.bgView.alpha = (1-(1-scale)*2)<0?0:(1-(1-scale)*2);
}

// 取消转场的时候 也要回调completeTransition:；
// 不需要移除self.sourceImageBackgroundWhiteView，self.bgView；直接改FromView的背景
- (void)cancelInteractivePercentTransition
{
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    
    self.fromView.backgroundColor = [UIColor blackColor];

    BOOL wasCancelled = [transitionContext transitionWasCancelled];
    [transitionContext completeTransition:!wasCancelled];
    
//    NSLog(@"%@",containerView.subviews);
}

- (void)finishInteractivePercentTransition:(CGFloat)scale
{
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    //    containerView上已经有大图view了；
    UIView *containerView = [transitionContext containerView];
    //    <UIView: 0x7ff0fa7d3d20; frame = (0 0; 375 812); autoresize = W+H; gestureRecognizers = <NSArray: 0x600000e4fa20>; layer = <CALayer: 0x600000c2b100>>
    //    NSLog(@"%@",containerView.subviews);
    
    //ToVC,在fromViewController大图的view之上加原小头像视图toViewController的view,再加黑色view盖住+过渡大图；等于一点击大图，当前控制器大图控制器就看不到了，接着构造一个和大图控制器类似的UI布局，处理被放大的过渡imageView渐渐缩小到原小图的frame；背景bgView透明度渐渐变透明；给人一种是在原大图上渐渐变成小头像的视图；
    //    最后转场结束的时候，真正的toViewController就会显示的；
    UIView *tempToView = [transitionContext viewForKey:UITransitionContextToViewKey];
    [containerView addSubview:tempToView];
    //
    //    把原来的图片的展示区域 给覆盖掉(设置成fromViewController的view的背景颜色一样），自己再加一个可以控制移动的imageView
    
    [containerView addSubview:self.sourceImageBackgroundWhiteView];
    
    //有渐变的黑色背景,遮住ToViewController的view
    self.bgView.alpha = (1-(1-scale)*2)<0?0:(1-(1-scale)*2);
    self.bgView.frame = containerView.bounds;
    [containerView addSubview:self.bgView];
    
    //默认过渡的图片-frame = afterImageFrame大图frame
    self.transitionImageView.frame = self.transitionCurrentImgFrame;
    [containerView addSubview:self.transitionImageView];

    //从transitionAfterImgFrame 移动到 transitonBeforeImgFrame
    [UIView animateWithDuration:0.3 animations:^{
        
        self.transitionImageView.frame = self.transitionBeforeImgFrame;
        self.bgView.alpha = 0;
        
    } completion:^(BOOL finished) {
        //      由于手势交互的时候，一直在拖动，所以不会回调block：completion；
        [self.sourceImageBackgroundWhiteView removeFromSuperview];
        [self.bgView removeFromSuperview];
        [self.transitionImageView removeFromSuperview];

        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
        
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
        transitionImageView.frame = self.transitionCurrentImgFrame;
        transitionImageView.clipsToBounds = YES;
       transitionImageView.contentMode = UIViewContentModeScaleAspectFit;
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

@end
