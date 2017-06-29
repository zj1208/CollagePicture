//
//  ZXLocalNotification.m
//  CollagePicture
//
//  Created by 朱新明 on 16/11/16.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "ZXLocalNotification.h"

@implementation ZXLocalNotification

+ (UILocalNotification *)setLocalNotification:(NSDate *)fireDate alertBody:(NSString *)alertBody badge:(int)badge alertAction:(NSString *)alertAction identifierKey:(NSString *)notificationKey userInfo:(NSDictionary *)userInfo soundName:(NSString *)soundName
{
    //如果你之前已经向系统添加过一个本地通知，会缓存在系统中，即使删除app也保留着；在你设置新的本地通知时，你要把之前的通知都取消掉，或者取消那些不需要的通知；也如果不重复，也可以在刚进入前台的时候取消本地通知
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    //定时周期性安排-presentLocalNotificationNow:无效
    localNotification.fireDate = fireDate;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    //／设置重复推送或触发 间隔，日历单元（可以 不重复－0，每周，每日，每分钟等）一般不重复，重复的话计算applicationIconBadgeNumber比较复杂；所以这个功能必须设置不重复，不然无法实现；
    localNotification.repeatInterval = 0;
    //通知内容设置
    localNotification.soundName =soundName?soundName:  UILocalNotificationDefaultSoundName;
    localNotification.alertBody = alertBody;
    NSInteger bageNum = [UIApplication sharedApplication].applicationIconBadgeNumber;
    if (bageNum > 0) {
        localNotification.applicationIconBadgeNumber = bageNum + 1 ;
        
    }else{
        localNotification.applicationIconBadgeNumber += 1 ;
    }
    localNotification.alertAction=NSLocalizedString(alertAction, nil);
    //通知的标识
    localNotification.category = notificationKey;
    localNotification.userInfo = userInfo;
        
    //把本地通知添加到iOS系统，且立即触发通知,它只会触发代理方法或推送一次，不会保留在iOS系统;UILocalNotifications的scheduled设置对它无效；
    //[[UIApplication sharedApplication]presentLocalNotificationNow:localNotification];
    
    //获取本地周期性推送通知的数组,只会获取 添加到iOS系统的周期性通知：scheduleLocalNotification，用presentLocalNotificationNow添加到iOS系统的通知不会保留，获取不到；所以添加过的但没有取消过的本地周期性通知都缓存在iOS系统中，都能获取到；
    NSLog(@"%@",[[UIApplication sharedApplication]scheduledLocalNotifications]);
    
    return localNotification;
}
@end
