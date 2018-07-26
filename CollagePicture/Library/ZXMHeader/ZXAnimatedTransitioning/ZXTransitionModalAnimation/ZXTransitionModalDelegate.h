//
//  ZXTransitionModalDelegate.h
//  YiShangbao
//
//  Created by simon on 17/3/9.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  6.26 添加注释

#import <Foundation/Foundation.h>
#import "ZXModalAnimation.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXTransitionModalDelegate : NSObject<UIViewControllerTransitioningDelegate>

//设置整个控制器viw页面的大小尺寸
@property (nonatomic, assign) CGSize contentSize;

@end


NS_ASSUME_NONNULL_END

/*
#pragma mark - 请求广告图
- (void)lauchPopoverView
{
    [[[AppAPIHelper shareInstance] getMessageAPI] GetAdvWithType:@1005 success:^(id data) {
        
        _advmodel = (AdvModel *)data;
        if (_advmodel.advArr.count>0)
        {
            [WYUserDefaultManager addTodayAppLanchAdvTimes];
            if ([WYUserDefaultManager isCanLanchAdvWithMaxTimes:@(_advmodel.num)])
            {
                advArrModel *advItemModel = [_advmodel.advArr firstObject];
                [self firstNewFunction:advItemModel];
            }
            else
            {
                [self addUNNotificationAlert];
            }
        }
        else
        {
            [self addUNNotificationAlert];
        }
        
    } failure:^(NSError *error) {
        
        [self addUNNotificationAlert];
    }];
}

#pragma mark - 广告图动画UIViewControllerTransitionDelegate


- (void)firstNewFunction:(advArrModel *)model
{
    if (!self.transitonModelDelegate)
    {
       self.transitonModelDelegate = [[ZXTransitionModalDelegate alloc] init];
    }
    ZXAdvModalController *vc = [[ZXAdvModalController alloc] initWithNibName:nil bundle:nil];
    vc.btnActionDelegate = self;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.transitioningDelegate = self.transitonModelDelegate;
    ZXAdvModel *zxModel =[[ZXAdvModel alloc]initWithDesc:model.desc picString:model.pic url:model.url advId:model.iid];
    vc.advModel = zxModel;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma  mark -  广告图按钮点击回调代理

- (void)zx_advModalController:(ZXAdvModalController *)controller advItem:(ZXAdvModel *)advModel
{
    [MobClick event:kUM_b_popups];
    
    NSString *advid = [NSString stringWithFormat:@"%@",advModel.advId];
    [self requestClickAdvWithAreaId:@1005 advId:advid];
    //业务逻辑的跳转
    [[WYUtility dataUtil]routerWithName:advModel.url withSoureController:self];
}

*/
