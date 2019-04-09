//
//  KxMenuView.m
//  Baby
//
//  Created by simon on 16/1/21.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "KxMenuView.h"

#import <QuartzCore/QuartzCore.h>
#import "UIImage+ZXHelper.h"

const CGFloat kArrowSize = 7.f;//箭头大小
const CGFloat kMarginX = 5; //button 按钮左右边距
const CGFloat kMarginY = 0; // button 按钮 上下边距


@implementation KxMenuView


- (id)init
{
    self = [super initWithFrame:CGRectZero];
    if(self) {
//        self.backgroundColor = [UIColor redColor];
        self.backgroundColor = [UIColor clearColor];
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowOffset = CGSizeMake(2, 2);
        self.layer.shadowRadius = 2;
    }
    return self;
}



- (void)showMenuInView:(UIView *)view fromRect:(CGRect)rect menuItems:(NSArray *)menuItems
{
    self.menuItems = nil;
    self.menuItems = [NSArray arrayWithArray:menuItems];
    
    [self addContentView];//在KxMenuView上添加 contentView
    
    [self setupFrameInView:view fromRect:rect];//在KxMenuView 上动态改变箭头坐标，箭头和contentView之间的距离
    
    ZXKxMenuOverlay *overlay = [[ZXKxMenuOverlay alloc] initWithFrame:view.frame];
    overlay.delegate = self;
    overlay.backgroundColor = [KxMenu sharedMenu].kxMenuOverlayBackgroundColor;
    [overlay addSubview:self];
    [view addSubview:overlay];
    
    
    //动画出现，等框框出现后，内容再出现
    self.contentView.hidden = YES;
    const CGRect toFrame = self.frame;
    self.frame = (CGRect){self.arrowPoint, 1, 1};
    
    
    [UIView animateWithDuration:0.2
                     animations:^(void) {
                         
                         self.alpha = 1.0f;
                         self.frame = toFrame;
                         
                     } completion:^(BOOL completed) {
                         
                         self.contentView.hidden = NO;
                         
                     }];
    
}

//整个contentView，如同tableView，把一个个的item，线条，加入道contentView上，contentView是透明的

- (void)addContentView
{
    if (self.contentView)
    {
        [self.contentView removeFromSuperview];
    }
    if (!self.menuItems.count)
    {
        return ;
    }
    
    const CGFloat kMinMenuItemHeight = 40.f;
    const CGFloat kMinMenuItemWidth = 32.f;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
    
    for (int i =0; i<_menuItems.count; i++)
    {
        UIFont *font = [[KxMenu sharedMenu] titleFont];
        KxMenuItem *menuItem =[_menuItems objectAtIndex:i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 1+i;
        button.enabled =menuItem.enabled;
        button.layer.masksToBounds = YES;//自己添加
        button.layer.cornerRadius = 5;//自己添加
        button.backgroundColor = [UIColor clearColor];
        button.opaque = YES;
        button.titleLabel.font = font?font:[UIFont boldSystemFontOfSize:16];
        [button setTitle:menuItem.title forState:UIControlStateNormal];
        [button setImage:menuItem.image forState:UIControlStateNormal];
        if (menuItem.image && menuItem.title)
        {
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        }
        [button sizeToFit];
        [button addTarget:self action:@selector(performAction:)forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:button];
        
        if (CGRectGetHeight(button.frame) > self.maxItemHeight)
            self.maxItemHeight = CGRectGetHeight(button.frame)+2*kMarginY;
        
        if (CGRectGetWidth(button.frame) > self.maxItemWidth)
            self.maxItemWidth = CGRectGetWidth(button.frame)+2*kMarginX;
    }
    
    self.maxItemWidth  = MAX(self.maxItemWidth, kMinMenuItemWidth);//取最大值-得整个itemWidth
    self.maxItemHeight = MAX(self.maxItemHeight, kMinMenuItemHeight);
    
    
    UIEdgeInsets contentViewEdge = [[KxMenu sharedMenu]contentViewEdge];

    [_menuItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UIButton *btn = (UIButton *)[contentView viewWithTag:idx+1];
        btn.frame =  (CGRect){contentViewEdge.left, contentViewEdge.top+ idx*(self.maxItemHeight+1), self.maxItemWidth, self.maxItemHeight};
        [btn setBackgroundImage:[self getHighlightedImage] forState:UIControlStateHighlighted];
        UIColor *color = [[_menuItems objectAtIndex:idx] foreColor]?[[_menuItems objectAtIndex:idx] foreColor]:[UIColor whiteColor];
        [btn setTitleColor:color forState:UIControlStateNormal];
        //        [btn setTitleColor:AppColor forState:UIControlStateHighlighted];
        
        if (idx<_menuItems.count-1)
        {
            UIImageView *gradientView = [[UIImageView alloc] initWithImage:[self getSeperateImage]];
            gradientView.frame = (CGRect){0, CGRectGetMaxY(btn.frame), [self getSeperateImage].size};
            [contentView addSubview:gradientView];
        }
    }];
    
    
    contentView.frame = (CGRect){0, 0, self.maxItemWidth+contentViewEdge.left+contentViewEdge.right, contentViewEdge.top+ _menuItems.count*(self.maxItemHeight+1) +contentViewEdge.bottom};
    
    self.contentView = contentView;
    
    self.contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.contentView];
}



