//
//  UIViewController+ZXHelper.m
//  Baby
//
//  Created by simon on 16/2/24.
//  Copyright © 2016年 sina. All rights reserved.
//

#import "UIViewController+ZXHelper.h"
#import "MBProgressHUD+ZXCategory.h"


//iTunesLink 链接－－iTunesLink＋appID，ios6以后有直接跳转appStore的item应用Controller页面
#ifndef ITUNESLINK
#define ITUNESLINK @"http://itunes.apple.com/cn/app/id"
#endif

@implementation UIViewController (ZXHelper)


- (void)zx_presentStoryboardViewControllerWithStoryboardName:(NSString *)name identifier:(nullable NSString *)storyboardId isNavigationController:(BOOL)flag withData:(nullable NSDictionary *)data completion:(void(^ __nullable)(void))completion
{
    UIViewController *controller = [self zx_getControllerWithStoryboardName:name controllerWithIdentifier:storyboardId];
    if (controller)
    {
        if (data)
        {
            [data enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                
                [controller setValue:obj forKey:key];
            }];
        }
        if (flag)
        {
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:nav animated:YES completion:completion];
        }
        else
        {
            [self presentViewController:controller animated:YES completion:completion];
        }
    }
}

-(UIViewController *)zx_getControllerWithStoryboardName:(NSString *)name controllerWithIdentifier:(nullable NSString *)storyboardId
{
    if (!name)
    {
        assert(name);
        return nil;
    }
    NSURL *resoureUrl = [[NSBundle mainBundle] URLForResource:name withExtension:@"storyboardc"];
    NSError  *error = nil;
    if ([resoureUrl checkResourceIsReachableAndReturnError:&error]==NO)
    {
        NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey: NSLocalizedStringFromTable(@"File URL not reachable.", @"", nil)};
        error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:NSURLErrorBadURL userInfo:userInfo];
        return nil;
    }
    UIStoryboard *sb=[UIStoryboard  storyboardWithName:name  bundle:[NSBundle mainBundle]];
    if (storyboardId)
    {
        return  [sb instantiateViewControllerWithIdentifier:storyboardId];
    }
    return [sb instantiateInitialViewController];
}
//


- (void)pushSameStoryboardPerformSegueWithIdentifier:(NSString *)segue withData:(NSDictionary *)data
{
    
}


- (void)zx_goBackPreController
{
    if (self.presentingViewController)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - SKStoreProductViewController
- (void)zx_goAppStoreWithAppId:(NSString *)appId
{
    Class skStore = NSClassFromString(@"SKStoreProductViewController");
    UIDevice *device = [UIDevice currentDevice];
    device.proximityMonitoringEnabled = YES;
    //用近距离传感器来判断是否是真机
    if (device.isProximityMonitoringEnabled && skStore)
    {
        [MBProgressHUD zx_showLoadingWithStatus:@"正在载入" toView:self.view];
        __weak __typeof(self)weakSelf = self;
        
        SKStoreProductViewController *skStoreProductVC = [[SKStoreProductViewController alloc] init];
        skStoreProductVC.delegate = self;
        [skStoreProductVC loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:appId} completionBlock:^(BOOL result, NSError *error) {
            
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            if (result)
            {
                [weakSelf presentViewController:skStoreProductVC animated:YES completion:nil];
            }
            if (error)
            {
                [MBProgressHUD zx_showError:[error localizedDescription] toView:self.view];
            }
        }];
        
    }
    else
    {
        NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ITUNESLINK,appId]];
        
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            if (@available(iOS 10.0,*)) {
//              如果指定的URL scheme由另一个app应用程序处理，options可以使用通用链接的key。空的options字典与旧的openURL调用是相同的；
//              当有这个key，如果设置为YES, 则URL必须是通用链接，并且有一个已安装的应用程序被用于打开该URL时，当前app才会打开URL。
//              如果没有其它app应用程序配置这个通用链接，或者用户设置NO禁用打开链接，则completion handler 回调里的success为false(NO)；
                [[UIApplication sharedApplication]openURL:url options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@(YES)} completionHandler:nil];
            }
            else
            {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }
    device.proximityMonitoringEnabled = NO;
}



//取消按钮
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)zx_callIphone:(NSString *)phone withAlertControllerFlag:(BOOL)flag
{
    if (!phone || phone.length == 0)
    {
        return;
    }
    if (!flag)
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
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"您还没有登录，是否需要登录", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
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
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}



/**
 回退到根控制器;
 1）原理上是presentingViewController对象负责dismiss，即使你用presentedViewController对象调用dismiss方法；
 2）如果您连续prensent呈现几个视图控制器，从而构建一个呈现的视图控制器堆栈，那么在堆栈中较低的视图控制器上调用此方法将会丢弃它的当前子视图控制器以及堆栈中该子视图控制器之上的所有视图控制器。
 例如：A页面prenset到页面B-B又prenset到C-C又prensent到D;只要A调用dismissViewController方法就会移除堆栈中该子视图控制器之上的所有控制器B，C，D；
 */
- (void)zx_dismissToRootViewController
{
    UIViewController *vc = self;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:nil];
}
@end
