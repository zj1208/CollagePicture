//
//  UserInfoUDManager.m
//  ICBC
//
//  Created by 朱新明 on 15/3/17.
//  Copyright (c) 2015年 朱新明. All rights reserved.
//

#import "UserInfoUDManager.h"

NSString *const kNotificationUserLoginIn = @"kNotificationUserLoginIn";
NSString *const kNotificationUserLoginOut =@"kNotificationUserLoginOut";
NSString *const kNotificationUpdateUserInfo = @"kNotificationUpdateUserInfo";
NSString *const kNotificationUserTokenError = @"kNotificationUserTokenError";

@implementation UserInfoUDManager

#define UID            @"uid"
#define Appkey         @"BabyAppkey"
#define Token          @"token"

//个推定义
#define GTClientId @"clientId"
#define GTDeviceToken @"deviceToken"

+ (bool)isLogin
{
    NSString *userId = [self getUserId];
    NSString *token = [self getToken];
    id model = [self getUserData];
    if (userId ||token ||model)
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


//本地cookie一定要清理，退出后传给服务端cookie，会造成服务器取出来签名bug；
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
        NSLog(@"%@",strName);
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
        NSLog(@"%@",strName);
        id getIvar = [model valueForKey:strName];
        [UserDefault setObject:getIvar forKey:strName];
        
    }
    free(properties);
    NSLog(@"%u",count);
    
    NSLog(@"%@",[UserDefault objectForKey:@"mobile"]);
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




#pragma mark -登陆／退出

+ (void)loginOut {
    
    [UserInfoUDManager removeData];
    [UserInfoUDManager removeUserData];
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationUserLoginOut object:self];    
}


+ (void)loginOutWithTokenErrorAPI:(NSString *)api
{
    [UserInfoUDManager removeData];
    [UserInfoUDManager removeUserData];
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationUserTokenError object:self userInfo:@{@"api":api}];

}

+ (void)loginIn
{
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationUserLoginIn object:self];
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
    if ([NSString zhIsBlankString:shopId])
    {
        return NO;
    }
    return YES;
}



+ (void)setRemoteNotiDeviceToken:(id)deviceToken
{
    [UserDefault setObject:deviceToken forKey:GTDeviceToken];
    [UserDefault synchronize];
}

+ (id)getRemoteNotiDeviceToken
{
    return [UserDefault objectForKey:GTDeviceToken];
}


+ (void)setClientId:(id)clientId
{
    [UserDefault setObject:clientId forKey:GTClientId];
    [UserDefault synchronize];
 
}
+ (id)getClientId
{
    return [UserDefault objectForKey:GTClientId];
 
}

@end
