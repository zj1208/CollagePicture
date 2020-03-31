//
//  ZXImagePickerVCManager.h
//  Baby
//
//  Created by simon on 16/4/19.
//  Copyright © 2016年 simon. All rights reserved.
//
//  简介：UIKit类的相册，相机调用的管理类，支持image和movie资源访问，支持权限检查及提示，当没有权限的时候会自动弹出默认引导提示;UIImagePickerController支持DarkMode模式；
//  注意：
//  （1）当我们使用UIImagePickerController的时候，如果它的页面是英文的，解决方案：Project-->Info-->Localizations 添加 Chinese; （2）如果加入了这个类，则必须添加隐私权限key-value；从2019年春季开始，如果应用程序的代码引用一个或多个访问敏感用户数据的api，所有提交到AppStore的访问用户数据的应用程序都必须包含一个目的字符串。如果您正在使用外部库或sdk，它们可能会引用需要目的字符串的api。虽然您的应用程序可能不使用这些api，但仍然需要一个目的字符串。
//  必须在info.plist文件中添加隐私权限提示key-value；
//  key1:  Privacy - Photo Library Additions Usage Description; 存照片权限；
//  value：若不允许，你将无法在***中保存照片；
//  key2: Privacy - NSPhotoLibraryUsageDescription 读照片权限；
//  value：若不允许，你将无法在***中发送及保存照片；
//  key3: Privacy - Camera Usage Description  相机拍照权限
//  value：用于扫描商铺二维码进商铺首页，和拍摄图片、视频以供上传；
//  key4: Privacy - Microphone Usage Description 相机拍视频权限


//  2018.3.28； 优化代码；
//  2019.4.18 增加权限检查及提示的管理器；
//  2020.3.31 优化代码，增加属性控制；

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 参考云信封装-NIMKitPhotoFetcher；
//#import "ImagePickerViewController.h"

NS_ASSUME_NONNULL_BEGIN


/**
 相册选择列表类型
 */
typedef NS_ENUM(NSInteger, ZXPhotosAlbumListType)
{
    ZXPhotosAlbumListType_system = 0, // UIImagePickerControllerSourceType系统相册；
    ZXPhotosAlbumListType_custom = 1  // 自定义列表，可多选; 跳转到封装的多选照片控制器；
};

@class ZXImagePickerVCManager;
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


/// 去打开第三方相册组件功能回调；
/// @param manager manager description
- (void)zxImagePickerVCManagerWithOpenCustomAlbumList:(ZXImagePickerVCManager *)manager;
@end

@interface ZXImagePickerVCManager : NSObject<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic, weak) id <ZXImagePickerVCManagerDelegate> delegate;

/**
 设置是否允许用户编辑选定的静态图像或电影。默认是NO；
 即当相机拍完生成静态的视频&照片，或在相册中选完静态的视频&照片后，是否跳到编辑模式进行图片/视频剪裁。
 */
@property (nonatomic, assign) BOOL allowsEditing;


/// 设置媒体选择控制器要访问的媒体类型的数组；默认只支持kUTTypeImage媒体类型；
@property(nonatomic, copy) NSArray <NSString *> *mediaTypes;


/// 设置当前使用摄像头的类型；default is UIImagePickerControllerCameraDeviceRear
@property(nonatomic) UIImagePickerControllerCameraDevice cameraDevice;

/// 设置是否每次检查权限;默认YES;
@property (nonatomic, assign) BOOL alwayCheckAuthorization;

/**
 相册选择列表类型
 */
@property (nonatomic, assign) ZXPhotosAlbumListType albumListType;


/// 调用ActionSheet弹窗，可以自己选择相册／相机
/// @param sourceController presentingViewController的对象；
- (void)zx_presentActionSheetToImagePickerWithSourceController:(UIViewController *)sourceController;


/// 根据sourceType直接调用相册列表，相机/摄像头
/// @param sourceType UIImagePickerControllerSourceType类型
/// @param sourceController presentingViewController的对象；
- (void)zx_presentMoreImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType sourceController:(UIViewController *)sourceController;







//
//// 这些属性该怎么处理？
///**
// *  是否显示图片压缩按钮
// */
//@property (nonatomic , assign) BOOL displayCutBtn;
///**
// *  最小选中数
// */
//@property (nonatomic , assign) NSUInteger minNumberOfSelection;
//
///**
// *  最大选中数
// */
//@property (nonatomic , assign) NSUInteger maxNumberOfSelection;


@end

NS_ASSUME_NONNULL_END

/*
 #import "ZXImagePickerVCManager.h"
 #import "AliOSSUploadManager.h"

<ZXImagePickerVCManagerDelegate>
 
 @property (nonatomic, strong) ZXImagePickerVCManager *imagePickerVCManager;
 @property (nonatomic, strong) NSMutableArray *mImages;
 @property (nonatomic, strong) NSMutableArray *photosMArray;
 
 @implementation ******
 
 
 //初始化照片／拍照选择
 - (ZXImagePickerVCManager *)imagePickerVCManager
 {
     if (!_imagePickerVCManager) {
         ZXImagePickerVCManager *manager = [[ZXImagePickerVCManager alloc] init];
         manager.delegate = self;
         _imagePickerVCManager = manager;
     }
     return _imagePickerVCManager;
 }
 
 - (NSMutableArray *)photosMArray
 {
     if (!_photosMArray) {
         _photosMArray = [NSMutableArray array];
     }
     return _photosMArray;
 }
 
 - (void)initImagePickerVCManager {
    
     //初始化oss上传
     [[AliOSSUploadManager sharedInstance] initAliOSSWithSTSTokenCredential];
     //是否需要获取图片信息，长宽
     [AliOSSUploadManager sharedInstance].getPicInfo = YES;
 }
 
 - (IBAction)shareAction:(UIButton *)sender {
 
     [self.imagePickerVCManager zxPresentActionSheetToImagePickerWithSourceController:self];
 }
*/


