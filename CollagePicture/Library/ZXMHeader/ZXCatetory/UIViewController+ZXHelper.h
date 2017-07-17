//
//  UIViewController+ZXHelper.h
//  Baby
//
//  Created by simon on 16/2/24.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "UIViewController+ZXSystemBackButtonAction.h"

@interface UIViewController (ZXHelper)<SKStoreProductViewControllerDelegate,UIActionSheetDelegate>
/**
 *  storyboard跳转
 *
 *  @param name  storyboardName
 *  @param segue  storyboardID
 *  @param data  参数－dictionary格式
 */
- (void)pushStoryboardViewControllerWithStoryboardName:(NSString *)name identifier:(NSString *)segue withData:(NSDictionary *)data;


-(UIViewController *)getControllerWithStoryboardName:(NSString *)name controllerWithIdentifier:(NSString *)segue;

- (void)pushStoryboardViewControllerWithStoryboardName:(NSString *)name identifier:(NSString *)segue withData:(NSDictionary *)data toController:(void(^)(UIViewController *vc))toControllerBlock;

/**
 *  过滤modalController的返回；如果是模态的，则dismiss；
 */
- (void)goBackPreController;


/**
 去appStore
 */
- (void)goAppStore;


/**
 拨打电话，是否需要添加actionSheet提示

 @param phone 电话号码
 @param alertController 是否需要添加UIAlertController提示 
 // UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"您还没有登录，是否需要登录", nil) preferredStyle:UIAlertControllerStyleAlert];

 */
- (void)zhCallIphone:(NSString *)phone withAlertController:(UIAlertController *)alertController;

@end
