//
//  WelcomeViewController.m
//  Baby
//
//  Created by hzidea on 16/2/19.
//  Copyright © 2016年 simon. All rights reserved.
//  欢迎界面
//  这个页面的gif动画有问题，不建议使用这个页面；

#import "WelcomeViewController.h"
#import "ZXOrientationNaController.h"


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
    [self setUI];
    [self setData];
}

- (void)setUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
}


- (void)setData
{
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"newWelcome" ofType:@"gif"];
    NSData * gif = [NSData dataWithContentsOfFile:path];
    [self.webView loadData:gif MIMEType:@"image/gif" textEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:path]];
}

- (UIWebView *)webView
{
    if (!_webView)
    {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0, LCDW, LCDH)];
        webView.delegate = self;
        webView.scalesPageToFit = YES;
        webView.dataDetectorTypes = !UIDataDetectorTypeAddress;
        webView.mediaPlaybackRequiresUserAction = NO;
        webView.allowsInlineMediaPlayback = YES;
        if ([webView respondsToSelector:@selector(allowsPictureInPictureMediaPlayback)])
        {
            webView.allowsPictureInPictureMediaPlayback = YES;
        }
        _webView = webView;
    }
    return _webView;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self performSelector:@selector(setRootController) withObject:self afterDelay:2.f];
}

- (void)setRootController
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    ZXOrientationNaController *myCenter = (ZXOrientationNaController *)[sb instantiateViewControllerWithIdentifier:SBID_MyCenterControllerNavID];
    APP_MainWindow.rootViewController =myCenter;


//     UITabBarController *tb = (UITabBarController *)[sb instantiateViewControllerWithIdentifier:sTabBarControllerID];

//    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
//    
//    LoginRegisterController *welcome = [[LoginRegisterController alloc] init];
//    
//    ZXOrientationNaController *welNav = [[ZXOrientationNaController alloc] initWithRootViewController:welcome];
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
