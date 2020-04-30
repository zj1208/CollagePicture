//
//  UIView+ZXHelper.m
//  ShiChunTang
//
//  Created by simon on 13/11/1.
//  Copyright (c) 2013年 yinyuetai.com. All rights reserved.
//

#import "UIView+ZXHelper.h"

////不能用，一旦用了，会无法打包
#ifndef __OPTIMIZE__
#define NSLitLog(format, ...) printf(" %s\n", [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#endif

@implementation UIView (ZXHelper)

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


- (void)zx_setBorderWithCornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(nullable UIColor *)borderColor
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor =borderColor?[borderColor CGColor]:[UIColor clearColor].CGColor;
}

- (void)zx_setBorderWithShadowWithCornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(nullable UIColor *)borderColor
{
    self.layer.masksToBounds = NO;
    self.layer.cornerRadius = radius;
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor =borderColor?[borderColor CGColor]:[UIColor clearColor].CGColor;
}


- (void)zx_setBorderWithCornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(nullable UIColor *)borderColor maskedCorners:(CACornerMask) maskedCorners
{
    [self zx_setBorderWithCornerRadius:radius borderWidth:borderWidth borderColor:borderColor];
    if (@available(iOS 11.0, *)) {
        self.layer.maskedCorners = maskedCorners;
    } else {
        // Fallback on earlier versions
    }
}

- (void)zx_setBorderWithCornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(nullable UIColor *)borderColor byRoundingCorners:(UIRectCorner) cornersType
{
    //如果只是设置mask，则无法显示边框宽度，边框颜色等信息，只有mask部分展示；所以一定要另外添加一个透明layer用于展示边框信息；

//    UIRectCorner type = UIRectCornerTopRight | UIRectCornerBottomRight | UIRectCornerBottomLeft;
    CGRect rect = CGRectMake(borderWidth/2.0, borderWidth/2.0, CGRectGetWidth(self.frame)-borderWidth, CGRectGetHeight(self.frame)-borderWidth);
    CGSize radii = CGSizeMake(radius, borderWidth);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:cornersType cornerRadii:radii];
    
    //设置layer的属性，填充颜色，画线颜色，线条宽度；如果是透明的，则底下的layer内容可见；
    CAShapeLayer *shapeLayer  = [CAShapeLayer layer];
    shapeLayer.strokeColor = borderColor.CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = borderWidth;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.path = path.CGPath;
    
    [self.layer addSublayer:shapeLayer];
    
    //2. 加一个layer 按形状 把外面的减去;只允许这个路径内的内容通过alpha通道显示；
    //设置一个通过alpha通道来屏蔽当前图层内容的mask蒙版； 和UIView的maskView同理；完全或部分不透明像素允许底层内容通过，但完全透明像素会阻塞该内容。

    CGRect clipRect = CGRectMake(0, 0,
                                 CGRectGetWidth(self.frame)-1, CGRectGetHeight(self.frame)-1);
    CGSize clipRadii = CGSizeMake(radius, borderWidth);
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithRoundedRect:clipRect byRoundingCorners:cornersType cornerRadii:clipRadii];
    
    CAShapeLayer *clipLayer = [CAShapeLayer layer];
    clipLayer.path = clipPath.CGPath;
    
    self.layer.mask = clipLayer;
}

- (void)zx_setBorderWithRoundItem
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = CGRectGetHeight(self.frame)/2;
    self.layer.borderWidth = 1.f;
    self.layer.borderColor =[UIColor clearColor].CGColor;
}


- (void)zx_setMasksToBoundsRoundedCornerWithBounds:(CGRect)rect
{
    CGFloat x = rect.size.width/2.0;
    CGFloat y = rect.size.height/2.0;
    CGFloat radius = MIN(x, y);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(x, y) radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = bezierPath.CGPath;
    self.layer.mask = maskLayer;
}


- (void)zx_setShadowColor:(nullable UIColor *)shadowColor shadowOpacity:(CGFloat)opacity shadowOffset:(CGSize)offset shadowRadius:(CGFloat)shadowRadius
{
    // cannot have masking
    self.layer.masksToBounds = NO;
    
    self.layer.shadowColor=shadowColor?shadowColor.CGColor:[UIColor blackColor].CGColor;
    self.layer.shadowOpacity=opacity;
    self.layer.shadowOffset=offset;
    self.layer.shadowRadius = shadowRadius;
}



- (void)zx_setBorderWithTop:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width
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


- (void)zx_updateShadowPathToBounds:(CGRect)bounds withDuration:(NSTimeInterval)duration
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

- (nullable UIViewController *)zx_getResponderViewController
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


- (float)zx_getValueFortapGestureOnSliderObject:(UISlider *)slider  withGesture:(UITapGestureRecognizer *)gesture
{
    CGPoint tapPoint = [gesture locationInView:slider];
    CGRect rect = [slider trackRectForBounds:[slider bounds]];
    float value = [slider minimumValue] + (tapPoint.x -rect.origin.x-2)*(([slider maximumValue]-[slider minimumValue])/(rect.size.width - 4));
    return value;
}


+ (void)zx_NSLogSubviewsFromView:(UIView *)view andLevel:(NSInteger)level
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
        [self zx_NSLogSubviewsFromView:subview andLevel:(level+1)];
        
    }
}

+ (id)zx_viewFromNib
{
    NSArray *arr =[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil];
    return [arr firstObject];
}

#pragma mark - perform


- (void)zx_performKeyboardDismissWithClass:(Class)aClass
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

