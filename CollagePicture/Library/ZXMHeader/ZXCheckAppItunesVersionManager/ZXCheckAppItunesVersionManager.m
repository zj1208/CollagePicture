//
//  ZXCheckAppItunesVersionManager.m
//  CollagePicture
//
//  Created by simon on 16/11/18.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "ZXCheckAppItunesVersionManager.h"
#import "NSURL+ZXAppLinks.h"

/**
 *  请求发生错误的自定义参数
 */
static NSString *const kAPPErrorDomain = @"com.CheckVersionAPI.domain";
static NSInteger const kAPPErrorCode = 5000;

//检查版本更新请求数据用的
#ifndef kITUNESURL
#define kITUNESURL @"http://itunes.apple.com"
#endif

@implementation ZXCheckAppItunesVersionManager


+ (instancetype)shareInstance
{
    static id sharedHelper = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedHelper = [[self alloc] init];
    });
    return sharedHelper;
}


- (void)checkVersionSuccessWithAppId:(NSString *)appId success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSURL *baseURL = [NSURL URLWithString:kITUNESURL];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
   
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval =20.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    NSDictionary *dic = @{@"id":appId};
    
    __weak __typeof(&*self)weakSelf = self;
    [manager GET:@"lookup" parameters:dic headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [weakSelf requestSuccessDealWithResponseObeject:responseObject success:success failure:failure];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@,%@",error,@(error.code));
        if (failure)
        {
            error = [weakSelf getErrorFromError:error];
            failure(error);
        }
    }];
}

- (void)requestSuccessDealWithResponseObeject:(id)responseObject success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    //这是json数据格式的字典；
    NSError *parseError = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",str);
    
     if ([[responseObject objectForKey:@"resultCount"] integerValue] == 1)
     {
         if (success)
         {
             NSArray *results = [responseObject objectForKey:@"results"];
             if (results)
             {
                 NSDictionary *di = [results firstObject];
                 
                 success([di objectForKey:@"version"]);
             }
         }
     }
    else
    {
        if (failure)
        {
            NSError *error= [self customErrorWithObject:@"已经是最新版本了" errorCode:kAPPErrorCode userInfoErrorCode:nil];
            failure(error);
        }
    }
}

- (NSError *)getErrorFromError:(NSError *)error
{
    NSString *title = nil;
    switch (error.code)
    {
        case NSURLErrorCancelled:title = @"您的请求被取消了";break;
        case NSURLErrorBadURL:title = @"您的请求URL错误";break;
        case NSURLErrorUnsupportedURL:title =@"您的请求URL格式有误"; break;//-1002
        case NSURLErrorCannotFindHost:title =@"没有找到服务器";break;//-1003
        case NSURLErrorCannotConnectToHost:title =@"未能连接到服务器";  break; //Could not connect to the server -1004
            //        case NSURLErrorNotConnectedToInternet:title =@"您没有连接网络";  break;//The Internet connection appears to be offline.-1009
            //        case NSURLErrorTimedOut:title =@"您的网络有问题，请稍后重试";  break;//The request timed out -1001
            //        case NSURLErrorDNSLookupFailed:title = @"很抱歉,我们服务器发生错误\n域名系统查找失败";break; //-1006
            //        case NSURLErrorBadServerResponse:title =@"服务器发生错误";  break;//-1011
            //
            //        case NSURLErrorNetworkConnectionLost:title = @"网络连接中断";break;//The network connection was lost -1005
            
        case NSURLErrorNetworkConnectionLost:title = @"老板，你的网断了，检查下哇";break;//The network connection was lost -1005
        case NSURLErrorNotConnectedToInternet:title =@"老板，你的网断了，检查下哇";  break;//The Internet connection appears to be offline.-1009
        case NSURLErrorTimedOut:title =@"网络有点不稳定呀~";  break;//The request timed out -1001
        case NSURLErrorDNSLookupFailed:title = @"程序开小差了，请稍后再试哦";break; //-1006
        case NSURLErrorBadServerResponse:title =@"程序开小差了，请稍后再试哦";  break;//-1011
            
            //            NSCocoaErrorDomain
        case NSURLErrorCannotDecodeContentData:title =@"unacceptable content-type: text/javascript";
            break; //-1016
            //"JSON text did not start with array or object and option to allow fragments not set."
        case 3840:title = @"程序开小差了，请稍后再试哦"; break; //502
        default: return error;
            break;
    }
    error= [self customErrorWithObject:title errorCode:error.code userInfoErrorCode:nil];
    return error;
}


//自定义NSError错误信息，在userInfo中封装公司业务key：code，value：errorCode字符串
- (NSError *)customErrorWithObject:(NSString *)object errorCode:(NSInteger)code userInfoErrorCode:(NSString *)errorCode;

{
    if (!object) {
        object =@"";
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObject:object forKey:NSLocalizedDescriptionKey];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:dic];
    if (errorCode)
    {
        [userInfo setObject:errorCode forKey:@"code"];
    }
    NSError * error = [NSError errorWithDomain:kAPPErrorDomain code:code userInfo:userInfo];
    return error;
}



- (nullable NSString *)getAppVersionFromItunesWithAppId:(NSString *)appId
{
    NSURL *url =[NSURL zx_appStoreAppInfomationURLForApplicationIdentifier:appId];
    NSString *jsonData  = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
//    NSLog(@"%@",jsonData);
    id dic =[self getJSONSerializationObjectFromString:jsonData];
    if (dic)
    {
        NSArray *results = [dic objectForKey:@"results"];
        NSDictionary *appDic = [results firstObject];
        NSString *version = [appDic objectForKey:@"version"];
        return version;
    }
    return nil;
}


- (nullable id)getJSONSerializationObjectFromString:(nullable NSString *)string
{
    if ([NSString zhIsBlankString:string])
    {
        return nil;
    }
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error=nil;
    id dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    if (!error && data)
    {
        return dic;
    }
    return nil;
}


-(void)checkVersionUpdateWithAppId:(NSString *)appId success:(void(^)(BOOL needUpdate))success failure:(void(^)(NSError *error))failure
{
    __weak __typeof(&*self)weakSelf = self;
    [[ZXCheckAppItunesVersionManager shareInstance]checkVersionSuccessWithAppId:appId success:^(id data) {
        
        weakSelf.itunesVersion = data;
        if (success) {
            BOOL newVersion = [weakSelf isNewWithVersionCompare];
            success(newVersion);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}

#pragma mark-Version比较


- (BOOL)isNewWithVersionCompare
{
    NSString * version =  [[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    if ([self.itunesVersion compare:version options:NSNumericSearch] ==NSOrderedDescending)
    {
        return YES;
    }
    return NO;
}

@end
