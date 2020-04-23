//
//  UserInfoUDManager.m
//  
//
//  Created by simon on 15/6/17.
//  Copyright (c) 2015年 sina. All rights reserved.
//

#import "UserInfoUDManager.h"
#import <WebKit/WebKit.h>

NSString *const kNotificationUserLogin = @"kNotificationUserLogin";
NSString *const kNotificationUserLogout = @"kNotificationUserLogout";
NSNotificationName const kNotificationUpdateUserInfo = @"kNotificationUpdateUserInfo";
NSNotificationName const kNotificationUserTokenError = @"kNotificationUserTokenError";


static NSString *const ud_saveVersion = @"ud_saveVersion";

static NSString *const ud_saveLoginInputPhone_develop = @"ud_saveLoginInputPhone_develop";
static NSString *const ud_saveLoginInputPhone_test = @"ud_saveLoginInputPhone_test";
static NSString *const ud_saveLoginInputPhone_online = @"ud_saveLoginInputPhone_online";

@implementation UserInfoUDManager

#define UID            @"uid"
#define Appkey         @"BabyAppkey"
#define Token          @"token"








+ (bool)isLogin
{
    NSString *userId = [self getUserId];
    NSString *token = [self getToken];
    if (userId ||token)
    {
        return YES;
    }
    return NO;
}



+ (void)setUserId:(NSString *)uid
{
    [UserDefault setObject:uid forKey:UID];
    [UserDefault synchronize];
}



+ (NSString *)getUserId {
    return [UserDefault stringForKey:UID];
}

+ (void)setToken:(NSString *)token
{
    [UserDefault setObject:token forKey:Token];
    [UserDefault synchronize];

}

+(NSString *)getToken
{
    return [UserDefault objectForKey:Token];
}


+ (void)setAppKey:(NSString *)appKey
{
    [UserDefault setObject:appKey forKey:Appkey];
}

+ (NSString *)getAppKey
{
    return [UserDefault objectForKey:Appkey];
}


+ (void)removeData
{
    [UserDefault removeObjectForKey:UID];
    [UserDefault  synchronize];
    [UserDefault removeObjectForKey:Token];
    [UserDefault  synchronize];
    [UserDefault removeObjectForKey:Appkey];
    [UserDefault  synchronize];
    [UserDefault removeObjectForKey:@"shopId"];
    [UserDefault  synchronize];
    [UserInfoUDManager cleanCookies];
}


// 本地cookie一定要清理，退出后传给服务端cookie，会造成服务器取出来签名bug；
+ (void)cleanCookies
{
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookieArray = [NSArray arrayWithArray:[cookieStorage cookies]];
    if (cookieArray.count>0)
    {
        for (id obj in cookieArray) {
            [cookieStorage deleteCookie:obj];
        }
    }
// getAllCookies:不能使用，即使上面方法没有，使用下面方法也会崩溃；刚登录的时候使用getAllCookies:也会崩溃
//    不会崩溃？
//    if (@available(iOS 11.0, *))
//    {
//        WKHTTPCookieStore *cookieStore = [WKWebsiteDataStore defaultDataStore].httpCookieStore;
//        NSLog(@"%@",cookieStore);
//        [cookieStore getAllCookies:^(NSArray<NSHTTPCookie *> * _Nonnull cookies) {
//
//            NSLog(@"%@",cookies);
//            [cookies enumerateObjectsUsingBlock:^(NSHTTPCookie * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//                [cookieStore deleteCookie:obj completionHandler:nil];
//            }];
//
//        }];
//    }
 }

+ (void)cleanWebsiteDataWithCompletionHandler:(void (^)(void))completionHandler
{
    if ([[UIDevice currentDevice] systemVersion].floatValue >=9.f)
    {
        NSSet *websieteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        //移除cookie，不删除WK的本地cookie
        NSMutableSet *mSet = [NSMutableSet setWithSet:websieteDataTypes];
        [mSet removeObject:WKWebsiteDataTypeCookies];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore]removeDataOfTypes:mSet modifiedSince:dateFrom completionHandler:completionHandler];
    }
}
#pragma mark-自己用的方法

/**
 * 用NSUserDefault的时候
 **/
+ (void)removeUserAllData:(id)model
{
    u_int count;
    objc_property_t *properties = class_copyPropertyList([model class], &count);
    for (int i =0; i<count; i++)
    {
        objc_property_t property = properties [i];
        const char *propertyName = property_getName(property);
        NSString *strName = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
        [UserDefault removeObjectForKey:strName];
    }
    free(properties);
}


/**
 * 用NSUserDefault的时候
 **/
+ (void)setUserAllData:(id)model
{
    u_int count;
    objc_property_t *properties = class_copyPropertyList([model class], &count);
    for (int i =0; i<count; i++)
    {
        objc_property_t property = properties [i];
        const char *propertyName = property_getName(property);
        NSString *strName = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
        id getIvar = [model valueForKey:strName];
        [UserDefault setObject:getIvar forKey:strName];
        
    }
    free(properties);
}

+ (void)setPropertyImplementationValue:(id)value forKey:(NSString *)key
{
    if (!value ||!key)
    {
        return;
    }
    id object = [UserInfoUDManager getUserData];
    [object setValue:value forKey:key];
    [[TMDiskCache sharedCache]removeObjectForKey:@"userModel"];
    [[TMDiskCache sharedCache] setObject:object forKey:@"userModel"];
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationUpdateUserInfo object:self];
}


