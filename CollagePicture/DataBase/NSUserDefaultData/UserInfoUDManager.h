//
//  UserInfoUDManager.h
//  ICBC
//
//  Created by 朱新明 on.
//  Copyright (c) 2015年 朱新明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "TMCache.h"

FOUNDATION_EXPORT NSString *const kNotificationUserLoginIn;
FOUNDATION_EXPORT NSString *const kNotificationUserLoginOut;
FOUNDATION_EXPORT NSString *const kNotificationUpdateUserInfo;
FOUNDATION_EXPORT NSString *const kNotificationUserTokenError;


//用户有关的相对应数据
#define UserDefault  [NSUserDefaults standardUserDefaults]



#define ISLOGIN         [UserInfoUDManager isLogin]
#define USER_TOKEN      [UserInfoUDManager getToken]
#define USER_ID         [UserInfoUDManager getUserId]
#define USER_NICKNAME   [UserInfoUDManager getNickname]




@interface UserInfoUDManager : NSObject


+ (bool)isLogin;

+ (void)setUserId:(NSString *)uid;
+ (NSString *)getUserId;



/**
 *  传输层加密用的appKey
 *
 *  @param appKey 服务器取得
 */
+ (void)setAppKey:(NSString *)appKey;

+(NSString *)getAppKey;



+ (void)setToken:(NSString *)token;

+(NSString *)getToken;


+ (void)cleanCookies;
/******************************************************************************/

/**
 * 用NSUserDefault的时候,此app没有使用这方法;
 **/

+ (void)setUserAllData:(id)model;
+ (void)removeUserAllData:(id)model;


/******************************************************************************/
/**
 *  利用TMCache保存自定义对象,不仅仅是集合类;
 */
+ (void)setUserData:(id)object;

+ (void)removeData;
/**
 *  从本地获取用户信息model
 */
+ (id)getUserData;


/**
 *  修改用户信息，根据key设置model里的其中一个值；
 */
+ (void)setPropertyImplementationValue:(id)value forKey:(NSString *)key;

/**
 *  从本地删除用户信息model
 */
+ (void)removeUserData;



/**
 *  用户商店id,判断是否开店
 */
+ (void)setShopId:(id)shopId;
+ (id)getShopId;
+ (BOOL)isOpenShop;
//+ (void)setKowledgeListURL:(NSString *)urlString;
//+ (id)getKowledgeListURL;



/**
 推送的token-例如：用于设备更新接口
 */
+ (void)setRemoteNotiDeviceToken:(id)deviceToken;
+ (id)getRemoteNotiDeviceToken;


/**
 用户推送
 
 @param clientId 推送目标ID
 */
+ (void)setClientId:(id)clientId;
+ (id)getClientId;



#pragma mark - 登陆／退出

+ (void)loginOut;
+ (void)loginIn;
//可以区分不同api，处理不同业务
+ (void)loginOutWithTokenErrorAPI:(NSString *)api;




@end



///////在需要的地方（比如APPDelegate）监听
/*
 #pragma mark - 监听事件
 - (void)commonInitListenEvents
 {
     //token错误
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tokenError:) name:kNotificationUserTokenError object:nil];
     
     //先去获取一下im信息
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginIn:) name:kNotificationUserLoginIn object:nil];
     //    监听自动登录
     [[[NIMSDK sharedSDK]loginManager]addDelegate:self];;
     
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginOut:) name:kNotificationUserLoginOut object:nil];
     
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeDomain:) name:kNotificationUserChangeDomain object:nil];
 }
 #pragma mark- token错误
 - (void)tokenError:(NSNotification *)notification
 {
     if ([[notification.userInfo objectForKey:@"api"] isEqualToString:kNIM_getUserIMInfo])
     {
        return;
     }
     [self.window.rootViewController zh_presentLoginController];
 }
 
 - (void)changeDomain:(id)notification
 {
    [self initNIMSDK];
    [self registerGetuiAndRemoteNotification];
 }
 #pragma mark - app登陆后，云信登陆处理，手动登陆；
 
 - (void)loginIn:(id)notification
 {
    WS(weakSelf);
    [[[AppAPIHelper shareInstance]getNimAccountAPI]getNIMUserIMInfoWithSuccess:^(id data) {
 
    [WYUserDefaultManager setNimAccid:[data objectForKey:@"accid"]];
    [WYUserDefaultManager setNimPWD:[data objectForKey:@"pwd"]];
    [WYUserDefaultManager setNiMMyInfoUrl:[data objectForKey:@"url"]];
    [weakSelf loginNIM];
 
 } failure:^(NSError *error) {
    NSString *codeString = [error.userInfo objectForKey:@"code"];
    //        您的聊天功能无法使用，请联系客服。
    if ([codeString isEqualToString:@"im_netease_get_iminfo_failed_disp4from"])
    {
        [[WYNIMAccoutManager shareInstance]setupLoginFailedErrorCode:NIMRemoteErrorCodeUserNotExist];
    }
    //        您已被禁言，如有疑问请联系客服。
    if ([codeString isEqualToString:@"im_netease_get_iminfo_block_disp4from"])
    {
        [[WYNIMAccoutManager shareInstance]setupLoginFailedErrorCode:NIMRemoteErrorAccountBlock];
    }
    }];
 }
 
 #pragma mark - app退出后，注销NIM登陆；
 
 - (void)loginOut:(id)notification
 {
 
 //    登出
 //    @param completion 完成回调
 //    @discussion 用户在登出是需要调用这个接口进行 SDK 相关数据的清理,回调 Block 中的 error 只是指明和服务器的交互流程中可能出现的错误,但不影响后续的流程。
 //    如用户登出时发生网络错误导致服务器没有收到登出请求，客户端仍可以登出(切换界面，清理数据等)，但会出现推送信息仍旧会发到当前手机的问题。
 
    [[[NIMSDK sharedSDK]loginManager]logout:^(NSError * _Nullable error) {
 
        [UserDefault removeObjectForKey:@"accid"];
        [UserDefault removeObjectForKey:@"nimPwd"];
        [UserDefault removeObjectForKey:@"nimMyInfo"];
    }];
 }
 */
