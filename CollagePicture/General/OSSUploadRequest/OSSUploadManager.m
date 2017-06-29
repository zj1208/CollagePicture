//
//  OSSUploadManager.m
//  YiShangbao
//
//  Created by simon on 17/2/10.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "OSSUploadManager.h"
#import "OSSPicInfoRequest.h"
#import "BaseHttpAPI.h" //需要请求自己公司服务器，加密

#import "WYUserDefaultManager.h"
#ifndef APP_bundleIdentifier
#define APP_bundleIdentifier [[NSBundle mainBundle]bundleIdentifier]
#endif

@interface OSSUploadManager ()<NSURLSessionTaskDelegate>

@property (nullable, nonatomic, copy) ZXImageUploadFailureBlock failuerBlock;
@property (nullable, nonatomic, copy) ZXImageUploadSingleCompletedBlock singleCompletedBlock;
@property (nullable, nonatomic, copy) OSSNetworkingUploadProgressBlock uploadProgress;

//获取文件目录
- (NSString *)getFileCatalogWithType:(OSSFileCatalog)type;
@end

@implementation OSSUploadManager

- (void)setGetPicInfo:(BOOL)getPicInfo
{
    if (_getPicInfo != getPicInfo)
    {
        _getPicInfo = getPicInfo;
    }
}

+ (instancetype)getInstance
{
    static id manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[self alloc] init];
        
    });
    return manager;
}

- (void)putObjectOSSStsTokenPublicBucketWithUserId:(nullable NSString *)userId
                                     uploadingData:(NSData *)data
                                          progress:(nullable OSSNetworkingUploadProgressBlock)progressBlock
                                    singleComplete:(nullable ZXImageUploadSingleCompletedBlock)signleCompleteBlock
                                           failure:(nullable ZXImageUploadFailureBlock)failure
{

    
     [self putObjectWithUserId:userId bucketName:kOSS_bucketName_public fileCatalog:nil uploadingData:data progress:progressBlock singleComplete:signleCompleteBlock failure:failure];
}

- (void)putObjectOSSStsTokenPublicBucketWithUserId:(nullable NSString *)userId
                                   fileCatalogType:(OSSFileCatalog)fileCatalog
                                     uploadingData:(NSData *)data
                                          progress:(nullable OSSNetworkingUploadProgressBlock)progressBlock
                                    singleComplete:(nullable ZXImageUploadSingleCompletedBlock)signleCompleteBlock
                                           failure:(nullable ZXImageUploadFailureBlock)failure
{
    
    NSString *fileType = [self getFileCatalogWithType:fileCatalog];
    [self putObjectWithUserId:userId bucketName:kOSS_bucketName_public fileCatalog:fileType uploadingData:data progress:progressBlock singleComplete:signleCompleteBlock failure:failure];

}



- (NSString *)getFileCatalogWithType:(OSSFileCatalog)type
{
    
    switch (type)
    {
        case OSSFileCatalog_userHeadIcon:return @"2/head/";break;
        case OSSFileCatalog_uploadProduct: return @"2/pro/"; break;
        case OSSFileCatalog_shopHeadIcon: return @"2/sh/";break;
        case OSSFileCatalog_ownFactory:return @"2/fac/";break;
        case OSSFileCatalog_tradeReply:return @"2/rep/";break;
        case OSSFileCatalog_shopQRCode:return @"2/qr/";break;
        case OSSFileCatalog_shopScenery:return @"2/sr/";break;
        default:
            break;
    }
    return nil;

}

/**
 stsToken方式，公共读上传文件数据

 @param fileCatalog 自定义文件目录，可以是空；
 @param userId 用户id，用于产生唯一的objectKey
 @param data 上传的数据
 */
- (void)putObjectOSSStsTokenPublicBucketWithUserId:(nullable NSString *)userId
                                 customfileCatalog:(nullable NSString *)fileCatalog
                                     uploadingData:(NSData *)data
                                          progress:(nullable OSSNetworkingUploadProgressBlock)progressBlock
                                    singleComplete:(nullable ZXImageUploadSingleCompletedBlock)signleCompleteBlock
                                           failure:(nullable ZXImageUploadFailureBlock)failure
{
      [self putObjectWithUserId:userId bucketName:kOSS_bucketName_public fileCatalog:fileCatalog uploadingData:data progress:progressBlock singleComplete:signleCompleteBlock failure:failure];
}






