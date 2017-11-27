//
//  ZXImagePickerVCManager.h
//  Baby
//
//  Created by simon on 16/4/19.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import "ImagePickerViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, PhotosAlbumListType)
{
    PhotosAlbumListType_system =0, //UIImagePickerControllerSourceTypeSavedPhotosAlbum系统相册；
    PhotosAlbumListType_custom = 1 //自定义列表，可多选; 跳转到封装的多选照片控制器；
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

@property (nonatomic, assign) PhotosAlbumListType morePickerAlbumType;

// 是否允许编辑
@property (nonatomic, assign) BOOL allowsEditing;
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
- (void)zxPresentActionSheetToMoreUIImagePickerControllerFromSourceController:(UIViewController *)sourceController;

//根据sourceType直接调用相册列表或相机
- (void)presentMoreImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType sourceController:(UIViewController *)sourceController;

@end

NS_ASSUME_NONNULL_END

/*
 #import "ZXImagePickerVCManager.h"
 
<ZXImagePickerVCManagerDelegate>
 
 @property (nonatomic ,strong)ZXImagePickerVCManager *ZXImagePickerVCManager;

 
//初始化照片／拍照选择
ZXImagePickerVCManager *pickerVCManager = [[ZXImagePickerVCManager alloc] init];
pickerVCManager.morePickerActionDelegate = self;
self.ZXImagePickerVCManager = pickerVCManager;
 //初始化oss上传
 [[OSSUploadManager getInstance] initOSSStsTokenCredential];
 //是否需要获取图片信息，长宽
 [OSSUploadManager getInstance].getPicInfo = YES;

 - (IBAction)shareAction:(UIButton *)sender {
 
  [self.ZXImagePickerVCManager zxPresentActionSheetToMoreUIImagePickerControllerFromSourceController:self];
 
 }

//代理 
- (void)zxImagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info withEditedImage:(UIImage *)image
{
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    [self zhHUD_showHUDAddedTo:self.view labelText:@"正在上传"];
    WS(weakSelf);
    [[OSSUploadManager getInstance]putObjectOSSStsTokenPublicBucketWithUserId:USER_TOKEN uploadingData:imageData progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        
    } singleComplete:^(id imageInfo,NSString*imagePath,CGSize imageSize) {
        
        //这里处理上传图片
        [weakSelf zhHUD_hideHUDForView:weakSelf.view];
        
    } failure:^(NSError *error) {
        
        [weakSelf zhHUD_showErrorWithStatus:[error localizedDescription]];
    }];
}

*/
