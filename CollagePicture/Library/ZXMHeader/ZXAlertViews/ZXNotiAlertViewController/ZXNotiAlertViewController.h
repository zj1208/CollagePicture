//
//  ZXNotiAlertViewController.h
//  YiShangbao
//
//  Created by simon on 2017/8/5.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  注释： 一个用于提示是否打开用户远程推送通知开关的自定义UI,有不打开和打开2个按钮；
//  2018.2.2 添加注释
//  2019.8.31 解决block调用循环引用的问题：ZXNotiAlertViewController * __weak SELF = alertView;

#import <UIKit/UIKit.h>

@interface ZXNotiAlertViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (nonatomic, copy) void (^cancleActionHandleBlock)(void);
@property (nonatomic, copy) void (^doActionHandleBlock)(void);


- (IBAction)cancleBtnAction:(UIButton *)sender;

- (IBAction)doBtnAction:(UIButton *)sender;

@end

// 举例
/*
- (void)presentNotiAlert
{
    if ([WYUserDefaultManager isCanPresentAlertWithIntervalDay:7])
    {
        
        ZXNotiAlertViewController *alertView = [[ZXNotiAlertViewController alloc] initWithNibName:@"ZXNotiAlertViewController" bundle:nil];
        [self.tabBarController addChildViewController:alertView];
        alertView.view.frame = self.tabBarController.view.frame;
        [self.tabBarController.view addSubview:alertView.view];
        ZXNotiAlertViewController * __weak SELF = alertView;
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
