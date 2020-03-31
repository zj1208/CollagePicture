//
//  ZXAuthorizationManager.m
//  FunLive
//
//  Created by simon on 2019/4/18.
//  Copyright © 2019 com.Microants All rights reserved.
//

#import "ZXAuthorizationManager.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

@interface ZXAuthorizationManager ()<CLLocationManagerDelegate>

@property (nonatomic, copy) NSString *appDisplayName;

@end

@implementation ZXAuthorizationManager

+ (instancetype)shareInstance
{
    static id sharedHelper = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedHelper = [[self alloc] init];
    });
    return sharedHelper;
}

- (instancetype)init
{
    if (self = [super init])
    {
        NSDictionary *infoDict = [NSBundle mainBundle].localizedInfoDictionary;
        if (!infoDict) {
            infoDict = [NSBundle mainBundle].infoDictionary;
        }
        NSString *appName = [infoDict valueForKey:@"CFBundleDisplayName"];
        if (!appName){
            appName = [infoDict valueForKey:@"CFBundleName"];
        }
        _appDisplayName = appName;
    }
    return self;
}
#pragma mark - 用户通知授权
+ (void)zx_requestUserNotificationAuthorization:(void(^)(ZXAuthorizationStatus status))callback
{
    [[self alloc] zx_requestUserNotificationAuthorizationWithDeniedAlertViewInViewController:nil call:callback];
}

- (void)zx_requestUserNotificationAuthorizationWithDeniedAlertViewInViewController:(nullable UIViewController *)sourceController call:(void(^)(ZXAuthorizationStatus status))callback
{
    
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            
            if (settings.authorizationStatus ==UNAuthorizationStatusDenied)
            {
                dispatch_async(dispatch_get_main_queue(), ^{

                [self executeCallback:callback status: ZXAuthorizationStatusDenied];
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self executeCallback:callback status:ZXAuthorizationStatusAuthorized];
                });
            }
        }];
    }
    else
    {
        UIUserNotificationSettings * notiSettings = [[UIApplication sharedApplication]currentUserNotificationSettings];
        if (notiSettings.types == UIUserNotificationTypeNone)
        {
            [self executeCallback:callback status: ZXAuthorizationStatusDenied];
        }
        else
        {
            [self executeCallback:callback status:ZXAuthorizationStatusAuthorized];
        }
    }
}


#pragma mark - 相机授权

+ (void)zx_requestPhotoLibraryAuthorization:(void(^)(ZXAuthorizationStatus status))callback
{
    [[self alloc] zx_requestPhotoLibraryAuthorizationWithDeniedAlertViewInViewController:nil call:callback];
}

- (void)zx_requestPhotoLibraryAuthorizationWithDeniedAlertViewInViewController:(nullable UIViewController *)sourceController call:(void(^)(ZXAuthorizationStatus status))callback
{
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    if (authStatus == PHAuthorizationStatusDenied || authStatus == PHAuthorizationStatusRestricted)
    {
        [self presentAuthorizationStatusDeniedAlertViewInViewController:sourceController authorizationType:ZXAuthorizationType_PhotoLibrary];

        [self executeCallback:callback status:authStatus == PHAuthorizationStatusDenied ? ZXAuthorizationStatusDenied:ZXAuthorizationStatusRestricted];
    }
    else if (authStatus == PHAuthorizationStatusNotDetermined)
    {
        //点击之后警告框会消失；异步+新的队列执行；
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (status == PHAuthorizationStatusAuthorized) {
                    [self executeCallback:callback status:ZXAuthorizationStatusAuthorized];
                    
                } else if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted)
                {
                    [self executeCallback:callback status:ZXAuthorizationStatusAlertDeniedOrRestricted];
                }
            });
        }];
    }
    else
    {
        [self executeCallback:callback status:ZXAuthorizationStatusAuthorized];
    }
}

#pragma mark - 摄像头授权

+ (void)zx_requestCameraAuthorization:(void(^)(ZXAuthorizationStatus status))callback
{
    [[self alloc]zx_requestCameraAuthorizationWithDeniedAlertViewInViewController:nil call:callback];
}

