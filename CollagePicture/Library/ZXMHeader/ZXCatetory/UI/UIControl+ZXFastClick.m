//
//  UIControl+ZXFastClick.m
//  YiShangbao
//
//  Created by simon on 17/4/5.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "UIControl+ZXFastClick.h"


static const char *uiControl_kIgnoreEventChar = "uiControl_kIgnoreEvent";
static const char *uiControl_kTimeIntervalChar = "uiControl_kTimeInterval";
static const double uiControl_kTimeInterval = 0.5;

@interface UIControl ()

@property (nonatomic, assign) BOOL ignoreEvent;

@end

@implementation UIControl (ZXFastClick)

+ (void)load
{
    Method originalMethod = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    Method swizzledMethod = class_getInstanceMethod(self, @selector(zx_sendAction:to:forEvent:));
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)zx_sendAction:(SEL)action to:(nullable id)target forEvent:(nullable UIEvent *)event
{
    if ([self isKindOfClass:[UIButton class]]  && self.allControlEvents ==UIControlEventTouchUpInside)
    {
        self.timeInterval = self.timeInterval ==0?uiControl_kTimeInterval:self.timeInterval;
        if (self.ignoreEvent)
        {
            NSLog(@"重复点击UIControlEventTouchUpInside");
            return;
        }
        else if (self.timeInterval>0)
        {
            [self performSelector:@selector(resetState) withObject:nil afterDelay:self.timeInterval];
        
        }
        self.ignoreEvent = YES;

     }
    [self zx_sendAction:action to:target forEvent:event];
}

- (void)resetState
{
    [self setIgnoreEvent:NO];
}

- (NSTimeInterval)timeInterval
{
    return [objc_getAssociatedObject(self, uiControl_kTimeIntervalChar) doubleValue];
}

- (void)setTimeInterval:(NSTimeInterval)timeInterval
{
    objc_setAssociatedObject(self, uiControl_kTimeIntervalChar, @(timeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)ignoreEvent
{
    return [objc_getAssociatedObject(self, uiControl_kIgnoreEventChar) boolValue];
}

- (void)setIgnoreEvent:(BOOL)ignoreEvent
{
    objc_setAssociatedObject(self, uiControl_kIgnoreEventChar, @(ignoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