- (void)putObjectWithUserId:(nullable NSString *)userId
                 bucketName:(NSString *)bucket
                    fileCatalog:(nullable NSString *)fileCatalog
                  uploadingData:(NSData *)data
                       progress:(nullable OSSNetworkingUploadProgressBlock)progressBlock
                 singleComplete:(nullable ZXImageUploadSingleCompletedBlock)signleCompleteBlock
                        failure:(nullable ZXImageUploadFailureBlock)failure
{
    if (!userId)
    {
        return;
    }
    self.bucketName = bucket;

    [self putObjectRequestWithUserId:userId fileCatalog:fileCatalog uploadingData:data progress:progressBlock singleComplete:signleCompleteBlock failure:failure];
}

//明文设置模式;明文设置secret的方式建议只在测试时使用；
- (void)initOSSPlainCredentialWithBucketType:(OSSBucketType)bucketType accessKey:(NSString *)accessKey secretKey:(NSString *)secretKey
{
    if (bucketType ==OSSBucketType_public)
    {
        self.bucketName = kOSS_bucketName_public;
    }
    else
    {
        self.bucketName = kOSS_bucketName_private;
    }
    // 由阿里云颁发的AccessKeyId/AccessKeySecret构造一个CredentialProvider。
    id<OSSCredentialProvider>credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:accessKey secretKey:secretKey];
    
    [self initOSSClientCredentialProvider:credential];
}


//STS鉴权模式凭证-
- (void)initOSSStsTokenCredential
{
    id<OSSCredentialProvider> credential = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * {
        
        //等你 真正开始上传的时候，会回调来获取STS鉴权模式凭证token的block方法
        
        // 构造请求访问您的业务server；
        //构造get请求的url字符串；
        NSString *kBaseURL =[WYUserDefaultManager getkAPP_BaseURL];
        NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/m?",kBaseURL];
       
        NSDictionary *par = [[BaseHttpAPI alloc] addRequestPostData:nil apiName:kOSS_credential_URL];
        [par enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            NSString *str = [NSString stringWithFormat:@"%@=%@&",key,obj];
            [urlString appendString:str];
            
        }];
        NSString *utf8URL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL * url = [NSURL URLWithString:utf8URL];
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        
        OSSTaskCompletionSource * tcs = [OSSTaskCompletionSource taskCompletionSource];
  
        //发送请求
//        NSURLSession * session = [NSURLSession sharedSession];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
        configuration.timeoutIntervalForRequest = 10.f;
        configuration.timeoutIntervalForResource = 20.f;
//        是否允许使用蜂窝网络
        configuration.allowsCellularAccess = YES;
        configuration.networkServiceType = NSURLNetworkServiceTypeDefault;
        
        NSURLSession * session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        
        NSURLSessionTask *sessionTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            // 请求失败
            if (error)
            {
                [tcs setError:error];
                return;
            }
            //请求成功
//            NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
            [tcs setResult:data];
        }];
        
        [sessionTask resume];
        // 需要阻塞等待请求返回
        [tcs.task waitUntilFinished];
        // 解析结果
        if (tcs.task.error) {
            NSLog(@"get token error: %@", tcs.task.error);
            return nil;
        } else {
            // 返回数据是json格式，需要解析得到token的各个字段
            NSDictionary * origObject = [NSJSONSerialization JSONObjectWithData:tcs.task.result
                                                                    options:kNilOptions
                                                                      error:nil];
            //根据公司返回数据要求，解析数据；
            NSDictionary *object = [[origObject objectForKey:@"result"]objectForKey:@"data"];
            OSSFederationToken * token = [OSSFederationToken new];
            token.tAccessKey = [object objectForKey:@"accessKeyId"];
            token.tSecretKey = [object objectForKey:@"accessKeySecret"];
            token.tToken = [object objectForKey:@"securityToken"];
            token.expirationTimeInGMTFormat = [object objectForKey:@"expiration"];
//            NSLog(@"get token: %@", token);
            return token;
        }

    }];
    [self initOSSClientCredentialProvider:credential];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust)
    {
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
    }
}

//初始化OSSClient
- (void)initOSSClientCredentialProvider:(id)credential
{
    //初始化OSSClient
    NSString *endpoint =[NSString stringWithFormat:@"http://%@.aliyuncs.com",kOSS_region];
    
    OSSClientConfiguration * conf = [OSSClientConfiguration new];
    conf.maxRetryCount = 3; // 网络请求遇到异常失败后的重试次数
    conf.timeoutIntervalForRequest = 15; // 网络请求的超时时间
//    conf.timeoutIntervalForResource = 24 * 60 * 60; // 允许资源传输的最长时间
    conf.timeoutIntervalForResource = 20; // 允许资源传输的最长时间 20秒；

    //初始化主要完成Endpoint设置、鉴权方式设置、Client参数设置。其中，鉴权方式包含明文设置模式、自签名模式、STS鉴权模式。
    self.client =  [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential clientConfiguration:conf];
}





