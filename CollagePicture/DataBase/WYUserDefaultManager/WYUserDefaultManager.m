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
    [[NSUserDefaults standardUserDefaults] setObject:dateStr forKey:WYToday];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

+ (NSString *)getSavedAppLanchedDay
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:WYToday];
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
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:WYToday];
            [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:WYTimes];
        }
        else
        {
           NSNumber *times = [self getTodayAppLanchAdvTimes];
           [[NSUserDefaults standardUserDefaults] setObject:@([times integerValue]+1) forKey:WYTimes];
        }
    }
    else
    {
        [self setSavedAppLanchedDay];
        [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:WYTimes];
    }

  
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)getTodayAppLanchAdvTimes
{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:WYTimes];
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
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:advIdString]];
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
        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:advIdString];
        return YES;
    }

    return NO;
}



+ (void)bsetSavedAppLanchedDay
{
    NSDateFormatter *dateFor = [[NSDateFormatter alloc] init];
    dateFor.dateFormat =@"MM月-dd日";
    NSString *dateStr = [dateFor stringFromDate:[NSDate date]];
    [[NSUserDefaults standardUserDefaults] setObject:dateStr forKey:WYToday];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+ (NSString *)bgetSavedAppLanchedDay
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:WYToday];
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
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:WYToday];
            [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:WYTimes];
        }
        else
        {
            NSNumber *times = [self bgetTodayAppLanchAdvTimes];
            [[NSUserDefaults standardUserDefaults] setObject:@([times integerValue]+1) forKey:WYTimes];
        }
    }
    else
    {
        [self bsetSavedAppLanchedDay];
        [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:WYTimes];
    }
    
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)bgetTodayAppLanchAdvTimes
{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:WYTimes];
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
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"LastPresentAlertDate"])
    {
        NSDate *lastDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"LastPresentAlertDate"];
        NSDate *nowDate = [NSDate date];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        unsigned int unitFlags = NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitMinute;
        NSDateComponents *comps = [calendar components:unitFlags fromDate:lastDate toDate:nowDate options:0];
        if (comps.day >interval||comps.month>0)
//        if (comps.day >interval||comps.month>0 ||comps.minute>=0)
        {
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"LastPresentAlertDate"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            return YES;
        }
        return NO;

    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"LastPresentAlertDate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return YES;
}



#pragma mark - 设置用户推送通知的允许，不允许，还不知道三种状态；

+ (void)setMyAppUserNotificationOpenType:(UDAuthorizationStatus)type
{
    [[NSUserDefaults standardUserDefaults] setInteger:type forKey:ud_userNotificationType];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)getMyAppUserNotificationOpenType
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:ud_userNotificationType];
}

#pragma mark -

+ (void)setDidFinishLaunchRemoteNoti:(NSString *)url
{
    [[NSUserDefaults standardUserDefaults] setObject:url forKey:@"remoteUrl"];
}

+ (NSString *)getDidFinishLaunchRemoteNoti
{
   return [[NSUserDefaults standardUserDefaults] objectForKey:@"remoteUrl"];
}

+ (void)removeDidFinishLaunchRemoteNoti
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"remoteUrl"];
}

+ (BOOL)isOpenAppRemoteNoti
{
    NSString *noti = [self getDidFinishLaunchRemoteNoti];
    if ([NSString zx_isBlankString:noti])
    {
        return NO;
    }
    return YES;
}




+ (void)setkAPP_BaseURL:(NSString *)baseURL
{
    [[NSUserDefaults standardUserDefaults] setObject:baseURL forKey:kbaseUrl];
}
+ (NSString *)getkAPP_BaseURL
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kbaseUrl];
}

+ (void)setkAPP_H5URL:(NSString *)h5URL
{
    [[NSUserDefaults standardUserDefaults] setObject:h5URL forKey:kh5URL];
}
+ (NSString *)getkAPP_H5URL
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kh5URL];
}

+ (void)setkURL_WXAPPID:(NSString *)wxAppID
{
    [[NSUserDefaults standardUserDefaults] setObject:wxAppID forKey:kWxAppId];
}

+ (NSString *)getkURL_WXAPPID
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kWxAppId];
}


