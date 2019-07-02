//
//  ZXPushKitAVNotification.h
//  DS
//
//  Created by simon on 2019/6/13.
//  Copyright © 2019 ds. All rights reserved.
//
//  简介：主要用于在PushKit激活在后台，因为收到PushKit的通知后会立即唤醒app，
//  由于没有弹窗（alert提醒，图标badge标记，播放声音），在进入回调的时候 可以利用这个类来自己发送本地通知+播放声音及震动 来达到提醒效果；

/*
 1.PushKit优点
 （1）该设备只有在收到PushKit通知时才会唤醒，这可以延长电池寿命。因为原理上一旦进入后台，有10分钟可以借用，需要与voip服务器长链接保持才行，比较耗电；但是使用PushKit后，app不需要在后台与voip服务器长链接保持；在收到呼叫或者发起呼叫时再连接即可;
 附：但是APNS服务器/Voip服务器与iPhone设备永远是基于长链接的，因为需要传送到指定设备上；
 socket长连接：连接->传输数据->保持连接->传输数据->....->关闭连接
 
 2.PushKit 与 APNS的比较优点
 （1）最大区别：收到PushKit通知后，如果app应用程序没有运行，系统会自动启动它。相比之下，用户通知不能启动你的app应用。
 附：APNS即使收到push通知也需要用户去点击push条进入App才能唤醒app；
 
 （2）当收到PushKit通知时，系统会给你的app应用程序一些执行时间(可能是在后台)处理其他业务。
 附：收到PushKit的通知后会立即唤醒app，接通消息的socet长链接，在消息回调里可以自定义处理业务，比如展示通话页面；由于没有弹窗（alert提醒，图标badge标记，播放声音），也可以自己发送本地通知+播放声音及震动 来达到提醒效果；
 
 （3）PushKit通知可以包含比userNotifications更多的数据。 APNS的push消息有最大限制，最大4KB；
 
 
 3.与用户通知相比，有以下缺点：
 PushKit通知不回呈现给用户，不会显示alert提醒、标记应用程序的图标badge或播放声音。除非自己发送本地通知+播放声音及震动 来达到提醒效果；
 
 */


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXPushKitAVNotification : NSObject

// 震动次数,默认15
@property (nonatomic, assign) NSInteger vibrateCount;

// 通知声音名
@property (nonatomic, copy) NSString *soundName;


/**
 呼出本地通知，播放连续震动；如果再次调用会清除之前的本地通知，震动次数重新计算；

 @param text 本地通知需要展示的文本；
 */
- (void)start:(NSString *)text;

- (void)stop;

@end

NS_ASSUME_NONNULL_END
