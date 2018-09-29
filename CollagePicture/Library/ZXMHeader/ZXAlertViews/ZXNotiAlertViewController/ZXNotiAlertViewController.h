//
//  ZXNotiAlertViewController.h
//  YiShangbao
//
//  Created by simon on 2017/8/5.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  注释： 一个自定义UI效果的通知广告；
//  2018.2.2 添加注释

#import <UIKit/UIKit.h>

@interface ZXNotiAlertViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *containerView;
//void(^photoModelItemViewBlock)(UIView* itemView);
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
