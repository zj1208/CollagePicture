//
//  AliOSSUploadManager.m
//  YiShangbao
//
//  Created by simon on 17/2/10.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "AliOSSUploadManager.h"
#import "AliOSSPicInfoRequest.h"
#import "BaseHttpAPI.h" //需要请求自己公司服务器，加密

#ifndef APP_bundleIdentifier
#define APP_bundleIdentifier [[NSBundle mainBundle]bundleIdentifier]
#endif

@interface AliOSSUploadManager ()<NSURLSessionTaskDelegate>

@property (nullable, nonatomic, copy) ZXImageUploadFailureBlock failuerBlock;
@property (nullable, nonatomic, copy) ZXImageUploadSingleCompletedBlock singleCompletedBlock;
@property (nullable, nonatomic, copy) OSSNetworkingUploadProgressBlock uploadProgress;

//获取文件目录
- (NSString *)getFileCatalogWithType:(OSSFileCatalog)type;
@end

@implementation AliOSSUploadManager

- (void)setGetPicInfo:(BOOL)getPicInfo
{
    if (_getPicInfo != getPicInfo)
    {
        _getPicInfo = getPicInfo;
    }
}

+ (instancetype)sharedInstance
{
    static id manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[self alloc] init];
        
    });
    return manager;
}


#pragma mark - 明文模式凭证初始化
//明文设置模式;明文设置secret的方式建议只在测试时使用；
- (void)initOSSPlainCredentialWithBucketType:(OSSBucketType)bucketType accessKey:(NSString *)accessKey secretKey:(NSString *)secretKey
{
    if (bucketType ==OSSBucketType_public)
    {
        self.bucketName = kOSS_bucketName_public_read;
    }
    else
    {
        self.bucketName = kOSS_bucketName_private;
    }
    // 由阿里云颁发的AccessKeyId/AccessKeySecret构造一个CredentialProvider。
    id<OSSCredentialProvider>credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:accessKey secretKey:secretKey];
    
    [self initOSSClientCredentialProvider:credential];
}

