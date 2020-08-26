//
//  UserInfoUDManager.h
//
//
//  Created by simon on 15/6/17.
//  Copyright (c) 2015年 sina. All rights reserved.
//
//  简介：一个管理用户有关的本地数据简单管理器；待优化更方便的方法；

// 2017.12.22 增加WK的cookie容器清理； 修改wkWebView的清理缓存不包括cookie
// 2018.4.02；优化代码；
// 2019.12.31 修改通知定义的参数类型
// 2020.5.07 优化代码
// 2020.8.20 修改常量

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "TMCache.h"

FOUNDATION_EXPORT NSString *const kNotificationUserLogin;
FOUNDATION_EXPORT NSString *const kNotificationUserLogout;
FOUNDATION_EXPORT NSNotificationName const kNotificationUpdateUserInfo;
FOUNDATION_EXPORT NSNotificationName const kNotificationUserTokenError;


#define ISLOGIN         [UserInfoUDManager isLogin]
#define USER_TOKEN      [UserInfoUDManager getToken]
#define USER_ID         [UserInfoUDManager getUserId]

///用户token
static NSString *const ud_token = @"ud_token";
///用户id
static NSString *const ud_uId = @"ud_uId";
///app版本号
static NSString *const ud_saveVersion = @"ud_saveVersion";
///商铺id
static NSString *const ud_shopId = @"ud_shopId";
//第三方推送id定义
static NSString *const ud_clientId = @"clientId";
//苹果注册的设备token
static NSString *const ud_deviceToken = @"deviceToken";

@interface UserInfoUDManager : NSObject


+ (bool)isLogin;

+ (void)setUserId:(NSString *)uid;
+ (NSString *)getUserId;



+ (void)setToken:(NSString *)token;

+ (NSString *)getToken;

// 清理本地cookie； 退出登录的时候需要清理；
+ (void)cleanCookies;

//// 根据cookieName 从NSHTTPCookieStorage 获取cookie；
//+ (NSHTTPCookie *)getHTTPCookieFromNSHTTPCookieStorageWithCookieName:(NSString *)cookieName;
//
//// 根据cookieName 从cookies数组中筛选获取cookie；
//+ (NSHTTPCookie *)getHTTPCookieFromCookesArray:(NSArray *)cookies withCookieName:(NSString *)cookieName;

// 清理网页的所有本地数据，包括硬盘存储，内存缓存，离线缓存等；
+ (void)cleanWebsiteDataWithCompletionHandler:(void (^)(void))completionHandler;
/******************************************************************************/

/**
 * 用NSUserDefault的时候,此app没有使用这方法;
 **/

+ (void)setUserAllData:(id)model;
+ (void)removeUserAllData:(id)model;


/******************************************************************************/
/**
 *  @brief 利用TMCache保存自定义对象,不仅仅是集合类;
 */
+ (void)setUserData:(id)object;

+ (void)removeData;
/**
 *  @brief 从本地获取用户信息model
 */
+ (id)getUserData;


/**
  @brief 修改用户信息，根据key设置model里的其中一个值；swift的model不支持setValue：forKey，不然会崩溃；
 */
+ (void)setPropertyImplementationValue:(id)value forKey:(NSString *)key;

/**
 *  @brief 从本地删除用户信息model
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



#pragma mark - 推送

#pragma mark -苹果设备token
//从苹果服务器注册返回的远程通知设备token

+ (void)setRemoteNotiDeviceToken:(id)deviceToken;
+ (id)getRemoteNotiDeviceToken;




#pragma mark -用户第三方推送id

//用户推送：clientId 推送目标ID
+ (void)setClientId:(id)clientId;
+ (id)getClientId;



#pragma mark - 本地保存版本号，用户每个版本第一次处理业务

+ (void)setSaveVersion:(NSString *)version;

+ (id)getSaveVersion;

#pragma mark - 登录／退出

+ (void)logout;
+ (void)login;
//自己服务器API的token错误需要重新登录；聊天API的token错误不需要重新登录，
+ (void)postTokenErrorNotificationWithUserInfo:(NSDictionary *)userInfo;

////本地记录用户历史输入电话号码、国家区号
//+ (void)saveLoginInputPhone:(NSDictionary *)phone;
//+ (NSArray *)getLoginInputPhones;

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
     [self.window.rootViewController xm_presentLoginController];
 }
 
 - (void)changeDomain:(id)notification
 {
    [self initNIMSDK];
    [self registerGetuiAndRemoteNotification];
 }
 #pragma mark - app登录后，云信登录处理，手动登录；
 
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
 
 #pragma mark - app退出后，注销NIM登录；
 
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