- (void)zx_requestCameraAuthorizationWithDeniedAlertViewInViewController:(nullable UIViewController *)sourceController call:(void(^)(ZXAuthorizationStatus status))callback
{
    // 判断是否支持摄像头
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted)
        {
            [self presentAuthorizationStatusDeniedAlertViewInViewController:sourceController authorizationType:ZXAuthorizationType_AVCaptureCamera];
            [self executeCallback:callback status:authStatus == AVAuthorizationStatusDenied ? ZXAuthorizationStatusDenied:ZXAuthorizationStatusRestricted];
        }
        else if (authStatus == AVAuthorizationStatusNotDetermined)
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (granted){
                        [self executeCallback:callback status:ZXAuthorizationStatusAuthorized];
                    }
                    else{
                        [self executeCallback:callback status:ZXAuthorizationStatusAlertDeniedOrRestricted];
                    }
                });
            }];
        }
        else
        {
            [self executeCallback:callback status:ZXAuthorizationStatusAuthorized];
        }
    }
    else
    {
        [self executeCallback:callback status:ZXAuthorizationStatusNotSupport];
        //模拟器
        [self presentGeneralAlertInViewController:sourceController withTitle:@"该设备不支持摄像头拍照" message:nil cancelButtonTitle:nil cancleHandler:nil doButtonTitle:@"确定" doHandler:nil];
    }
}



+ (void)zx_requestLocationAuthorization:(void(^)(CLAuthorizationStatus status))callback
{
    [[self alloc]zx_requestLocationAuthorizationWithDeniedAlertViewInViewController:nil call:callback];
}

- (void)zx_requestLocationAuthorizationWithDeniedAlertViewInViewController:(nullable UIViewController *)sourceController call:(void(^)(CLAuthorizationStatus status))callback
{
    CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
    if (authStatus == kCLAuthorizationStatusDenied)
    {
        [self presentAuthorizationStatusDeniedAlertViewInViewController:sourceController authorizationType:ZXAuthorizationType_Location];

        if (callback) {
             callback(authStatus);
        }
    }
    else if (authStatus == kCLAuthorizationStatusNotDetermined)
    {
        CLLocationManager *manager = [[CLLocationManager alloc] init];
        manager.delegate = self;
        [manager requestWhenInUseAuthorization];
    }
    else
    {
        if (callback) {
             callback(authStatus);
         }
    }
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status API_AVAILABLE(ios(4.2), macos(10.7))
{
    
}






#pragma mark - callback

- (void)executeCallback:(void (^)(ZXAuthorizationStatus))callback status:(ZXAuthorizationStatus)status {
    if (callback) {
        callback(status);
    }
}


#pragma mark - DeniedAlertView

- (void)presentAuthorizationStatusDeniedAlertViewInViewController:(nullable UIViewController *)sourceController authorizationType:(ZXAuthorizationType)type
{
    if ([self.delegate respondsToSelector:@selector(zxAuthorizationManagerShowAlertViewWithAuthorizationType:)])
    {
        [self.delegate zxAuthorizationManagerShowAlertViewWithAuthorizationType:type];
    }
    else
    {
        if (!sourceController)
        {
            return;
        }
        NSString *title = nil;
        if (type == ZXAuthorizationType_PhotoLibrary)
        {
            title =[NSString stringWithFormat:@"请在iPhone的\"设置-隐私-照片\"选项中，\r允许%@访问你的手机照片",self.appDisplayName];
        }
        else if (type == ZXAuthorizationType_AVCaptureCamera)
        {
            title =[NSString stringWithFormat:@"请在iPhone的\"设置-隐私-相机\"选项中，\r允许%@访问你的手机相机",self.appDisplayName];
        }
        else if (type == ZXAuthorizationType_Location)
        {
            title =[NSString stringWithFormat:@"请打开\"定位服务\"允许%@确定你的位置",self.appDisplayName];
        }
        
        [self presentGeneralAlertInViewController:sourceController withTitle:title message:nil cancelButtonTitle:@"取消" cancleHandler:nil doButtonTitle:@"去设置" doHandler:^(UIAlertAction *action) {
            
//            如果指定的URL scheme由另一个app应用程序处理，options可以使用通用链接的key。空的options字典与旧的openURL调用是相同的；
//            当openURL:options:completionHandler:方法的选项字典中有这个key时，如果设置为YES, 则URL必须是通用链接，并且有一个已安装的应用程序被用于打开该URL时，当前app才会打开URL。
//            如果没有其它app应用程序配置这个通用链接，或者用户设置NO禁用打开链接，则completion handler 回调里的success为false(NO);
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if (@available(iOS 10.0,*)) {
                [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:nil];
            }
            else
            {
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
    }
}

#pragma mark - 弹框

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
    
    #if TARGET_OS_IOS || TARGET_OS_WATCH
    #endif
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

@end