-(UIImage *)getHighlightedImage
{
    UIColor *color = [[KxMenu sharedMenu] kxMenuSelectionBackgoundColor]?[[KxMenu sharedMenu] kxMenuSelectionBackgoundColor]:[UIColor clearColor];
    UIImage *selectedImage = [self imageWithColor:color andSize:CGSizeMake(self.maxItemWidth, self.maxItemHeight+2) opaque:NO];
    return selectedImage;
}

- (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size opaque:(BOOL)opaque
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, opaque, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)getSeperateImage
{
    UIImage *gradientLine = nil;
    KxMenuCellSeperateStyle style =[[KxMenu sharedMenu] kxMenuCellSeperateStyle];
    UIEdgeInsets contentViewEdge = [[KxMenu sharedMenu]contentViewEdge];
    if (style ==KxMenuCellSeperateStyleLine)
    {
        gradientLine = [self imageWithColor:[UIColor colorWithWhite:0.9 alpha:1] andSize:(CGSize){self.maxItemWidth+contentViewEdge.left+contentViewEdge.right, 1} opaque:NO];
    }
    if (style ==KxMenuCellSeperateStyleNone)
    {
        return nil;
    }
    return gradientLine;
}


//动态改变箭头坐标，箭头和contentView之间的距离 ，坐标只针对于当前frame的view；注意在滚动视图中；view要以controller的view做基准页面；
- (void) setupFrameInView:(UIView *)view fromRect:(CGRect)fromRect
{
    const CGSize contentSize = self.contentView.frame.size;
    
    const CGFloat outerWidth = view.bounds.size.width;
    const CGFloat outerHeight = view.bounds.size.height;
    
    const CGFloat rectX0 = fromRect.origin.x;
    const CGFloat rectX1 = fromRect.origin.x + fromRect.size.width;
    const CGFloat rectXM = fromRect.origin.x + fromRect.size.width * 0.5f;//获取fromRect的width中心x坐标
    const CGFloat rectY0 = fromRect.origin.y;
    const CGFloat rectY1 = fromRect.origin.y + fromRect.size.height;
    const CGFloat rectYM = fromRect.origin.y + fromRect.size.height * 0.5f;;
    
    const CGFloat widthPlusArrow = contentSize.width + kArrowSize;
    const CGFloat heightPlusArrow = contentSize.height + kArrowSize;
    const CGFloat widthHalf = contentSize.width * 0.5f;//contentView一半宽度
    const CGFloat heightHalf = contentSize.height * 0.5f;
    
    const CGFloat kMargin = 5.f;
    
    //判断（cotentView＋箭头高度）是否能在显示的view高度－y值后的空间显示；
    if (heightPlusArrow < (outerHeight - rectY1))
    {
        
        self.arrowDirection = KxMenuViewArrowDirectionUp;
        CGPoint point = (CGPoint){
            rectXM - widthHalf,
            rectY1
        };
        
        if (point.x < kMargin)
            point.x = kMargin;
        
        if ((point.x + contentSize.width + kMargin) > outerWidth)
            point.x = outerWidth - contentSize.width - kMargin;
        
        self.arrowPosition = rectXM - point.x;
        self.contentView.frame = (CGRect){0, kArrowSize, contentSize};
        //kXMenuView的高度＝contentView高度＋箭头高度KArrowSize
        self.frame = CGRectMake(point.x, point.y, contentSize.width, contentSize.height+kArrowSize);
        
    }
    else if (heightPlusArrow < rectY0)
    {
        
        _arrowDirection = KxMenuViewArrowDirectionDown;
        CGPoint point = (CGPoint){
            rectXM - widthHalf,
            rectY0 - heightPlusArrow
        };
        
        if (point.x < kMargin)
            point.x = kMargin;
        
        if ((point.x + contentSize.width + kMargin) > outerWidth)
            point.x = outerWidth - contentSize.width - kMargin;
        
        _arrowPosition = rectXM - point.x;
        _contentView.frame = (CGRect){CGPointZero, contentSize};
        
        self.frame = (CGRect) {
            
            point,
            contentSize.width,
            contentSize.height + kArrowSize
        };
        
    }
    else if (widthPlusArrow < (outerWidth - rectX1))
    {
        
        _arrowDirection = KxMenuViewArrowDirectionLeft;
        CGPoint point = (CGPoint){
            rectX1,
            rectYM - heightHalf
        };
        
        if (point.y < kMargin)
            point.y = kMargin;
        
        if ((point.y + contentSize.height + kMargin) > outerHeight)
            point.y = outerHeight - contentSize.height - kMargin;
        
        _arrowPosition = rectYM - point.y;
        _contentView.frame = (CGRect){kArrowSize, 0, contentSize};
        
        self.frame = (CGRect) {
            
            point,
            contentSize.width + kArrowSize,
            contentSize.height
        };
        
    }
    else if (widthPlusArrow < rectX0)
    {
        
        _arrowDirection = KxMenuViewArrowDirectionRight;
        CGPoint point = (CGPoint){
            rectX0 - widthPlusArrow,
            rectYM - heightHalf
        };
        
        if (point.y < kMargin)
            point.y = kMargin;
        
        if ((point.y + contentSize.height + 5) > outerHeight)
            point.y = outerHeight - contentSize.height - kMargin;
        
        _arrowPosition = rectYM - point.y;
        _contentView.frame = (CGRect){CGPointZero, contentSize};
        
        self.frame = (CGRect) {
            
            point,
            contentSize.width  + kArrowSize,
            contentSize.height
        };
        
    }
    else
    {
        
        _arrowDirection = KxMenuViewArrowDirectionNone;
        
        self.frame = (CGRect) {
            
            (outerWidth - contentSize.width)   * 0.5f,
            (outerHeight - contentSize.height) * 0.5f,
            contentSize,
        };
    }
}


