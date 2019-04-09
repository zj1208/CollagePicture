//
//  ZXModalPresentaionController.h
//  YiShangbao
//
//  Created by simon on 2018/9/26.
//  Copyright © 2018年 com.Microants. All rights reserved.
//
//  简介：封装转场弹窗通用管理类ZXModalPresentaionController，增加了模糊背景的蒙层；它是自定义呈现presentedViewController的管理器，而不是一个控制器，管理着prentingViewController和presentedViewController，它的最大作用是分离实际需要展示业务内容 和 遮罩、设置frame等技术需要。可以自定义设置frame大小和位置，并且遮罩在原来的presentingViewController页面之上，在containerView上添加模糊背景view，点击手势可以dismiss当前控制器页面；使用的是默认往上呈现/往下消失的过渡切换；
//  优点：封装转场通过管理类可以通用于一种场景：遮罩+可以设置frame的业务控制器的整个view；

//  2019.3.14  增加透明度属性；
//  2019.3.20 增加转场协调方法；


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXModalPresentaionController : UIPresentationController

// 设置弹出的presentedView的frame大小位置；
@property (nonatomic, assign) CGRect frameOfPresentedView;

@property (nonatomic, assign) CGFloat dimmingViewAlpha;

@end

NS_ASSUME_NONNULL_END

/*
 #import "ZXModalPresentaionController.h"
<UIViewControllerTransitioningDelegate>
// 预览
- (void)previewBtnAction:(UIButton *)sender
{
    ZXNotiAlertViewController *alertView = [[ZXNotiAlertViewController alloc] initWithNibName:@"ZXNotiAlertViewController" bundle:nil];
    alertView.modalPresentationStyle = UIModalPresentationCustom;
    alertView.transitioningDelegate = self;
    __block ZXNotiAlertViewController *SELF = alertView;
    alertView.cancleActionHandleBlock = ^{
        
        [SELF dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentViewController:alertView animated:YES completion:nil];
 }
//转场管理器
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    ZXModalPresentaionController *presentation =  [[ZXModalPresentaionController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    presentation.frameOfPresentedView = CGRectMake(0, LCDH-300, LCDW, 300);
    return presentation;
}
 */
