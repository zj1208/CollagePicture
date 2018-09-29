//
//  ZXAlphaTransitionDelegate.h
//  lovebaby
//
//  Created by simon on 16/6/28.
//  Copyright © 2016年 . All rights reserved.
//
//  简介：非交互式基础转场动画，透明呈现整个toView；使用UIModalPresentationCustom；居中展示，可以设置toViewController的contentSize大小；
//  present出现时候的动画：从alpha =0 变为alpha =1过渡；
//  dismiss消失的动画：从alpha =1 变为alpha=0，scale=1变为scale=0过渡；
//  2018.8.07  优化代码；

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZXAlphaAnimatedTranstion.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXAlphaTransitionDelegate : NSObject<UIViewControllerTransitioningDelegate>

//设置整个控制器viw页面的大小尺寸
@property (nonatomic, assign) CGSize contentSize;

@end

NS_ASSUME_NONNULL_END


// 例： APP首页各种弹窗汇总及先后顺序处理；新功能引导>主页面数据展示>推送通知跳转>检查版本更新>主页广告弹窗>检查用户推送通知是否关闭及弹窗引导打开提示（如果有广告弹窗，那么不检查）
/*
#import "ZXAlphaTransitionDelegate.h"

@property (nonatomic,strong)ZXAlphaTransitionDelegate *transitionDelegate;



#pragma mark - 新功能引导
//第一步
- (void)newFunctionGuideOfNextStep:(id)noti
{
    [self checkAppVersionAndNotificationPush];
}
- (void)lauchFirstNewFunction
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newFunctionGuideOfNextStep:) name:@"NewFunctionGuide_ShopHomeV1_Dismiss" object:nil];
    if (![WYUserDefaultManager getNewNewFunctionGuide_ShopHomeV1])
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        GuideShopHomeController *vc = [sb instantiateViewControllerWithIdentifier:SBID_GuideShopHomeController];
        [self.tabBarController addChildViewController:vc];
        [self.tabBarController.view addSubview:vc.view];
    }
}

#pragma mark - 第二步,展示主数据，先请求完展示主要数据后，再检查推送跳转及版本更新
//在viewDidAppear中请求
 - (void)viewDidAppear:(BOOL)animated
 {
    [super viewDidAppear:animated];
    [self requestData];
    [self checkShopId];
 }

- (void)requestShopHomeInfo
{
    WS(weakSelf);
    [[[AppAPIHelper shareInstance]getShopAPI]getShopHomeInfoWithFactor:@(0) Success:^(id data) {
        
        weakSelf.shopHomeInfoModel = nil;
        weakSelf.shopHomeInfoModel = [[ShopHomeInfoModel alloc] init];
        weakSelf.shopHomeInfoModel = data;
        [MBProgressHUD zx_hideHUDForView:weakSelf.view];
        [weakSelf.emptyViewController hideEmptyViewInController:weakSelf hasLocalData:weakSelf.shopHomeInfoModel?YES:NO];
        if (weakSelf.shopHomeInfoModel)
        {
            weakSelf.customNavigationBar.hidden = NO;
            weakSelf.stausBarStyle = UIStatusBarStyleLightContent;
            [weakSelf setNeedsStatusBarAppearanceUpdate];
        }
        [weakSelf.collectionView reloadData];
        weakSelf.topImageView.hidden = NO;
        if ([WYUserDefaultManager getNewNewFunctionGuide_ShopHomeV1])
        {
            [weakSelf checkAppVersionAndNotificationPush];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD zx_hideHUDForView:weakSelf.view];
        [weakSelf.emptyViewController addEmptyViewInController:weakSelf hasLocalData:weakSelf.shopHomeInfoModel?YES:NO error:error emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];
    }];
}

#pragma mark - 先检查通知跳转再检查更新
//第三步：先检查推送通知跳转再检查版本更新，如果通知跳转下一页，返回来继续下一步检查更新
 
- (void)checkAppVersionAndNotificationPush
{
    if ([WYUserDefaultManager isOpenAppRemoteNoti])
    {
        BOOL pushed = [[WYUtility dataUtil]routerWithName:[WYUserDefaultManager getDidFinishLaunchRemoteNoti] withSoureController:self];
        if (!pushed)
        {
            [self checkAppVersion];
        }
    }
    else{
        
        [self checkAppVersion];
    }
}


#pragma mark -检查版本更新请求
//第四步：检查完版本更新，再请求广告弹窗
- (void)checkAppVersion
{
    WS(weakSelf);
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        版本更新
        [[CheckVersionManager sharedInstance]checkAppVersionWithNextStep:^{
            
            [weakSelf launchHomeAdvViewOrUNNotificationAlert];
        }];
    });
}

//第五步：检查完请求广告弹窗，再检查推送通知是否关闭

#pragma mark - 请求广告弹窗图
- (void)launchHomeAdvViewOrUNNotificationAlert
{
    WS(weakSelf);
    [[[AppAPIHelper shareInstance] getMessageAPI] GetAdvWithType:@1005 success:^(id data) {
        
        _advmodel = (AdvModel *)data;
        if (_advmodel.advArr.count>0)
        {
            [WYUserDefaultManager addTodayAppLanchAdvTimes];
            if ([WYUserDefaultManager isCanLanchAdvWithMaxTimes:@(_advmodel.num)])
            {
                advArrModel *advItemModel = [_advmodel.advArr firstObject];
                [weakSelf launchHomeAdvView:advItemModel];
            }
            else
            {
                [weakSelf addUNNotificationAlert];
            }
        }
        else
        {
            [weakSelf addUNNotificationAlert];
        }
        
    } failure:^(NSError *error) {
        
        [weakSelf addUNNotificationAlert];
    }];
}

#pragma mark launchAdv

- (void)launchHomeAdvView:(advArrModel *)model
{
    if (!self.transitonModelDelegate)
    {
        self.transitonModelDelegate = [[ZXAlphaTransitionDelegate alloc] init];
    }
    ZXAdvModalController *vc = [[ZXAdvModalController alloc] initWithNibName:nil bundle:nil];
    vc.btnActionDelegate = self;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.transitioningDelegate = self.transitonModelDelegate;
    ZXAdvModel *zxModel =[[ZXAdvModel alloc]initWithDesc:model.desc picString:model.pic url:model.url advId:model.iid];
    vc.advModel = zxModel;
    [self presentViewController:vc animated:YES completion:nil];
}

//第六步：检查推送通知是否关闭
*/
/*
- (void)addUNNotificationAlert
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0)
    {
        WS(weakSelf);
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            
            if (settings.authorizationStatus ==UNAuthorizationStatusDenied)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [weakSelf presentNotiAlert];
                });
            }
        }];
    }
    else
    {
        UIUserNotificationSettings * notiSettings = [[UIApplication sharedApplication]currentUserNotificationSettings];
        if (notiSettings.types == UIUserNotificationTypeNone)
        {
            [self presentNotiAlert];
        }
    }
}
- (void)presentNotiAlert
{
    if ([WYUserDefaultManager isCanPresentAlertWithIntervalDay:7])
    {
        ZXNotiAlertViewController *alertView = [[ZXNotiAlertViewController alloc] initWithNibName:@"ZXNotiAlertViewController" bundle:nil];
        [self.tabBarController addChildViewController:alertView];
        [self.tabBarController.view addSubview:alertView.view];
        alertView.view.frame = self.tabBarController.view.frame;
        __block ZXNotiAlertViewController *SELF = alertView;
        alertView.cancleActionHandleBlock = ^{
            
            [SELF removeFromParentViewController];
            [SELF.view removeFromSuperview];
        };
        alertView.doActionHandleBlock = ^{
            
            NSURL *openUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication]respondsToSelector:@selector(openURL:options:completionHandler:)])
            {
                [[UIApplication sharedApplication] openURL:openUrl options:@{} completionHandler:nil];
            }
            else
            {
                [[UIApplication sharedApplication] openURL:openUrl];
            }
        };
    }
}
*/
