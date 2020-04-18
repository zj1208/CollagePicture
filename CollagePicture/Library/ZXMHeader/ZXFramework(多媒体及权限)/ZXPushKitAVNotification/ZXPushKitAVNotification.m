//
//  ZXPushKitAVNotification.m
//  DS
//
//  Created by simon on 2019/6/13.
//  Copyright © 2019 com.Microants. All rights reserved.
//

#import "ZXPushKitAVNotification.h"


@import AudioToolbox;

#ifndef ZXSuppressPerformSelectorLeakWarning
#define ZXSuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)
#endif

//static void ZXVibrateCompletion(SystemSoundID soundID, void *data)
//{
//    id notifier = (__bridge id)data;
//    if([notifier isKindOfClass:[ZXPushKitAVNotification class]])
//    {
//        SEL selector = NSSelectorFromString(@"vibrate");
//        ZXSuppressPerformSelectorLeakWarning([(ZXPushKitAVNotification *)notifier performSelector:selector withObject:nil afterDelay:1.0]);
//    }
//}

@interface ZXPushKitAVNotification ()

// 本地通知
@property (nonatomic, strong) UILocalNotification *currentNotification;

// 是否需要震动；
@property (nonatomic, assign) BOOL shouldStopVibrate;

@end

@implementation ZXPushKitAVNotification

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(willEnterForeground:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        self.vibrateCount = 15;
        self.soundName = @"video_chat_push.mp3";
    }
    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)willEnterForeground:(NSNotification *)notification
{
    [self stop];
}


// 当连续调用的时候，之前的本地通知将会取消，震动也会取消,震动次数重新开始计算；
- (void)start:(NSString *)text
{
    // 后台状态；按home键进入后台；启动其它应用把当前应用挤入后台；本来是属于后台状态的，当点击通知栏将要激活，变成前台的时候，就会马上变成非激活状态；
    // 非活跃状态：手机锁屏；
    if ([[UIApplication sharedApplication]applicationState] != UIApplicationStateBackground) {
        
        return;
    }
    [self stop];
    self.vibrateCount = 0;
    self.shouldStopVibrate = NO;
    [self presentLocalNotificationWithAlertBody:text];
    [self vibrate];
}

- (void)stop
{
    if (self.currentNotification)
    {
        [[UIApplication sharedApplication] cancelLocalNotification:self.currentNotification];
        self.currentNotification = nil;
    }
    self.shouldStopVibrate = YES;
}



- (UILocalNotification *)currentNotification
{
    if (!_currentNotification) {
        _currentNotification = [[UILocalNotification alloc] init];
    }
    return _currentNotification;
}

- (void)presentLocalNotificationWithAlertBody:(NSString *)text
{
    self.currentNotification.soundName = self.soundName;
    self.currentNotification.alertBody = text;
    
    [[UIApplication sharedApplication]presentLocalNotificationNow:self.currentNotification];
}


- (void)vibrate
{
    if (!self.shouldStopVibrate) {
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, NULL, NULL, ZXVibrateCompletion, (__bridge void *)self);
#else
        AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate, ^{
       
            [self vibrate];
        });
#endif
        self.vibrateCount++;
        if (self.vibrateCount >= self.vibrateCount)
        {
            self.shouldStopVibrate = YES;
        }
    }
}

void ZXVibrateCompletion(SystemSoundID soundID, void *data)
{
    id notifier = (__bridge id)data;
    if([notifier isKindOfClass:[ZXPushKitAVNotification class]])
    {
        SEL selector = NSSelectorFromString(@"vibrate");
        ZXSuppressPerformSelectorLeakWarning([(ZXPushKitAVNotification *)notifier performSelector:selector withObject:nil afterDelay:1.0]);
    }
}
@end
