//
//  ZXAudioServicesManager.h
//  DS
//
//  Created by simon on 2019/5/29.
//  Copyright © 2019 com.Microants. All rights reserved.
//
//  简介：SystemSoundService的优点：（1）能够立即播放（2）能够在同一时间播放多次音乐（3）可以加上振动效果;
//  SystemSoundService的缺点：（1）不能循环播放（2）不能控制播放时间（3）不能控制声道（4）不能控制音量（5）不能暂停音乐；
//  注意：（1）一般如果需要声音和震动同时存在的时候，又想在某个播放N次，由于无法统一在完成播放后回调，声音文件只播放已经录制好的一次，震动播放N次；
//           在有同时播放声音和震动的需求时，声音一般用AVPlayer播放，因为它可以控制音量；
//       （2）连续播放震动比较频繁和紧凑，最好有个延迟1s；
//       （3）AudioServicesPlayAlertSoundWithCompletion(soundID,nil); 同时具备声音和震动的警告声不能使用，只有效于Mac-OS


//  2019.06.14  优化代码，增加限制次数

#import <Foundation/Foundation.h>

@import AudioToolbox;

NS_ASSUME_NONNULL_BEGIN



@interface ZXAudioServicesManager : NSObject

@property (nonatomic, assign) NSInteger numberOfLoops;


+ (instancetype)sharedManager;


/**
 使用自定义的提示音(时间必须小于30秒. caf文件)

 @param name 本地资源名字
 @return 系统声音对象ID
 */
- (SystemSoundID)creatAudioCustomSoundWithResourceName:(NSString *)name;


#pragma mark - 三个直接调用的便利方法；

/**
 根据soundID，播放系统声音服务对象;

 @param soundID 系统声音对象ID；可以是调系统的提示音，soundID范围:1000to2000；也可以是自定义声音；
 */
+ (ZXAudioServicesManager *)playSystemSoundWithOnlyAudio:(SystemSoundID)soundID numberOfLoops:(NSInteger)num withCompletion:(nullable void(^)(void))completion;

/*
 根据指定声音文件播放声音服务对象;
 */
+ (ZXAudioServicesManager *)playSystemSoundWithCustomSoundResourceName:(NSString *)name numberOfLoops:(NSInteger)num withCompletion:(nullable void(^)(void))completion;

/**
 播放震动,
 */
+ (ZXAudioServicesManager *)playVibrateWithNumberOfLoops:(NSInteger)num completion:(nullable void(^)(void))completion;


/**
  同时播放声音和震动,声音只播放一次，震动N次； 基本不用这个方法；

 @param soundID 声音id
 @param num 震动的播放次数
 @param completion 完成回调
 */
- (void)playSystemSoundWithAudioAndVibrate:(SystemSoundID)soundID  vibrateNumberOfLoops:(NSInteger)num completion:(nullable void(^)(void))completion;

// 移除停止播放；
- (void)invalidate;

@end

NS_ASSUME_NONNULL_END




// 依次播放所有的系统声音，你可以来选择一个；
/*
- (void)playAudio
{
    __block UInt32 soundId = 1000;
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        
        while (soundId < 1050) {
            
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            [ZXAudioServicesManager playSystemSoundWithOnlyAudio:soundId numberOfLoops:1 withCompletion:^{
                NSLog(@"%@",@(soundId));
                soundId ++;
                dispatch_semaphore_signal(semaphore);
            }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
    });
}
*/
