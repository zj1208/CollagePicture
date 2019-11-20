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

//第一次使用翻译功能引导
static NSString * const isFirstUseTranslation = @"isFirstUseTranslation";

//接生意设置第一次小红点-点击消失
static NSString * const ud_TouchTradeSet = @"firstTouchTradeSet_3";
//第一次使用接生意功能引导
static NSString * const ud_NewFunctionGuide_Trade = @"ud_NewFunctionGuide_Trade_2";

//开单预览单据-点击关闭不再出现
static NSString * const ud_MakeBillPreview_Set = @"ud_MakeBillPreview_Set_1";
//开单预览单据-第一次使用打印功能引导
static NSString * const ud_MakeBillPreview_Printf = @"ud_MakeBillPreview_Printf_1";


extern NSString *const kNotificationUserChangeDomain;


typedef NS_ENUM(NSInteger, WYTargetRoleType)
{
    WYTargetRoleType_seller = 4,//卖家
    WYTargetRoleType_buyer = 2//买家
};


typedef NS_ENUM(NSInteger, UDAuthorizationStatus) {
    
    // 这个应用有权限发送用户通知；
    UDAuthorizationStatusAuthorized =0,
    
    // 这个应用没有权限发送用户通知；
    UDAuthorizationStatusDenied =1,
        
    // 还不知道是否允许用户推送通知，因为可能是异步获取，但及时要用；
    UDAuthorizationStatusNotDetermined = 2,

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



#pragma mark -采购商首页再次判断一天弹三次的广告
//添加一次今天的弹框次数；会判断本地已经保存的是否是同一天，如果不是则清理之前的重新存储；
+ (void)baddTodayAppLanchAdvTimes;

/**
 判断每天弹框最大次数，如果一天弹框次数已经到maxTimes，则返回NO；
 
 @param maxTimes 每天最大弹框次数
 @return YES／NO
 */
+ (BOOL)bisCanLanchAdvWithMaxTimes:(NSNumber *)maxTimes;

//判断广告是否达到当天最大展现次数
+ (BOOL)isShowAdvWithMaxTimes:(NSNumber *)maxTimes advId:(NSNumber *)advId;

#pragma mark - 隔多少天允许执行一次
+ (BOOL)isCanPresentAlertWithIntervalDay:(NSInteger)interval;



#pragma mark - 设置用户推送通知的允许，不允许，还不知道三种状态；
//0允许，1不允许；2还没有获取回来不知道；

+ (void)setMyAppUserNotificationOpenType:(UDAuthorizationStatus)type;

+ (NSInteger)getMyAppUserNotificationOpenType;

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
//4卖家，2买家
+ (WYTargetRoleType)getUserTargetRoleType;

// 切换角色来源
+ (void)setChangeUserTargetRoleSource:(NSInteger)key;
+ (NSInteger)getChangeUserTargetRoleSource;


//商户端-商铺-新功能引导
+ (void)setNewFunctionGuide_ShopHomeV1;
+ (BOOL)getNewNewFunctionGuide_ShopHomeV1;

// 商户端-接生意-新功能引导
+ (void)setNewFunctionGuide_Trade;
+ (BOOL)getNewFunctionGuide_Trade;

// 商户端-引导点击接生意设置
+ (void)setTouchTradeSet;
+ (BOOL)getTouchTradeSet;

// 商户端-我的-新功能引导
+ (void)setNewFunctionGuide_MineV1;
+ (BOOL)getNewNewFunctionGuide_MineV1;


// 商户端-上传产品-引导上传产品图片
+ (void)setNewFunctionGuide_AddProPicV1;
+ (BOOL)getNewFunctionGuide_AddProPicV1;

//设置卖家开屏图地址
+ (void)setOpenAPPSellerAdvURL:(NSString *)url;
+ (NSString *)getOpenAPPSellerAdvURL;
+ (void)removeOpenAPPSellerAdvURL;

//设置买家开屏图地址
+ (void)setOpenAPPPurchaserAdvURL:(NSString *)url;
+ (NSString *)getOpenAPPPurchaserAdvURL;
+ (void)removeOpenAPPPurchaserAdvURL;

// 商户端-开单预览点击关闭不再出现
+ (void)setMakeBillPreviewSet;
+ (BOOL)getMakeBilglPreviewSet;
// 商户端-开单预览第一次使用打印功能引导
+ (void)setMakeBillPreviewPrintf;
+ (BOOL)getMakeBilglPreviewPrintf;
@end



#pragma mark - 一天最多弹几次
/*
- (void)launchHomeAdvViewOrUNNotificationAlert
{
    self.modalAnimation = [[ZXModalAnimatedTranstion alloc] init];
    [[[AppAPIHelper shareInstance] getMessageAPI] GetAdvWithType:@1005 success:^(id data) {
        
        AdvModel *model = (AdvModel *)data;
        if (model.advArr.count>0)
        {
            [WYUserDefaultManager addTodayAppLanchAdvTimes];
            if ([WYUserDefaultManager isCanLanchAdvWithMaxTimes:@(model.num)])
            {
                advArrModel *advItemModel = [model.advArr firstObject];
                [self launchHomeAdvView:advItemModel];
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

