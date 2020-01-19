//
//  NSTimer+ZXCategory.h
//  MobileCaiLocal
//
//  Created by simon on 2019/12/24.
//  Copyright © 2019 com.Chs. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (ZXCategory)


/*暂停*/
- (void)zx_pauseTimer;

/* 开始*/
- (void)zx_resumeTimer;

/*
 @param interval 时间量
 一定时间后重新开始
 */
- (void)zx_resumeTimerAfterTimeInterval:(NSTimeInterval)interval;

@end

NS_ASSUME_NONNULL_END
