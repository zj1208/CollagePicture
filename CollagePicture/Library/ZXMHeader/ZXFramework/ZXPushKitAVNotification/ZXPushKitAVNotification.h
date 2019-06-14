//
//  ZXPushKitAVNotification.h
//  DS
//
//  Created by simon on 2019/6/13.
//  Copyright © 2019 ds. All rights reserved.
//
//  简介：主要用于在PushKit激活在后台，因为收到PushKit的通知后会立即唤醒app，
//  由于没有弹窗（alert提醒，图标badge标记，播放声音），在进入回调的时候 可以利用这个类来自己发送本地通知+播放声音及震动 来达到提醒效果；

// PushKit 与 APNS的比较优点
/*
//（1）该设备只有在收到PushKit通知时才会唤醒链接，这可以延长电池寿命。即应用的voip长连接是不保持的，在收到呼叫或者发起呼叫时再连接; 附：APNS是基于长链接的数据通道，比较耗电；
  （2）收到PushKit通知后，可以随时唤醒App，如果应用程序没有运行，系统会自动启动它。相比之下，用户通知不一定能启动你的应用。
      附：APNS即使收到push通知也需要用户去点击push条才能唤醒app；
  （3）系统会给你的应用程序执行时间(可能是在后台)来处理PushKit通知。
      附：收到PushKit的通知后会立即唤醒app，在进入回调的时候 可以自定义处理业务，比如展示通话页面；由于没有弹窗（alert提醒，图标badge标记，播放声音），也可以自己发送本地通知+播放声音及震动 来达到提醒效果；
  （4）PushKit通知可以包含比userNotifications更多的数据。 APNS的push消息有最大限制，最大4KB；
*/


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXPushKitAVNotification : NSObject

// 震动次数,默认15
@property (nonatomic, assign) NSInteger vibrateCount;

/**
 呼出本地通知，播放连续震动；如果再次调用会清除之前的本地通知，震动次数重新计算；
 
 @param text 本地通知需要展示的文本；
 */
- (void)start:(NSString *)text;

- (void)stop;
@end

NS_ASSUME_NONNULL_END
