//
//  ZXAdvModalController.h
//  YiShangbao
//
//  Created by simon on 17/3/24.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXAdvModel.h"

NS_ASSUME_NONNULL_BEGIN
@class ZXAdvModalController;

@protocol ZXAdvModalControllerDelegate <NSObject>


/**
 点击广告图按钮的回调代理

 @param controller self
 @param advModel 广告数据源
 */
- (void)zx_advModalController:(ZXAdvModalController *)controller advItem:(ZXAdvModel *)advModel;

@end



@interface ZXAdvModalController : UIViewController

@property (nonatomic, weak) id<ZXAdvModalControllerDelegate>btnActionDelegate;


@property (weak, nonatomic) IBOutlet UIButton *advPicBtn;
@property (weak, nonatomic) IBOutlet UIButton *dismissBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dismissBtnLayoutWidth;

//广告图左边距／上边距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMaginLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMaginLayout;

//数据源
@property (nonatomic, strong)ZXAdvModel *advModel;

//点击广告图按钮
- (IBAction)advPicBtnAction:(UIButton *)sender;

//取消隐藏
- (IBAction)dismissBtnAction:(id)sender;

@end

NS_ASSUME_NONNULL_END

/*****************例如***********************/
/*
- (void)firstNewFunction:(advArrModel *)model
{
    ZXAdvModalController *vc = [[ZXAdvModalController alloc] initWithNibName:nil bundle:nil];
    vc.btnActionDelegate = self;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.transitioningDelegate = self;
    ZXAdvModel *zxModel =[[ZXAdvModel alloc]initWithDesc:model.desc picString:model.pic url:model.url];
    vc.advModel = zxModel;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma  mark -  广告图按钮点击回调代理

- (void)zx_advModalController:(ZXAdvModalController *)controller advItem:(ZXAdvModel *)advModel
{
    //业务逻辑的跳转
    [[WYUtility dataUtil]cheackAdvURLToControllerWithSoureController:self.navigationController advUrlString:advModel.url];
}

 
 #pragma mark-UIViewControllerTransitionDelegate
 
 - (nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
 {
    self.modalAnimation.type = ZXAnimationTypePresent;
    return self.modalAnimation;
 }
 
 
 - (nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
 {
    self.modalAnimation.type = ZXAnimationTypeDismiss;
    return self.modalAnimation;
 }

 */