+ (void)setkCookieDomain:(NSString *)cookieDomain
{
    [[NSUserDefaults standardUserDefaults] setObject:cookieDomain forKey:@"cookieDomain"];
}
+ (NSString *)getkCookieDomain
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"cookieDomain"];
}

+ (void)setOpenChangeDomain:(BOOL)isOpen
{
    [[NSUserDefaults standardUserDefaults] setBool:isOpen forKey:@"changeDomain"];
}
+ (BOOL)getOpenChangeDomain
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"changeDomain"];
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
    [[NSUserDefaults standardUserDefaults] setObject:key forKey:@"accid"];
    [[NSUserDefaults standardUserDefaults] synchronize];


}
+ (NSString *)getNimAccid
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"accid"];
}

+ (void)setNimPWD:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:key forKey:@"nimPwd"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
+ (NSString *)getNimPWD
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"nimPwd"];
 
}


+ (void)setNiMMyInfoUrl:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:key forKey:@"nimMyInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getNiMMyInfoUrl
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"nimMyInfo"];
}

+ (void)setUserTargetRoleType:(NSInteger)key{
    [[NSUserDefaults standardUserDefaults] setInteger:key forKey:@"TargetRoleType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (WYTargetRoleType)getUserTargetRoleType{
   
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"TargetRoleType"];
}

+ (void)setChangeUserTargetRoleSource:(NSInteger)key
{
    [[NSUserDefaults standardUserDefaults] setInteger:key forKey:@"TargetRoleSource"];
    [[NSUserDefaults standardUserDefaults] synchronize];

 
}
+ (NSInteger)getChangeUserTargetRoleSource
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"TargetRoleSource"];
}


#pragma mark - 功能引导
+ (void)setNewFunctionGuide_Trade
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ud_NewFunctionGuide_Trade];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)getNewFunctionGuide_Trade
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:ud_NewFunctionGuide_Trade];
}

+(void)setTouchTradeSet
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ud_TouchTradeSet];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)getTouchTradeSet
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:ud_TouchTradeSet];
}

+ (void)setNewFunctionGuide_ShopHomeV1
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ud_NewFunctionGuide_ShopHome_V1"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)getNewNewFunctionGuide_ShopHomeV1
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"ud_NewFunctionGuide_ShopHome_V1"];
}

+ (void)setNewFunctionGuide_MineV1
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ud_NewFunctionGuide_Mine_V1"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)getNewNewFunctionGuide_MineV1
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"ud_NewFunctionGuide_Mine_V1"];
}

// 商户端-上传产品-引导上传产品图片
+ (void)setNewFunctionGuide_AddProPicV1
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ud_NewFunctionGuide_AddProPic_V1"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)getNewFunctionGuide_AddProPicV1
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"ud_NewFunctionGuide_AddProPic_V1"];
}



//设置卖家开屏图地址
+ (void)setOpenAPPSellerAdvURL:(NSString *)url
{
    [[NSUserDefaults standardUserDefaults] setObject:url forKey:ud_OpenAPPSellerAdvURL];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getOpenAPPSellerAdvURL
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:ud_OpenAPPSellerAdvURL];
}

+ (void)removeOpenAPPSellerAdvURL
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:ud_OpenAPPSellerAdvURL];
}

//设置买家开屏图地址
+ (void)setOpenAPPPurchaserAdvURL:(NSString *)url
{
    [[NSUserDefaults standardUserDefaults] setObject:url forKey:ud_OpenAPPPurchaserAdvURL];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getOpenAPPPurchaserAdvURL
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:ud_OpenAPPPurchaserAdvURL];
}

+ (void)removeOpenAPPPurchaserAdvURL
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:ud_OpenAPPPurchaserAdvURL];
}

+ (void)setMakeBillPreviewSet
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ud_MakeBillPreview_Set];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)getMakeBilglPreviewSet
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:ud_MakeBillPreview_Set];
}
+ (void)setMakeBillPreviewPrintf;
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ud_MakeBillPreview_Printf];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)getMakeBilglPreviewPrintf
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:ud_MakeBillPreview_Printf];
}
@end

