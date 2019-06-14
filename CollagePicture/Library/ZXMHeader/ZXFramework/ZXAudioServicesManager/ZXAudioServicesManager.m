//
//  ZXAudioServicesManager.m
//  DS
//
//  Created by simon on 2019/5/29.
//  Copyright © 2019 ds. All rights reserved.
//

#import "ZXAudioServicesManager.h"

#ifndef ZXSuppressPerformSelectorLeakWarning
#define ZXSuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)
#endif

typedef void(^completedBlock) (void);


//static void ZXAudioServicesCompletion(SystemSoundID soundID, void *data)
//{
//    id notifier = (__bridge id)data;
//    if([notifier isKindOfClass:[ZXAudioServicesManager class]])
//    {
//        SEL selector = NSSelectorFromString(@"vibrate");
//        SuppressPerformSelectorLeakWarning([(ZXAudioServicesManager *)notifier performSelector:selector withObject:nil afterDelay:1.0]);
//    }
//}

@interface ZXAudioServicesManager()

@property (nonatomic, assign) SystemSoundID systemSoundID;

@property (nullable, nonatomic, copy) completedBlock completedBlock;

@property (nonatomic, assign) NSInteger playNums;

@end

@implementation ZXAudioServicesManager

+ (instancetype)sharedManager{
    static ZXAudioServicesManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZXAudioServicesManager alloc]init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.numberOfLoops = 1;
    }
    return self;
}



- (SystemSoundID)creatAudioCustomSoundWithResourceName:(NSString *)name{
    //播放test.wav文件
    SystemSoundID soundIDTest = 0;//当soundIDTest == kSystemSoundID_Vibrate的时候为震动
    NSString * path = [[NSBundle mainBundle] pathForResource:name ofType:@"caf"];//自定义声音
    if (path) {
        AudioServicesCreateSystemSoundID( (__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundIDTest);
    }
    self.systemSoundID = soundIDTest;
    return soundIDTest;
}


#pragma mark - 三个直接调用的便利方法；

+ (ZXAudioServicesManager *)playSystemSoundWithOnlyAudio:(SystemSoundID)soundID numberOfLoops:(NSInteger)num withCompletion:(nullable void(^)(void))completion
{
    ZXAudioServicesManager *manager = [ZXAudioServicesManager sharedManager];
    manager.numberOfLoops = num;
    manager.playNums = 0;
    [manager playOnlyAudio:soundID withCompletion:completion];
    return manager;
}

+ (ZXAudioServicesManager *)playSystemSoundWithCustomSoundResourceName:(NSString *)name numberOfLoops:(NSInteger)num withCompletion:(nullable void(^)(void))completion
{
    SystemSoundID soundID = 0;
    NSString * path = [[NSBundle mainBundle] pathForResource:name ofType:@"caf"];//自定义声音
    if (path) {
        AudioServicesCreateSystemSoundID( (__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    }
    ZXAudioServicesManager *manager = [[ZXAudioServicesManager alloc]init];
    manager.numberOfLoops = num;
    [manager playOnlyAudio:soundID withCompletion:completion];
    return manager;
}


+ (ZXAudioServicesManager *)playVibrateWithNumberOfLoops:(NSInteger)num completion:(nullable void(^)(void))completion
{
    ZXAudioServicesManager *manager = [[ZXAudioServicesManager alloc]init];
    manager.numberOfLoops = num;
    [manager playVibrateWithCompletion:completion];
    return manager;
}


- (void)playSystemSoundWithAudioAndVibrate:(SystemSoundID)soundID  vibrateNumberOfLoops:(NSInteger)num completion:(nullable void(^)(void))completion
{
    self.playNums = 0;
    self.numberOfLoops = num;
    [self playSystemSoundWithAudioAndVibrate:soundID withCompletion:completion];
}

// 是在异步串行队列中执行播放的，也是在子线程中回调的
- (ZXAudioServicesManager *)playOnlyAudio:(SystemSoundID)soundID  withCompletion:(nullable void(^)(void))completion
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
    if (complection) {
        self.completedBlock = completion;
    }
    AudioServicesPlaySystemSound(soundID);
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, playOnlyAudioSoundCompleteCallback, (__bridge void *)self);
#else
    AudioServicesPlaySystemSoundWithCompletion(soundID, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.playNums++;
            if (self.numberOfLoops > self.playNums) {
                [self playOnlyAudio:soundID withCompletion:completion];
            }else{
                if (completion) {
                    completion();
                }
            }
        });
    });
#endif
    return self;
}

/*
*  播放完成的回调函数,需要测试 在子线程还是主线程；
*
*  @param soundID    系统声音ID
*  @param clientDate 回调时传递的数据
*/
void playOnlyAudioSoundCompleteCallback(SystemSoundID ssID,void* __nullable  clientData)
{
    id notifier = (__bridge id)clientData;
    if([notifier isKindOfClass:[ZXAudioServicesManager class]])
    {
        ZXAudioServicesManager *manager = (ZXAudioServicesManager *)notifier;
        if (manager.completedBlock) {
            manager.completedBlock();
        }
        ZXSuppressPerformSelectorLeakWarning([manager performSelector:@selector(playOnlyAudio:withCompletion:) withObject:@(ssID) withObject:manager.completedBlock]);
    }
}


- (ZXAudioServicesManager *)playVibrateWithCompletion:(nullable void(^)(void))completion
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, NULL, NULL, playVibrateCompleteCallback, (__bridge void *)self);
#else
    AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.playNums++;
            if (self.numberOfLoops > self.playNums) {
                
                ZXSuppressPerformSelectorLeakWarning([self performSelector:@selector(playVibrateWithCompletion:) withObject:completion afterDelay:1]);
            }else{
                if (completion) {
                    completion();
                }
            }
        });
    });
#endif
    return self;
}

void playVibrateCompleteCallback(SystemSoundID ssID,void* __nullable  clientData)
{
    id notifier = (__bridge id)clientData;
    if([notifier isKindOfClass:[ZXAudioServicesManager class]])
    {
        ZXAudioServicesManager *manager = (ZXAudioServicesManager *)notifier;
        if (manager.completedBlock) {
            manager.completedBlock();
        }
        ZXSuppressPerformSelectorLeakWarning([manager performSelector:@selector(playVibrateWithCompletion:) withObject:manager.completedBlock afterDelay:1]);
    }
}


- (void)playSystemSoundWithAudioAndVibrate:(SystemSoundID)soundID withCompletion:(nullable void(^)(void))completion
{
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
        AudioServicesPlaySystemSound(soundID);
        [self playVibrateWithCompletion:completion];
#else
        AudioServicesPlaySystemSoundWithCompletion(soundID, nil);
        [self playVibrateWithCompletion:completion];
#endif
}

- (void)invalidate
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
    AudioServicesRemoveSystemSoundCompletion(self.systemSoundID);
#else
    AudioServicesDisposeSystemSoundID(self.systemSoundID);
#endif
}

#pragma mark -
#pragma mark - dealloc
- (void)dealloc{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
    AudioServicesRemoveSystemSoundCompletion(self.systemSoundID);
#else
    AudioServicesDisposeSystemSoundID(self.systemSoundID);
#endif
}
@end