#pragma mark -ZXImagePickerVCManagerDelegate

/*
//例1： 直接上传图片后加入到网络图片数组；
 
- (void)zxImagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info withEditedImage:(UIImage *)image
{
   // NSData *imageData = UIImageJPEGRepresentation(image, 1);
    NSData *imageData = [WYUtility zipNSDataWithImage:image];
    self.navigationController.navigationBar.userInteractionEnabled = NO;

    [MBProgressHUD zx_showLoadingWithStatus:@"正在上传" toView:self.view];
    WS(weakSelf);
    [[AliOSSUploadManager sharedInstance]putOSSObjectSTSTokenInPublicBucketWithUserId:USER_TOKEN uploadingData:imageData progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        
    } singleComplete:^(id imageInfo,NSString*imagePath,CGSize imageSize) {
        
        [MBProgressHUD zx_hideHUDForView:weakSelf.view];
        weakSelf.navigationController.navigationBar.userInteractionEnabled = YES;

        //这里处理上传图片
         NSURL *picUrl = [NSURL ossImageWithResizeType:OSSImageResizeType_w200_hX relativeToImgPath:imagePath];
         ZXPhoto *photo = [ZXPhoto photoWithOriginalUrl:imagePath thumbnailUrl:picUrl.absoluteString];
         photo.width = imageSize.width;
         photo.height = imageSize.height;
         photo.type = ZXAssetModelMediaTypePhoto;
         [weakSelf.photosMArray addObject:photo];

    } failure:^(NSError *error) {
 
        weakSelf.navigationController.navigationBar.userInteractionEnabled = YES;
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}
 - (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
     
      CHSVisitSignInUploadPicTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CHSVisitSignInUploadPicTableCell class]) forIndexPath:indexPath];
      cell.picCollectionView.delegate = self;
      [cell setData:self.photosMArray];
      return cell;
 }
*/

/*
//例2： 直接先加入到本地图片数组，后续在提交数据的时候逐个上传；
 
 - (NSMutableArray *)mImages
 {
     if (!_mImages) {
         _mImages = [NSMutableArray arrayWithCapacity:3];
     }
     return _mImages;
 }
 
 
- (void)zxImagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info withEditedImage:(UIImage *)image
{
    [self.mImages addObjectsFromArray:photos];
    [self.tableView reloadData];
}
 - (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
     
      CHSVisitSignInUploadPicTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CHSVisitSignInUploadPicTableCell class]) forIndexPath:indexPath];
      cell.picCollectionView.delegate = self;
      [cell setData:self.mImages];
      return cell;
 }
 
 //本地上传数据+图片
 - (void)postDataAction:(UIButton *)sender
 {
     if (self.contentCell.textView.text.length<5)
     {
         [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:NSLocalizedString(@"老板，生意回复不能少于5个字哦～", nil) message:nil cancelButtonTitle:nil cancleHandler:nil doButtonTitle:NSLocalizedString(@"知道了", nil) doHandler:nil];
         return;
     }
     
     WYPromptGoodsType goodsType = [self.contentCell getGoodsPromptType];
     if (goodsType ==WYPromptGoodsType_NOSelect)
     {
         [MBProgressHUD zx_showError:NSLocalizedString(@"请选择是否现货", nil) toView:self.view];
         return;
     }
     [MBProgressHUD zx_showLoadingWithStatus:NSLocalizedString(@"正在提交", nil) toView:self.view];
     //如果有图片则先上传图片；
     if (self.mImages.count>0)
     {
         //清空数据
         [self.photosMArray removeAllObjects];
         __block NSInteger currentIndex = 0;
         WS(weakSelf);
         [self.mImages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             
             UIImage *image = (UIImage *)obj;
             NSData *imageData = [WYUtility zipNSDataWithImage:image];
             
             [[AliOSSUploadManager sharedInstance]putOSSObjectSTSTokenInPublicBucketWithUserId:USER_TOKEN fileCatalogType:OSSFileCatalog_tradeReply uploadingData:imageData progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
                 
             } singleComplete:^(id imageInfo,NSString*imagePath,CGSize imageSize) {
                 
                 currentIndex ++;
                 //这里处理上传图片
                 AliOSSPicUploadModel *model = [[AliOSSPicUploadModel alloc] init];
                 model.p = imagePath;
                 model.w = imageSize.width;
                 model.h = imageSize.height;
                 
                 [weakSelf.photosMArray addObject:model];
                 if (currentIndex ==weakSelf.mImages.count)
                 {
                     [weakSelf performSelector:@selector(uploadData)];
                 }
                 
             } failure:^(NSError *error) {

                 [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
             }];
         }];
     }
     //如果没有图片则直接上传其它数据；
     else
     {
          [self performSelector:@selector(uploadData)];
     }
 }
*/
