//
//  WelcomeViewController.m
//  Baby
//
//  Created by hzidea on 16/2/19.
//  Copyright © 2016年 simon. All rights reserved.
//  欢迎界面

#import "WelcomeViewController.h"
#import "OrientationNaController.h"

@interface WelcomeViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView * webView;

@end

@implementation WelcomeViewController
//是否支持屏幕旋转；
- (BOOL)shouldAutorotate
{
    return YES;
}
/**
 *  支持的界面旋转方向
 *
 *  @return 旋转的方向
 */
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
     return UIInterfaceOrientationMaskPortrait;
}

//播放gif图片
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"newWelcome" ofType:@"gif"];
    NSData * gif = [NSData dataWithContentsOfFile:path];
    UIWebView *web = [[UIWebView alloc] initWithFrame:self.view.frame];
    web.scalesPageToFit = YES;
    [web loadData:gif MIMEType:@"image/gif" textEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:path]];
    web.delegate =self;
    self.webView = web;
    [self.view addSubview:self.webView];

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self performSelector:@selector(setRootController) withObject:self afterDelay:1.5f];
}

- (void)setRootController
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    OrientationNaController *myCenter = (OrientationNaController *)[sb instantiateViewControllerWithIdentifier:SBID_MyCenterControllerNavID];
    APP_MainWindow.rootViewController =myCenter;


//    UITabBarController *tb = (UITabBarController *)[sb instantiateViewControllerWithIdentifier:sTabBarControllerID];

//    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
//    
//    LoginRegisterController *welcome = [[LoginRegisterController alloc] init];
//    
//    OrientationNaController *welNav = [[OrientationNaController alloc] initWithRootViewController:welcome];
//   
//    if ([UserInfoUDManager isLogin])
//    {
//        window.rootViewController = tb;
//    }
//    else
//    {
//        window.rootViewController = welNav;
//    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
