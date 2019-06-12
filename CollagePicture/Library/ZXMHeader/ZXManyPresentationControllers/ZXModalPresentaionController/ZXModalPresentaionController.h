//
//  ZXModalPresentaionController.h
//  YiShangbao
//
//  Created by simon on 2018/9/26.
//  Copyright © 2018年 com.Microants. All rights reserved.
//
//  简介：封装转场弹窗通用管理类ZXModalPresentaionController，增加了模糊背景的蒙层；它是自定义呈现presentedViewController的管理器，而不是一个控制器，管理着prentingViewController和presentedViewController，它的最大作用是分离实际需要展示业务内容 和 遮罩、设置frame等技术需要。可以自定义设置frame大小和位置，并且遮罩在原来的presentingViewController页面之上，在containerView上添加模糊背景view，点击手势可以dismiss当前控制器页面；使用的是默认往上呈现/往下消失的过渡切换；
//  也可以把UIVisualEffectView模糊蒙层换成普通的view蒙层；

//  优点：（1）封装转场通过管理类可以通用于一种场景：遮罩+可以设置frame的业务控制器的整个view；
//       （2）实现弹框，最常见的实现方式是把模态框作为一个View，需要的时候通过动画从底部弹出来。这样做起来很方便，但可扩展性往往不够，弹框的内容可能会是任何控件或者组合。如果弹框是个控制器，扩展性会更好。
//（3）不管连续prensted多少页面，只要在最初prensent的控制器调用[self dismissViewController：]就会移除所有prenseted的控制器；
/*
【dismissViewController：】：
1）原理上是presentingViewController对象负责dismiss，即使你用presentedViewController对象调用此方法；
2）如果您连续prensent呈现几个视图控制器，从而构建一个呈现的视图控制器堆栈，那么在堆栈中较低的视图控制器上调用此方法将会丢弃它的当前子视图控制器以及堆栈中该子视图控制器之上的所有视图控制器。
 例如：A页面prenset到页面B-B又prenset到C-C又prensent到D;只要A调用dismissViewController方法就会移除堆栈中该子视图控制器之上的所有控制器B，C，D；
*/

//  缺点：注意引起bug：当在当前控制器调用presentViewController:方法弹起A时，会让presentedViewController（A）上设置自定义frame，当再用A调用presentViewController:方法在A页面之上弹起B，A会被移除，当Bdismiss的时候，会重新添加A控制器且frame为全屏,导致frameOfPresentedViewInContainerView返回的frame无效；
//  造成这种现象的原因是因为，在自定义尺寸的控制器上present一个全屏控制器的时候，系统会自动把当前层级下的自定义尺寸的控制器的View移除掉，当我们对全屏控制器做dismiss操作后又会添加回去。   已解决；

//  扩展学习：http://www.cocoachina.com/ios/20190225/26413.html

//  2019.3.14  增加透明度属性；
//  2019.3.20 增加转场协调方法；
//  2019.06.03 修改注释；解决bug；
//  2019.06.11 修改注释；


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface ZXModalPresentaionController : UIPresentationController

// 设置弹出的presentedView的frame大小位置；
@property (nonatomic, assign) CGRect frameOfPresentedView;
// 最小0.02，如果小于0.02，dimingView则不会接收事件；
@property (nonatomic, assign) CGFloat dimmingViewAlpha;

@end

NS_ASSUME_NONNULL_END

/*
 #import "ZXModalPresentaionController.h"
<UIViewControllerTransitioningDelegate>
// 预览
- (void)previewBtnAction:(UIButton *)sender
{
    ZXNotiAlertViewController *vc = [[ZXNotiAlertViewController alloc] initWithNibName:@"ZXNotiAlertViewController" bundle:nil];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.transitioningDelegate = self;
    __block ZXNotiAlertViewController *SELF = vc;
    vc.cancleActionHandleBlock = ^{
        
        [SELF dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentViewController:vc animated:YES completion:nil];
 }
 
 #pragma mark - UIViewControllerTransitioningDelegate
//转场管理器
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    ZXModalPresentaionController *presentation =  [[ZXModalPresentaionController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    presentation.frameOfPresentedView = CGRectMake(0, LCDH-300, LCDW, 300);
    presentation.dimmingViewAlpha = 0.02;
    return presentation;
}
 */
