//
//  ZXOrientationTabController.m
//  Baby
//
//  Created by simon on 16/2/24.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "ZXOrientationTabController.h"

@interface ZXOrientationTabController ()

@end

@implementation ZXOrientationTabController
- (BOOL)shouldAutorotate
{
    return [self.selectedViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.selectedViewController supportedInterfaceOrientations];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


// 方案一：
// 重写statusBarStyle
- (nullable UIViewController *)childViewControllerForStatusBarStyle
{
    return self.selectedViewController;
}

- (nullable UIViewController *)childViewControllerForStatusBarHidden
{
    return self.selectedViewController;
}

//方案二：
//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return [self.selectedViewController preferredStatusBarStyle];
//}
//- (BOOL)prefersStatusBarHidden
//{
//    return [self.selectedViewController prefersStatusBarHidden];
//}
//- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
//{
//    return [self.selectedViewController preferredStatusBarUpdateAnimation];
//}

- (nullable UIViewController *)childViewControllerForHomeIndicatorAutoHidden
{
    return self.selectedViewController;
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
