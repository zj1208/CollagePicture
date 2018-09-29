//
//  ZXPopoverBackgroundView.h
//  YiShangbao
//
//  Created by simon on 2018/9/29.
//  Copyright © 2018年 com.Microants. All rights reserved.
//
//  简介：UIPopoverPresentationController是为了展示带箭头的选项弹框的；由于系统弹窗一些UI的局限性，没法修改；需要利用设置UIPopoverBackgroundView类重写；重写实现UIPopoverBackgroundView弹窗背景，定制化箭头，圆角，蒙层透明度；
//  定制弹出窗口背景chrome-_UIPopoverStandardChromeView，可以子类化UIPopoverBackgroundView替代默认背景，并在该类上实现所需的实例和类方法。通过这个类可以重写定制箭头大小；箭头宽度，高度通过常量统一设置； 还设置内容矩形-presentedViewController的view的圆角,系统的圆角无法修改，只有在重写的地方从父视图中间接获得修改；修改蒙层透明度；
//  注意：利用遍历superView的方法修改圆角，蒙层透明度，有可能会有bug，一旦系统控件内部结构修改；每次iOS的SDK更新都要留意变化；


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXPopoverBackgroundView : UIPopoverBackgroundView

// 绘制完箭头显示；
@property (nonatomic, strong) UIImageView *arrowImageView;

@end

NS_ASSUME_NONNULL_END

// 例如：弹出一个自定义popoverBackgroundView的popoverView；
/*
// #import "ZXPopoverBackgroundView.h"
// <UIPopoverPresentationControllerDelegate>

// [self displayOptionsForSelectedItem:sender];


- (void)displayOptionsForSelectedItem:(UIButton *)sender
{
    UIStoryboard *sb=[UIStoryboard  storyboardWithName:storyboard_ShopStore  bundle:[NSBundle mainBundle]];
    FansViewController *vc = (FansViewController *) [sb instantiateViewControllerWithIdentifier:SBID_FansViewController];
    vc.shopId = [UserInfoUDManager getShopId];
    vc.modalPresentationStyle = UIModalPresentationPopover;
    vc.preferredContentSize = CGSizeMake(LCDScale_5Equal6_To6plus(160), 250);
    vc.popoverPresentationController.sourceView = sender;
    vc.popoverPresentationController.sourceRect =sender.bounds;
    //    vc.popoverPresentationController.barButtonItem = sender;
    //    vc.popoverPresentationController.backgroundColor = [UIColor blackColor];//一般不设置
    vc.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    //    vc.popoverPresentationController.passthroughViews = @[self.tableView];
    vc.popoverPresentationController.delegate = self;
    vc.popoverPresentationController.popoverBackgroundViewClass = [ZXPopoverBackgroundView class];
    [self presentViewController:vc animated:YES completion:nil];
}
-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller traitCollection:(UITraitCollection *)traitCollection
{
    return UIModalPresentationNone;
}
*/