- (void)putObjectRequestWithUserId:(nullable NSString *)userId
                       fileCatalog:(nullable NSString *)fileCatalog
                          uploadingData:(NSData *)data
                               progress:(nullable OSSNetworkingUploadProgressBlock)progressBlock
                         singleComplete:(nullable ZXImageUploadSingleCompletedBlock)signleCompleteBlock
                                failure:(nullable ZXImageUploadFailureBlock)failure;

{
    _failuerBlock = [failure copy];
    _uploadProgress = [progressBlock copy];
    _singleCompletedBlock = [signleCompleteBlock copy];
    
    OSSPutObjectRequest *put = [OSSPutObjectRequest new];
    put.bucketName = _bucketName;
    put.objectKey = [self getOSSPutObjectKeyWithUserId:userId fileCatalog:fileCatalog];
    put.uploadingData =data; // 直接上传NSData

    //上传进度
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
        if (progressBlock)
        {
            progressBlock(bytesSent,totalByteSent,totalBytesExpectedToSend);
        }

    };
    //SDK的所有操作都会返回一个OSSTask，您可以为这个task设置一个延续动作，等待其异步完成，也可以通过调用waitUntilFinished阻塞等待其完成
    
    NSAssert(_client, @"没有初始化凭证");
//    NSLog(@"Thread:%@",[NSThread currentThread]);
    dispatch_queue_t currentQueue = dispatch_queue_create("my.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(currentQueue, ^{
        
        OSSTask *putTask = [_client putObject:put];
        [putTask continueWithBlock:^id _Nullable(OSSTask * _Nonnull task) {
            if (!task.error)
            {
                //子线程
                //            NSLog(@"SuccessThread:%@",[NSThread currentThread]);
                
                NSLog(@"uploadObjectSuccess");
                NSString *picString =[NSString stringWithFormat:@"http://%@.%@.aliyuncs.com/%@",_bucketName, kOSS_region,put.objectKey];
                NSLog(@"%@",picString);
                
                if (_getPicInfo)
                {
                    //          signleCompleteBlock(nil,picString,nil);
                    [OSSPicInfoRequest ossGetPicInfoWithBasePicURL:picString sucess:^(id  _Nullable data, CGSize picSize, NSError * _Nullable error) {
                       
                        if (!error)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                NSLog(@"获取图片信息成功，info:%@",data);
                                _singleCompletedBlock (data,picString,picSize);
                            });
                        }
                    }];
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        _singleCompletedBlock (nil,picString,CGSizeZero);
                    });
                }
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                     //应该系分网络好不好；
                    NSLog(@"upload object failed,error:%@,code =%ld",task.error,task.error.code); //请求超时是 6；
                    NSError * error = [self customErrorWithObject:@"上传失败，请稍后再试！" errorCode:task.error.code userInfoErrorCode:nil];

                    failure (error);
                });
            }
            return nil;
        }];
        [putTask waitUntilFinished];

    });
}


//产生唯一的objectKey,如果userId为空，则有可能产生同一个key；
- (NSString *)getOSSPutObjectKeyWithUserId:(nullable NSString *)userId fileCatalog:(nullable NSString *)fileCatalog
{
    
    long long int timevalue = (long long int)([NSDate date].timeIntervalSince1970 * 1000);
    NSNumber *timeNum = [NSNumber numberWithLongLong:timevalue];
    NSString *appendObejectKey = [userId stringByAppendingString:[timeNum stringValue]];
//    NSString *key = [NSString zhCreatedMD5:appendObejectKey];
//    NSString *userId_16 = [NSString zhHexStringFromString:userId];
//    NSLog(@"%@,%@",userId_16,userId);
    if (!fileCatalog)
    {
        return [appendObejectKey stringByAppendingString:@".jpg"];
    }
    return [NSString stringWithFormat:@"%@%@.jpg",fileCatalog,appendObejectKey];
}


//自定义NSError错误信息
- (NSError *)customErrorWithObject:(NSString *)object errorCode:(NSInteger)code userInfoErrorCode:(nullable NSString *)errorCode;

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
    NSError * error = [NSError errorWithDomain:APP_bundleIdentifier code:code userInfo:userInfo];
    return error;
}

@end
