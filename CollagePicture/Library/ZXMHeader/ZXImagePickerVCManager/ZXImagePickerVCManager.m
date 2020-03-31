//
//  ZXImagePickerVCManager.m
//  Baby
//
//  Created by simon on 16/4/19.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "ZXImagePickerVCManager.h"
#include <MobileCoreServices/UTCoreTypes.h>
#import <objc/runtime.h>
#import <Photos/Photos.h>
#import "ZXAuthorizationManager.h"

static char pickerControllerActionKey;

@interface ZXImagePickerVCManager ()

/// 设置picker控制器界面要显示的资源类型；
@property (nonatomic) UIImagePickerControllerSourceType sourceType;

@end

@implementation ZXImagePickerVCManager


- (instancetype)init
{
    self = [super init];
    if (self)
    {
//        self.allowsEditing = NO;
        self.allowsEditing = YES;
        self.alwayCheckAuthorization = YES;
        self.mediaTypes = @[(NSString *)kUTTypeImage];
//        self.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
//        self.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    return self;
}

- (void)zx_presentActionSheetToImagePickerWithSourceController:(UIViewController *)sourceController
{
    NSString *title = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]?NSLocalizedString(@"选择", nil):nil;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];

    __weak __typeof(&*self)weakSelf = self;
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"拍照", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf zx_presentMoreImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera sourceController:sourceController];
    }];
    [alertController addAction:cameraAction];

    
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"从相册选择", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
          [weakSelf zx_presentMoreImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum sourceController:sourceController];
    }];
    [alertController addAction:albumAction];
    [sourceController presentViewController:alertController animated:YES completion:nil];
}




- (void)zx_presentMoreImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType sourceController:(UIViewController *)sourceController
{
    // 如果是camera,不需要allowsEditing
    if (sourceType ==UIImagePickerControllerSourceTypeCamera)
    {
        [self presentCameraWithSourceController:sourceController];
    }
    //如果是相册
    else
    {
        [self presentPhotosWithSourceType:sourceType sourceController:sourceController];
    }
}

#pragma mark - 实际方法

/// 弹出摄像头，相机；只有在sourceType是UIImagePickerControllerSourceTypeCamera时才可以添加camera；不然会崩溃；
/// @param sourceController sourceController description
- (void)presentCameraWithSourceController:(UIViewController *)sourceController
{
    // 判断相机资源是否有效：已经在使用中，设备不支持
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [self presentGeneralAlertInViewController:sourceController withTitle:@"该设备不支持摄像头拍照" message:nil cancelButtonTitle:nil cancleHandler:nil doButtonTitle:@"确定" doHandler:nil];
        return;
    }
    if (self.cameraDevice == UIImagePickerControllerCameraDeviceRear && ![self isAvailableRearCamera]) {
        return;
    }
    if (self.cameraDevice == UIImagePickerControllerCameraDeviceFront && ![self isAvailableFrontCamera]) {
        return;
    }
    self.sourceType = UIImagePickerControllerSourceTypeCamera;
    if (self.alwayCheckAuthorization)
    {
        __weak __typeof(&*self)weakSelf = self;
        [[ZXAuthorizationManager shareInstance] zx_requestCameraAuthorizationWithDeniedAlertViewInViewController:sourceController call:^(ZXAuthorizationStatus status) {
            if (status == ZXAuthorizationStatusAuthorized)
            {
                [weakSelf presentCameraImagePickerControllerWithSourceController:sourceController];
            }
            return;
        }];
    }
    else
    {
        [self presentCameraImagePickerControllerWithSourceController:sourceController];
    }
}


/// 弹出相册
/// @param sourceType 源类型
/// @param sourceController sourceController description
- (void)presentPhotosWithSourceType:(UIImagePickerControllerSourceType)sourceType sourceController:(UIViewController *)sourceController
{
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        return;
    }
    self.sourceType = sourceType;
    if (self.alwayCheckAuthorization)
    {
        __weak __typeof(&*self)weakSelf = self;
        [[ZXAuthorizationManager shareInstance] zx_requestPhotoLibraryAuthorizationWithDeniedAlertViewInViewController:sourceController call:^(ZXAuthorizationStatus status) {
            
            if (status == ZXAuthorizationStatusAuthorized)
            {
                [weakSelf presentCommonImagePickerControllerWithSourceController:sourceController];
            }
        }];
    }
    else
    {
        [self presentCommonImagePickerControllerWithSourceController:sourceController];
    }
}


/// 弹出UIImagePickerController 摄像头模式方法
- (void)presentCameraImagePickerControllerWithSourceController:(UIViewController *)sourceController
{
    if (self.sourceType != UIImagePickerControllerSourceTypeCamera) {
        return;
    }
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.mediaTypes = self.mediaTypes;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicker.modalTransitionStyle = UIModalPresentationFullScreen;
    imagePicker.allowsEditing = self.allowsEditing;
    imagePicker.sourceType = self.sourceType;
    imagePicker.cameraDevice = self.cameraDevice;
    if ([imagePicker.mediaTypes containsObject:(NSString *) kUTTypeMovie]) {
    }
    imagePicker.videoMaximumDuration = 600;
    imagePicker.videoQuality = UIImagePickerControllerQualityTypeHigh;

    [sourceController presentViewController:imagePicker animated:YES completion:^{}];
}

