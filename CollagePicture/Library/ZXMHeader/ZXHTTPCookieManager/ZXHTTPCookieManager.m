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



- (NSString *)cookieStringWithResponse:(NSHTTPURLResponse *)response
{
//    NSArray *cookies =[NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:response.URL];
    NSString *cookieString = [[response allHeaderFields] valueForKey:@"Set-Cookie"];
    return cookieString;
}


/*
 当headerFields response响应头中无cookie,可能是服务器人员没有写入，所以没有返回；
 
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
- (NSArray <NSHTTPCookie *> *)handleResponseHeaderFields:(NSDictionary *)headerFields forURL:(NSURL *)URL
{
    
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
//{
//    Accept = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8";
//    Cookie = "mat=6ed567cadeb63102a02a1d64b022c19f";
//    "User-Agent" = "Mozilla/5.0 (iPhone; CPU iPhone OS 11_2_6 like Mac OS X) AppleWebKit/604.5.6 (KHTML, like Gecko) Mobile/15D100microants-4-3.3.0.3";
//}
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
// 注意：从NSHTTPCookieStorage获取的cookie永远是最新更新的，只要NSURLRequest请求系统就会更新到最新，所以对应最新cookie的创建时间一直是最新请求反馈的时间；
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
// 也可以用removeCookiesSinceDate:方法删除；
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
//                [cookies enumerateObjectsUsingBlock:^(NSHTTPCookie * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//    
//                    [cookieStore deleteCookie:obj completionHandler:nil];
//                }];
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

- (void)cleanWKWebsiteDataWithCompletionHandler:(void (^)(void))completionHandler
{
    if (Device_SYSTEMVERSION_IOS9_OR_LATER)
    {
        NSSet *mSet = [NSSet setWithArray:@[WKWebsiteDataTypeMemoryCache,WKWebsiteDataTypeDiskCache]];
//        NSSet *websieteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
//        //移除cookie，不删除WK的本地cookie
//        NSMutableSet *mSet = [NSMutableSet setWithSet:websieteDataTypes];
//        [mSet removeObject:WKWebsiteDataTypeCookies];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore]removeDataOfTypes:mSet modifiedSince:dateFrom completionHandler:completionHandler];
    }
}

@end
