//
//  ZXHTTPCookieManager.m
//  YiShangbao
//
//  Created by simon on 2017/12/29.
//  Copyright © 2017年 com.Microants. All rights reserved.
//


#import "ZXHTTPCookieManager.h"

@implementation ZXHTTPCookieManager

- (instancetype)init
{
    if (self = [super init])
    {
        self.cookieFilter = ^BOOL(NSHTTPCookie *cookie,NSURL *url){
          
            if ([url.host containsString:cookie.domain])
            {
                return YES;
            }
            return NO;
        };
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static id  singletonInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!singletonInstance)
        {
            singletonInstance = [[super allocWithZone:NULL] init];
        }
    });
    return singletonInstance;
}


+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

- (void)setCookieFilter:(ZXHTTPCookieFilter)filter
{
    _cookieFilter = filter;
}

/*
 headerFields response响应头中获取是肯定无cookie的,但是系统确实返回回来了，怎么去获取呢；而且文章博客都说有返回；
 是不是哪里错了；
 
response.allHTTPHeaderFields = {
    Connection = keep-alive;
    Content-Type = text/html;
    Server = Tengine/2.2.0;
    Last-Modified = Tue, 26 Dec 2017 08:49:59 GMT;
    Transfer-Encoding = Identity;
    Date = Fri, 29 Dec 2017 08:01:20 GMT;
    Content-Encoding = gzip;
    Etag = W/"5a420d37-7c7";
}
 */
- (NSArray <NSHTTPCookie *> *)handleHeaderFields:(NSDictionary *)headerFields forURL:(NSURL *)URL
{
    // 肯定是空的；怎样才能有数据呢？
    NSArray *cookiesArray = [NSHTTPCookie cookiesWithResponseHeaderFields:headerFields forURL:URL];
    if (cookiesArray && cookiesArray.count>0)
    {
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        [cookiesArray enumerateObjectsUsingBlock:^(NSHTTPCookie*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (self.cookieFilter(obj,URL))
            {
                [cookieStorage setCookie:obj];
            }
        }];
    }
    return cookiesArray;
}


#pragma mark - 获取请求头cookie字典格式的字符串；

// 获取当前所有NSHTTPCookie的请求头[name=value;name=value]格式组合字符串
- (nullable NSString *)getCurrentRequestCookieHeader
{
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage]cookies];
    // 有可能是空字典
    NSDictionary *fieldCookies = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    NSString *cookie = [fieldCookies objectForKey:@"Cookie"];
    return cookie;
}

// 获取当前某个域名下的所有NSHTTPCookie的请求头[name=value;name=value]格式组合字符串；
- (nullable NSString *)getCurrentRequestCookieHeaderForURL:(NSURL *)URL
{
    NSArray *cookieArray = [self searchAppropriateCookies:URL];
    if (cookieArray != nil && cookieArray.count > 0) {
        NSDictionary *cookieDic = [NSHTTPCookie requestHeaderFieldsWithCookies:cookieArray];
        if ([cookieDic objectForKey:@"Cookie"])
        {
            return cookieDic[@"Cookie"];
        }
    }
    return nil;
}

// 获取当前某个域名下的所有NSHTTPCookie数组；
- (nullable NSArray *)searchAppropriateCookies:(NSURL *)URL
{
    NSMutableArray *cookieArray = [NSMutableArray array];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookieStorage.cookies enumerateObjectsUsingBlock:^(NSHTTPCookie * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.cookieFilter(obj,URL))
        {
            [cookieArray addObject:obj];
        }
    }];
    return cookieArray;
}

- (void)resetHTTPCookieStorageCookiesWithURL:(NSURL *)URL withCookieName:(NSString *)cookieName
{
    NSArray *cookiesArray = [self searchAppropriateCookies:URL];
    if (cookiesArray && cookiesArray.count >0)
    {
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        [cookiesArray enumerateObjectsUsingBlock:^(NSHTTPCookie*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (self.cookieFilter(obj,URL))
            {
                if ([obj.name isEqualToString:cookieName])
                {
                    [cookieStorage setCookie:obj];
                    *stop = YES;
                }
            }
        }];
    }
    
}
#pragma mark - 获取指定NSHTTPCookie

// 请求完回调回来，就能马上获取到正确的值；说明可以保证在请求response回来的时候，NSHTTPCookieStorage已经存储了最新的cookie；
- (nullable NSHTTPCookie *)getHTTPCookieFromNSHTTPCookieStorageWithCookieName:(NSString *)cookieName
{
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage]cookies];
    __block NSHTTPCookie *cookie = nil;
    [cookies enumerateObjectsUsingBlock:^(NSHTTPCookie*_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.name isEqualToString:cookieName])
        {
            cookie = obj;
            *stop = YES;
        }
        
    }];
    return cookie;
}

- (nullable NSHTTPCookie *)getHTTPCookieFromCookesArray:(NSArray *)cookies withCookieName:(NSString *)cookieName
{
    __block NSHTTPCookie *cookie = nil;
    [cookies enumerateObjectsUsingBlock:^(NSHTTPCookie*_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.name isEqualToString:cookieName])
        {
            cookie = obj;
            *stop = YES;
        }
    }];
    return cookie;
}


#pragma mark - 清理NSHTTPcookieStorage

// 本地cookie一定要清理，退出后传给服务端cookie，会造成服务器取出来签名bug；
- (void)cleanAllCookieInNSHTTPCookieStorage
{
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookieArray = [NSArray arrayWithArray:[cookieStorage cookies]];
    if (cookieArray.count>0)
    {
        for (id obj in cookieArray) {
            [cookieStorage deleteCookie:obj];
        }
    }
    // getAllCookies:不能使用，即使上面方法没有，使用下面方法也会崩溃；刚登陆的时候使用getAllCookies:也会崩溃
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

- (NSInteger)deleteCookieInNSHTTPCookieStorageWithURL:(NSURL *)URL
{
    __block NSInteger delCount = 0;
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookieStorage.cookies enumerateObjectsUsingBlock:^(NSHTTPCookie * _Nonnull cookie, NSUInteger idx, BOOL * _Nonnull stop) {
        if (_cookieFilter(cookie, URL))
        {
            NSLog(@"Delete a cookie: %@", cookie);
            [cookieStorage deleteCookie:cookie];
            delCount++;
        }
    }];
    return delCount;
}

//- (void)cleanWKWebsiteDataWithCompletionHandler:(void (^)(void))completionHandler
//{
//    if (Device_SYSTEMVERSION_IOS9_OR_LATER)
//    {
//        NSSet *websieteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
//        //移除cookie，不删除WK的本地cookie
//        NSMutableSet *mSet = [NSMutableSet setWithSet:websieteDataTypes];
//        [mSet removeObject:WKWebsiteDataTypeCookies];
//        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
//        [[WKWebsiteDataStore defaultDataStore]removeDataOfTypes:mSet modifiedSince:dateFrom completionHandler:completionHandler];
//    }
//}

@end
