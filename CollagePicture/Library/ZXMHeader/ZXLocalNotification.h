//
//  ZXLocalNotification.h
//  CollagePicture
//
//  Created by 朱新明 on 16/11/16.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXLocalNotification : NSObject


/*! __attribute__((deprecated("已过期")))
 * @abstract 本地推送，最多支持64个
 *
 * @param fireDate 本地推送触发的时间 [NSDate dateWithTimeIntervalSinceNow:10]
 * @param alertBody 本地推送需要显示的内容
 * @param badge 角标的数字。如果不需要改变角标传-1
 * @param alertAction 弹框的按钮显示的内容（IOS 8默认为"打开", 其他默认为"启动"）
 * @param notificationKey 本地推送标示符
 * @param userInfo 自定义参数，可以用来标识推送和增加附加信息
 * @param soundName 自定义通知声音:导入文件@"sound.caf"，设置为nil为默认声音
 *
 * @discussion 最多支持 64 个定义，此方法被[addNotification:]方法取代
 */
+ (UILocalNotification *)setLocalNotification:(NSDate *)fireDate
                                    alertBody:(NSString *)alertBody
                                        badge:(int)badge
                                  alertAction:(NSString *)alertAction
                                identifierKey:(NSString *)notificationKey
                                     userInfo:(NSDictionary *)userInfo
                                    soundName:(NSString *)soundName ;


@end


/*
 
 //把本地通知添加到iOS系统，根据周期拷贝通知执行；而且缓存在iOS系统，可以触发无数次，除非取消；计划执行某个本地推送-在计划规定的日期触发通知，这个可以根据UILocalNotification设置的推送周期来推送；
 [[UIApplication sharedApplication]scheduleLocalNotification:localNotification];

 - (void)presentLocalNotification
 {
 
    UILocalNotification *localNotification = [ZXLocalNotification setLocalNotification:[NSDate dateWithTimeIntervalSinceNow:5] alertBody:@"你的朋友在招呼你" badge:0 alertAction:nil identifierKey:@"ACTIONABLE" userInfo:nil soundName:nil];
    [[UIApplication sharedApplication]scheduleLocalNotification:localNotification];
 }

 */