#pragma mark - STS鉴权模式凭证初始化
// STS鉴权模式凭证，实现获取STSToken回调；自动更新；
// 从服务端请求获取到信息－构造一个OSSFederationToken对象，再返回给aliOSS；
// STS优点：您无需透露您的长期密钥(AccessKey)给第三方应用，只需生成一个访问令牌并将令牌交给第三方应用即可。这个令牌的访问权限及有效期限都可以由您自定义。您无需关心权限撤销问题，访问令牌过期后就自动失效。
- (void)initAliOSSWithSTSTokenCredential
{
    id<OSSCredentialProvider> credential = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * {
        
        NSLog(@"测试，是否oss在后台偷偷请求调用");
        //等你 真正开始上传的时候，会回调来获取STS鉴权模式凭证token的block方法
        
        // 构造请求访问您的业务server；
        // 构造get请求的url字符串；
        NSString *kBaseURL =[WYUserDefaultManager getkAPP_BaseURL];
        NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/m?",kBaseURL];
        
        NSDictionary *par = [[BaseHttpAPI alloc] addRequestPostData:nil apiName:kOSS_credential_URL];
        [par enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            NSString *str = [NSString stringWithFormat:@"%@=%@&",key,obj];
            [urlString appendString:str];
            
        }];
        NSString *utf8Str = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL * url = [NSURL URLWithString:utf8Str];
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

#pragma mark - 初始化OSSClient
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








#pragma mark - 简单上传 公有读bucket存储空间

//没有文件目录
- (void)putOSSObjectSTSTokenInPublicBucketWithUserId:(nullable NSString *)userId
                                       uploadingData:(NSData *)data
                                            progress:(nullable OSSNetworkingUploadProgressBlock)progressBlock
                                      singleComplete:(nullable ZXImageUploadSingleCompletedBlock)signleCompleteBlock
                                             failure:(nullable ZXImageUploadFailureBlock)failure
{
    
    
    [self putObjectWithUserId:userId bucketName:kOSS_bucketName_public_read fileCatalog:nil uploadingData:data progress:progressBlock singleComplete:signleCompleteBlock failure:failure];
}

//多了指定文件目录类型
- (void)putOSSObjectSTSTokenInPublicBucketWithUserId:(nullable NSString *)userId
                                     fileCatalogType:(OSSFileCatalog)fileCatalog
                                       uploadingData:(NSData *)data
                                            progress:(nullable OSSNetworkingUploadProgressBlock)progressBlock
                                      singleComplete:(nullable ZXImageUploadSingleCompletedBlock)signleCompleteBlock
                                             failure:(nullable ZXImageUploadFailureBlock)failure
{
    
    NSString *fileType = [self getFileCatalogWithType:fileCatalog];
    [self putObjectWithUserId:userId bucketName:kOSS_bucketName_public_read fileCatalog:fileType uploadingData:data progress:progressBlock singleComplete:signleCompleteBlock failure:failure];
    
}

//自定义文件目录
- (void)putOSSObjectSTSTokenInPublicBucketWithUserId:(nullable NSString *)userId
                                 customfileCatalog:(nullable NSString *)fileCatalog
                                     uploadingData:(NSData *)data
                                          progress:(nullable OSSNetworkingUploadProgressBlock)progressBlock
                                    singleComplete:(nullable ZXImageUploadSingleCompletedBlock)signleCompleteBlock
                                           failure:(nullable ZXImageUploadFailureBlock)failure
{
      [self putObjectWithUserId:userId bucketName:kOSS_bucketName_public_read fileCatalog:fileCatalog uploadingData:data progress:progressBlock singleComplete:signleCompleteBlock failure:failure];
}




#pragma mark -简单上传 指定初始化
/**
 最原始的简单上传；铭文／sts都用这个方法上传；
 
 @param userId 用户id
 @param bucket bucket存储空间；公有/私有
 @param fileCatalog 文件目录，可以是空
 @param data 上传的数据
 @param progressBlock 上传返回的进度
 @param signleCompleteBlock 上传成功block返回
 @param failure 失败block返回
 */
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






- (void)putObjectRequestWithUserId:(nullable NSString *)userId
                       fileCatalog:(nullable NSString *)fileCatalog
                          uploadingData:(NSData *)data
                               progress:(nullable OSSNetworkingUploadProgressBlock)progressBlock
                         singleComplete:(nullable ZXImageUploadSingleCompletedBlock)signleCompleteBlock
                                failure:(nullable ZXImageUploadFailureBlock)failure;

{
    self.failuerBlock = failure;
    self.uploadProgress = progressBlock;
    self.singleCompletedBlock = signleCompleteBlock;
    
    // 对象由元信息（Object Meta），用户数据（Data）和文件名（Key）组成；由存储空间内部唯一的 Key 来标识。对象元信息是一个键值对，表示了对象的一些属性，比如最后修改时间、大小等信息，同时用户也可以在元信息中存储一些自定义的信息。
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
    __weak typeof (self) weakSelf = self;
//    NSLog(@"Thread:%@",[NSThread currentThread]);
    dispatch_queue_t currentQueue = dispatch_queue_create("my.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(currentQueue, ^{
        
        OSSTask *putTask = [weakSelf.client putObject:put];
        [putTask continueWithBlock:^id _Nullable(OSSTask * _Nonnull task) {
            if (!task.error)
            {
                //子线程
                //            NSLog(@"SuccessThread:%@",[NSThread currentThread]);
                
                NSLog(@"uploadObjectSuccess");
                NSString *picString =[NSString stringWithFormat:@"http://%@.%@.aliyuncs.com/%@",weakSelf.bucketName, kOSS_region,put.objectKey];
                NSLog(@"%@",picString);
                
                if (weakSelf.getPicInfo)
                {
                    //          signleCompleteBlock(nil,picString,nil);
                    [AliOSSPicInfoRequest ossGetPicInfoWithBasePicURL:picString sucess:^(id  _Nullable data, CGSize picSize, NSError * _Nullable error) {
                       
                        if (!error)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                NSLog(@"获取图片信息成功，info:%@",data);
                                weakSelf.singleCompletedBlock (data,picString,picSize);
                            });
                        }
                    }];
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        weakSelf.singleCompletedBlock (nil,picString,CGSizeZero);
                    });
                }
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                     //应该系分网络好不好；
                    NSLog(@"upload object failed,error:%@,code =%ld",task.error,task.error.code); //请求超时是 6；
                    NSError * error = [weakSelf customErrorWithObject:@"上传失败，请稍后再试！" errorCode:task.error.code userInfoErrorCode:nil];

                    failure (error);
                });
            }
            return nil;
        }];
        [putTask waitUntilFinished];

    });
}