- (void)dismissMenu:(BOOL) animated
{
    if (self.superview) {
        
        if (animated) {
            
            _contentView.hidden = YES;
            const CGRect toFrame = (CGRect){self.arrowPoint, 1, 1};
            
            [UIView animateWithDuration:0.2
                             animations:^(void) {
                                 
                                 self.alpha = 0;
                                 self.frame = toFrame;
                                 
                             } completion:^(BOOL finished) {
                                 
                                 if ([self.superview isKindOfClass:[ZXKxMenuOverlay class]])
                                     [self.superview removeFromSuperview];
                                 [self removeFromSuperview];
                             }];
            
        } else {
            
            if ([self.superview isKindOfClass:[ZXKxMenuOverlay class]])
                [self.superview removeFromSuperview];
            [self removeFromSuperview];
        }
    }
}

- (void)performAction:(id)sender
{
    [self dismissMenu:YES];
    
    UIButton *button = (UIButton *)sender;
    KxMenuItem *menuItem = _menuItems[button.tag-1];
    [menuItem performAction];
}


- (CGPoint) arrowPoint
{
    CGPoint point;
    
    if (_arrowDirection == KxMenuViewArrowDirectionUp) {
        
        point = (CGPoint){ CGRectGetMinX(self.frame) + _arrowPosition, CGRectGetMinY(self.frame) };
        
    } else if (_arrowDirection == KxMenuViewArrowDirectionDown) {
        
        point = (CGPoint){ CGRectGetMinX(self.frame) + _arrowPosition, CGRectGetMaxY(self.frame) };
        
    } else if (_arrowDirection == KxMenuViewArrowDirectionLeft) {
        
        point = (CGPoint){ CGRectGetMinX(self.frame), CGRectGetMinY(self.frame) + _arrowPosition  };
        
    } else if (_arrowDirection == KxMenuViewArrowDirectionRight) {
        
        point = (CGPoint){ CGRectGetMaxX(self.frame), CGRectGetMinY(self.frame) + _arrowPosition  };
        
    } else {
        
        point = self.center;
    }
    
    return point;
}

