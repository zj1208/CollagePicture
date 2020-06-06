//
//  ZXMHeader.h
//  ShiChunTang
//
//  Created by simon on 14/12/1.
//  Copyright (c) 2014年 simon. All rights reserved.
//

#ifndef ShiChunTang_ZhuHeader_h
#define ShiChunTang_ZhuHeader_h

#import "ZXCatetories.h"
#import "APPCommonDef.h"

#endif

/// 注意1：如果加入以下类，则必须添加隐私权限key-value；从2019年春季开始，如果应用程序的代码引用一个或多个访问敏感用户数据的api，所有提交到App Store的访问用户数据的应用程序都必须包含一个目的字符串。如果您正在使用外部库或sdk，它们可能会引用需要目的字符串的api。虽然您的应用程序可能不使用这些api，但仍然需要一个目的字符串。
/// ZXImagePickerVCManager/ZXAuthorizationManager,还有带UIImagePickerController的类； （机器会检测UIImagePickerController，PHPhoto类）

///  注意2:里面涉及如下framework和第三方库：
///  #import <WebKit/WebKit.h>,
///  #import <Photos/Photos.h>,#include <MobileCoreServices/UTCoreTypes.h>
///  #import "AFNetworking.h"
///  #import <UserNotifications/UserNotifications.h> ,@import Photos;@import CoreLocation;
///  @import AudioToolbox;
/// #import "AppDelegate.h"
/// #import "UIButton+WebCache.h"
/// #import <MBProgressHUD/MBProgressHUD.h>
/// #import "UIImageView+WebCache.h",#import <SDWebImage/SDWebImage.h>
/// #import "Masonry.h"

// 待解决：
// 把所有系统库引用 都改为 @import ，优化编译；  在新项目中又不能用了；
// QiNiuUploadRequest 耦合性太强了，需要优化；
// 已解决一大堆耦合性问题，还有很多组件？




