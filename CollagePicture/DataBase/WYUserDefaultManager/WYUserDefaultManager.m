//
//  WYUserDefaultManager.m
//  YiShangbao
//
//  Created by simon on 17/3/9.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYUserDefaultManager.h"

static NSString *WYTimes = @"WYTimes";
static NSString *WYToday = @"WYToday";

static NSString  *kbaseUrl = @"baseURL";
static NSString  *kh5URL = @"h5URL";
static NSString  *kWxAppId = @"kWxAppID";

//用户通知允许状态
static NSString *const ud_userNotificationType = @"ud_UserNotificationType";



NSString *const kNotificationUserChangeDomain = @"kNotificationUserChangeDomain";

@implementation WYUserDefaultManager



+ (void)setSavedAppLanchedDay
{
    NSDateFormatter *dateFor = [[NSDateFormatter alloc] init];
    dateFor.dateFormat =@"MM月-dd日";
    NSString *dateStr = [dateFor stringFromDate:[NSDate date]];
    [UserDefault setObject:dateStr forKey:WYToday];
    [UserDefault synchronize];

}

+ (NSString *)getSavedAppLanchedDay
{
    return [UserDefault objectForKey:WYToday];
}

+ (void)addTodayAppLanchAdvTimes
{
    NSDateFormatter *dateFor = [[NSDateFormatter alloc] init];
    dateFor.dateFormat =@"MM月-dd日";
    NSString *currentDateStr = [dateFor stringFromDate:[NSDate date]];
    NSString *beforStr = [self getSavedAppLanchedDay];
    if ([self getSavedAppLanchedDay].length>0)
    {
        if (![beforStr isEqualToString:currentDateStr])
        {
            [UserDefault removeObjectForKey:WYToday];
            [UserDefault setObject:@(1) forKey:WYTimes];
        }
        else
        {
           NSNumber *times = [self getTodayAppLanchAdvTimes];
           [UserDefault setObject:@([times integerValue]+1) forKey:WYTimes];
        }
    }
    else
    {
        [self setSavedAppLanchedDay];
        [UserDefault setObject:@(1) forKey:WYTimes];
    }

  
    [UserDefault synchronize];
}

+ (id)getTodayAppLanchAdvTimes
{
    
    return [UserDefault objectForKey:WYTimes];
}

+ (BOOL)isCanLanchAdvWithMaxTimes:(NSNumber *)maxTimes
{
    //0表示不限制次数
    if ([maxTimes integerValue]==0)
    {
        return YES;
    }
    NSNumber *times = [self getTodayAppLanchAdvTimes];
    if ([times compare:maxTimes] ==NSOrderedAscending)
    {
        return YES;
    }
    if ([times compare:maxTimes] ==NSOrderedSame)
    {
        return YES;
    }

    return NO;
}




+ (void)bsetSavedAppLanchedDay
{
    NSDateFormatter *dateFor = [[NSDateFormatter alloc] init];
    dateFor.dateFormat =@"MM月-dd日";
    NSString *dateStr = [dateFor stringFromDate:[NSDate date]];
    [UserDefault setObject:dateStr forKey:WYToday];
    [UserDefault synchronize];
    
}

+ (NSString *)bgetSavedAppLanchedDay
{
    return [UserDefault objectForKey:WYToday];
}

+ (void)baddTodayAppLanchAdvTimes
{
    NSDateFormatter *dateFor = [[NSDateFormatter alloc] init];
    dateFor.dateFormat =@"MM月-dd日";
    NSString *currentDateStr = [dateFor stringFromDate:[NSDate date]];
    NSString *beforStr = [self bgetSavedAppLanchedDay];
    if ([self bgetSavedAppLanchedDay].length>0)
    {
        if (![beforStr isEqualToString:currentDateStr])
        {
            [UserDefault removeObjectForKey:WYToday];
            [UserDefault setObject:@(1) forKey:WYTimes];
        }
        else
        {
            NSNumber *times = [self bgetTodayAppLanchAdvTimes];
            [UserDefault setObject:@([times integerValue]+1) forKey:WYTimes];
        }
    }
    else
    {
        [self bsetSavedAppLanchedDay];
        [UserDefault setObject:@(1) forKey:WYTimes];
    }
    
    
    [UserDefault synchronize];
}

