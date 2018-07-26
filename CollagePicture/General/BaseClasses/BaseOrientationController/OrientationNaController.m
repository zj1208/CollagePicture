//
//  OrientationNaController.m
//  Baby
//
//  Created by simon on 16/2/24.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "OrientationNaController.h"

@interface OrientationNaController ()
@end

@implementation OrientationNaController

static NSString * const kTopViewController_OrientationRight = @"MakingPhotoController";


//是否支持屏幕旋转；
- (BOOL)shouldAutorotate
{

    return YES;
}
/**
 *  支持的界面旋转方向,刚启动的时候viewController会回调9次。 如果只支持UIInterfaceOrientationMaskLandscapeRight，UIInterfaceOrientationMaskPortrait，则另外每次旋转设备只会调用2次；
 *
 *  @return 旋转的方向
 */
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([self.topViewController isKindOfClass:NSClassFromString(kTopViewController_OrientationRight)])
    {
        return UIInterfaceOrientationMaskLandscapeRight;
    }
    return UIInterfaceOrientationMaskPortrait;
}

// 回最优先显示的屏幕方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if ([self.topViewController isKindOfClass:NSClassFromString(kTopViewController_OrientationRight)])
    {
        return UIInterfaceOrientationLandscapeRight ;
    }
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

/**
 *  如果支持某个界面方向，则可以强制调整；
 *
 *  @param direction  你想转过去的方向
 */
- (void)rotateToDirection:(UIInterfaceOrientation)direction
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = direction;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

// 方案一：
// 重写statusBarStyle
- (nullable UIViewController *)childViewControllerForStatusBarStyle
{
    return self.topViewController;
}

- (nullable UIViewController *)childViewControllerForStatusBarHidden
{
    return self.topViewController;
}

//方案二：
//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    UIViewController* topVC = self.topViewController;
//    return [topVC preferredStatusBarStyle];
//}
//- (BOOL)prefersStatusBarHidden
//{
//    return [self.topViewController prefersStatusBarHidden];
//}
//- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
//{
//    return [self.topViewController preferredStatusBarUpdateAnimation];
//}


- (nullable UIViewController *)childViewControllerForHomeIndicatorAutoHidden API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(watchos, tvos)
{
    return self.topViewController;
}
// 要隐藏Home指示条的viewController重写回调：
//- (BOOL)prefersHomeIndicatorAutoHidden
//{
//    return YES;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
