//
//  AliOSSUploadManager.h
//  YiShangbao
//
//  Created by simon on 17/2/10.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  简介：通过OSS控制台上传小于 5GB 的文件。通过SDK或API使用Multipart Upload的分片上传方法，可以上传大于 5GB 的文件，分片上传 最大支持 48.8TB 的对象大小；
/*
    在 OSS 中，操作的基本数据单元是文件（Object）。OSS iOS SDK提供了以下三种文件上传方式：
简单上传：包括从内存中上传或上传本地文件。最大不能超过 5GB。
分片上传：当文件较大时，可以使用分片上传，最大不能超过48.8TB。
追加上传：最大不能超过 5GB。
断点续传上传：支持并发上传、自定义分片大小。大文件上传推荐使用断点续传。最大不能超过 48.8TB。
*/
//  注意：如果上传的文件与存储空间中已有的文件重名，则会覆盖已有文件。

//  待优化：（1）如果没有文件目录;文件名末尾默认以jpg结尾；
//    （2）如果视频目录，则mp4结尾；

//  2018.3.30 添加注释
//  2018.4.08；新增图片按时间排序
//  2018.5.25；block循坏引用
//  2019.5.09 添加注释



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
临时凭证授权的上传
具体步骤如下：
1.客户端向应用服务器发出上传文件到OSS的请求。
2.应用服务器向STS服务器请求一次，获取临时凭证。包括一个安全令牌（SecurityToken）、临时访问密钥（AccessKeyId, AccessKeySecret）以及过期时间。
3.应用服务器回复客户端，将临时凭证返回给客户端。ClientApp 可以缓存这个凭证。当凭证失效时，ClientApp 需要向 AppServer 申请新的有效访问凭证。比如，访问凭证有效期为1小时，那么 ClientApp 可以每 30 分钟向 AppServer 请求更新访问凭证。
4.客户端获取上传到OSS的授权（STS的AccessKey以及Token），用属性构造STS鉴权模式凭证；ClientApp使用本地缓存的访问凭证去请求 Aliyun Service API。云服务会感知 STS 访问凭证，并会依赖 STS 服务来验证访问凭证，然后利用这个凭证属性调用OSS提供的移动端SDK上传。
5.客户端成功上传数据到OSS。如果没有设置回调，则流程结束。如果设置了回调功能，OSS会调用相关的接口。
*/

/*
Bucket权限控制
OSS提供ACL（Access Control List）权限控制方法，OSS ACL提供Bucket级别的权限访问控制，Bucket目前有三种访问权限：public-read-write，public-read和private，它们的含义如下：
私有读写：只有该存储空间的拥有者可以对该存储空间内的文件进行读写操作，其他人无法访问该存储空间内的文件。
公共读，私有写：只有该存储空间的拥有者可以对该存储空间内的文件进行写操作，任何人（包括匿名访问者）可以对该存储空间中的文件进行读操作。
公共读写：任何人（包括匿名访问者）都可以对该存储空间中的文件进行读写操作。所有这些操作产生的费用由该存储空间的拥有者承担，请慎用该权限。
bucket：
 只能包括小写字母，数字和短横线（-）。
 必须以小写字母或者数字开头。
 长度必须在3-63字节之间。
*/

//公有读，私有写；bucket存储空间－自己定义的bucket命名
static NSString *const kOSS_bucketName_public_read = @"public-read-bkt-oss";
//私有读写bucket存储空间－自己定义的bucket命名
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
// 通过STS，您可以为第三方应用或子用户（即用户身份由您自己管理的用户）颁发一个自定义时效和权限的访问凭证。
- (void)initAliOSSWithSTSTokenCredential;


#pragma PutObject 简单上传

