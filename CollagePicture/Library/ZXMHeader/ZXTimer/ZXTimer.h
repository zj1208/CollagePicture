//
//  ZXTimer.h
//  CollagePicture
//
//  Created by simon on 2019/6/21.
//  Copyright © 2019 simon. All rights reserved.
//
//  简介：包装NSTimer使得NSTimer只强引用这个对象，而不被控制器强引用；
//       在外部直接调用引用的当前实例对象 = nil，依然无法进入ZXTimer对象的dealloc方法，即无法释放当前对象，因为当前对象被timer强引用添加到runloop了；只有调用stopTimer后，才能释放当前对象；


#import <Foundation/Foundation.h>
#import "NSTimer+ZXCategory.h"

NS_ASSUME_NONNULL_BEGIN


@class ZXTimer;

@protocol ZXTimerDelegate <NSObject>

- (void)zxTimerFired:(ZXTimer *)timer;

@end

@interface ZXTimer : NSObject

@property (nonatomic, weak) id<ZXTimerDelegate> timerDelegate;


// 预加载初始化定时器及设置代理方法；初始化ti时间后开始执行定时器，将以默认mode直接添加到当前的runloop中；
- (void)scheduledTimerWithTimeInterval:(NSTimeInterval)ti
          delegate:(id<ZXTimerDelegate>)delegate
          userInfo:(nullable id)userInfo
           repeats:(BOOL)repeats;

// 非预加载初始化定时器及设置代理方法；初始化ti时间后开始执行定时器，您必须使用【addTimer:forMode: 】方法 将timer添加到当前runloop运行循环中;如果你手动调用fair，定时器会立马启动,不需要等ti时间后执行。
- (void)timerWithTimeInterval:(NSTimeInterval)ti
                              delegate:(id<ZXTimerDelegate>)delegate
                              userInfo:(nullable id)userInfo
                               repeats:(BOOL)repeats;

// 释放当前对象的唯一方法；只有调用当前方法，移除定时器，才能正常释放当前对象;
- (void)stopTimer;



/**
 添加定时器到指定runloop中；

 @param timer ZXTimer;
 @param mode NSRunLoopModel中的其中一个；
 */
- (void)addTimer:(ZXTimer *)timer forMode:(NSRunLoopMode)mode;

@property (nonatomic, strong) NSTimer *timer;

@end

NS_ASSUME_NONNULL_END



//例如 获取验证码的控制器页面
/*
#import "ZXTimer.h"
@interface RegisterViewController ()<UITextFieldDelegate,ZXTimerDelegate>

@property (nonatomic, strong) ZXTimer *timer;
@property (nonatomic, assign) NSInteger smsDownSeconds;

@end

- (void)dealloc
{
    [self.timer stopTimer];
}

- (ZXTimer *)timer
{
    if (!_timer) {
        _timer = [[ZXTimer alloc] init];
    }
    return _timer;
}
#pragma mark - 验证码获取成功后执行

- (void)smsCodeRequestSuccess
{
    self.verfiCodeBtn.enabled = NO;
    self.verfiCodeBtn.backgroundColor = [UIColor lightGrayColor];
    self.smsDownSeconds = 60;
    [self.timer scheduledTimerWithTimeInterval:1 delegate:self repeats:YES];
}


#pragma mark - ZXTimerDelegate
- (void)zxTimerFired:(ZXTimer *)timer
{
    if (self.smsDownSeconds ==0)
    {
        self.verfiCodeBtn.enabled = NO;
        self.verfiCodeBtn.backgroundColor = [UIColor orangeColor];
        [self.verfiCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.ZXTimer stopTimer];
    }else
    {
        [self.verfiCodeBtn setTitle:[[NSNumber numberWithInt:(int)self.smsDownSeconds] description] forState:UIControlStateNormal];
        self.smsDownSeconds--;
    }
}
*/
