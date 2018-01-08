//
//  AliOSSUploadManager.h
//  YiShangbao
//
//  Created by simon on 17/2/10.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AliyunOSSiOS/OSSService.h>

// 2017.12.29
// 修改单列方法名字；

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, OSSBucketType)
{
    OSSBucketType_public =0,
    OSSBucketType_private = 1
};

typedef NS_ENUM(NSInteger, OSSFileCatalog){
    
    OSSFileCatalog_uploadProduct = 0, //上传产品
    OSSFileCatalog_shopScenery = 1,//商铺实景
    OSSFileCatalog_shopHeadIcon = 2,//商铺头像
    OSSFileCatalog_ownFactory =3,//经验工厂
    OSSFileCatalog_tradeReply =4,//生意回复求购
    OSSFileCatalog_shopQRCode = 5,//二维码
    OSSFileCatalog_userHeadIcon =6, //用户app头像
    OSSFileCatalog_ProductVideo =7, //产品视频
    OSSFileCatalog_ProductExtend =8, //产品推广
    OSSFileCatalog_ProductExtendStock =9, //产品推广库存

    
};


//公有读bucket存储空间－修改后的
static NSString *const kOSS_bucketName_public = @"public-read-bkt-oss";
//私有读bucket存储空间
static NSString *const kOSS_bucketName_private = @"private-read-bkt";

static NSString *const kOSS_region = @"oss-cn-hangzhou";

//从服务端请求获取到信息－OSSFederationToken，再传给alioss
static NSString *const kOSS_credential_URL = @"mtop.oss.getSts";


/**
 *  上传单个成功
 *
 *  @param imageInfo     成功上传的图片信息
 *  @param imagePath 图片http地址
 *  @param imageSize     图片size
 */
typedef void(^ZXImageUploadSingleCompletedBlock) (id _Nullable imageInfo, NSString* _Nullable imagePath,CGSize imageSize);
typedef void (^ZXImageUploadFailureBlock)(NSError * _Nullable error);

 
@interface AliOSSUploadManager : NSObject

@property (nonatomic, strong) OSSClient *client;

@property (nonatomic, copy) NSString *bucketName;

//设置是否获取图片详细信息，如果不获取，返回的成功block则没有详细信息，只有imagePath路径地址
@property (nonatomic, assign)BOOL getPicInfo;

+ (instancetype)sharedInstance;



/**
 明文设置模式;明文设置secret的方式建议只在测试时使用；

 @param bucketType bucket存储空间
 @param accessKey  权限key
 @param secretKey  secret密码
 */
- (void)initOSSPlainCredentialWithBucketType:(OSSBucketType)bucketType accessKey:(NSString *)accessKey secretKey:(NSString *)secretKey __attribute__((deprecated("We recommend the STS authentication mode on mobile")));


// STS鉴权模式凭证，实现获取STSToken回调；自动更新；
// 从服务端请求获取到信息－构造一个OSSFederationToken对象，再返回给aliOSS；
- (void)initAliOSSWithSTSTokenCredential;


/**
 利用sts鉴权模式（这个方法会自动更新token），
 在指定公共读bucket区域存储，在主目录上简单上传data数据；
 
 @param userId 用户id，用于产生唯一的objectKey
 @param data 上传的数据
 */
- (void)putOSSObjectSTSTokenInPublicBucketWithUserId:(nullable NSString *)userId
                                     uploadingData:(NSData *)data
                                          progress:(nullable OSSNetworkingUploadProgressBlock)progressBlock
                                    singleComplete:(nullable ZXImageUploadSingleCompletedBlock)signleCompleteBlock
                                           failure:(nullable ZXImageUploadFailureBlock)failure;


/**
 利用sts鉴权模式（这个方法会自动更新token），
 在指定公共读bucket区域存储，在指定文件目录上简单上传data数据；
 
 @param fileCatalog 指定文件目录；
 @param userId 用户id，用于产生唯一的objectKey
 @param data 上传的数据
 */

- (void)putOSSObjectSTSTokenInPublicBucketWithUserId:(nullable NSString *)userId
                                   fileCatalogType:(OSSFileCatalog)fileCatalog
                                     uploadingData:(NSData *)data
                                          progress:(nullable OSSNetworkingUploadProgressBlock)progressBlock
                                    singleComplete:(nullable ZXImageUploadSingleCompletedBlock)signleCompleteBlock
                                           failure:(nullable ZXImageUploadFailureBlock)failure;

/**
 利用sts鉴权模式（这个方法会自动更新token），
 在指定公共读bucket区域存储，在自定义文件目录上简单上传data数据；
 
 @param fileCatalog 自定义文件目录，可以是空；
 @param userId 用户id，用于产生唯一的objectKey
 @param data 上传的数据
 */
- (void)putOSSObjectSTSTokenInPublicBucketWithUserId:(nullable NSString *)userId
                                   customfileCatalog:(nullable NSString *)fileCatalog
                                     uploadingData:(NSData *)data
                                          progress:(nullable OSSNetworkingUploadProgressBlock)progressBlock
                                    singleComplete:(nullable ZXImageUploadSingleCompletedBlock)signleCompleteBlock
                                           failure:(nullable ZXImageUploadFailureBlock)failure;


/**
 最原始的简单上传；铭文／sts都用这个方法上传；

 @param userId 用户id
 @param bucket bucket存储空间
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
                    failure:(nullable ZXImageUploadFailureBlock)failure;

@end

NS_ASSUME_NONNULL_END

/*
//初始化照片／拍照选择
ZXImagePickerVCManager *pickerVCManager = [[ZXImagePickerVCManager alloc] init];
pickerVCManager.morePickerActionDelegate = self;
self.imagePickerVCManager = pickerVCManager;
//初始化oss上传
[[AliOSSUploadManager sharedInstance] initAliOSSWithSTSTokenCredential];


- (void)zxImagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info withEditedImage:(UIImage *)image
{
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    [self zhHUD_showHUDAddedTo:self.view labelText:@"正在上传"];
    WS(weakSelf);
    [[AliOSSUploadManager sharedInstance]putOSSObjectSTSTokenInPublicBucketWithUserId:USER_TOKEN uploadingData:imageData progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        
    } singleComplete:^(id model, NSString *imageName, NSNumber *imgId) {
        
        //这里处理上传图片
        [weakSelf zhHUD_hideHUDForView:self.view];
        
    } failure:^(NSError *error) {
        
        [weakSelf zhHUD_showErrorWithStatus:[error localizedDescription]];
    }];
}

 */