#pragma  mark - 用TMDiskCache设置model

+ (void)setUserData:(id)object
{
    if (!object)
    {
        return;
    }
    [[TMDiskCache sharedCache] setObject:object forKey:@"userModel"];
}

+ (id)getUserData
{
    return [[TMDiskCache sharedCache] objectForKey:@"userModel"];
}



+ (void)removeUserData
{
    TMDiskCache *disk = [TMDiskCache sharedCache];
    [disk removeObjectForKey:@"userModel"];
}




#pragma mark -登录／退出

+ (void)loginOut {
    
    [UserInfoUDManager removeData];
    [UserInfoUDManager removeUserData];
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationUserLogout object:self];
}


+ (void)reLoginingWithTokenErrorAPI:(NSString *)api
{
    [UserInfoUDManager removeData];
    [UserInfoUDManager removeUserData];
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationUserTokenError object:self userInfo:@{@"api":api}];

}

+ (void)loginIn
{
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationUserLogin object:self];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



+ (void)setShopId:(id)shopId
{
    [UserDefault setObject:shopId forKey:@"shopId"];
    [UserDefault synchronize];
}

+ (id)getShopId
{
   return  [UserDefault objectForKey:@"shopId"];
}

+ (BOOL)isOpenShop
{
    id shopId = [self getShopId];
    if (shopId==nil || [shopId length]==0)
    {
        return NO;
    }
    return YES;
}



+ (void)setRemoteNotiDeviceToken:(id)deviceToken
{
    [UserDefault setObject:deviceToken forKey:ud_deviceToken];
    [UserDefault synchronize];
}

+ (id)getRemoteNotiDeviceToken
{
    return [UserDefault objectForKey:ud_deviceToken];
}


+ (void)setClientId:(id)clientId
{
    [UserDefault setObject:clientId forKey:ud_GTClientId];
    [UserDefault synchronize];
 
}
+ (id)getClientId
{
    return [UserDefault objectForKey:ud_GTClientId];
}


#pragma mark - 本地保存版本号，用户每个版本第一次处理业务


+ (void)setSaveVersion:(NSString *)version
{
    [UserDefault setObject:version forKey:ud_saveVersion];
    [UserDefault synchronize];
}

+ (id)getSaveVersion
{
    return [UserDefault objectForKey:ud_saveVersion];
}

//#pragma mark - 本地记录用户历史输入电话号码、国家区号
//+ (void)saveLoginInputPhone:(NSDictionary *)phone
//{
//    NSMutableArray *arrayM = [NSMutableArray arrayWithObject:phone];
//    NSMutableArray *history = [NSMutableArray array];
//    [history addObjectsFromArray:[UserInfoUDManager getLoginInputPhones]];
//    for (NSDictionary *dict in history) { //去重复数据
//        if ([[dict objectForKey:@"phone"] isEqualToString:[phone objectForKey:@"phone"] ]&&[[dict objectForKey:@"countryCode"] isEqualToString:[phone objectForKey:@"countryCode"] ]) {
//            [history removeObject:dict];
//            break;
//        }
//    }
//    if (history.count>4) {
//        NSArray *subHistory = [history subarrayWithRange:NSMakeRange(0, 4)];
//        [arrayM addObjectsFromArray:subHistory];
//    }else{
//        [arrayM addObjectsFromArray:history];
//    }
//
//    NSString *ud_saveLoginInputPhone;
//    NSString *appURL = [WYUserDefaultManager getkAPP_BaseURL];
//    if ([appURL isEqualToString:@"http://api.m-internal.s-ant.cn"])
//    {
//        ud_saveLoginInputPhone = ud_saveLoginInputPhone_develop;
//    }
//    else if ([appURL isEqualToString:@"http://api.m-internal.microants.com.cn"])
//    {
//        ud_saveLoginInputPhone = ud_saveLoginInputPhone_test;
//    }
//    else if ([appURL isEqualToString:@"https://api.m.microants.cn"])
//    {
//        ud_saveLoginInputPhone = ud_saveLoginInputPhone_online;
//    }
//
//    [UserDefault setObject:arrayM forKey:ud_saveLoginInputPhone];
//    [UserDefault synchronize];
//}
//+ (NSArray *)getLoginInputPhones
//{
//    NSString *ud_saveLoginInputPhone;
//    NSString *appURL = [WYUserDefaultManager getkAPP_BaseURL];
//    if ([appURL isEqualToString:@"http://api.m-internal.s-ant.cn"])
//    {
//        ud_saveLoginInputPhone = ud_saveLoginInputPhone_develop;
//    }
//    else if ([appURL isEqualToString:@"http://api.m-internal.microants.com.cn"])
//    {
//        ud_saveLoginInputPhone = ud_saveLoginInputPhone_test;
//    }
//    else if ([appURL isEqualToString:@"https://api.m.microants.cn"])
//    {
//        ud_saveLoginInputPhone = ud_saveLoginInputPhone_online;
//    }
//    NSArray *arr = [UserDefault objectForKey:ud_saveLoginInputPhone];
//    return arr;
//}

@end
