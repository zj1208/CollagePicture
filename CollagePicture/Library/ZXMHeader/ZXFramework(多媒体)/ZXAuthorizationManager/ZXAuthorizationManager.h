//
//  ZXAuthorizationManager.h
//  FunLive
//
//  Created by simon on 2019/4/18.
//  Copyright © 2019 com.Microants. All rights reserved.
//
// 简介：各种授权的检查，及默认UIAlertController提示引导；当检查到某权限没有被授权时，会回调代理或block，可以根据统一的ZXAuthorizationStatus状态来判断，执行自定义弹窗引导提示；当使用实例方法且传控制器参数，则会显示默认警告弹窗提示；

//  2019.5.09  优化检查权限的时候应该为主线程检查，未对访问授权做出选择的情况返回才需要特殊改为异步主线程回调；
//  2019.9.07  增加检查用户通知权限；没有实际测试；
//  2020.1.02  优化openURL方法
//  2020.1.18  去除黄色警告-使用@available判断版本
//  2020.3.31  优化

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@import Photos;
@import CoreLocation;

NS_ASSUME_NONNULL_BEGIN

//授权类型
typedef NS_ENUM(NSUInteger, ZXAuthorizationType) {
    ZXAuthorizationType_PhotoLibrary,        // 相册
    ZXAuthorizationType_AVCaptureCamera,     // 相机
    ZXAuthorizationType_Location,     // 定位
};

// 授权状态
typedef NS_ENUM(NSUInteger, ZXAuthorizationStatus){
    ZXAuthorizationStatusNotDetermined = 0, // 未对访问授权做出选择
    ZXAuthorizationStatusDenied,            // 拒绝访问
    ZXAuthorizationStatusAuthorized,        // 已授权；在业务中应该是继续执行后面的主进程；
    ZXAuthorizationStatusRestricted,        // 应用没有相关权限，且当前用户无法改变这个权限，比如：家长控制
    ZXAuthorizationStatusAlertDeniedOrRestricted,      // 系统授权提示弹框中的交互，点击拒绝授权返回的状态；因为提示弹窗点击后，还要继续执行后面的主进程；
    ZXAuthorizationStatusNotSupport         // 不支持授权
};

@protocol ZXAuthorizationManagerDelegate <NSObject>


/**
 检查授权的时候，如果没有授权，则自定义回调代理；
 当然也可以用第二种方法，调用检查授权方法zx_requestPhotoLibraryAuthorization:，再根据block回调判断授权状态来提示；

 @param authorizationType 授权类型
 */
- (void)zxAuthorizationManagerShowAlertViewWithAuthorizationType:(ZXAuthorizationType)authorizationType;

@end


@interface ZXAuthorizationManager : NSObject

+ (instancetype)shareInstance;

@property (nonatomic,weak)id<ZXAuthorizationManagerDelegate>delegate;



/**
 检查用户通知授权

 @param callback 回调block
 */
+ (void)zx_requestUserNotificationAuthorization:(void(^)(ZXAuthorizationStatus status))callback;

/**
 检查相册授权及回调

 @param callback 回调block
 */
+ (void)zx_requestPhotoLibraryAuthorization:(void(^)(ZXAuthorizationStatus status))callback;

/**
 检查相册授权及回调，当权限是被拒绝的时候会有默认AlertController提示指引

 @param sourceController 原控制器，如果需要默认提示则一定要这个值；
 */
- (void)zx_requestPhotoLibraryAuthorizationWithDeniedAlertViewInViewController:(nullable UIViewController *)sourceController call:(void(^)(ZXAuthorizationStatus status))callback;


/**
 检查摄像头授权及回调
 
 @param callback 回调block
 */
+ (void)zx_requestCameraAuthorization:(void(^)(ZXAuthorizationStatus status))callback;
/**
 检查摄像头授权及提示指引;当权限是被拒绝的时候会有默认AlertController提示指引;

 @param sourceController 原控制器，如果需要默认提示则一定要这个值；
 */
