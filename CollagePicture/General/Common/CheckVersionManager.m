//
//  CheckVersionManager.m
//  YiShangbao
//
//  Created by simon on 17/6/1.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "CheckVersionManager.h"


@implementation CheckVersionManager


+ (instancetype)sharedInstance
{
    static CheckVersionManager *manager = nil;
    if (manager==nil)
    {
        manager = [[CheckVersionManager alloc] init];
    }
    return manager;
}

// 即使多个地方调用也 只会检查一次
- (void)checkAppVersionOnceWithNextStep:(NextStepBlock)nextStep
{

        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            /**
             *  版本更新
             */
            [self checkAppVersionWithNextStep:nextStep];
            
        });

}


- (void)checkAppVersionWithNextStep:(NextStepBlock)nextStep
{
    /*
    [[[AppAPIHelper shareInstance] getMessageAPI] checkAppVersionWithSuccess:^(id data) {
        VersionModel *model = data;
        if ([model.version compare:APP_Version options:NSNumericSearch] ==NSOrderedDescending)
        {
            if ([model.isForce integerValue]==1) {
                HKVersionAlertView *alert_update = [[HKVersionAlertView alloc] initWithMessage:model.desc version:model.version closeButton:NO];
                [alert_update addConfirmButton:^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.url]];//苹果下载地址
                }];
                [alert_update show];
            }else{
                HKVersionAlertView *alert_update = [[HKVersionAlertView alloc]initWithMessage:model.desc version:model.version closeButton:YES];
                [alert_update addConfirmButton:^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.url]];//苹果下载地址
                }];
                [alert_update addCloseButton:^{
                    
                    nextStep();
                    
                }];
                [alert_update show];
            }
        }
        else
        {
            nextStep();
//            static dispatch_once_t onceToken;
//            dispatch_once(&onceToken, ^{
//                
//                [self lauchFirstNewFunction];
//                
//            });
            
        }
    } failure:^(NSError *error) {
        
        NSLog(@"检查App版本失败:%@",[error localizedDescription]);
        nextStep();
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
//            
//            [self lauchFirstNewFunction];
//            
//        });
        
    }];
     */
}


@end
