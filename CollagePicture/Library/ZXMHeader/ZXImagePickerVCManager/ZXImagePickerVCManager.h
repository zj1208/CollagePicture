//
//  ZXImagePickerVCManager.h
//  Baby
//
//  Created by simon on 16/4/19.
//  Copyright © 2016年 simon. All rights reserved.
//
//  简介：相册，相机调用的管理类，支持权限检查及提示，当没有权限的时候会自动弹出默认引导提示;

//  注意：必须在info.plist文件中添加三个隐私权限提示key-value；
//  key:   Privacy - NSPhotoLibraryAdditionsUsageDescription; 存照片权限；
//  value：若不允许，你将无法在义采宝中发送及保存照片；
//  key: Privacy - NSPhotoLibraryUsageDescription 读照片权限；
//  value：若不允许，你将无法在义采宝中保存照片；
//  key: Privacy - Camera Usage Description  相机拍照权限
//  value：用于扫描商铺二维码进商铺首页，和拍摄图片、视频以供上传；

/// 注意：如果加入了这个类，则必须添加隐私权限key-value；从2019年春季开始，如果应用程序的代码引用一个或多个访问敏感用户数据的api，所有提交到App Store的访问用户数据的应用程序都必须包含一个目的字符串。如果您正在使用外部库或sdk，它们可能会引用需要目的字符串的api。虽然您的应用程序可能不使用这些api，但仍然需要一个目的字符串。

//  待优化：如果是调用第三方相册选择器，该怎么用？


//  2018.3.28； 优化代码；
//  2019.4.04； 优化代码；
//  4.18 增加权限检查及提示的管理器；

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 参考云信封装-NIMKitPhotoFetcher；
//#import "ImagePickerViewController.h"

NS_ASSUME_NONNULL_BEGIN


/**
 相册选择列表类型
 */
typedef NS_ENUM(NSInteger, PhotosAlbumListType)
{
    PhotosAlbumListType_system = 0, // UIImagePickerControllerSourceTypeSavedPhotosAlbum系统相册；
    PhotosAlbumListType_custom = 1  // 自定义列表，可多选; 跳转到封装的多选照片控制器；
};

@protocol ZXImagePickerVCManagerDelegate <NSObject>

@optional
/**
 *  ZXImagePickerVCManager的协议,拍照返回的一张照片回调代理；
 *
 *  @param picker  UIImagePickerController
 *  @param info   选择之后的媒体信息
 *  @param image  选择之后的源图片，如果有裁剪，就是裁减后的图片；
 */
- (void)zxImagePickerController:(UIImagePickerController *)picker
  didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
                withEditedImage:(UIImage *)image;

@required
/**
 *  多选照片ImagePickerViewController的回调方法
 *
 *  @param imagePicker ImagePickerViewController 用于多选照片
 *  @param assets      选择回调的资源文件数组，ALAsset
 *  @param original    是否压缩；YES，表示是压缩上传；
 */
//- (void)zxImagePickerController:(ImagePickerViewController *)imagePicker
//              didSelectAssets:(NSArray *)assets
//                   isOriginal:(BOOL)original;

/**
 *  多选照片ImagePickerViewController的回调方法
 *
 *  @param imagePicker ImagePickerViewController 用于多选照片
 *  @param assets      选择回调的资源文件数组，ALAsset
 *  @param original    是否压缩；YES，表示是压缩上传；
 *  @param data        要传输的数据
 */

//- (void)zxImagePickerController:(ImagePickerViewController *)imagePicker didSelectAssets:(NSArray *)assets isOriginal:(BOOL)original requestData:(id)data;
@end

@interface ZXImagePickerVCManager : NSObject<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic, weak) id<ZXImagePickerVCManagerDelegate>morePickerActionDelegate;

/**
 相册选择列表类型
 */
@property (nonatomic, assign) PhotosAlbumListType albumListType;


/**
 是否允许编辑
 */
@property (nonatomic, assign) BOOL allowsEditing;



/**
 是否每次检查权限,主要用于测试；
 */
@property (nonatomic, assign) BOOL awayCheckAuthorization;

// 这些属性该怎么处理？
/**
 *  是否显示图片压缩按钮
 */
@property (nonatomic , assign) BOOL displayCutBtn;
/**
 *  最小选中数
 */
@property (nonatomic , assign) NSUInteger minNumberOfSelection;

/**
 *  最大选中数
 */
@property (nonatomic , assign) NSUInteger maxNumberOfSelection;

///**
// *  是否在这个类中上传请求数据，同时也是判断是否要在此控制器请求接口，得到上传id；
//    如果是YES，就会请求数据返回一个json，得到id：操作记录id；type类型：是否是主题；subjectId：上传分类id；
//    然后你再根据返回的数据参数来创建上传；
// */
//@property (nonatomic , assign) BOOL isNeedUpdate;
//
///**
// *  新增操作记录需要的参数
// */
//@property (nonatomic) NSInteger type;
//
//@property (nonatomic, strong) NSNumber *subjectId;

//调用ActionSheet，可以自己选择相册／相机
- (void)zxPresentActionSheetToImagePickerWithSourceController:(UIViewController *)sourceController;

//根据sourceType直接调用相册列表或相机
- (void)zxPresentMoreImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType sourceController:(UIViewController *)sourceController;

@end

NS_ASSUME_NONNULL_END

/*
 #import "ZXImagePickerVCManager.h"
 #import "AliOSSUploadManager.h"

<ZXImagePickerVCManagerDelegate>
 
 @property (nonatomic, strong)ZXImagePickerVCManager *zxImagePickerVCManager;

 @implementation ******
 
 - (void)initImagePickerVCManager {
    //初始化照片／拍照选择
    ZXImagePickerVCManager *imagePickerVCManager = [[ZXImagePickerVCManager alloc] init];
    imagePickerVCManager.morePickerActionDelegate = self;
    self.imagePickerVCManager = imagePickerVCManager;
     //初始化oss上传
     [[AliOSSUploadManager sharedInstance] initAliOSSWithSTSTokenCredential];
     //是否需要获取图片信息，长宽
     [AliOSSUploadManager sharedInstance].getPicInfo = YES;
 }
 
 - (IBAction)shareAction:(UIButton *)sender {
 
  [self.imagePickerVCManager zxPresentActionSheetToImagePickerWithSourceController:self];
 
 }

//代理 
- (void)zxImagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info withEditedImage:(UIImage *)image
{
   // NSData *imageData = UIImageJPEGRepresentation(image, 1);
    NSData *imageData = [WYUtility zipNSDataWithImage:image];
    self.navigationController.navigationBar.userInteractionEnabled = NO;

    [MBProgressHUD zx_showLoadingWithStatus:@"正在上传" toView:self.view];
    WS(weakSelf);
    [[AliOSSUploadManager sharedInstance]putOSSObjectSTSTokenInPublicBucketWithUserId:USER_TOKEN uploadingData:imageData progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        
    } singleComplete:^(id imageInfo,NSString*imagePath,CGSize imageSize) {
        
        //这里处理上传图片
        [MBProgressHUD zx_hideHUDForView:weakSelf.view];
         AliOSSPicUploadModel *model = [[AliOSSPicUploadModel alloc] init];
         model.p = imagePath;
         model.w = imageSize.width;
         model.h = imageSize.height;
        weakSelf.navigationController.navigationBar.userInteractionEnabled = YES;

    } failure:^(NSError *error) {
 
        weakSelf.navigationController.navigationBar.userInteractionEnabled = YES;

        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

*/