- (void)zx_requestCameraAuthorizationWithDeniedAlertViewInViewController:(nullable UIViewController *)sourceController call:(void(^)(ZXAuthorizationStatus status))callback;




/// 检查定位服务授权，“定位服务”使用GPS，蓝牙，和众包Wi－Fi热点以及信号塔位置来确定您的大致方位。具体的定位方式不需要开发者考虑，iPhone会根据不同场景选择不同定位方式。
/// @param callback callback description
+ (void)zx_requestLocationAuthorization:(void(^)(CLAuthorizationStatus status))callback;


- (void)zx_requestLocationAuthorizationWithDeniedAlertViewInViewController:(nullable UIViewController *)sourceController call:(void(^)(CLAuthorizationStatus status))callback;

@end

NS_ASSUME_NONNULL_END

//例如1，当没有权限的时候自动弹出默认引导提示；

/*
- (void)zxPresentMoreImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType sourceController:(UIViewController *)sourceController
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    //    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicker.modalTransitionStyle = UIModalPresentationOverCurrentContext;
    __weak __typeof(self) weakSelf = self;
    // 如果是camera,不需要allowsEditing
    if (sourceType ==UIImagePickerControllerSourceTypeCamera)
    {
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [[ZXAuthorizationManager shareInstance] zx_requestCameraAuthorizationWithDeniedAlertViewInViewController:sourceController call:^(ZXAuthorizationStatus status) {
                if (status == ZXAuthorizationStatusAuthorized)
                {
                    imagePicker.allowsEditing = weakSelf.allowsEditing;
                    // 跳转到相机或相册页面; 必须是支持摄像头，不然赋值摄像头会报错
                    imagePicker.sourceType = sourceType;
                    [sourceController presentViewController:imagePicker animated:YES completion:^{}];
                }
            }];
        }
        else
        {
            //模拟器
            [self presentGeneralAlertInViewController:sourceController withTitle:@"该设备不支持摄像头拍照" message:nil cancelButtonTitle:nil cancleHandler:nil doButtonTitle:@"确定" doHandler:nil];
            return;
        }
    }
    //如果是相册
    else
    {
        [[ZXAuthorizationManager shareInstance] zx_requestPhotoLibraryAuthorizationWithDeniedAlertViewInViewController:sourceController call:^(ZXAuthorizationStatus status) {
            
            if (status == ZXAuthorizationStatusAuthorized)
            {
                if (self.albumListType == PhotosAlbumListType_custom)
                {
                    //          [weakSelf pushToImagePickerToController:sourceController];
                }
                else
                {
                    imagePicker.allowsEditing = weakSelf.allowsEditing;
                    imagePicker.sourceType = sourceType;
                    [sourceController presentViewController:imagePicker animated:YES completion:^{}];
                }
            }
        }];
    }
}
*/

//例2
/*
- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount columnNumber:(NSInteger)columnNumber delegate:(nullable id<ZXImagePickerControllerDelegate>)delegate autoPushPhotoPickerViewController:(BOOL)pushPhotoPickerVc
{
    ZXAlbumPickerController *albumPickerController = [[ZXAlbumPickerController alloc] init];
    albumPickerController.columnNumber = columnNumber;
    self = [super initWithRootViewController:albumPickerController];
    if (self)
    {
        self.pushPhotoPickerViewController = pushPhotoPickerVc;
        self.maxImagesCount = maxImagesCount > 0 ? maxImagesCount : 9;
        self.pickerDelegate = delegate;
        self.columnNumber = columnNumber;
        
        [self initData];
        
        __weak __typeof(self) weakSelf = self;
        [ZXAuthorizationManager zx_requestPhotoLibraryAuthorization:^(ZXAuthorizationStatus status) {
            
            if (status != ZXAuthorizationStatusAuthorized)
            {
                [weakSelf.view addSubview:weakSelf.tipLabel];
            }else{
                
                [weakSelf pushPhotoPickerVc];
            }
        }];
    }
    return self;
}
*/
