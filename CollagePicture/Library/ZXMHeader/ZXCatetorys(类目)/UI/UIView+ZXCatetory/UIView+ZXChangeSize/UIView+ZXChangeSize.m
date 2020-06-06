//
//  UIView+ZXChangeSize.m
//  CollagePicture
//
//  Created by simon on 17/1/6.
//  Copyright © 2017年 simon. All rights reserved.
//

#import "UIView+ZXChangeSize.h"


@implementation UIView (ZXChangeSize)

- (void)setZx_x:(CGFloat)zx_x
{
    CGRect frame = self.frame;
    frame.origin.x = zx_x;
    self.frame = frame;
}

- (CGFloat)zx_x
{
    return self.zx_origin.x;
}

- (void)setZx_centerX:(CGFloat)zx_centerX
{
    CGPoint center = self.center;
    center.x = zx_centerX;
    self.center = center;
}

- (CGFloat)zx_centerX
{
    return self.center.x;
}

-(void)setZx_centerY:(CGFloat)zx_centerY
{
    CGPoint center = self.center;
    center.y = zx_centerY;
    self.center = center;
}

- (CGFloat)zx_centerY
{
    return self.center.y;
}

- (void)setZx_y:(CGFloat)zx_y
{
    CGRect frame = self.frame;
    frame.origin.y = zx_y;
    self.frame = frame;
}

- (CGFloat)zx_y
{
    return self.frame.origin.y;
}

- (void)setZx_size:(CGSize)zx_size
{
    CGRect frame = self.frame;
    frame.size = zx_size;
    self.frame = frame;
    
}

- (CGSize)zx_size
{
    return self.frame.size;
}

- (void)setZx_height:(CGFloat)zx_height
{
    CGRect frame = self.frame;
    frame.size.height = zx_height;
    self.frame = frame;
}

- (CGFloat)zx_height
{
    return self.frame.size.height;
}

- (void)setZx_width:(CGFloat)zx_width
{
    CGRect frame = self.frame;
    frame.size.width = zx_width;
    self.frame = frame;
}

- (CGFloat)zx_width
{
    return self.frame.size.width;
}

- (void)setZx_origin:(CGPoint)zx_origin
{
    CGRect frame = self.frame;
    frame.origin = zx_origin;
    self.frame = frame;
}

- (CGPoint)zx_origin
{
    return self.frame.origin;
}



#pragma mark - safeAreaLayoutGuide


- (CGFloat)zx_safeAreaLayoutGuideY
{
    CGFloat originY = 0;
    if (@available(iOS 11.0, *)) {
        UILayoutGuide *layout = self.safeAreaLayoutGuide;
        originY = layout.layoutFrame.origin.y;
    }else
    {
        UILayoutGuide *layout = self.layoutMarginsGuide;
        originY = layout.layoutFrame.origin.y;
    }
    return originY;
}

- (CGSize)zx_safeAreaLayoutGuideSize
{
    CGSize size = CGSizeZero;
    if (@available(iOS 11.0, *)) {
        UILayoutGuide *layout = self.safeAreaLayoutGuide;
        size = layout.layoutFrame.size;
    }else
    {
        UILayoutGuide *layout = self.layoutMarginsGuide;
        size = CGSizeMake(layout.layoutFrame.size.width + 2*layout.layoutFrame.origin.x, layout.layoutFrame.size.height);
    }
    return size;
}
@end
