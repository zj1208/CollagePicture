//
//  AliOSSUploadManager.h
//  YiShangbao
//
//  Created by simon on 17/2/10.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  简介：通过OSS控制台上传小于 5GB 的文件。通过SDK或API使用Multipart Upload的分片上传方法，可以上传大于 5GB 的文件，分片上传 最大支持 48.8TB 的对象大小；
//  注意：如果上传的文件与存储空间中已有的文件重名，则会覆盖已有文件。

//  待优化：（1）如果没有文件目录;文件名末尾默认以jpg结尾；
//    （2）如果视频目录，则mp4结尾；

//  2018.3.30 添加注释
//  2018.4.08；新增图片按时间排序
//  2018.5.25；block循坏引用



#import <Foundation/Foundation.h>
#import <AliyunOSSiOS/OSSService.h>
#import "ZXPhoto.h"


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
    OSSFileCatalog_MakeBill = 10,//开单
    OSSFileCatalog_uploadProductPicText = 11, //上传产品图文详情

};

/*
私有：只有该存储空间的拥有者可以对该存储空间内的文件进行读写操作，其他人无法访问该存储空间内的文件。
公共读：只有该存储空间的拥有者可以对该存储空间内的文件进行写操作，任何人（包括匿名访问者）可以对该存储空间中的文件进行读操作。
公共读写：任何人（包括匿名访问者）都可以对该存储空间中的文件进行读写操作。所有这些操作产生的费用由该存储空间的拥有者承担，请慎用该权限。
bucket：
 只能包括小写字母，数字和短横线（-）。
 必须以小写字母或者数字开头。
 长度必须在3-63字节之间。
*/

//公有读bucket存储空间－自己定义的bucket命名
static NSString *const kOSS_bucketName_public = @"public-read-bkt-oss";
//私有读bucket存储空间－自己定义的bucket命名
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

// 存储空间名字
@property (nonatomic, copy) NSString *bucketName;

//设置是否获取图片详细信息，如果不获取，返回的成功block则没有详细信息，只有imagePath路径地址
@property (nonatomic, assign)BOOL getPicInfo;

+ (instancetype)sharedInstance;



/**
 明文设置模式;明文设置secret的方式建议只在测试时使用；

 @param bucketType bucket存储空间类型
 @param accessKey  权限key
 @param secretKey  secret密码
 */
- (void)initOSSPlainCredentialWithBucketType:(OSSBucketType)bucketType accessKey:(NSString *)accessKey secretKey:(NSString *)secretKey __attribute__((deprecated("We recommend the STS authentication mode on mobile")));


// STS鉴权模式凭证，实现获取STSToken回调；自动更新；
// 从服务端请求获取到信息－构造一个OSSFederationToken对象，再返回给aliOSS；
- (void)initAliOSSWithSTSTokenCredential;


/**
 利用sts鉴权模式（这个方法会自动更新token），
 在指定公共读bucket存储区域存储，在主目录上简单上传data数据；
 
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
 在指定公共读bucket存储区域存储，在指定文件目录上简单上传data数据；
 
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
 在指定公共读bucket存储区域存储，在自定义文件目录上简单上传data数据；
 
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
 @param bucket bucket存储空间名
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

//============================
/**
 根据本地上传的图片以UserID+time的图片命名方式上传中末尾时间戳排序，如不符合相关规则，则不排序返回原数组
 eg: http://public-read-bkt-oss.oss-cn-hangzhou.aliyuncs.com/2/sp/93a0897ab5823be48d812025abd427eb1522397528846.jpg;
 */
//+ (NSArray *)sortAliOSSImage_UserID_time_WithModelArr:(NSArray<__kindof AliOSSPicUploadModel *> *)array;
+ (NSArray *)sortAliOSSImage_UserID_time_WithPhotoModelArr:(NSArray<__kindof ZXPhoto*> *)array;
+ (NSArray *)sortAliOSSImage_UserID_time_WithStringArr:(NSArray<__kindof NSString *> *)array;

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
        [MBProgressHUD zx_hideHUDForView:weakSelf.view];

    } failure:^(NSError *error) {
        
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

 */
