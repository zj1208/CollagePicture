//
//  UIViewController+ZXHelper.h
//  Baby
//
//  Created by simon on 16/2/24.
//  Copyright © 2016年 sina. All rights reserved.
//
// 2018.01.04 修改优化方法；
// 2019.06.11 增加连续present的最后页面dismiss到最初的页面；
// 2020.01.02 openURL方法增加兼容

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "UIViewController+ZXSystemBackButtonAction.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ZXHelper)<SKStoreProductViewControllerDelegate,UIActionSheetDelegate>

/**
 同上storyboard跳转-present

 @param name name description
 @param storyboardId storyboardId description
 @param flag 是否有导航navigationController
 @param data 参数－dictionary格式;kvc传值；
 @param completion 跳转完成
 */
- (void)zx_presentStoryboardViewControllerWithStoryboardName:(NSString *)name identifier:(nullable NSString *)storyboardId isNavigationController:(BOOL)flag withData:(nullable NSDictionary *)data completion:(void(^ __nullable)(void))completion;


/**
 根据storyboardId获取controller

 @param name name description
 @param storyboardId storyboardId description
 @return return value description
 */
- (UIViewController *)zx_getControllerWithStoryboardName:(NSString *)name controllerWithIdentifier:(nullable NSString *)storyboardId;



/**
 *  过滤modalController的返回；如果是模态的，则dismiss；
 */
- (void)zx_goBackPreController;


/**
 去appStore
 */
- (void)zx_goAppStoreWithAppId:(NSString *)appId;


/**
 拨打电话，是否需要添加actionSheet提示
 @param phone 电话号码
 @param flag 是否需要添加UIAlertController提示

 注意：
 如果指定的URL scheme由另一个app应用程序处理，options可以使用通用链接的key。空的options字典与旧的openURL调用是相同的；
 当openURL:options:completionHandler:方法的选项字典中有这个key时，如果设置为YES, 则URL必须是通用链接，并且有一个已安装的应用程序被用于打开该URL时，当前app才会打开URL。
 如果没有其它app应用程序配置这个通用链接，或者用户设置NO禁用打开链接，则completion handler 回调里的success为false(NO)；
 */
- (void)zx_callIphone:(NSString *)phone withAlertControllerFlag:(BOOL)flag;


/**
 回退到根控制器
 */
- (void)zx_dismissToRootViewController;
@end


NS_ASSUME_NONNULL_END