+ (id)bgetTodayAppLanchAdvTimes
{
    
    return [UserDefault objectForKey:WYTimes];
}

+ (BOOL)bisCanLanchAdvWithMaxTimes:(NSNumber *)maxTimes
{
    //0表示不限制次数
    if ([maxTimes integerValue]==0)
    {
        return YES;
    }
    NSNumber *times = [self bgetTodayAppLanchAdvTimes];
    if ([times compare:maxTimes] ==NSOrderedAscending)
    {
        return YES;
    }
    if ([times compare:maxTimes] ==NSOrderedSame)
    {
        return YES;
    }
    
    return NO;
}


#pragma mark - 隔多少天允许执行一次
+ (BOOL)isCanPresentAlertWithIntervalDay:(NSInteger)interval
{
//    id object = [UserDefault objectForKey:@"LastPresentAlertDate"];
//    NSLog(@"%@",object);
    if ([UserDefault objectForKey:@"LastPresentAlertDate"])
    {
        NSDate *lastDate = [UserDefault objectForKey:@"LastPresentAlertDate"];
        NSDate *nowDate = [NSDate date];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        unsigned int unitFlags = NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitMinute;
        NSDateComponents *comps = [calendar components:unitFlags fromDate:lastDate toDate:nowDate options:0];
        if (comps.day >interval||comps.month>0)
        {
            [UserDefault setObject:[NSDate date] forKey:@"LastPresentAlertDate"];
            [UserDefault synchronize];
            return YES;
        }
        return NO;

    }
    else
    {
        [UserDefault setObject:[NSDate date] forKey:@"LastPresentAlertDate"];
        [UserDefault synchronize];
    }
    return YES;
}



#pragma mark - 设置用户推送通知的允许，不允许，还不知道三种状态；

+ (void)setMyAppUserNotificationOpenType:(UDAuthorizationStatus)type
{
    [UserDefault setInteger:type forKey:ud_userNotificationType];
    [UserDefault synchronize];
}

+ (NSInteger)getMyAppUserNotificationOpenType
{
    return [UserDefault integerForKey:ud_userNotificationType];
}

#pragma mark -

+ (void)setDidFinishLaunchRemoteNoti:(NSString *)url
{
    [UserDefault setObject:url forKey:@"remoteUrl"];
}

+ (NSString *)getDidFinishLaunchRemoteNoti
{
   return [UserDefault objectForKey:@"remoteUrl"];
}

+ (void)removeDidFinishLaunchRemoteNoti
{
    [UserDefault removeObjectForKey:@"remoteUrl"];
}

+ (BOOL)isOpenAppRemoteNoti
{
    NSString *noti = [self getDidFinishLaunchRemoteNoti];
    if ([NSString zhIsBlankString:noti])
    {
        return NO;
    }
    return YES;
}




+ (void)setkAPP_BaseURL:(NSString *)baseURL
{
    [UserDefault setObject:baseURL forKey:kbaseUrl];
}
+ (NSString *)getkAPP_BaseURL
{
    return [UserDefault objectForKey:kbaseUrl];
}

+ (void)setkAPP_H5URL:(NSString *)h5URL
{
    [UserDefault setObject:h5URL forKey:kh5URL];
}
+ (NSString *)getkAPP_H5URL
{
    return [UserDefault objectForKey:kh5URL];
}

+ (void)setkURL_WXAPPID:(NSString *)wxAppID
{
    [UserDefault setObject:wxAppID forKey:kWxAppId];
}

