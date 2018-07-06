//
//  ZXHTTPCookieManager.h
//  YiShangbao
//
//  Created by simon on 2017/12/29.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  简介：cookie的各种方法处理；

// 2018.01.02 创建这个类
// 2018.04.20 添加方法；

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef BOOL(^ZXHTTPCookieFilter)(NSHTTPCookie *cookie,NSURL *url);

@interface ZXHTTPCookieManager : NSObject

@property (nonatomic, copy) ZXHTTPCookieFilter cookieFilter;

+ (instancetype)sharedInstance;





/**
 指定URL匹配Cookie策略

 @param filter filter description
 */
- (void)setCookieFilter:(ZXHTTPCookieFilter)filter;

#pragma mark - 响应头数据：


/**
 获取响应头的cookie数据字符串格式； 

 @param response 响应对象
 @return cookie字符串
 NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
 NSString *cookieString =  [[ZXHTTPCookieManager sharedInstance]cookieStringWithResponse:response];
 
 */
- (NSString *)cookieStringWithResponse:(NSHTTPURLResponse *)response;

/**
 先读取响应头中的cookie数据，再根据URL获取指定cookie，再NSHTTPCookieStorage存储；
 即处理HTTP中Reponse的headerFields携带的Cookie并存储；

 @param headerFields response 请求响应后的头字典
 @param URL 根据匹配策略获取查找URL关联的所有Cookie；可能不同的name设置；
 @return 返回添加到存储的Cookie数组；
 
 [[ZXHTTPCookieManager sharedInstance]handleResponseHeaderFields:response.allHeaderFields forURL:response.URL];

 */
- (nullable NSArray <NSHTTPCookie *> *)handleResponseHeaderFields:(NSDictionary *)headerFields forURL:(NSURL *)URL;


#pragma mark - 请求头数据：获取请求头cookie字典格式的字符串；

/**
 获取当前所有cookie的字符串拼接
UM_distinctid=160a0e171573ed-06957cb7c349838-6a462226-2c600-160a0e1715847a;mat=8be8ad68688837b79470fb689bdc2d7b；

 @return 当前所有cookie的字符串拼接;
 */
- (nullable NSString *)getCurrentRequestCookieHeader;

/**
 获取当前某个域名下的所有NSHTTPCookie的请求头[name=value;name=value]格式组合字符串；

 @param URL 指定URL
 @return return value description
 */
- (nullable NSString *)getCurrentRequestCookieHeaderForURL:(NSURL *)URL;



// 获取当前某个域名下的所有NSHTTPCookie数组；
- (nullable NSArray *)searchAppropriateCookies:(NSURL *)URL;


// 重新设置最新的cookie
- (void)resetHTTPCookieStorageCookiesWithURL:(NSURL *)URL withCookieName:(NSString *)cookieName;

#pragma mark - 获取指定NSHTTPCookie

/**
 根据cookieName获取指定的NSHTTPCookie；
 注意：请求完回调回来，就能马上获取到正确的值；
 在请求response回来的时候，NSHTTPCookieStorage已经存储了最新的cookie；

 @param cookieName name
 @return return value description
 */
- (nullable NSHTTPCookie *)getHTTPCookieFromNSHTTPCookieStorageWithCookieName:(NSString *)cookieName;


/**
  根据cookies数组 和 cookieName获取指定的NSHTTPCookie；

 @param cookies cookies数组
 @param cookieName name
 @return return value description
 */
- (nullable NSHTTPCookie *)getHTTPCookieFromCookesArray:(NSArray *)cookies withCookieName:(NSString *)cookieName;



#pragma mark - 清理NSHTTPcookieStorage

/**
 清理NSHTTPCookieStorage中的所有cookie；
 注意：本地cookie一定要清理，退出后传给服务端cookie，会造成服务器取出来签名bug；
 */
- (void)cleanAllCookieInNSHTTPCookieStorage;


/**
 清理删除指定URL的所有cookie

 @param URL 指定URL
 @return 删除个数；
 */
- (NSInteger)deleteCookieInNSHTTPCookieStorageWithURL:(NSURL *)URL;


- (void)cleanWKWebsiteDataWithCompletionHandler:(void (^)(void))completionHandler;
@end

NS_ASSUME_NONNULL_END
