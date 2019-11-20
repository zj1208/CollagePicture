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

//开屏广告图地址；
static NSString *const ud_OpenAPPSellerAdvURL = @"ud_OpenAPPSellerAdvURL";
static NSString *const ud_OpenAPPPurchaserAdvURL = @"ud_OpenAPPPurchaserAdvURL";

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

//本地保存广告展示次数判断
+ (BOOL)isShowAdvWithMaxTimes:(NSNumber *)maxTimes advId:(NSNumber *)advId{
    if ([maxTimes integerValue]==0){
        return YES;
    }
    NSString *advIdString = [NSString stringWithFormat:@"ADV%@",advId];
    //今天日期
    NSDateFormatter *dateFor = [[NSDateFormatter alloc] init];
    dateFor.dateFormat =@"MM-dd";
    NSString *dateStr = [dateFor stringFromDate:[NSDate date]];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[UserDefault objectForKey:advIdString]];
    //判断有没有想要数据
    if (dic.allKeys.count != 2){
        [dic setValue:@(0) forKey:@"count"];
        [dic setValue:dateStr forKey:@"time"];
    }
    NSString *time = [dic objectForKey:@"time"];
    //判断是不是同一个日期
    if (![time isEqualToString:dateStr]){
        [dic setValue:@(0) forKey:@"count"];
        [dic setValue:dateStr forKey:@"time"];
    }
    NSNumber *count = [dic objectForKey:@"count"];
    //判断有没有超过次数
    if (count.integerValue < maxTimes.integerValue){
        [dic setValue:@(count.integerValue + 1) forKey:@"count"];
        [UserDefault setObject:dic forKey:advIdString];
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
//        if (comps.day >interval||comps.month>0 ||comps.minute>=0)
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


#pragma mark - 功能引导
+ (void)setNewFunctionGuide_Trade
{
    [UserDefault setBool:YES forKey:ud_NewFunctionGuide_Trade];
    [UserDefault synchronize];
}
+ (BOOL)getNewFunctionGuide_Trade
{
    return [UserDefault boolForKey:ud_NewFunctionGuide_Trade];
}

+(void)setTouchTradeSet
{
    [UserDefault setBool:YES forKey:ud_TouchTradeSet];
    [UserDefault synchronize];
}
+ (BOOL)getTouchTradeSet
{
    return [UserDefault boolForKey:ud_TouchTradeSet];
}

+ (void)setNewFunctionGuide_ShopHomeV1
{
    [UserDefault setBool:YES forKey:@"ud_NewFunctionGuide_ShopHome_V1"];
    [UserDefault synchronize];
}

+ (BOOL)getNewNewFunctionGuide_ShopHomeV1
{
    return [UserDefault boolForKey:@"ud_NewFunctionGuide_ShopHome_V1"];
}

+ (void)setNewFunctionGuide_MineV1
{
    [UserDefault setBool:YES forKey:@"ud_NewFunctionGuide_Mine_V1"];
    [UserDefault synchronize];
}

+ (BOOL)getNewNewFunctionGuide_MineV1
{
    return [UserDefault boolForKey:@"ud_NewFunctionGuide_Mine_V1"];
}

// 商户端-上传产品-引导上传产品图片
+ (void)setNewFunctionGuide_AddProPicV1
{
    [UserDefault setBool:YES forKey:@"ud_NewFunctionGuide_AddProPic_V1"];
    [UserDefault synchronize];
}
+ (BOOL)getNewFunctionGuide_AddProPicV1
{
    return [UserDefault boolForKey:@"ud_NewFunctionGuide_AddProPic_V1"];
}



//设置卖家开屏图地址
+ (void)setOpenAPPSellerAdvURL:(NSString *)url
{
    [UserDefault setObject:url forKey:ud_OpenAPPSellerAdvURL];
    [UserDefault synchronize];
}

+ (NSString *)getOpenAPPSellerAdvURL
{
    return [UserDefault objectForKey:ud_OpenAPPSellerAdvURL];
}

+ (void)removeOpenAPPSellerAdvURL
{
    [UserDefault removeObjectForKey:ud_OpenAPPSellerAdvURL];
}

//设置买家开屏图地址
+ (void)setOpenAPPPurchaserAdvURL:(NSString *)url
{
    [UserDefault setObject:url forKey:ud_OpenAPPPurchaserAdvURL];
    [UserDefault synchronize];
}

+ (NSString *)getOpenAPPPurchaserAdvURL
{
    return [UserDefault objectForKey:ud_OpenAPPPurchaserAdvURL];
}

+ (void)removeOpenAPPPurchaserAdvURL
{
    [UserDefault removeObjectForKey:ud_OpenAPPPurchaserAdvURL];
}

+ (void)setMakeBillPreviewSet
{
    [UserDefault setBool:YES forKey:ud_MakeBillPreview_Set];
    [UserDefault synchronize];
}
+ (BOOL)getMakeBilglPreviewSet
{
    return [UserDefault boolForKey:ud_MakeBillPreview_Set];
}
+ (void)setMakeBillPreviewPrintf;
{
    [UserDefault setBool:YES forKey:ud_MakeBillPreview_Printf];
    [UserDefault synchronize];
}
+ (BOOL)getMakeBilglPreviewPrintf
{
    return [UserDefault boolForKey:ud_MakeBillPreview_Printf];
}
@end

