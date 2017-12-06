//
//  BaseHttpAPI.m
//  SiChunTang
//
//  Created by 朱新明 on 15/6/4.
//  Copyright (c) 2015年 simon. All rights reserved.
//

#import "BaseHttpAPI.h"
#import "AFNetworking.h"
#import "UserInfoUDManager.h"
#import "WYUserDefaultManager.h"
#import "AFHTTPSessionManager+Synchronous.h"



@implementation BaseHttpAPI


/**
 *  请求成功
 */
static NSInteger const kRequestSuccess_Value = 1;
static NSString *const kRequestSuccess_Key = @"success";//请求是否成功key
static NSString *const kRequestSuccess_ErrorMsg = @"msg"; //请求成功，接收错误信息

/**
 *  请求发生错误的自定义参数
 */
static NSString *const kAPPErrorDomain = @"com.yicaibao.domain";
static NSInteger const kAPPErrorCode = 5000;

NSInteger const kAPPErrorCode_Token = 5001;




-(void)postRequest:(NSString *)path parameters:(NSDictionary *)parameter success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSMutableDictionary *postDictionary = [NSMutableDictionary dictionaryWithDictionary:parameter];
    postDictionary =[self addRequestPostData:postDictionary apiName:path];
//    NSURL *baseURL = [NSURL URLWithString:kAPP_BaseURL];
    NSString *kBaseURL =[WYUserDefaultManager getkAPP_BaseURL];
    NSURL *baseURL = [NSURL URLWithString:kBaseURL];

    //    用于添加更多参数
    ZX_NSLog_HTTPURL(kBaseURL, @"/m", postDictionary);
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    AFJSONResponseSerializer *response =[AFJSONResponseSerializer serializer];
//    response.removesKeysWithNullValues = YES;
//    manager.responseSerializer = response;
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval =10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    WS(weakSelf);
    [manager POST:@"/m" parameters:postDictionary progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [weakSelf requestSuccessDealWithResponseObeject:responseObject success:success failure:failure];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@,%@",error,@(error.code));
        
        //        ZX_NSLog_ModelAllValue(error);
        //        NSLog(@"\n error.domain=%@ \n error.code=%ld \n error.userInfo=%@,\n error.localizedDescription=%@",error.domain,error.code,error.userInfo,error.localizedDescription);
        
        if (failure)
        {
            error = [self getErrorFromError:error];
            failure(error);
        }
    }];
}

//{
//    Accept-Language = en;q=1;
//    User-Agent = YiShangbao/2.4.0.0 (iPhone; iOS 11.0; Scale/2.00);
//}

//get请求
-(void) getRequest:(NSString *)path parameters:(NSDictionary *)parameter success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSMutableDictionary *postDictionary = [NSMutableDictionary dictionaryWithDictionary:parameter];
    postDictionary =[self addRequestPostData:postDictionary apiName:path];

//    NSURL *baseURL = [NSURL URLWithString:kAPP_BaseURL];
    NSString *kBaseURL =[WYUserDefaultManager getkAPP_BaseURL];
    NSURL *baseURL = [NSURL URLWithString:kBaseURL];
    //    用于添加更多参数
    ZX_NSLog_HTTPURL(kBaseURL, @"/m", postDictionary);
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    AFJSONResponseSerializer *response =[AFJSONResponseSerializer serializer];
//    response.removesKeysWithNullValues = YES;
//    manager.responseSerializer = response;
//
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval =10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
//    NSLog(@"%@",manager.requestSerializer.HTTPRequestHeaders);
    WS(weakSelf);
    [manager GET:@"/m" parameters:postDictionary progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSLog(@"%@",task.response.URL);
//        NSHTTPURLResponse *response =  (NSHTTPURLResponse *)task.response;
//        NSLog(@"response.allHeaderFields=%@",response.allHeaderFields);
//        NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:response.allHeaderFields forURL:baseURL];
//        NSLog(@"cookies =%@",cookies);

        [weakSelf requestSuccessDealWithResponseObeject:responseObject success:success failure:failure];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
//        NSLog(@"%@",task.response.URL);
        NSLog(@"%@,%@",error,@(error.code));
        
        //        NSLog(@"\n error.domain=%@ \n error.code=%ld \n error.userInfo=%@,\n error.localizedDescription=%@",error.domain,error.code,error.userInfo,error.localizedDescription);
        
        if (failure)
        {
            error = [self getErrorFromError:error];
            failure(error);
        }
        
    }];
    
}