/// 弹出UIImagePickerController基础方法
- (void)presentCommonImagePickerControllerWithSourceController:(UIViewController *)sourceController
{
    ///没有经过验证
    if (self.sourceType == UIImagePickerControllerSourceTypePhotoLibrary || self.sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum) {
        if(![UIImagePickerController isSourceTypeAvailable:self.sourceType])
        {
            __weak __typeof(&*self)weakSelf = self;
            [self presentGeneralAlertInViewController:sourceController withTitle:@"还没有照片,马上去拍照一个吧" message:nil cancelButtonTitle:nil cancleHandler:nil doButtonTitle:@"确定" doHandler:^(UIAlertAction *action) {
                [weakSelf presentCameraWithSourceController:sourceController];
            }];
            return;
        }
    }
    if ([self.delegate respondsToSelector:@selector(zxImagePickerVCManagerWithOpenCustomAlbumList:)]) {
        [self.delegate zxImagePickerVCManagerWithOpenCustomAlbumList:self];
        return;
    }
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.mediaTypes = self.mediaTypes;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicker.modalTransitionStyle = UIModalPresentationFullScreen;
    imagePicker.allowsEditing = self.allowsEditing;
    imagePicker.sourceType = self.sourceType;
    imagePicker.cameraDevice = self.cameraDevice;
    [sourceController presentViewController:imagePicker animated:YES completion:^{}];
}

#pragma mark- UIAlertController弹框

- (void)presentGeneralAlertInViewController:(UIViewController *)viewController
                                  withTitle:(nullable NSString *)title
                                    message:(nullable NSString *)message
                          cancelButtonTitle:(nullable NSString *)cancelButtonTitle cancleHandler:(void (^ __nullable)(UIAlertAction *action))handler
                              doButtonTitle:(nullable NSString *)doButtonTitle
                                  doHandler:(void (^ __nullable)(UIAlertAction *action))doHandler
{
    if (!title && message) {
        title = NSLocalizedString(title, nil);
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (cancelButtonTitle.length >0)
    {
        //UIAlertAction的title参数不能为nil，会奔溃；
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(cancelButtonTitle, @"Cancel") style:UIAlertActionStyleCancel handler:handler];
        [alertController addAction:cancelAction];
    }
    if (doButtonTitle.length>0)
    {
        UIAlertAction *doAction = [UIAlertAction actionWithTitle:NSLocalizedString(doButtonTitle, @"OK") style:UIAlertActionStyleDefault handler:doHandler];
        [alertController addAction:doAction];
    }
    [viewController presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - 其它方法

// 前面的摄像头是否可用-如果是坏了不知道能不能判断；
- (BOOL) isAvailableFrontCamera{
    BOOL isAvailable = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
    return isAvailable;
}

// 后面的摄像头是否可用-如果是坏了不知道能不能判断；
- (BOOL) isAvailableRearCamera{
    
    BOOL isAvailable = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    return isAvailable;
}



#pragma mark-imagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // 如果想之后立刻调用UIVideoEditor,animated不能是YES。最好的还是dismiss结束后在调用editor。
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *type =[info objectForKey:UIImagePickerControllerMediaType ];
    //如果返回回来的是照片
    if ([type isEqualToString:(NSString *)kUTTypeImage])
    {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        //如果是camera的照片,save original photos到photosAlbum
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            //一定要有存照片权限提示，不然会崩溃；
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
        else
        {
            if (picker.allowsEditing)
            {
                image = [info objectForKey:UIImagePickerControllerEditedImage];
            }
        }
        
        if ([self.delegate respondsToSelector:@selector(zxImagePickerController:didFinishPickingMediaWithInfo:withEditedImage:)])
        {
            [self.delegate zxImagePickerController:picker didFinishPickingMediaWithInfo:info withEditedImage:image];
        }
    }
//    //保存视频,这里不对，如果已经有视频了，就不能再保存了
//    if ([type isEqualToString:(NSString *)kUTTypeMovie])
//    {
//        NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
//        NSString *path =url.path;
//        UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
//    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)setDelegate:(id<ZXImagePickerVCManagerDelegate>)delegate
{
    [self willChangeValueForKey:@"key"];
    objc_setAssociatedObject(self, &pickerControllerActionKey, delegate, OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"key"];
}



- (id<ZXImagePickerVCManagerDelegate>)delegate
{
    return objc_getAssociatedObject(self, &pickerControllerActionKey);
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(id)info
{
    NSLog(@"D＝%@,%@",[NSThread currentThread], [NSThread currentThread].name);
    
    if(error)
    {
        NSLog(@"savefailed:%@",error.localizedDescription);
    }
    else
    {
        NSLog(@"savesuccess");
    }
}


- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(error)
    {
        NSLog(@"savefailed:%@",error.localizedDescription);
    }
    else
    {
        NSLog(@"savesuccess");
    }
    NSLog(@"%@",videoPath);
}


@end
