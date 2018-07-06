//
//  UIView+XMHelper.m
//  ShiChunTang
//
//  Created by zhuxinming on 14/11/1.
//  Copyright (c) 2014年 ZhuXinMing. All rights reserved.
//

#import "UIView+XMHelper.h"
#import "APPCommonDef.h"
#import <objc/runtime.h>

////不能用，一旦用了，会无法打包
//#ifndef __OPTIMIZE__
//#define NSLitLog(format, ...) printf(" %s\n", [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
//#endif


@implementation UIView (XMHelper)

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
- (void)setCornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(nullable UIColor *)borderColor
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
    self.layer.borderWidth = width;
    self.layer.borderColor =borderColor?[borderColor CGColor]:[UIColor clearColor].CGColor;
}

- (void)xm_setCornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(nullable UIColor *)borderColor
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
    self.layer.borderWidth = width;
    self.layer.borderColor =borderColor?[borderColor CGColor]:[UIColor clearColor].CGColor;
}

- (void)xm_setRoundItem
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = CGRectGetHeight(self.frame)/2;
    self.layer.borderWidth = 1.f;
    self.layer.borderColor =[UIColor clearColor].CGColor;
}



- (void)xm_setShadowColor:(nullable UIColor *)shadowColor shadowOpacity:(CGFloat)opacity shadowOffset:(CGSize)offset shadowRadius:(CGFloat)shadowRadius
{
    // cannot have masking
    self.layer.masksToBounds = NO;
    
    self.layer.shadowOpacity=opacity;
    self.layer.shadowOffset=offset;
    self.layer.shadowRadius = shadowRadius;
    
    self.layer.borderColor =shadowColor?[shadowColor CGColor]:[UIColor clearColor].CGColor;
}


- (void)xm_setShadowAndCornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(nullable UIColor *)borderColor shadowColor:(nullable UIColor *)shadowColor shadowOpacity:(CGFloat)opacity shadowOffset:(CGSize)offset shadowRadius:(CGFloat)shadowRadius
{
    self.layer.shadowColor=shadowColor?shadowColor.CGColor:[UIColor blackColor].CGColor;
    self.layer.shadowOpacity=opacity;
    self.layer.shadowOffset=offset;
    self.layer.shadowRadius = shadowRadius;
    
    self.layer.cornerRadius = radius;
    self.layer.borderWidth = width;
    self.layer.borderColor =borderColor?[borderColor CGColor]:[UIColor clearColor].CGColor;
}

- (void)xm_setBorderWithTop:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width
{
    if (top) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, self.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [self.layer addSublayer:layer];
    }
    if (left) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, width, self.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [self.layer addSublayer:layer];
    }
    if (bottom) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, self.frame.size.height - width, self.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [self.layer addSublayer:layer];
    }
    if (right) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(self.frame.size.width - width, 0, width, self.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [self.layer addSublayer:layer];
    }
}


- (void)xm_updateShadowPathToBounds:(CGRect)bounds withDuration:(NSTimeInterval)duration
{
    CGPathRef oldPath = self.layer.shadowPath;
    CGPathRef newPath = CGPathCreateWithRect(bounds, NULL);
    
    if (oldPath && duration>0)
    {
        CABasicAnimation *theAnimation = [CABasicAnimation animationWithKeyPath:@"shadowPath"];
        theAnimation.duration = duration;
        theAnimation.fromValue = (__bridge id)oldPath;
        theAnimation.toValue = (__bridge id)newPath;
        theAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [self.layer addAnimation:theAnimation forKey:@"shadowPath"];
    }
    
    self.layer.shadowPath = newPath;
    
    CGPathRelease(newPath);
}

#pragma mark - getter


/**
 * @brief 获取UIView的对应controller
 */

- (nullable UIViewController *)xm_getResponderViewController
{
//    UIResponder *nextResponder =  self;
//    do
//    {
//        nextResponder = [nextResponder nextResponder];
//        
//        if ([nextResponder isKindOfClass:[UIViewController class]])
//            return (UIViewController*)nextResponder;
//        
//    } while (nextResponder != nil);
//
    for (UIView* next = self; next; next = next.superview)
    {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    
    return nil;
}


- (float)xm_getValueFortapGestureOnSliderObject:(UISlider *)slider  withGesture:(UITapGestureRecognizer *)gesture
{
    CGPoint tapPoint = [gesture locationInView:slider];
    CGRect rect = [slider trackRectForBounds:[slider bounds]];
    float value = [slider minimumValue] + (tapPoint.x -rect.origin.x-2)*(([slider maximumValue]-[slider minimumValue])/(rect.size.width - 4));
    return value;
}


+ (void)xm_NSLogSubviewsFromView:(UIView *)view andLevel:(NSInteger)level
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
        [self xm_NSLogSubviewsFromView:subview andLevel:(level+1)];
        
    }
}

+ (id)xm_viewFromNib
{
    NSArray *arr =[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil];
    return [arr firstObject];
}

#pragma mark - perform


- (void)xm_performKeyboardDismissWithClass:(Class)aClass
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


- (void)xm_performCallPhone:(NSString *)phone
{
    if (phone && phone.length>0) {
        
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phone]];
        UIWebView *webV= [[UIWebView alloc] initWithFrame:CGRectZero];
        [webV loadRequest:[NSURLRequest requestWithURL:phoneURL]];
        [self addSubview:webV];
    }
}



- (void)xm_performCallPhoneApplication:(NSString *)phone
{
    NSString *allString = [NSString stringWithFormat:@"tel:%@",phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
}




- (nullable NSIndexPath *)jl_getIndexPathWithViewInCellFromTableViewOrCollectionView:(UIScrollView *)view
{
    UIView *superview = self.superview;
    while (superview) {
        if ([superview isKindOfClass:[UITableViewCell class]])
        {
            if ([view isKindOfClass:[UITableView class]])
            {
                UITableView *tableView = (UITableView *)view;
                UITableViewCell *tableViewCell = (UITableViewCell *)superview;
                NSIndexPath* indexPath = [tableView indexPathForCell:tableViewCell];
                return indexPath;
            }
        }
        if ([superview isKindOfClass:[UICollectionViewCell class]])
        {
            if ([view isKindOfClass:[UICollectionView class]])
            {
                UICollectionView *collectionView = (UICollectionView *)view;
                UICollectionViewCell *collectionViewCell = (UICollectionViewCell *)superview;
                NSIndexPath* indexPath = [collectionView indexPathForCell:collectionViewCell];
                return indexPath;
            }
        }
        superview = superview.superview;
    }
    return nil;
}

@end

