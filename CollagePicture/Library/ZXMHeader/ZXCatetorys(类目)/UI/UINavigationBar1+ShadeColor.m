//
//  UINavigationBar+ShadeColor.m
//  CollagePicture
//
//  Created by simon on 16/1/14.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "UINavigationBar+ShadeColor.h"
#import <objc/runtime.h>

#ifndef LCDW
#define LCDSize [[UIScreen mainScreen] bounds]
#define LCDW LCDSize.size.width
#define LCDH LCDSize.size.height
#endif


@implementation UINavigationBar (ShadeColor)

static char overlayKey;


- (UIView *)overlay
{
    return objc_getAssociatedObject(self, &overlayKey);
}

- (void)setOverlay:(UIView *)overlay
{
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)zh_setBackgroundColor:(UIColor *)backgroundColor
{
    if (!self.overlay)
    {
        [self setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, -20, LCDW, CGRectGetHeight(self.bounds)+20)];
        self.overlay.userInteractionEnabled = NO;
        [self insertSubview:self.overlay atIndex:0];
    }
    self.overlay.backgroundColor = backgroundColor;
}

- (void)zh_reset
{
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.overlay removeFromSuperview];
    self.overlay = nil;
}
@end