- (NSString *)getFileCatalogWithType:(OSSFileCatalog)type
{
    
    switch (type)
    {
        case OSSFileCatalog_userHeadIcon:   return @"2/head/"; break;
        case OSSFileCatalog_uploadProduct:  return @"2/pro/";  break;
        case OSSFileCatalog_shopHeadIcon:   return @"2/sh/";   break;
        case OSSFileCatalog_ownFactory:     return @"2/fac/";  break;
        case OSSFileCatalog_tradeReply:     return @"2/rep/";  break;
        case OSSFileCatalog_shopQRCode:     return @"2/qr/";   break;
        case OSSFileCatalog_shopScenery:    return @"2/sr/";   break;
        case OSSFileCatalog_ProductVideo:   return @"2/pvi/";  break;
        case OSSFileCatalog_ProductExtend:  return @"2/sp/";   break;
        case OSSFileCatalog_ProductExtendStock: return @"2/ss/"; break;
        case OSSFileCatalog_MakeBill: return @"2/bill/"; break;
        case OSSFileCatalog_uploadProductPicText: return @"2/grap/";break;
        default:
            break;
    }
    return nil;
    
}

// 产生唯一的objectKey；自定义方法自己构造，如果userId为空，则有可能产生同一个key；
// 如果没有文件目录，默认.jpg结尾； 如果
/*
对象的命名规范如下：
使用UTF-8编码。
长度必须在1-1023字节之间。
不能以“/”或者“\”字符开头。
 */
- (NSString *)getOSSPutObjectKeyWithUserId:(nullable NSString *)userId fileCatalog:(nullable NSString *)fileCatalog
{
    
    long long int timevalue = (long long int)([NSDate date].timeIntervalSince1970 * 1000);
    NSNumber *timeNum = [NSNumber numberWithLongLong:timevalue];
    NSString *appendObejectKey = [userId stringByAppendingString:[timeNum stringValue]];//userId+时间(保留三位小数再乘1000) = 图片名称
//    NSString *key = [NSString zhCreatedMD5:appendObejectKey];
//    NSString *userId_16 = [NSString zhHexStringFromString:userId];
//    NSLog(@"%@,%@",userId_16,userId);
    
    //  如果是视频目录
    NSString *videoFile = [self getFileCatalogWithType:OSSFileCatalog_ProductVideo];
    //  如果没有文件目录;文件名末尾默认以jpg结尾；待优化；
    if (!fileCatalog)
    {
        return [appendObejectKey stringByAppendingString:@".jpg"];
    }
   //   如果视频目录，则mp4结尾；待优化；
    else if ([fileCatalog isEqualToString:videoFile])
    {
        return [NSString stringWithFormat:@"%@%@.mp4",fileCatalog,appendObejectKey];
    }
    return [NSString stringWithFormat:@"%@%@.jpg",fileCatalog,appendObejectKey];
}
//对上面👆[userId stringByAppendingString:[timeNum stringValue]拼接的字符串数组按末尾时间戳排序
//eg: XX93a0897ab5823be48d812025abd427eb1522394434132.jpg
/*
+ (NSArray *)sortAliOSSImage_UserID_time_WithModelArr:(NSArray<__kindof AliOSSPicUploadModel *> *)array
{
    NSMutableArray* arraySort = [NSMutableArray arrayWithArray:array];
    for (int i=0; i<arraySort.count; ++i)
    {
        AliOSSPicUploadModel *model_i = arraySort[i];
        NSArray *arr_i = [model_i.p componentsSeparatedByString:@"."];//.jpg
        NSString* imageP_i = arr_i.count>1?arr_i[arr_i.count-2]:nil;
        if (imageP_i.length <13)
        { //暂时只取末尾13位
            return array; //一旦图片名称长度有异常不排序了，返回原数组
        }
        NSRange range_i = NSMakeRange(imageP_i.length-13, 13);
        NSString* subthr_i = [imageP_i substringWithRange:range_i];
        if (![NSString zhIsIntScan:subthr_i]) {//非存数字
            return array;
        }
        long long int integer_i = subthr_i.longLongValue;
        for (int j=i+1; j<arraySort.count; ++j)
        {
            AliOSSPicUploadModel *model_j = arraySort[j];
            NSArray *arr_j = [model_j.p componentsSeparatedByString:@"."];
            NSString* imageP_j = arr_j.count>1?arr_j[arr_j.count-2]:nil;
            if (imageP_j.length <13)
            {
                return array;
            }
            NSRange range_j = NSMakeRange(imageP_j.length-13, 13);
            NSString* subthr_j = [imageP_j substringWithRange:range_j];
            if (![NSString zhIsIntScan:subthr_j]) {
                return array;
            }
            long long int integer_j = subthr_j.longLongValue;
            if (integer_i >integer_j) {
                [arraySort exchangeObjectAtIndex:j withObjectAtIndex:i];
            }
        }
    }
    NSLog(@"=====\n%@\n====\n%@\n",array,arraySort);
    return arraySort;
}
 */
