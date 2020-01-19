//
//  NSTimer+ZXCategory.m
//  MobileCaiLocal
//
//  Created by simon on 2019/12/24.
//  Copyright © 2019 com.Chs. All rights reserved.
//

#import "NSTimer+ZXCategory.h"

@implementation NSTimer (ZXCategory)

- (void)zx_pauseTimer
{
    if (![self isValid])
    {
        return;
    }
    [self setFireDate:[NSDate distantFuture]];
}


- (void)zx_resumeTimer
{
    if (![self isValid])
    {
        return;
    }
    [self setFireDate:[NSDate date]];
}

- (void)zx_resumeTimerAfterTimeInterval:(NSTimeInterval)interval
{
    if (![self isValid])
    {
        return;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end