/**
 利用sts鉴权模式（这个方法会自动更新token），
 在指定公共读bucket存储区域存储，在主目录上简单上传data数据；
 
 @param userId 用户id，用于产生唯一的objectKey
 @param data 上传的数据
 @param progressBlock 上传进度回调,子线程异步回调；
 @param signleCompleteBlock  上传完成回调，主线程；
 @param failure  上传失败回调，主线程；
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
 最原始的简单上传；铭文／sts都用这个方法上传；OSSPutObjectRequest构造需要上传的bucket，Object（文件目录+用户id+时间戳+.jpg/.mp4），uploadingData；

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

//1.简单上传：
//简单上传指的是使用OSS API中的PutObject方法上传单个文件（Object）。简单上传适用于一次HTTP请求交互即可完成上传的场景，比如小文件（小于5GB）的上传。

//2.追加上传：
/*
简单上传，表单上传，断点续传上传等创建的Object都是Normal类型，这种Object在上传结束之后内容就是固定的，只能读取，不能修改。如果Object内容发生了改变，只能重新上传同名的Object来覆盖之前的内容，这也是OSS和普通文件系统使用的一个重大区别。

正因为这种特性，在很多应用场景下会很不方便，比如视频监控、视频直播领域等，视频数据在实时的不断产生。如果使用其他上传方式，只能将视频流按照一定规律切分成小块然后不断的上传新的Object。这种方式在实际使用上存在很明显的缺点：

软件架构比较复杂，需要考虑文件分块等细节问题。
需要有位置保存元信息，比如已经生成的Object列表等，然后每次请求都重复读取元信息来判断是否有新的Object生成。这样对服务器的压力很大，而且客户端每次都需要发送两次网络请求，延时上也会有一定的影响。
如果Object切分的比较小的话，延时比较低，但是众多Object会导致管理起来很复杂。如果Object切分的比较大的话，数据的延时又会很高。
为了简化这种场景下的开发成本，OSS提供了追加上传（Append Object）的方式在一个Object后面直接追加内容的功能。通过这种方式操作的Object的类型为Appendable Object，而其他的方式上传的Object类型为Normal Object。每次追加上传的数据都能够即时可读。

如果使用追加上传，那么上述场景的架构就变得很简单。视频数据产生之后即时地通过追加上传到同一个Object，而客户端只需要定时获取该Object的长度与上次读取的长度进行对比，如果发现有新的数据可读，那么就触发一次读操作来获取新上传的数据部分即可。通过这种方式可以很大的简化架构，增强扩展性。
*/

//3.分片上传，断点续传：https://www.alibabacloud.com/help/zh/doc-detail/31850.htm?spm=a2c63.p38356.b99.51.7d0111801YFj8r
/*
将要上传的文件分成多个数据块（OSS里又称之为Part）来分别上传，上传完成之后再调用OSS的接口将这些Part组合成一个Object来达到断点续传的效果。
 当使用简单上传（PutObject）功能来上传较大的文件到OSS的时候，如果上传的过程中出现了网络错误，那么此次上传失败，重试必须从文件起始位置上传。针对这种情况，您可以使用分片上传来达到断点续传的效果。
 
 分片上传：
 
 相对于其他的上传方式，分片上传适用于以下场景：
 恶劣的网络环境：如手机端，当出现上传失败的时候，可以对失败的Part进行独立的重试，而不需要重新上传其他的Part。
 断点续传：中途暂停之后，可以从上次上传完成的Part的位置继续上传。
 加速上传：要上传到OSS的本地文件很大的时候，可以并行上传多个Part以加快上传。
 流式上传：可以在需要上传的文件大小还不确定的情况下开始上传。这种场景在视频监控等行业应用中比较常见。
 
 分片上传的基本流程如下：
 将要上传的文件按照一定的大小分片。
 初始化一个分片上传任务（InitiateMultipartUpload）。
 逐个或并行上传分片（UploadPart）。
 完成上传（CompleteMultipartUpload）。
 
 断点续传操作方式
 
 在使用分片上传的过程中，如果系统意外崩溃，可以在重启的时候通过ListMultipartUploads和ListParts两个接口来获取某个Object上的所有的分片上传任务和每个分片上传任务中上传成功的Part列表。这样就可以从最后一块成功上传的Part开始继续上传，从而达到断点续传的效果。暂停和恢复上传实现原理也是一样的。
*/
