//
//  UIApplication+ZXCategory.m
//  MobileCaiLocal
//
//  Created by simon on 2019/11/28.
//  Copyright © 2019 com.Chs. All rights reserved.
//

#import "UIApplication+ZXCategory.h"


@implementation UIApplication (ZXCategory)

//定义状态栏区域的框架矩形。如果状态栏隐藏，则statusBarFrame属性的值为CGRectZero。
- (CGFloat)zx_safeAreaStatusBarHeight
{
    CGFloat statusBarHeight = 0;
    if (@available(iOS 13.0, *)) {
         statusBarHeight = [[UIApplication sharedApplication] delegate].window.windowScene.statusBarManager.statusBarFrame.size.height;
    } else
    {
        statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    }
    return statusBarHeight;
}
/*
- (CGFloat)zx_safeAreaStatusBarHeight
{
    CGFloat statusBarHeight = 0;
    if (@available(iOS 13.0, *)) {
         NSSet *set = [UIApplication sharedApplication].connectedScenes;
         UIWindowScene *scene = (UIWindowScene *)[[set allObjects] firstObject];
         id sceneDelegate = scene.delegate;
         if (!sceneDelegate){
             statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
         }
         else
         {
             if ([sceneDelegate respondsToSelector:@selector(setWindow:)])
             {
                 statusBarHeight = [sceneDelegate window].windowScene.statusBarManager.statusBarFrame.size.height;
             }
         }
    }
    else
    {
        statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    }
    return statusBarHeight;
}
*/
- (CGFloat)zx_safeAreaLayoutNormalBottom
{
    CGFloat safeAreaBottomHeight = 0;
    if (@available(iOS 13.0, *)) {
          NSSet *set = [UIApplication sharedApplication].connectedScenes;
          UIWindowScene *scene = (UIWindowScene *)[[set allObjects] firstObject];
          id sceneDelegate = scene.delegate;
          if (!sceneDelegate){
              UIEdgeInsets areaInset = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
              safeAreaBottomHeight = areaInset.bottom;
          }
          else
          {
              if ([sceneDelegate respondsToSelector:@selector(setWindow:)])
              {
                  safeAreaBottomHeight = [sceneDelegate window].safeAreaInsets.bottom;
              }
          }
    }
    else
    {
        if (@available(iOS 11.0, *)) {
            UIEdgeInsets areaInset = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
            if (areaInset.bottom >0) {
                safeAreaBottomHeight = areaInset.bottom;
            }
        }
    }
    return safeAreaBottomHeight;
}

- (UIWindow *)zx_mainWindow
{
    UIWindow *window = nil;
    if (@available(iOS 13.0,*)) {
        
        NSSet *set = [UIApplication sharedApplication].connectedScenes;
        UIWindowScene *scene = (UIWindowScene *)[[set allObjects] firstObject];
        id sceneDelegate = scene.delegate;
        if (!sceneDelegate){
            window = [[[UIApplication sharedApplication] delegate] window];
        }
        else
        {
            if ([sceneDelegate respondsToSelector:@selector(setWindow:)])
            {
               window = [sceneDelegate window];
            }
        }
    }else{
        window = [[[UIApplication sharedApplication] delegate] window];
    }
    return window;
}


- (NSArray *)zx_windows
{
    NSArray *windows = nil;
    if (@available(iOS 13.0,*)) {
        NSSet *set = [UIApplication sharedApplication].connectedScenes;
        UIWindowScene *scene = (UIWindowScene *)[[set allObjects] firstObject];
        id sceneDelegate = scene.delegate;
        if (!sceneDelegate){
            windows = UIApplication.sharedApplication.windows;
        }
        else
        {
            windows = scene.windows;
        }
    }else{
        windows = UIApplication.sharedApplication.windows;
    }
    return windows;
}



- (void)zx_openURLToCallIphoneWithTel:(NSString *)phone
{
    NSString *allString = [NSString stringWithFormat:@"tel:%@",phone];
    NSURL *url =[NSURL URLWithString:allString];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        if (@available(iOS 10.0,*)) {
            [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:nil];
        }
        else
        {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

- (void)zx_openURLToSendSMSWithTel:(NSString *)phone
{
    NSURL *relativeURL= [NSURL URLWithString:@"sms:"];
    NSURL *url = [NSURL URLWithString:phone relativeToURL:relativeURL];
    if (@available(iOS 10.0,*)) {
        [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:nil];
    }
    else
    {
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)zx_openURLToSendMailWithTel:(NSString *)phone
{
    NSURL *relativeURL= [NSURL URLWithString:@"mailto:"];
    NSURL *url = [NSURL URLWithString:phone relativeToURL:relativeURL];
    if (@available(iOS 10.0,*)) {
        [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:nil];
    }
    else
    {
        [[UIApplication sharedApplication] openURL:url];
    }
}


-(void)zx_openURLToAppSetting
{
//  如果指定的URL scheme由另一个app应用程序处理，options可以使用通用链接的key。空的options字典与旧的openURL调用是相同的；
//  当openURL:options:completionHandler:方法的选项字典中有这个key时，如果设置为YES, 则URL必须是通用链接，并且有一个已安装的应用程序被用于打开该URL时，当前app才会打开URL。
//  如果没有其它app应用程序配置这个通用链接，或者用户设置NO禁用打开链接，则completion handler 回调里的success为false(NO);
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if (@available(iOS 10.0,*)) {
        [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:nil];
    }
    else
    {
        [[UIApplication sharedApplication] openURL:url];
    }
}

//  如果指定的URL scheme由另一个app应用程序处理，options可以使用通用链接的key。空的options字典与旧的openURL调用是相同的；
//  当有这个key，如果设置为YES, 则URL必须是通用链接，并且有一个已安装的应用程序被用于打开该URL时，当前app才会打开URL。
//  如果没有其它app应用程序配置这个通用链接，或者用户设置NO禁用打开链接，则completion handler 回调里的success为false(NO)；
- (void)zx_openURLToItunesForApplicationIdentifier:(NSString *)appId
{
    static NSString *itunesLink = @"http://itunes.apple.com/cn/app/id";
    NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",itunesLink,appId]];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        if (@available(iOS 10.0,*)) {

            [[UIApplication sharedApplication]openURL:url options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@(YES)} completionHandler:nil];
        }
        else
        {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

- (void)zx_openURLToAppleMapsWithSearchQuery:(NSString *)query
{
    NSString *urlString = [NSString stringWithFormat:@"http://maps.apple.com/?q=%@",query];
    if (@available(iOS 9.0,*)) {
        urlString = [ urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    }
    NSURL *url =[NSURL URLWithString:urlString];
    if (@available(iOS 10.0,*)) {
        [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:nil];
    }
    else
    {
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)zx_openURLToQQClientWithQQ:(NSString *)qq canNotOpen:(void(^)(NSString *title))failure
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]])
    {
        NSURL * url=[NSURL URLWithString:[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",qq]];
        if (@available(iOS 10.0,*)) {
            [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:nil];
        }
        else
        {
            [[UIApplication sharedApplication] openURL:url];
        }
    }else{
        if (failure) {
            failure(@"请先安装手机QQ哦～");
        }
    }
}
@end