+(NSArray *)sortAliOSSImage_UserID_time_WithPhotoModelArr:(NSArray<__kindof ZXPhoto*> *)array
{
    NSMutableArray* arraySort = [NSMutableArray arrayWithArray:array];
    for (int i=0; i<arraySort.count; ++i)
    {
        ZXPhoto *model_i = arraySort[i];
        NSArray *arr_i = [model_i.original_pic componentsSeparatedByString:@"."];//.jpg
        NSString* imageP_i = arr_i.count>1?arr_i[arr_i.count-2]:nil;
        if (imageP_i.length <13){ //暂时只取末尾13位
            return array; //一旦图片名称长度有异常不排序了，返回原数组
        }
        NSRange range_i = NSMakeRange(imageP_i.length-13, 13);
        NSString* subthr_i = [imageP_i substringWithRange:range_i];
        if (![NSString zhIsIntScan:subthr_i]) {//非存数字
            return array;
        }
        long long int integer_i = subthr_i.longLongValue;
        for (int j=i+1; j<arraySort.count; ++j)
        {
            ZXPhoto *model_j = arraySort[j];
            NSArray *arr_j = [model_j.original_pic componentsSeparatedByString:@"."];
            NSString* imageP_j = arr_j.count>1?arr_j[arr_j.count-2]:nil;
            if (imageP_j.length <13)
            {
                return array;
            }
            NSRange range_j = NSMakeRange(imageP_j.length-13, 13);
            NSString* subthr_j = [imageP_j substringWithRange:range_j];
            if (![NSString zhIsIntScan:subthr_j]) {
                return array;
            }
            long long int integer_j = subthr_j.longLongValue;
            if (integer_i >integer_j) {
                [arraySort exchangeObjectAtIndex:j withObjectAtIndex:i];
            }
        }
    }
    NSLog(@"=====\n%@\n====\n%@\n",array,arraySort);
    return arraySort;
}
+ (NSArray *)sortAliOSSImage_UserID_time_WithStringArr:(NSArray<__kindof NSString *> *)array
{
    NSMutableArray* arraySort = [NSMutableArray arrayWithArray:array];
    for (int i=0; i<arraySort.count; ++i) {
        NSString *str_i = arraySort[i];
        NSArray *arr_i = [str_i componentsSeparatedByString:@"."];//.jpg
        NSString* imageP_i = arr_i.count>1?arr_i[arr_i.count-2]:nil;
        if (imageP_i.length <13) { //暂时只取末尾13位
            return array; //一旦图片名称长度有异常不排序了，返回原数组
        }
        NSRange range_i = NSMakeRange(imageP_i.length-13, 13);
        NSString* subthr_i = [imageP_i substringWithRange:range_i];
        if (![NSString zhIsIntScan:subthr_i]) {//非存数字
            return array;
        }
        long long int integer_i = subthr_i.longLongValue;
        for (int j=i; j<arraySort.count; ++j) {
            NSString *str_j = arraySort[j];
            NSArray *arr_j = [str_j componentsSeparatedByString:@"."];
            NSString* imageP_j = arr_j.count>1?arr_j[arr_j.count-2]:nil;
            if (imageP_j.length <13) {
                return array;
            }
            NSRange range_j = NSMakeRange(imageP_j.length-13, 13);
            NSString* subthr_j = [imageP_j substringWithRange:range_j];
            if (![NSString zhIsIntScan:subthr_j]) {
                return array;
            }
            long long int integer_j = subthr_j.longLongValue;
            if (integer_i >integer_j) {
                [arraySort exchangeObjectAtIndex:j withObjectAtIndex:i];
            }
        }
    }
    NSLog(@"=====\n%@\n====\n%@\n",array,arraySort);
    return arraySort;
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
