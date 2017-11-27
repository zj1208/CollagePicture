//
//  UIView+ViewHelper.m
//  ShiChunTang
//
//  Created by zhuxinming on 14/11/1.
//  Copyright (c) 2014年 ZhuXinMing. All rights reserved.
//

#import "UIView+ViewHelper.h"
#import "APPCommonDef.h"
#import <objc/runtime.h>


@implementation UIView (ViewHelper)

//+ (void)load
//{
//    if (@available(iOS 11, *)) {
//        
//        [NSClassFromString(@"_UIBackButtonContainerView") exchangeInstanceMethod1:@selector(addSubview:) method2:@selector(iOS11BackButtonNoTextTrick_addSubview:)];
//    }
//}
//
//- (void)iOS11BackButtonNoTextTrick_addSubview:(UIView *)view
//{
//    view.alpha = 0;
//    if ([view isKindOfClass:[UIButton class]]) {
//        UIButton *button = (id)view;
//        [button setTitle:@" " forState:UIControlStateNormal];
//    }
//    [self iOS11BackButtonNoTextTrick_addSubview:view];
//}


//设置圆角
- (void)setCornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(nullable UIColor *)color
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
    self.layer.borderWidth = width;
    
    self.layer.borderColor =color?[color CGColor]:[UIColor clearColor].CGColor;
}


- (void)zhSetRoundItem
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = CGRectGetHeight(self.frame)/2;
    self.layer.borderWidth = 1.f;
    self.layer.borderColor =[UIColor clearColor].CGColor;
}


- (void)zhSetShadowColor:(nullable UIColor *)color shadowOffset:(CGSize)offset shadowOpacity:(CGFloat)opacity
{
    self.layer.shadowColor=color.CGColor;
    self.layer.shadowOffset=offset;
    self.layer.shadowOpacity=opacity==NSNotFound?0.5:opacity;
    self.layer.shadowRadius = 4.f;
}


#pragma mark - getter


/**
 * @brief 获取UIView的对应controller
 */

- (nullable UIViewController *)zhGetMyResponderViewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


- (float)zhGetValueFortapGestureOnSliderObject:(UISlider *)slider  withGesture:(UITapGestureRecognizer *)gesture
{
    CGPoint tapPoint = [gesture locationInView:slider];
    CGRect rect = [slider trackRectForBounds:[slider bounds]];
    float value = [slider minimumValue] + (tapPoint.x -rect.origin.x-2)*(([slider maximumValue]-[slider minimumValue])/(rect.size.width - 4));
    return value;
}


+ (void)zhNSLogSubviewsFromView:(UIView *)view andLevel:(NSInteger)level
{
    NSArray *subviews = [view subviews];
    // 如果没有子视图就直接返回
    if ([subviews count] == 0) return;
    for (UIView *subview in subviews) {
        
        // 根据层级决定前面空格个数，来缩进显示
        NSString *blank = @"";
        for (int i = 1; i < level; i++) {
            blank = [NSString stringWithFormat:@"  %@", blank];
        }
        // 打印子视图类名,不能用这个函数宏，无法打包
//        NSLitLog(@"%@%ld: %@", blank, level, subview.class);
        // 递归获取此视图的子视图
        [self zhNSLogSubviewsFromView:subview andLevel:(level+1)];
        
    }
}

#pragma mark - perform


- (void)zhPerformKeyboardDismissWithClass:(Class)aClass
{
    for(UIView* view in self.subviews)
    {
        
        if ([view isKindOfClass:[UITextField class]]||[view isKindOfClass:[UITextView class]])
        {
            if ([view isFirstResponder])
            {
                [view resignFirstResponder];
            }
        }
    }
}


- (void)zhPerformCallPhone:(NSString *)phone
{
    if (phone && phone.length>0) {
        
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phone]];
        UIWebView *webV= [[UIWebView alloc] initWithFrame:CGRectZero];
        [webV loadRequest:[NSURLRequest requestWithURL:phoneURL]];
        [self addSubview:webV];
    }
}



- (void)zhPerformCallPhoneApplication:(NSString *)phone
{
    NSString *allString = [NSString stringWithFormat:@"tel:%@",phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
}





@end



/*
@implementation UIView (animation)


#pragma mark-- animation动画

- (void)zhuCustomDirectionFromTopAnimationType:(NSString*)kCATransitionType layer:(CALayer*)layer
{
    CATransition * animation = [CATransition animation];
    animation.duration = 0.5f;
    animation.delegate = self;
    //[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];2种方法是不同的，但意思是一样的。这里不能用，得区分
    animation.timingFunction = UIViewAnimationCurveEaseInOut;//调速功能
    animation.type = kCATransitionType;//动画模式-4选一
    animation.subtype = kCATransitionFromTop; //动画方向-对于淡化，不需要可以所以省略
    //这里可以添加要转变的uiview，变化动作
    [layer addAnimation:animation forKey:@"alpha"];
    
}
- (void)zhuCustomDirectionFromBottomAnimationType:(NSString*)kCATransitionType layer:(CALayer*)layer
{
    CATransition * animation = [CATransition animation];
    animation.duration = 0.5f;
    animation.delegate = self;
    //[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];2种方法是不同的，但意思是一样的。这里不能用，得区分
    animation.timingFunction = UIViewAnimationCurveEaseInOut;//调速功能
    animation.type = kCATransitionType;
    animation.subtype = kCATransitionFromBottom; //对于淡化，不需要动画方向，所以省略
    //这里可以添加要转变的uiview，变化动作
    [layer addAnimation:animation forKey:@"alpha"];
    
}

//animation.type = kCATransitionReveal//揭开
//animation.type = kCATransitionPush//推挤
//animation.type = kCATransitionMoveIn;覆盖
//animation.type = KCATransitionFade;// 淡化

// @"cube" 立方体
// @"suckEffect" 吸收
// @"oglFlip" 翻转
// @"rippleEffect" 波纹
// @"pageCurl" 翻页
// @"pageUnCurl" 反翻页
// @"cameraIrisHollowOpen" 镜头开
// @"cameraIrisHollowClose" 镜头关

@end
*/
