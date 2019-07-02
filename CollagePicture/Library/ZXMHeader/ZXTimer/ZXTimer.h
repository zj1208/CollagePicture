//
//  ZXTimer.h
//  CollagePicture
//
//  Created by simon on 2019/6/21.
//  Copyright © 2019 simon. All rights reserved.
//
//  简介：包装NSTimer使得NSTimer只强引用这个对象，而不被控制器强引用；

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@class ZXTimer;

@protocol ZXTimerDelegate <NSObject>

- (void)zxTimerFired:(ZXTimer *)timer;

@end

@interface ZXTimer : NSObject

@property (nonatomic, weak) id<ZXTimerDelegate> timerDelegate;


// 预加载初始化定时器及设置代理方法；定时器在默认runloop中执行；
- (void)scheduledTimerWithTimeInterval:(NSTimeInterval)ti
          delegate:(id<ZXTimerDelegate>)delegate
          userInfo:(nullable id)userInfo
           repeats:(BOOL)repeats;

// 非预加载初始化定时器及设置代理方法；必须自己添加到NSRunLoop中；
- (void)timerWithTimeInterval:(NSTimeInterval)ti
                              delegate:(id<ZXTimerDelegate>)delegate
                              userInfo:(nullable id)userInfo
                               repeats:(BOOL)repeats;

- (void)stopTimer;



/**
 添加定时器到指定runloop中；

 @param timer ZXTimer;
 @param mode NSRunLoopModel中的其中一个；
 */
- (void)addTimer:(ZXTimer *)timer forMode:(NSRunLoopMode)mode;

@end

NS_ASSUME_NONNULL_END



//例如 获取验证码的控制器页面
/*
@interface RegisterViewController ()<UITextFieldDelegate,ZXTimerDelegate>

@property (nonatomic, strong) ZXTimer *smsDownTimer;
@property (nonatomic, assign) NSInteger smsDownSeconds;

@end

- (void)dealloc
{
    [self.smsDownTimer stopTimer];
}

- (ZXTimer *)smsDownTimer
{
    if (!_smsDownTimer) {
        _smsDownTimer = [[ZXTimer alloc] init];
    }
    return _smsDownTimer;
}
#pragma mark - 验证码获取成功后执行

- (void)smsCodeRequestSuccess
{
    self.verfiCodeBtn.enabled = NO;
    self.verfiCodeBtn.backgroundColor = [UIColor lightGrayColor];
    self.smsDownSeconds = 60;
    [self.smsDownTimer scheduledTimerWithTimeInterval:1 delegate:self repeats:YES];
}


#pragma mark - ZXTimerDelegate
- (void)zxTimerFired:(ZXTimer *)timer
{
    if (self.smsDownSeconds ==0)
    {
        self.verfiCodeBtn.enabled = NO;
        self.verfiCodeBtn.backgroundColor = [UIColor orangeColor];
        [self.verfiCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.smsDownTimer stopTimer];
    }else
    {
        [self.verfiCodeBtn setTitle:[[NSNumber numberWithInt:(int)self.smsDownSeconds] description] forState:UIControlStateNormal];
        self.smsDownSeconds--;
    }
}
*/