// post/get 通用处理请求成功的业务
- (void)requestSuccessDealWithResponseObeject:(id)responseObject success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSString *str = [NSString zhGetJSONSerializationStringFromObject:responseObject];
    
    NSLog(@"%@",str);

//    NSLog(@"\n+++++++%@",responseObject);
    NSDictionary *meta = [responseObject objectForKey:@"meta"];
    NSString *token = [meta objectForKey:@"mat"];
    if (token.length>0)
    {
//       NSString *message =[NSString stringWithFormat:@"新token:%@,\n 老token：%@",token,[UserInfoUDManager getToken]];
//       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"token变了" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//       [alert show];
       [self requestHeaderFieldsWithCookieToken:token];
       [UserInfoUDManager setToken:token];
    }
    
    
    NSDictionary *result = [responseObject objectForKey:@"result"];
    
    if ([[result objectForKey:kRequestSuccess_Key] integerValue] == kRequestSuccess_Value)
    {
        success([result objectForKey:@"data"]);
    }
    else
    {
        NSString *code = [result objectForKey:@"code"];
        if ([code isEqualToString:kToken_Code_Value_Invalid] ||[code isEqualToString:kToken_Code_Value_Disabled])
        {
//            NSString *message =[NSString stringWithFormat:@"您的登录已失效，请重新登录！\n 老token：%@",[UserInfoUDManager getToken]];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"token坏了" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
            NSError * error = [self customErrorWithObject:@"您的登录已失效，请重新登录！" errorCode:kAPPErrorCode_Token userInfoErrorCode:nil];
            //可以区分不同api，处理不同业务
            [UserInfoUDManager loginOutWithTokenErrorAPI:[meta objectForKey:@"api"]];
            if (failure)
            {
                failure(error);
            }
 
        }
        else
        {
            //因为errorCode是整形，所以在userInfo中封装 业务字符串code
            NSError *error= [self customErrorWithObject:[result objectForKey:kRequestSuccess_ErrorMsg] errorCode:kAPPErrorCode userInfoErrorCode:code];
            if (failure)
            {
                failure(error);
            }
        }
    }
}

- (void)requestHeaderFieldsWithCookieToken:(NSString *)token
{
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:@"mat" forKey:NSHTTPCookieName];
    [cookieProperties setObject:token forKey:NSHTTPCookieValue];
    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setObject:[WYUserDefaultManager getkCookieDomain] forKey:NSHTTPCookieOriginURL];
//    [cookieProperties setObject:@"604800" forKey:NSHTTPCookieMaximumAge];
//    [cookieProperties setObject:@"1" forKey:NSHTTPCookieVersion];
    [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:604800];
    [cookieProperties setObject:date forKey:NSHTTPCookieExpires];
    NSHTTPCookie *cookie_token = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage]setCookie:cookie_token];
//    po [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies
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
        case NSURLErrorCallIsActive:title =@"网络请求被电话中断，请稍后再试哦";//-1019
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



#pragma mark-添加参数
-(NSMutableDictionary *)addRequestPostData:(NSMutableDictionary *)dicArgument apiName:(NSString *)aApi
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    [dicParam setObject:aApi forKey:@"api"];
    
    if (![dicArgument objectForKey:HEAD_API_VERSION])
    {
        [dicParam setObject:@"1.0" forKey:HEAD_API_VERSION];
    }
    else
    {
        [dicParam setObject:[dicArgument objectForKey:HEAD_API_VERSION] forKey:HEAD_API_VERSION];
        [dicArgument removeObjectForKey:HEAD_API_VERSION];
    }
    [dicParam setObject:[BaseHttpAPI getCurrentAppVersion] forKey:HEAD_TTID];

    if (!dicArgument)
    {
        [dicParam setObject:@"" forKey:@"data"];
    }
    else
    {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicArgument options:0 error:NULL];
        NSString *dataString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [dicParam setObject:dataString forKey:@"data"];
    }
  
    NSString *authtoken = USER_TOKEN;
    
    if (authtoken) {
        [dicParam setObject:authtoken forKey:HEAD_AUTHTOKEN];
    }else{
        [dicParam setObject:@"" forKey:HEAD_AUTHTOKEN];
    }
    [dicParam setObject:[BaseHttpAPI getCurrentDatetime] forKey:HEAD_TS];
    [dicParam setObject:[[UIDevice currentDevice]getIDFAUUIDString] forKey:HEAD_DID];
    [dicParam setObject:@"" forKey:HEAD_LNG];
    [dicParam setObject:@"" forKey:HEAD_LAT];
    

    NSArray *keysArray = @[@"api",HEAD_API_VERSION,HEAD_TTID,@"data",HEAD_AUTHTOKEN,HEAD_TS,HEAD_DID,HEAD_LNG,HEAD_LAT];
    
    [dicParam setValue:[BaseHttpAPI MD5stringWithDict:dicParam sortKeyArray:keysArray] forKey:@"sign"];
    
    return dicParam;
}

