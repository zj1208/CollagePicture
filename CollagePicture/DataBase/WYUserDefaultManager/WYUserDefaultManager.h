//
//  WYUserDefaultManager.h
//  YiShangbao
//
//  Created by simon on 17/3/9.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoUDManager.h"

static NSString *kTestGtAppId  =@"j74eHeJgVe9AXSQNJ0upTA";
static NSString *kTestGtAppKey = @"L6SNGaRRQ37zQbdq88nmo5";
static NSString *kTestGtAppSecret = @"icUSGInym69NcKxSjm7DW";

static NSString *kOnlineGtAppId  =@"nI9gJsDGb99qGnwylak4I1";
static NSString *kOnlineGtAppKey = @"8lEwqfov90AKQziEqSvd31";
static NSString *kOnlineGtAppSecret = @"zR9M7HHU3X6k64XZiJ7sh6";



extern NSString *const kNotificationUserChangeDomain;

typedef NS_ENUM(NSInteger, WYTargetRoleType)
{
    WYTargetRoleType_seller = 4,//卖家
    WYTargetRoleType_buyer = 2//买家
};



@interface WYUserDefaultManager : NSObject


#pragma mark - 一天只允许最多弹N（maxTimes）次数广告；
//首页弹框次数 有关；


//添加一次今天的弹框次数；会判断本地已经保存的是否是同一天，如果不是则清理之前的重新存储；
+ (void)addTodayAppLanchAdvTimes;


+ (NSNumber *)getTodayAppLanchAdvTimes;

/**
 判断每天弹框最大次数，如果一天弹框次数已经到maxTimes，则返回NO；
 
 @param maxTimes 每天最大弹框次数
 @return YES／NO
 */
+ (BOOL)isCanLanchAdvWithMaxTimes:(NSNumber *)maxTimes;




//添加一次今天的弹框次数；会判断本地已经保存的是否是同一天，如果不是则清理之前的重新存储；
+ (void)baddTodayAppLanchAdvTimes;

/**
 判断每天弹框最大次数，如果一天弹框次数已经到maxTimes，则返回NO；
 
 @param maxTimes 每天最大弹框次数
 @return YES／NO
 */
+ (BOOL)bisCanLanchAdvWithMaxTimes:(NSNumber *)maxTimes;


#pragma mark - 收到通知再启动app的通知处理
//远程推送，点击通知再开机启动时候的 url传值；

+ (void)setDidFinishLaunchRemoteNoti:(NSString *)url;

+ (NSString *)getDidFinishLaunchRemoteNoti;

+ (void)removeDidFinishLaunchRemoteNoti;

+ (BOOL)isOpenAppRemoteNoti;


#pragma mark - 切换域名环境

//切换域名环境
+ (void)setkAPP_BaseURL:(NSString *)baseURL;
+ (NSString *)getkAPP_BaseURL;

+ (void)setkAPP_H5URL:(NSString *)h5URL;
+ (NSString *)getkAPP_H5URL;

+ (void)setkURL_WXAPPID:(NSString *)wxAppID;
+ (NSString *)getkURL_WXAPPID;

+ (void)setkCookieDomain:(NSString *)cookieDomain;
+ (NSString *)getkCookieDomain;

+ (void)setOpenChangeDomain:(BOOL)isOpen;
+ (BOOL)getOpenChangeDomain;

//个推有关的账号配置
+ (NSString *)getTestKGtAppId;
+ (NSString *)getOnlineKGtAppId;

+ (NSString *)getTestkGtAppKey;
+ (NSString *)getOnlinekGtAppKey;


+ (NSString *)getTestkGtAppSecret;
+ (NSString *)getOnlinekGtAppSecre;

//云信有关－

+ (NSString *)getTestNiMCerName;
+ (NSString *)getOnlineNiMCerName;

+ (void)setNimAccid:(NSString *)key;
+ (NSString *)getNimAccid;

+ (void)setNimPWD:(NSString *)key;
+ (NSString *)getNimPWD;

+ (void)setNiMMyInfoUrl:(NSString *)key;
+ (NSString *)getNiMMyInfoUrl;


//用户当前角色

+ (void)setUserTargetRoleType:(NSInteger)key;
+ (WYTargetRoleType)getUserTargetRoleType;

// 切换角色来源
+ (void)setChangeUserTargetRoleSource:(NSInteger)key;
+ (NSInteger)getChangeUserTargetRoleSource;



+ (void)setNewFunctionGuide_MainV1;
+ (BOOL)getNewNewFunctionGuide_MainV1;

+ (void)setNewFunctionGuide_MineV1;
+ (BOOL)getNewNewFunctionGuide_MineV1;
@end



#pragma mark - 一天最多弹几次
/*
- (void)lauchPopoverView
{
    self.modalAnimation = [[ZXModalAnimation alloc] init];
    [[[AppAPIHelper shareInstance] getMessageAPI] GetAdvWithType:@1005 success:^(id data) {
        
        AdvModel *model = (AdvModel *)data;
        if (model.advArr.count>0)
        {
            [WYUserDefaultManager addTodayAppLanchAdvTimes];
            if ([WYUserDefaultManager isCanLanchAdvWithMaxTimes:@(model.num)])
            {
                advArrModel *advItemModel = [model.advArr firstObject];
                [self firstNewFunction:advItemModel];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

*/


#pragma mark - 设置域名环境

//切换域名,注意要在didLaunch最先设定；
/*
- (void)setDomainManager
{
    [WYUserDefaultManager setOpenChangeDomain:YES];
    
    if (![WYUserDefaultManager getOpenChangeDomain] ||[WYUserDefaultManager getkAPP_BaseURL].length==0)
    {
        [WYUserDefaultManager  setkAPP_BaseURL:@"https://api.m.microants.cn"];
        [WYUserDefaultManager setkAPP_H5URL:@"https://wykj.microants.cn"];
        [WYUserDefaultManager setkURL_WXAPPID:@"wxc8edd69b7a7950ee"];
 
    }
}
*/


#pragma mark - 有广告或有中间页面才转为tabBarController处理开机app的通知

/*
- (void)takeLaunchRemoteNoti:(NSDictionary *)launchOptions
{
    //获取 APNs（通知） 推送内容（app未启动时接受推送消息）
    //apn 内容获取
    NSDictionary *remoteDic = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteDic)
    {
        NSString *url = nil;
        if ([remoteDic objectForKey:@"payload"])
        {
            NSString *payloadStr = [remoteDic objectForKey:@"payload"];
            NSDictionary *payload = [NSString zhGetJSONSerializationObjectFormString:payloadStr];
            url = [payload objectForKey:@"url"];
        }
        else
        {
            url = [remoteDic objectForKey:@"url"];
        }
        [WYUserDefaultManager setDidFinishLaunchRemoteNoti:url];
    }
}
*/

//设置推送或开屏路由跳转后 才 处理检查版本更新；
/*
- (void)viewDidAppear:(BOOL)animated
{
    if ([WYUserDefaultManager isOpenAppRemoteNoti])
    {
        BOOL pushed = [[WYUtility dataUtil]cheackAdvURLToControllerWithSoureController:self.navigationController advUrlString:[WYUserDefaultManager getDidFinishLaunchRemoteNoti]];
        if (!pushed)
        {
            [self checkAppVersion];
        }
    }
    else{
        
        [self checkAppVersion];
    }
    
    [super viewDidAppear:animated];
}
 
 */