+ (NSString *)getkURL_WXAPPID
{
    return [UserDefault objectForKey:kWxAppId];
}


+ (void)setkCookieDomain:(NSString *)cookieDomain
{
    [UserDefault setObject:cookieDomain forKey:@"cookieDomain"];
}
+ (NSString *)getkCookieDomain
{
    return [UserDefault objectForKey:@"cookieDomain"];
}

+ (void)setOpenChangeDomain:(BOOL)isOpen
{
    [UserDefault setBool:isOpen forKey:@"changeDomain"];
}
+ (BOOL)getOpenChangeDomain
{
    return [UserDefault boolForKey:@"changeDomain"];
}


+ (NSString *)getTestKGtAppId
{
    return kTestGtAppId;
}
+ (NSString *)getOnlineKGtAppId
{
    return kOnlineGtAppId;
}


+ (NSString *)getTestkGtAppKey
{
    return kTestGtAppKey;
}
+ (NSString *)getOnlinekGtAppKey
{
    return kOnlineGtAppKey;
}


+ (NSString *)getTestkGtAppSecret
{
    return kTestGtAppSecret;
}
+ (NSString *)getOnlinekGtAppSecret
{
    return kOnlineGtAppSecret;
}

+ (NSString *)getTestNiMCerName
{
    return @"ycbTestPush";
}
+ (NSString *)getOnlineNiMCerName
{
    return @"ycbProdPush";
}
+ (void)setNimAccid:(NSString *)key
{
    [UserDefault setObject:key forKey:@"accid"];
    [UserDefault synchronize];


}
+ (NSString *)getNimAccid
{
    return [UserDefault objectForKey:@"accid"];
}

+ (void)setNimPWD:(NSString *)key
{
    [UserDefault setObject:key forKey:@"nimPwd"];
    [UserDefault synchronize];

}
+ (NSString *)getNimPWD
{
    return [UserDefault objectForKey:@"nimPwd"];
 
}


+ (void)setNiMMyInfoUrl:(NSString *)key
{
     [UserDefault setObject:key forKey:@"nimMyInfo"];
    [UserDefault synchronize];

}
+ (NSString *)getNiMMyInfoUrl
{
    return [UserDefault objectForKey:@"nimMyInfo"];
}

+ (void)setUserTargetRoleType:(NSInteger)key{
    [UserDefault setInteger:key forKey:@"TargetRoleType"];
    [UserDefault synchronize];
}
+ (WYTargetRoleType)getUserTargetRoleType{
   
    return [UserDefault integerForKey:@"TargetRoleType"];
}

+ (void)setChangeUserTargetRoleSource:(NSInteger)key
{
    [UserDefault setInteger:key forKey:@"TargetRoleSource"];
    [UserDefault synchronize];

 
}
+ (NSInteger)getChangeUserTargetRoleSource
{
    return [UserDefault integerForKey:@"TargetRoleSource"];
}



+ (void)setNewFunctionGuide_MainV1
{
    [UserDefault setBool:YES forKey:@"NewFunctionGuide_MainV1"];
    [UserDefault synchronize];
}

+ (BOOL)getNewNewFunctionGuide_MainV1
{
    return [UserDefault boolForKey:@"NewFunctionGuide_MainV1"];
}

+ (void)setNewFunctionGuide_MineV1
{
    [UserDefault setBool:YES forKey:@"NewFunctionGuide_MineV1"];
    [UserDefault synchronize];
}

+ (BOOL)getNewNewFunctionGuide_MineV1
{
    return [UserDefault boolForKey:@"NewFunctionGuide_MineV1"];
}


+ (void)setNewFunctionGuide_ExtendV1
{
    [UserDefault setBool:YES forKey:@"NewFunctionGuide_ExtendV1"];
    [UserDefault synchronize];
}

+ (BOOL)getNewNewFunctionGuide_ExtendV1
{
    return [UserDefault boolForKey:@"NewFunctionGuide_ExtendV1"];
}

@end
