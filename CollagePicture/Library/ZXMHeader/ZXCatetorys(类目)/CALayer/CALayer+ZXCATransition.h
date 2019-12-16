//
//  CALayer+ZXCATransition.h
//  MusiceFate
//
//  Created by simon on 2013/8/13.
//  Copyright © 2013年 yinyuetai.com. All rights reserved.
//
//  简介：系统通过CATansition设置转场动画；给某个view的图层layer添加CATransition；CATransition 是CAAnimation的子类，用于页面之间的过度动画，官方提供了四个公有的API动画效果，但是私有API的效果更加炫酷； 高逼格动画效果不适用于普通APP，不然会显得格格不入；研究动画效果也要与产品类型相结合；；
//  使用Core Animation Transitions(过渡，翻页)/使用CATransition只针对图层
//  首先要在framework中引入QuatrtzCore.framework,在头文件中需要
//  #import <QuartzCore/QuartzCore.h>

//  2019.06.12  修改@import
//  2019.10.30  其它项目@import会报错，改回<QuartzCore/QuartzCore.h>


#import <QuartzCore/QuartzCore.h>
//@import QuartzCore;

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (ZXCATransition)<CAAnimationDelegate>




/**
 @param kCATransitionType 动画类型
 */
- (void)zx_customDirectionFromTopAnimationType:(NSString *)kCATransitionType;

- (void)zx_customDirectionFromBottomAnimationType:(NSString *)kCATransitionType;


/**
 添加一个CATransition转场动画到CALayer上

 @param kCATransitionType 动画类型
 系统公开的4个效果：
 kCATransitionReveal/揭开，
 kCATransitionPush/推挤，
 kCATransitionMoveIn/覆盖，
 KCATransitionFade/淡化；
 私有效果：@"cube" 立方体；
 @"suckEffect" 吸收，缩小斜着飞走到角落消失的感觉；
 @"oglFlip" 翻转（从A方向转到对立B方向，如从右翻转到左）；
 @"rippleEffect" 波纹，水滴波动效果；
 @"pageCurl" 翻页，向上翻一页；
 @"pageUnCurl" 反翻页，向下翻一页；
 @"cameraIrisHollowOpen" 相机镜头打开效果；
 @"cameraIrisHollowClose" 相机镜头关闭效果；
 
 @param subtype 转场弹出方向类型有以下4种：
 kCATransitionFromRight，kCATransitionFromLeft，kCATransitionFromTop，kCATransitionFromBottom；
 
 */
- (void)zx_addCATansitionWithAnimationType:(NSString *)kCATransitionType directionOfTransitionSubtype:(NSString *)subtype;
@end


NS_ASSUME_NONNULL_END
/*
 (1）Nav导航转场：
  
    [self.navigationController.view.layer zx_addCATansitionWithAnimationType:@"cube" directionOfTransitionSubtype:kCATransitionFromRight];

  例如：
 - (void)pushVCWithTransition{
    ZXWKWebViewController *htmlVc = [[ZXWKWebViewController alloc] init];
    [htmlVc loadWebPageWithURLString:url];
    htmlVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController.view.layer zx_addCATansitionWithAnimationType:@"cube" directionOfTransitionSubtype:kCATransitionFromRight];
    [self.navigationController pushViewController:htmlVc animated:NO];
 }

（2）modal模态转场：
    [self.view.window.layer zx_addCATansitionWithAnimationType:@"cube" directionOfTransitionSubtype:kCATransitionFromRight];
  例如：
  - (void)presentVCWithTransition{
    ZXWKWebViewController *htmlVc = [[ZXWKWebViewController alloc] init];
    [htmlVc loadWebPageWithURLString:url];
    htmlVc.hidesBottomBarWhenPushed = YES;
    [self.view.window.layer zx_addCATansitionWithAnimationType:@"cube" directionOfTransitionSubtype:kCATransitionFromRight];
    [self presentViewController:vc animated:NO completion:nil];
 }
*/


