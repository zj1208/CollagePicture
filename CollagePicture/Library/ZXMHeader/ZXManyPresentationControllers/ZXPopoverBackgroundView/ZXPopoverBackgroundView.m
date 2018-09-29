//
//  ZXPopoverBackgroundView.m
//  YiShangbao
//
//  Created by simon on 2018/9/29.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "ZXPopoverBackgroundView.h"

// 重写这个高度大小后，比系统默认的小的多了；只不过系统的有圆弧过渡，我是三角形；
static const CGFloat kArrowBase = 14.f;//箭头大小
static const CGFloat kArrowHeight = 8.f;//箭头高度
static const CGFloat kContentViewInset = 0;
// 设置圆角大小
static const CGFloat kContentViewCornerRadius = 6.f;


@interface ZXPopoverBackgroundView ()


@end

@implementation ZXPopoverBackgroundView

@synthesize arrowOffset = _arrowOffset;
@synthesize arrowDirection = _arrowDirection;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addSubview:self.arrowImageView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubview:self.arrowImageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize arrowSize = CGSizeMake([[self class] arrowBase], [[self class]arrowHeight]);
    UIImage *arrowImage = [self drawArrowImage:arrowSize];
    self.arrowImageView.image =arrowImage ;
    
    CGFloat x = 0;
    CGFloat y = 0;
    
    CGFloat popoverViewWidth = self.bounds.size.width;
    CGFloat popoverViewHeight = self.bounds.size.height;
    CGFloat arrowWidth = arrowSize.width;
    CGFloat arrowHeight = arrowSize.height;
    
    switch (self.arrowDirection)
    {
        case UIPopoverArrowDirectionUp:
            x = (popoverViewWidth - arrowWidth)/2 + self.arrowOffset;
            y = 0;
            break;
        case UIPopoverArrowDirectionLeft:
            x = 0;
            y = (popoverViewHeight- arrowHeight)/2 + self.arrowOffset;
            break;
        case UIPopoverArrowDirectionDown:
            x = (popoverViewWidth - arrowWidth)/2 + self.arrowOffset;
            y = popoverViewHeight-arrowHeight;
            break;
        case UIPopoverArrowDirectionRight:
            x = popoverViewWidth - arrowWidth;
            y = (popoverViewHeight- arrowHeight)/2 + self.arrowOffset;
            break;
        default:
            x = 0;
            y = 0;
            break;
    }
    self.arrowImageView.frame = CGRectMake(x, y, arrowSize.width, arrowSize.height);

//    设置圆角
    //    NSLog(@"%@",self.superview.subviews);
    [self.superview.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (![obj isKindOfClass:[self class]])
        {
            [self setCornerRadius:kContentViewCornerRadius borderWidth:1 borderColor:nil view:obj];
            *stop =YES;
        }
    }];
    
    [self.superview.superview.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:NSClassFromString(@"UIDimmingView")])
        {
            obj.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
            *stop =YES;
        }
    }];
}


- (UIImageView *)arrowImageView
{
    if (!_arrowImageView)
    {
        UIImageView *arrowImgView = [[UIImageView alloc] init];
        _arrowImageView = arrowImgView;
    }
    return _arrowImageView;
}


- (UIImage *)drawArrowImage:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor clearColor]setFill];
    CGContextFillRect(ctx, CGRectMake(0, 0, size.width, size.height));
    CGPoint point1;
    CGPoint point2;
    CGPoint point3;
    switch (self.arrowDirection)
    {
        case UIPopoverArrowDirectionUp:
            point1 = CGPointMake(size.width/2, 0);
            point2 = CGPointMake(size.width, size.height);
            point3 = CGPointMake(0, size.height);
            break;
        case UIPopoverArrowDirectionLeft:
            point1 = CGPointMake(0, size.height/2);
            point2 = CGPointMake(size.width, 0);
            point3 = CGPointMake(size.width, size.height);
            break;
        case UIPopoverArrowDirectionDown:
            point1 = CGPointMake(size.width/2, size.height);
            point2 = CGPointZero;
            point3 = CGPointMake(size.width, 0);
            break;
        case UIPopoverArrowDirectionRight:
            point1 = CGPointMake(size.width, size.height/2);
            point2 = CGPointMake(0, size.height);
            point3 = CGPointMake(0, 0);
            break;
        default:
            break;
    }
    CGMutablePathRef arrowPath = CGPathCreateMutable();
    CGPathMoveToPoint(arrowPath, NULL, point1.x, point1.y);
    CGPathAddLineToPoint(arrowPath, NULL, point2.x, point2.y);
    CGPathAddLineToPoint(arrowPath, NULL, point3.x, point3.y);
    CGPathCloseSubpath(arrowPath);
    
    CGContextAddPath(ctx, arrowPath);
    CGPathRelease(arrowPath);
    
    UIColor *fillColor = [UIColor whiteColor];
    CGContextSetFillColorWithColor(ctx, fillColor.CGColor);
    CGContextDrawPath(ctx, kCGPathFill);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (CGFloat)arrowBase
{
    return kArrowBase;
}

+ (CGFloat)arrowHeight
{
    return kArrowHeight;
}

+ (UIEdgeInsets)contentViewInsets
{
    return UIEdgeInsetsMake(kContentViewInset, kContentViewInset, kContentViewInset, kContentViewInset);
}
//是否使用默认的内置阴影和圆角
+(BOOL)wantsDefaultContentAppearance {
    return NO;
}


- (void)setCornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color view:(UIView *)view
{
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = radius;
    view.layer.borderWidth = width;
    
    view.layer.borderColor =color?[color CGColor]:[UIColor clearColor].CGColor;
}
@end
