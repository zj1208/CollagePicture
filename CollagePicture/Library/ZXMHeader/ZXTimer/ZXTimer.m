//
//  ZXTimer.m
//  CollagePicture
//
//  Created by simon on 2019/6/21.
//  Copyright © 2019 simon. All rights reserved.
//

#import "ZXTimer.h"


@interface ZXTimer ()

@property (nonatomic, assign) BOOL repeats;

- (void)onTimer:(NSTimer *)timer;
@end

@implementation ZXTimer
//在外部直接调用当前对象 = nil，是依然无法进入dealloc的，即无法释放当前对象，因为当前对象被timer强引用添加到runloop了；
- (void)dealloc
{

}


- (void)scheduledTimerWithTimeInterval:(NSTimeInterval)ti delegate:(id<ZXTimerDelegate>)delegate userInfo:(nullable id)userInfo repeats:(BOOL)repeats
{
    self.timerDelegate = delegate;
    self.repeats = repeats;
    if (self.timer) {
        [self.timer invalidate];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:ti target:self selector:@selector(onTimer:) userInfo:userInfo repeats:repeats];
}

- (void)timerWithTimeInterval:(NSTimeInterval)ti
                     delegate:(id<ZXTimerDelegate>)delegate
                     userInfo:(nullable id)userInfo
                      repeats:(BOOL)repeats
{
    self.timerDelegate = delegate;
    self.repeats = repeats;
    if (self.timer) {
        [self.timer invalidate];
    }
    self.timer = [NSTimer timerWithTimeInterval:ti target:self selector:@selector(onTimer:) userInfo:userInfo repeats:repeats];
}

- (void)addTimer:(ZXTimer *)timer forMode:(NSRunLoopMode)mode
{
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:mode];
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timerDelegate = nil;
}


- (void)onTimer:(NSTimer *)timer
{
//    if (!self.repeats) {
//        self.timer = nil;
//    }
    if (self.timerDelegate && [self.timerDelegate respondsToSelector:@selector(zxTimerFired:)]) {
        [self.timerDelegate zxTimerFired:self];
    }
}
@end