////绘制渐变的图片的－我不需要了
//+ (UIImage *) selectedImage: (CGSize) size
//{
//    
//    //    定义一个单进度一维数组
//    const CGFloat locations[] = {0,1};
//    //    颜色分量的数组－自己改变了选中后的背景图片 渐变颜色。
//    //    const CGFloat components[] = {
//    //        0.216, 0.471, 0.871, 1,
//    //        0.059, 0.353, 0.839, 1,
//    //    };
//    const CGFloat components[] ={
//        0.9,0.9,0.9,1,
//        0.95,0.95,0.95,1,
//    };
//    
//    return [self gradientImageWithSize:size locations:locations components:components count:2];
//}
//
//+ (UIImage *) gradientLine: (CGSize) size
//{
//    const CGFloat locations[5] = {0,0.2,0.5,0.8,1};
//    
//    const CGFloat R = 0.44f, G = 0.44f, B = 0.44f;
//    
//    const CGFloat components[20] = {
//        R,G,B,0.1,
//        R,G,B,0.4,
//        R,G,B,0.7,
//        R,G,B,0.4,
//        R,G,B,0.1
//    };
//    
//    return [self gradientImageWithSize:size locations:locations components:components count:5];
//}
//
////选中后的颜色 和 分割线图片 设定。
//+ (UIImage *) gradientImageWithSize:(CGSize) size
//                          locations:(const CGFloat []) locations
//                         components:(const CGFloat []) components
//                              count:(NSUInteger)count
//{
//    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();//色彩空间
//    CGGradientRef colorGradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, count);
//    CGColorSpaceRelease(colorSpace);
//    CGContextDrawLinearGradient(context, colorGradient, (CGPoint){0, 0}, (CGPoint){size.width, 0}, 0);
//    CGGradientRelease(colorGradient);
//    
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return image;
//}

//drawRect 箭头，and ContentView圆角填充颜色
- (void) drawRect:(CGRect)rect
{
    [self drawBackground:self.bounds
               inContext:UIGraphicsGetCurrentContext()];
}


