//
//  UIApplication+ZXCategory.h
//  MobileCaiLocal
//
//  Created by simon on 2019/11/28.
//  Copyright © 2019 com.Chs. All rights reserved.
//
//  2020.02.03，增加兼容iOS13Scene场景的window
//  2020.02.05，增加一系列openURL的方法；


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (ZXCategory)

/// iPhoneX系列 ? (20.f+24.f) : (20.f))；兼容iOS13
@property (nonatomic, assign, readonly) CGFloat zx_safeAreaStatusBarHeight;


/// 根据应用程序获取appDelegate的window 或SceneDelegate的window；兼容iOS13场景Scene；
@property (nonatomic, assign, readonly) UIWindow *zx_mainWindow;


/**
 拨打电话-UIApplication openURL方式；
 @param phone 电话号码
 
 注意：
 如果指定的URL scheme由另一个app应用程序处理，options可以使用通用链接的key。空的options字典与旧的openURL调用是相同的；
 当openURL:options:completionHandler:方法的选项字典中有这个key时，如果设置为YES, 则URL必须是通用链接，并且有一个已安装的应用程序被用于打开该URL时，当前app才会打开URL。
 如果没有其它app应用程序配置这个通用链接，或者用户设置NO禁用打开链接，则completion handler 回调里的success为false(NO)；
 */
- (void)zx_openURLToCallIphoneWithTel:(NSString *)phone;


/// 发送短信到**
/// @param phone 手机号
- (void)zx_openURLToSendSMSWithTel:(NSString *)phone;


/// 发送邮件到＊＊：可以通过to,cc,bcc,subject,body字段来指定邮件的抄送，密送，主题，消息内容;
/// @param phone 手机号
- (void)zx_openURLToSendMailWithTel:(NSString *)phone;

/// 打开当前app的系统设置页面；
- (void)zx_openURLToAppSetting;


/// 打开wifi设置页面
- (void)zx_openURLToWifiSetting;

/// iTunes links:打开苹果App Store中app的详情页；
/// @param appId 每个在itunes上申请的App的唯一id
- (void)zx_openURLToItunesForApplicationIdentifier:(NSString *)appId;


/// 打开苹果系统地图
/// @param query 在地图上查询周围的query
- (void)zx_openURLToAppleMapsWithSearchQuery:(NSString *)query;


/// 打开qq客户端-没有测试过，不知道是否能用；
/// @param qq 要聊天的对方qq号码
/// @param failure 无法打开block回调
- (void)zx_openURLToQQClientWithQQ:(NSString *)qq canNotOpen:(void(^)(NSString *title))failure;

@end

NS_ASSUME_NONNULL_END