+ (NSString *)MD5stringWithDict:(NSDictionary*)dict sortKeyArray:(NSArray *)sortKeys{
    
    __block NSString *str = @"";
    [sortKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        id value = [dict objectForKey:obj];
        if([str length] !=0) {
            str = [str stringByAppendingString:@"&"];
        }
        str = [str stringByAppendingFormat:@"%@=%@",obj,value];
    }];
    
//    NSString *md5String = [[str md5String]copy];
    NSString *md5String = [[NSString zhCreatedMD5String:str]copy];
    return md5String;
}





//获取软件版本号
+ (NSString *)getCurrentAppVersion {
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *ttid = [NSString stringWithFormat:@"%@_ysb@iphone",app_Version];
    return ttid;
}
//获取当前时间戳
+ (NSString *)getCurrentDatetime {
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *date = [NSString stringWithFormat:@"%llu",recordTime];
    return date;
}


//-(NSString*)getDateStr:(NSDate*)date
//{
//    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
//    NSString *destDateString = [dateFormatter stringFromDate:date];
//    return destDateString;
//}



- (void)postRequest:(NSString *)path parameters:(id)parameters
constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
           progress:(void (^)(NSProgress *uploadProgress))uploadProgress
            success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
            failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    //    NSMutableDictionary *postDictionary = [NSMutableDictionary dictionaryWithDictionary:parameters];
    //    postDictionary =[self addRequestPostData:postDictionary];
    //    //    用于添加更多参数
    //    ZX_NSLog_HTTPURL(kAPP_BaseURL, path, postDictionary);
    //    NSURL *baseURL = [NSURL URLWithString:kAPP_BaseURL];
    //
    //    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //
    //    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    //    manager.requestSerializer.timeoutInterval =60.f;
    //    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    //
    //    [manager POST:path parameters:postDictionary constructingBodyWithBlock:block progress:uploadProgress success:success failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //
    //        if (failure)
    //        {
    //            error = [self getErrorFromError:error];
    //            failure(task,error);
    //        }
    //
    //    }];
}

//dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//
//NSURLSessionDataTask *task =
//[self dataTaskWithHTTPMethod:method
//                   URLString:URLString
//                  parameters:parameters
//              uploadProgress:nil
//            downloadProgress:nil
//                     success:
// ^(NSURLSessionDataTask *unusedTask, id resp) {
//     responseObject = resp;
//     dispatch_semaphore_signal(semaphore);
// }
//                     failure:
// ^(NSURLSessionDataTask *unusedTask, NSError *err) {
//     error = err;
//     dispatch_semaphore_signal(semaphore);
// }];
//
//[task resume];
//dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//
//if (taskPtr != nil) *taskPtr = task;
//if (outError != nil) *outError = error;
//
//return responseObject;

-(void)synchronouslyGetRequest:(NSString *)path parameters:(NSDictionary *)parameter success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSMutableDictionary *postDictionary = [NSMutableDictionary dictionaryWithDictionary:parameter];
    postDictionary =[self addRequestPostData:postDictionary apiName:path];
    //    NSURL *baseURL = [NSURL URLWithString:kAPP_BaseURL];
    NSString *kBaseURL =[WYUserDefaultManager getkAPP_BaseURL];
    NSURL *baseURL = [NSURL URLWithString:kBaseURL];
    
    //    用于添加更多参数
    ZX_NSLog_HTTPURL(kBaseURL, @"/m", postDictionary);
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval =10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    manager.completionQueue = dispatch_queue_create("AFNetworking+Synchronous", NULL);
    
    NSError *error = nil;
    id responseObject = [manager syncGET:@"/m" parameters:postDictionary task:NULL error:&error];
    
    [self requestSuccessDealWithResponseObeject:responseObject success:success failure:^(NSError *error) {
        
        if (error)
        {
            failure (error);
        }

    }];
}

@end
