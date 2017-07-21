//
//  NSTimer+Addition.h
//  baohuai_iPhone
//
//  Created by 朱新明 on 14-5-2.
//  Copyright (c) 2014年 summer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Addition)

/*暂停*/
- (void)pauseTimer;

/* 开始*/
- (void)resumeTimer;

/*
 @param interval 时间量
 一定时间后重新开始
 */
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;
@end