//重写 render arrowPath and contentView ＝ render kxmenuView；
- (void)drawBackground:(CGRect)frame
             inContext:(CGContextRef) context
{
    
    CGFloat R0 = 0.267, G0 = 0.303, B0 = 0.335;
    CGFloat R1 = 0.040, G1 = 0.040, B1 = 0.040;
    
    UIColor *color = [[KxMenu sharedMenu]tintColor];
    if (color) {
        
        CGFloat a;
        [color getRed:&R0 green:&G0 blue:&B0 alpha:&a];
    }
    
    CGFloat X0 = frame.origin.x;
    CGFloat X1 = frame.origin.x + frame.size.width;
    CGFloat Y0 = frame.origin.y;
    CGFloat Y1 = frame.origin.y + frame.size.height;
    
    // render arrow
    
    UIBezierPath *arrowPath = [UIBezierPath bezierPath];
    
    // fix the issue with gap of arrow's base if on the edge
    //纠错 箭头 底部有没有插入contentView；
    const CGFloat kEmbedFix = 0.f;
    
    if (_arrowDirection == KxMenuViewArrowDirectionUp) {
        
        const CGFloat arrowXM = _arrowPosition;
        const CGFloat arrowX0 = arrowXM - kArrowSize;
        const CGFloat arrowX1 = arrowXM + kArrowSize;
        const CGFloat arrowY0 = Y0;
        const CGFloat arrowY1 = Y0 + kArrowSize + kEmbedFix;
        
        [arrowPath moveToPoint:    (CGPoint){arrowXM, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowXM, arrowY0}];
        
        if (color)
        {
            [color set];
        }
        else
        {
            [[UIColor colorWithRed:R0 green:G0 blue:B0 alpha:1] set];
        }
        
        Y0 += kArrowSize;
        
    } else if (_arrowDirection == KxMenuViewArrowDirectionDown) {
        
        const CGFloat arrowXM = _arrowPosition;
        const CGFloat arrowX0 = arrowXM - kArrowSize;
        const CGFloat arrowX1 = arrowXM + kArrowSize;
        const CGFloat arrowY0 = Y1 - kArrowSize - kEmbedFix;
        const CGFloat arrowY1 = Y1;
        
        [arrowPath moveToPoint:    (CGPoint){arrowXM, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowXM, arrowY1}];
        
        if (color)
        {
            [color set];
        }
        else
        {
            [[UIColor colorWithRed:R1 green:G1 blue:B1 alpha:1] set];
        }
        
        Y1 -= kArrowSize;
        
    } else if (_arrowDirection == KxMenuViewArrowDirectionLeft) {
        
        const CGFloat arrowYM = _arrowPosition;
        const CGFloat arrowX0 = X0;
        const CGFloat arrowX1 = X0 + kArrowSize + kEmbedFix;
        const CGFloat arrowY0 = arrowYM - kArrowSize;;
        const CGFloat arrowY1 = arrowYM + kArrowSize;
        
        [arrowPath moveToPoint:    (CGPoint){arrowX0, arrowYM}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowYM}];
        
        [[UIColor colorWithRed:R0 green:G0 blue:B0 alpha:1] set];
        
        X0 += kArrowSize;
        
    } else if (_arrowDirection == KxMenuViewArrowDirectionRight) {
        
        const CGFloat arrowYM = _arrowPosition;
        const CGFloat arrowX0 = X1;
        const CGFloat arrowX1 = X1 - kArrowSize - kEmbedFix;
        const CGFloat arrowY0 = arrowYM - kArrowSize;;
        const CGFloat arrowY1 = arrowYM + kArrowSize;
        
        [arrowPath moveToPoint:    (CGPoint){arrowX0, arrowYM}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowYM}];
        
        [[UIColor colorWithRed:R1 green:G1 blue:B1 alpha:1] set];
        
        X1 -= kArrowSize;
    }
    
    [arrowPath fill];
    
    
    
    
    // render body
    const CGRect bodyFrame = {X0, Y0, X1 - X0, Y1 - Y0};
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:bodyFrame
                                                          cornerRadius:5];//自己改变的角度
    if (color)
    {
        [color set];
    }
    else
    {
        [[UIColor colorWithRed:R0 green:G0 blue:B0 alpha:1] set];
    }
    
    
    ////    （3） 位置数组，颜色数组中各个颜色的位置：此参数控制该渐变从一种颜色过渡到另一种颜色的速度有多快。
    //    const CGFloat locations[] = {0, 1};
    //
    ////    （2）颜色分量的数组：这个数组必须包含CGFloat类型的红、绿、蓝和alpha值。数组中元素的数量和接下来两个参数密切。从本质来讲，你必须让这个数组包含足够的值，用来指定第四个参数中位置的数量。所以如果你需要两个位置位置（起点和终点），那么你必须为数组提供两种颜色
    //
    //    //打底颜色渐变－－自己改变了
    ////    const CGFloat components[] = {
    ////        R0, G0, B0, 1,
    ////        R1, G1, B1, 1,
    ////    };
    //    const CGFloat components[] = {
    //        0.95, 0.95,0.95, 1,
    //        0.95, 0.95, 0.95, 1,
    //    };
    //
    //
    ////    （1）色彩空间：（Color Space）这是一个色彩范围的容器，类型必须是CGColorSpaceRef.对于这个参数，我们可以传入CGColorSpaceCreateDeviceRGB函数的返回值，它将给我们一个RGB色彩空间。
    //    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //
    //
    //    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace,
    //                                                                 components,
    //                                                                 locations,
    //                                                                 sizeof(locations)/sizeof(locations[0]));
    //    CGColorSpaceRelease(colorSpace);
    
    
    [borderPath addClip];
    [borderPath fill];
    
    //设置渐变的起点和终点
    //    CGPoint start, end;
    //
    //    if (_arrowDirection == KxMenuViewArrowDirectionLeft ||
    //        _arrowDirection == KxMenuViewArrowDirectionRight) {
    //
    //        start = (CGPoint){X0, Y0};
    //        end = (CGPoint){X1, Y0};
    //
    //    } else {
    //        
    //        start = (CGPoint){X0, Y0};
    //        end = (CGPoint){X0, Y1};
    //    }
    //    
    //    CGContextDrawLinearGradient(context, gradient, start, end, 0);
    //    
    //    CGGradientRelease(gradient);    
}


- (void)zxKxMenuOverlaydissmissAction
{
    [self dismissMenu:YES];
}
@end
