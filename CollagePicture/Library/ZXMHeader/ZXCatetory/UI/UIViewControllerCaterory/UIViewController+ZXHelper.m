//
//  UIViewController+ZXHelper.m
//  Baby
//
//  Created by simon on 16/2/24.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "UIViewController+ZXHelper.h"
#import "MBProgressHUD+ZXExtension.h"


//iTunesLink 链接－－iTunesLink＋appID，ios6以后有直接跳转appStore的item应用Controller页面
#ifndef ITUNESLINK
#define ITUNESLINK @"http://itunes.apple.com/cn/app/id"
#endif

@implementation UIViewController (ZXHelper)

- (void)pushStoryboardViewControllerWithStoryboardName:(NSString *)name identifier:(NSString *)segue withData:(nullable NSDictionary *)data
{
    UIViewController *controller = [self getControllerWithStoryboardName:name controllerWithIdentifier:segue];
    if (controller)
    {
        if (data)
        {
            [data enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                
                [controller setValue:obj forKey:key];
            }];
        }
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}


- (void)presentStoryboardViewControllerWithStoryboardName:(NSString *)name identifier:(NSString *)segue withData:(nullable NSDictionary *)data
{
    UIViewController *controller = [self getControllerWithStoryboardName:name controllerWithIdentifier:segue];
    if (controller)
    {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
        if (data)
        {
            [data enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                
                [controller setValue:obj forKey:key];
            }];
        }
        [self presentViewController:nav animated:YES completion:nil];
    }
}

-(UIViewController *)getControllerWithStoryboardName:(NSString *)name controllerWithIdentifier:(NSString *)segue
{
    if (!name ||!segue)
    {
        assert(name);
        return nil;
    }
    NSURL *resoureUrl = [[NSBundle mainBundle] URLForResource:name withExtension:@"storyboardc"];
    NSError  *error = nil;
    if ([resoureUrl checkResourceIsReachableAndReturnError:&error]==NO)
    {
        NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey: NSLocalizedStringFromTable(@"File URL not reachable.", @"", nil)};
        error = [[NSError alloc] initWithDomain:AFURLRequestSerializationErrorDomain code:NSURLErrorBadURL userInfo:userInfo];
        NSLog(@"%@",error);
        return nil;
    }
    UIStoryboard *sb=[UIStoryboard  storyboardWithName:name  bundle:[NSBundle mainBundle]];
    UIViewController *controller= [sb instantiateViewControllerWithIdentifier:segue];
    return controller;
}
//
- (void)pushStoryboardViewControllerWithStoryboardName:(NSString *)name identifier:(NSString *)segue withData:(NSDictionary *)data toController:(void(^)(UIViewController *vc))toControllerBlock
{
    UIViewController *controller = [self getControllerWithStoryboardName:name controllerWithIdentifier:segue];
    if (toControllerBlock)
    {
        toControllerBlock(controller);
    }
    [self pushStoryboardViewControllerWithStoryboardName:name identifier:segue withData:data];

}


- (void)pushSameStoryboardPerformSegueWithIdentifier:(NSString *)segue withData:(NSDictionary *)data
{
    
}


- (void)goBackPreController
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
- (void)goAppStoreWithAppId:(NSString *)appId
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
            if ([[[UIDevice currentDevice] systemVersion]floatValue]>=10.f)
            {
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





- (void)zhCallIphone:(NSString *)phone withAlertController:(UIAlertController *)alertController
{
    if (phone && phone.length>0)
    {
        if (!alertController)
        {
            NSString *allString = [NSString stringWithFormat:@"tel:%@",phone];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
        }
        else
        {            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSString *allString = [NSString stringWithFormat:@"tel:%@",phone];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
                
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:otherAction];
            [self presentViewController:alertController animated:YES completion:nil];

        }

    }
}

@end
