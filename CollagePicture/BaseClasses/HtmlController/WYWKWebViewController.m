//
//  WYWKWebViewController.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/10/20.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYWKWebViewController.h"

#import "ZXEmptyViewController.h"

#import "WKWebViewJavascriptBridge.h"
#import <AlipaySDK/AlipaySDK.h>
#import "XLPhotoBrowser.h"
#import "ZXHTTPCookieManager.h"

typedef NS_ENUM(NSInteger, WebLoadType) {
    
    WebLoadType_URLString =0,//网络html地址
    WebLoadType_LocalHTMLFile =1,//本地html文件
    WebLoadType_LocalFileContent = 2,//本地纯文本文件
    WebLoadType_LocalFile =3, //本地文件
};


@interface WYWKWebViewController ()<WKNavigationDelegate,WKUIDelegate,
XLPhotoBrowserDatasource,XLPhotoBrowserDelegate, ZXEmptyViewControllerDelegate,UIGestureRecognizerDelegate>



//进度条
@property (nonatomic, strong) UIProgressView *progressView;

//标题
@property (nonatomic, copy) NSString *barTitle;

@property (nonatomic, copy) NSString *changeURLString;

// 导航条按钮;
// 返回按钮
@property (nonatomic, strong) UIBarButtonItem *backButtonItem;
// 关闭按钮
@property (nonatomic, strong) UIBarButtonItem *closeButtonItem;
// 填充间距按钮
@property (nonatomic, strong) UIBarButtonItem *negativeSpacerItem;
// 右侧分享按钮
@property (nonatomic, strong) UIBarButtonItem *shareButtonItem;
// 右侧更多按钮
//@property (nonatomic, strong)UIBarButtonItem *moreButtonItem;

// 空视图；
@property (nonatomic, strong) ZXEmptyViewController *emptyViewController;

@property WKWebViewJavascriptBridge *bridge;

//加载类型
@property (nonatomic) WebLoadType webLoadType;

//1.网络地址
@property (nonatomic, copy) NSString *URLString;
//2.本地文件资源
//文件名/或本地html名
@property (nonatomic, copy) NSString *localFileName;
//文件类型
@property (nonatomic, copy) NSString *localFileType;
@property (nonatomic, copy) NSString *localFileMimeType;
//3.本地文件txt数据
@property (nonatomic, copy) NSString *localTxtFileContent;
//URL数组
@property(nonatomic, strong) NSMutableArray *urlArrayM;


@property (nonatomic, strong) NSMutableDictionary *btnFun;
@property (nonatomic, strong) NSMutableDictionary *rrbtnDic;
@property (nonatomic, strong) NSMutableDictionary *lrbtnDic;

@property(nonatomic, copy) NSArray *picArray;

@property (nonatomic, assign) BOOL needDellocH5; //h5跳原生后，从堆栈中移除

@end
static NSString* const SixSpaces = @"      ";
@implementation WYWKWebViewController

#pragma mark - life cycle

- (instancetype)initWithBarTitle:(NSString *)aTitle{
    self = [super init];
    if (self)
    {
        self.barTitle = aTitle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"F3F3F3"];
    //设置userAgent-必须第一
    [self userAgent];
    
    //搭建UI
    [self buildUI];
    
    //初始化数据
    [self setData];
    //建立桥接
    [self addWebViewJavascriptBridge];
    
    //根据不同业务加载数据
    [self webViewRequestLoadType];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.bridge) {
        [self addWebViewJavascriptBridge]; //重新建立桥街
    }
   
    if (self.presentedViewController)
    {//h5调用系统相册、相机、文件系统后不resume(下面这两个类)
//        [self.presentedViewController isKindOfClass:[UIImagePickerController class]];
//        [self.presentedViewController isKindOfClass:[UIDocumentPickerViewController class]];
    }else{
        [self resume];//h5内路由跳转原生后，返回回来的时候，通知H5刷新页面
    }

    if (self.navigationController.viewControllers.count>1)
    {
       self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.webView.scrollView flashScrollIndicators];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.navigationController.navigationBar setShadowImage:nil];
    self.bridge = nil;

}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.needDellocH5) {
        NSMutableArray *arrayM = [NSMutableArray arrayWithArray:self.navigationController.childViewControllers];
        [arrayM removeObject:self];
        [self.navigationController setViewControllers:arrayM animated:NO];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
//    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)dealloc
{
    NSLog(@"dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(title)) ];
    [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(URL)) ];
}

#pragma mark - ------------------------UI--------------------------
-(void) buildUI
{    //设置导航条
    [self setupNav];
    //添加WKWebView；
    [self.view addSubview:self.webView];
    //添加进度条
    [self.view addSubview:self.progressView];
    
    [self addObserver];
    [self addEmptyView];
   
    if (@available(iOS 11.0, *)){
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark -初始化导航条
- (void)setupNav
{
    //不要用animated，不然有bug
    NSArray *items = [self zhNavigationItem_leftOrRightItemReducedSpaceToMagin:-7 withItems:@[self.backButtonItem,self.negativeSpacerItem]];
    self.navigationItem.leftBarButtonItems = items;
    
    NSRange rangeCFB = [self.URLString rangeOfString:@"pingan.com"];
    if (rangeCFB.location != NSNotFound)
    {
        self.barTitle = @"平安财富宝理财专区";
    }
    self.title = self.barTitle;
    
    NSRange rangeDuiBa = [self.URLString rangeOfString:@"duiba.com.cn"];
    
    // 屏蔽兑吧域名，兑吧界面不展示分享
    if(rangeDuiBa.location == NSNotFound && rangeCFB.location == NSNotFound)
    {
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:SixSpaces style:UIBarButtonItemStylePlain target:self action:@selector(shareAction:)];//默认6个空格占位，空格太少按钮宽度过小，title切换至“分享”过渡效果不太好
        self.shareButtonItem = rightBarButtonItem;
        self.shareButtonItem.enabled = NO;
        NSArray *rightItems = @[self.shareButtonItem];
        [self.navigationItem setRightBarButtonItems:rightItems animated:NO];
    }
}


- (WKWebView *)webView
{
    if (!_webView)
    {
        WKUserContentController *contentContorller = [[WKUserContentController alloc] init];
        
//        // 注入一个用户脚本；
//        NSString *source = [NSString stringWithFormat:@"document.cookie = 'mat = %@'",[UserInfoUDManager getToken]];
//        WKUserScript *cookieScript =  [[WKUserScript alloc] initWithSource:source injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
//        [contentContorller addUserScript:cookieScript];
        
        //不能乱设置，不然布局会乱
        WKPreferences *preferences = [[WKPreferences alloc] init];
        //默认值
        preferences.minimumFontSize = 0.f;
        preferences.javaScriptEnabled = YES;
        
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = contentContorller ;
        configuration.preferences = preferences;
        configuration.allowsInlineMediaPlayback = YES;
        //ios9以上
        if ([configuration respondsToSelector:@selector(allowsPictureInPictureMediaPlayback)])
        {
            configuration.allowsPictureInPictureMediaPlayback = YES;
        }
        if ([configuration respondsToSelector:@selector(allowsAirPlayForMediaPlayback)])
        {
            configuration.allowsAirPlayForMediaPlayback  = YES;
        }
        //  iOS10以上
        if ([configuration respondsToSelector:@selector(dataDetectorTypes)])
        {
            configuration.dataDetectorTypes = !WKDataDetectorTypeAddress;
        }
        // 音乐自动播放；iOS10
        if (Device_SYSTEMVERSION_Greater_THAN_OR_EQUAL_TO(10))
        {
            if ([configuration respondsToSelector:@selector(mediaTypesRequiringUserActionForPlayback)])
            {
                configuration.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
            }
        }
        else
        {
            // ios9
            if ([configuration respondsToSelector:@selector(requiresUserActionForMediaPlayback)])
            {
                configuration.requiresUserActionForMediaPlayback = NO;
            }
            // ios8
            if ([configuration respondsToSelector:@selector(mediaPlaybackRequiresUserAction)])
            {
                configuration.mediaPlaybackRequiresUserAction = NO;
            }
        }
        
        WKWebView *wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, HEIGHT_NAVBAR, LCDW, LCDH-HEIGHT_NAVBAR-HEIGHT_TABBARSAFE) configuration:configuration]; //设置frame来调整，用wkWebView.scrollView.contentInset会引起H5底部参考点出错
        wkWebView.backgroundColor = self.view.backgroundColor;
        wkWebView.allowsBackForwardNavigationGestures = YES;
        if ([wkWebView respondsToSelector:@selector(allowsLinkPreview)])
        {
            wkWebView.allowsLinkPreview = YES;
        }

        wkWebView.navigationDelegate = self;
//        wkWebView.UIDelegate = self;
        _webView = wkWebView;
    }
    return _webView;
}

- (UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.frame = CGRectMake(0,HEIGHT_NAVBAR, self.view.bounds.size.width, 2);
        _progressView.trackTintColor = [UIColor clearColor];
        if ([WYUserDefaultManager getUserTargetRoleType] == WYTargetRoleType_seller) {
            _progressView.progressTintColor = [UIColor colorWithHexString:@"FF5434"];
        }else{
            _progressView.progressTintColor = [UIColor colorWithHexString:@"F58F23"];
        }
    }
    return _progressView;
}



-(void)addEmptyView
{
    ZXEmptyViewController *emptyVC =[[ZXEmptyViewController alloc] init];
    emptyVC.view.frame = self.view.frame;
    emptyVC.delegate = self;
    self.emptyViewController = emptyVC;
}

- (void)managerCookiesChanged:(id)notification
{
//    NSURL* url = self.urlArrayM.firstObject;
//    [self requestWithUrlStr:url.absoluteString];
    
    
//    [self resume];//h5内路由跳转原生后，返回回来的时候，通知H5刷新页面
//    [self.webView reload];
//    NSLog(@"NSHTTPCookieStorage=%@",[NSHTTPCookieStorage sharedHTTPCookieStorage].cookies);
    
}

#pragma mark - 添加KVO观察者

- (void)addObserver
{
    //kvo监听，获得页面title和加载进度值;
    [self.webView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:NSKeyValueObservingOptionNew context:NULL];
    [self.webView addObserver:self forKeyPath:NSStringFromSelector(@selector(title)) options:NSKeyValueObservingOptionNew context:NULL];
    [self.webView addObserver:self forKeyPath:NSStringFromSelector(@selector(URL)) options:NSKeyValueObservingOptionNew context:NULL];

}

#pragma mark -KVO的监听代理

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    //加载进度值
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.webView)
    {
        [self.progressView setAlpha:1.0f];
        BOOL animated = self.webView.estimatedProgress > self.progressView.progress;
        if (animated)
        {
            [self.progressView setProgress:self.webView.estimatedProgress animated:animated];
        }
        if(self.webView.estimatedProgress >= 1.0f)
        {
            [UIView animateWithDuration:0.5f delay:0.1f options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 [self.progressView setAlpha:0.0f];
                             }completion:^(BOOL finished) {
                                 [self.progressView setProgress:0.0f animated:NO];
                                 [self.navigationController.navigationBar setShadowImage:nil];
                             }];
        }
    }
    //网页title
    else if ([keyPath isEqualToString:NSStringFromSelector(@selector(title))] && object ==self.webView)
    {
        if (!self.barTitle && self.webView.title.length>0)
        {
            self.navigationItem.title = self.webView.title;
        }
    }
    //网页url
    else if ([keyPath isEqualToString:NSStringFromSelector(@selector(URL))] && object ==self.webView)
    {
        if (self.webView.URL) {
            [self.urlArrayM addObject:self.webView.URL];
        }
        NSLog(@">>%@",self.webView.URL);
        NSLog(@"<<%@",self.urlArrayM);
    }
}


#pragma mark - initData初始化数据

//初始化数据
- (void)setData
{
    self.urlArrayM = [NSMutableArray array];
    self.picArray = [NSArray array];
    _btnFun = [NSMutableDictionary new];
    _lrbtnDic = [NSMutableDictionary new];
    _rrbtnDic = [NSMutableDictionary new];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateInfo:) name:Noti_ProductManager_Edit_goBackUpdate object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginIn:) name:kNotificationUserLoginIn object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(managerCookiesChanged:) name:NSHTTPCookieManagerCookiesChangedNotification object:nil];

}

#pragma mark-通知selector
- (void)updateInfo:(id)notification
{
    [self.webView reload];
}
- (void)loginIn:(id)notification
{
    if (Device_SYSTEMVERSION.floatValue>8 && Device_SYSTEMVERSION.floatValue<11)
    {
        // 为了解决登陆完，cookie还没有被写进浏览器；
        [MBProgressHUD zx_showSuccess:@"登陆成功，正在刷新数据" toView:self.view hideAfterDelay:2.5f];
        [self.webView performSelector:@selector(reload) withObject:nil afterDelay:2.5f];
        [self performSelector:@selector(resume) withObject:nil afterDelay:2.5f];
    }
    else
    {
        if (@available(iOS 11.0, *))
        {
            WKHTTPCookieStore *cookieStore = [WKWebsiteDataStore defaultDataStore].httpCookieStore;
            NSHTTPCookie *cookie = [[ZXHTTPCookieManager sharedInstance]getHTTPCookieFromNSHTTPCookieStorageWithCookieName:@"mat"];
            [cookieStore setCookie:cookie completionHandler:^{
            }];
        }
        [self.webView reload];
    }
}


#pragma mark - 设置user-agent

-(void)userAgent
{
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *oldAgent = [web stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *newAgent = nil;
    // microants-xx-版本号
    NSString *customString = [NSString stringWithFormat:@"microants-%ld-%@",(long)[WYUserDefaultManager getUserTargetRoleType],APP_Version];
    NSRange range = [oldAgent rangeOfString:@"microants"];
    if (range.location != NSNotFound)
    {
        NSArray *array = [oldAgent componentsSeparatedByString:@"microants"];
        newAgent = [NSString stringWithFormat:@"%@%@",array[0],customString];
    }
    else
    {
        newAgent = [oldAgent stringByAppendingString:customString];
    }
//    NSLog(@"%@",newAgent);
    if (Device_SYSTEMVERSION_IOS9_OR_LATER)
    {
        self.webView.customUserAgent = newAgent;
    }
    else
    {
        NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    }
}


#pragma mark - 加载各种不同数据

- (void)webViewRequestLoadType
{
    switch (self.webLoadType)
    {
        case WebLoadType_URLString:
            [self loadRequestWebPageWithURLString];
            break;
        case WebLoadType_LocalFile:
            [self loadRequestFileResource:self.localFileName ofType:self.localFileType MIMEType:self.localFileMimeType];
            break;
        case WebLoadType_LocalFileContent:
            [self loadRequestLocalText:self.localTxtFileContent];
            break;
        case WebLoadType_LocalHTMLFile:
            [self loadRequestLocalHTMLWithResource:self.localFileName];
            break;
        default:
            break;
    }
}

#pragma mark -响应不同加载：真正请求数据
//加载纯外部链接网页
- (void)loadRequestWebPageWithURLString
{

    NSURL *url = nil;
    // 如果是自己公司域名
    if ([self.URLString hasPrefix:[WYUserDefaultManager getkAPP_H5URL]])
    {
        if ([self.URLString rangeOfString:@"{token}"].location != NSNotFound)
        {
            NSString *token = ISLOGIN?[UserInfoUDManager getToken]:@"";
            self.URLString = [self.URLString stringByReplacingOccurrencesOfString:@"{token}" withString:token];
        }
        url = [NSURL zhURLWithString:self.URLString queryItemValue:[BaseHttpAPI getCurrentAppVersion] forKey:@"ttid"];
    }
    // 如果是平安域名-
    else if ([self.URLString hasPrefix:@"https://ncfb-stg3.pingan.com.cn"] ||[self.URLString hasPrefix:@"https://cfb.pingan.com"])
    {
        url = [NSURL URLWithString:self.URLString];
    }
    else
    {
        NSString * string= [self.URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        url = [NSURL URLWithString:string];
    }
  NSLog(@"url = %@",[url absoluteString]);
//  url = [NSURL URLWithString:@"http://192.168.10.210:8001/debug"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    if (@available(iOS 11.0, *))
    {
        WKWebsiteDataStore *websiteDataStore = self.webView.configuration.websiteDataStore;
        WKHTTPCookieStore *cookieStore  = websiteDataStore.httpCookieStore;
        //这个cookie一直是最新的
        NSHTTPCookie *cookie = [[ZXHTTPCookieManager sharedInstance]getHTTPCookieFromNSHTTPCookieStorageWithCookieName:@"mat"];
         NSLog(@"%@",cookie);
        if (!cookie)
        {
            [self.webView loadRequest:request];
            return;
        }
//        [cookieStore getAllCookies:^(NSArray<NSHTTPCookie *> * _Nonnull cookies) {
        
//            [MBProgressHUD zx_showSuccess:@"app中所有的cookie获取回调了" toView:nil];
            
//        }];
//      3.29 修改第二个wkWebView无法加载请求的bug；
//        当已经加载过WKWebViewController，也存在容器中；再添加第二个WKWebViewController到容器中，会导致WKHTTPCookieStore的方法失效，且所有block都无法返回；第二个无法加载请求的bug；
//        __block BOOL loadedWkWebView = NO;
//        if (self.navigationController.viewControllers.count>=2)
//        {
//            NSArray *arr = [self.navigationController.viewControllers subarrayWithRange:NSMakeRange(0, self.navigationController.viewControllers.count-1)];
//            [arr enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//                if ([obj isKindOfClass:[WYWKWebViewController class]])
//                {
//                    loadedWkWebView = YES;
//                }
//            }];
//            if (loadedWkWebView)
//            {
//                [self.webView loadRequest:request];
//            }
//            else
//            {
//                [cookieStore setCookie:cookie completionHandler:^{
//
//                    [self.webView loadRequest:request];
//                }];
//            }
//        }
//        else
//        {

            [cookieStore setCookie:cookie completionHandler:^{
                
//                [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:@"1" message:nil cancelButtonTitle:nil cancleHandler:nil doButtonTitle:@"确定" doHandler:nil];
//                [MBProgressHUD zx_showSuccess:[NSString stringWithFormat:@"%@",cookie] toView:nil hideAfterDelay:4.f];

                [_webView loadRequest:request];
            }];
//        }
    }
    else
    {
        // 即使请求头有cookie-mat，请求response服务器反应也没有cookie-mat？
        NSString *cookie = [[ZXHTTPCookieManager sharedInstance]getCurrentRequestCookieHeaderForURL:url];
        [request setValue:cookie forHTTPHeaderField:@"Cookie"];
        [self.webView loadRequest:request];
    }
}



#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0

//加载本地文件资源：- (void)loadData:(NSData *)data MIMEType:(NSString *)MIMEType textEncodingName:(NSString *)textEncodingName baseURL:(NSURL *)baseURL;
- (void)loadRequestFileResource:(NSString *)name ofType:(nullable NSString *)ext MIMEType:(NSString *)mimeType
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:ext];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSData *data = [NSData dataWithContentsOfFile:path];
    [self.webView loadData:data MIMEType:mimeType characterEncodingName:@"UTF-8" baseURL:url];
}


//加载本地txt文件的text文本
- (void)loadRequestLocalText:(NSString *)content
{
    // 判断是否可以无损转化编码
    if ([content canBeConvertedToEncoding:NSUTF8StringEncoding])
    {
        NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]];
        
        [self.webView loadData:data MIMEType:@"text/plain" characterEncodingName:@"UTF-8" baseURL:url];
    }
}
#endif

//加载本地html文件

- (nullable WKNavigation *)loadRequestLocalHTMLWithResource:(NSString *)name{
    //获取JS所在的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"html"];
    //获得html内容
    NSString *html = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //加载js
   return  [self.webView loadHTMLString:html baseURL:[[NSBundle mainBundle] bundleURL]];
}

//没有验证过；
- (nullable WKNavigation *)loadHTMLString:(NSString *)html baseURL:(nullable NSURL *)baseURL{
    //加载js
   return  [self.webView loadHTMLString:html baseURL:[[NSBundle mainBundle] bundleURL]];
}


#pragma mark - ------------------------WKWebView Delegate-------------------------
#pragma mark WKNavigationDelegate
// 1 在发送请求之前，决定是否请求
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSLog(@"1.在发送请求之前，决定是否请求跳转%@",navigationAction.request);
    NSURLRequest *request = navigationAction.request;
//    NSLog(@"wkWebViewAllHTTPHeaderFieldes = %@",request.allHTTPHeaderFields);
//    if (@available(iOS 11.0, *))
//    {
//    }
//    else
//    {
//        [[ZXHTTPCookieManager sharedInstance]handleHeaderFields:request.allHTTPHeaderFields  forURL:request.URL];
//    }
  
    // 阿里支付加载
    if ([self payWithAliPayWithRequest:request])
    {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    // 超链接
    else if ([self decidePolicyForNavigationActionWithNotHttpRequest:request])
    {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    // itunes跳转
    else if ([self decidePolicyForNavigationActionWithGoItunesRequest:request])
    {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);    
}

// 处理超链接
- (BOOL)decidePolicyForNavigationActionWithNotHttpRequest:(NSURLRequest *)request
{
    if ([[UIApplication sharedApplication] canOpenURL:request.URL] && ![request.URL.scheme isEqualToString:@"http"]&& ![request.URL.scheme isEqualToString:@"https"])
    {
        if ([[UIApplication sharedApplication]respondsToSelector:@selector(openURL:options:completionHandler:)])
        {
            [[UIApplication sharedApplication] openURL:request.URL options:@{} completionHandler:nil];
        }
        else
        {
            [[UIApplication sharedApplication] openURL:request.URL];
        }
        return YES;
    }
    return NO;
}
//  itunes跳转
- (BOOL)decidePolicyForNavigationActionWithGoItunesRequest:(NSURLRequest *)request
{
    NSString *urlString = [[request URL] absoluteString];
    urlString = [urlString stringByRemovingPercentEncoding];//解析url
    
    if ([urlString hasPrefix:@"https://itunes.apple.com"])
    {
        if ([[UIApplication sharedApplication]respondsToSelector:@selector(openURL:options:completionHandler:)])
        {
            [[UIApplication sharedApplication] openURL:request.URL options:@{} completionHandler:^(BOOL success) {
            }];
        }
        else
        {
            [[UIApplication sharedApplication] openURL:request.URL];
        }
        if ([self.webView canGoBack])
        {   // 返回时空白页问题
            [self.webView goBack];
        }
        return YES;
    }
    return NO;
}

// 2 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
//    NSLog(@"2.页面开始加载时调用");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

// 3 在收到响应后，决定导航响应策略是否加载； 即使请求头有cookie，响应为何无cookie?
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    [self updateNavigationItems];
    NSLog(@"3.在收到响应后，决定是否加载");
//    NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
//
//    NSArray *cookies =[NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:response.URL];
//    NSLog(@"[response allHeaderFields] = %@,cookies:%@",[response allHeaderFields],cookies);
    decisionHandler(WKNavigationResponsePolicyAllow);
}

// 4 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    NSLog(@"4.当内容开始返回时调用");
}

// 5 页面加载完成之后调用; 即使请求头有cookie-mat，NSHTTPStoreAge有，请求成功回调document.cookie为何没有mat；
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"5.页面加载完成之后调用");
//    NSLog(@"userScript =%@",webView.configuration.userContentController.userScripts);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateNavigationItems];
    [self.urlArrayM removeAllObjects];
    if ([self.shareButtonItem.title isEqualToString:SixSpaces]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.shareButtonItem.enabled = YES; //H5调用setRight方法，偶尔会在didFinishNavigation之后执行（桥异步原因）,导致分享刚出来，又被H5重置rightBarButtonItems;eg：我的收入页面,体验不太好，暂时性解决方案！
            self.shareButtonItem.title = @"分享";
        });
    }
    [_emptyViewController hideEmptyViewInController:self hasLocalData:YES];
    
    // 真机连数据线有； 不连数据线没有；该方法无法获取到 httponly 的cookie
    [webView evaluateJavaScript:[NSString stringWithFormat:@"document.cookie"] completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        if (response != 0) {
            NSLog(@"\n\n\n\n\n\n document.cookie=%@,error=%@",response,error);
        }
    }];
}

// 6 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"6.页面加载失败时调用：%@",error);
  
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if ([error code] == NSURLErrorCancelled)
    {
        NSLog(@"取消");
        return;
    }
    else if ([error code] == 102)
    {
        NSLog(@"帧框加载已中断");
        return;
    }
    
    [_emptyViewController addEmptyViewInController:self hasLocalData:NO error:error emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];
}


// 主机地址被重定向时调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"主机地址被重定向时调用");
}

// 跳转失败时调用；利用h5的缓存跳转的时候；
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"跳转失败时调用；");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateNavigationItems];
}


- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    NSLog(@"需要证书认证");
//    if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust)
//    {
//        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
//        completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
//    }
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        if ([challenge previousFailureCount] == 0)
        {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        }
        else
        {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    }
    else
    {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

//web内容处理中断时会触发
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0))
{
    [webView reload];
    NSLog(@"web内容处理中断时会触发");
}
#endif

//#pragma mark - -----------UIDelegate----------
//// 可以指定配置对象、导航动作对象、window特性。如果没有实现这个方法，不会加载链接，如果返回的是原webview会崩溃。
//-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
//{
//    NSLog(@"打开新窗口");//什么情况进来？
//    if (!navigationAction.targetFrame.isMainFrame) {
//        [webView loadRequest:navigationAction.request];
//    }
//    return nil;
//}
//// webview关闭时回调
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
//- (void)webViewDidClose:(WKWebView *)webView NS_AVAILABLE(10_11, 9_0);
//{
//}
//#endif


#pragma mark - alipay支付

- (BOOL)payWithAliPayWithRequest:(NSURLRequest *)request
{
    NSString *appScheme = @"yicaibao";
    WS(weakSelf);
    BOOL isIntercepted = [[AlipaySDK defaultService] payInterceptorWithUrl:[request.URL absoluteString] fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"result = %@",resultDic);
        [self paymentAlipayResult:[resultDic objectForKey:@"resultCode"]];
        if ([resultDic[@"isProcessUrlPay"] boolValue]) {
            // returnUrl 代表 第三方App需要跳转的成功页URL
            NSString* urlStr = resultDic[@"returnUrl"];
            if (urlStr.length ==0)
            {
                [self.webView goBack];
            }
            else
            {
                [weakSelf requestWithUrlStr:urlStr];
            }
        }
    }];
  
    return isIntercepted;
}


//支付宝支付结果反馈
- (void) paymentAlipayResult:(NSNumber *)code{
    switch (code.integerValue) {
        case 9000:
        {
            [MBProgressHUD zx_showError:@"恭喜您支付成功" toView:self.view];
        }
            break;
        case 8000:
            [MBProgressHUD zx_showError:@"正在处理支付结果，稍后注意查看结果" toView:self.view];
            break;
        case 4000:
            [MBProgressHUD zx_showError:@"支付失败，请重新支付" toView:self.view];
            break;
        case 5000:
            [MBProgressHUD zx_showError:@"您已请求支付，无需重复操作" toView:self.view];
            break;
        case 6001:
            [MBProgressHUD zx_showError:@"您已取消支付" toView:self.view];
            break;
        case 6002:
            [MBProgressHUD zx_showError:@"网络好像有点问题噢，请检查您的网络设置" toView:self.view];
            break;
        case 6004:
            [MBProgressHUD zx_showError:@"正在处理支付结果，稍后注意查看结果" toView:self.view];
            break;
            
        default:
            [MBProgressHUD zx_showError:@"支付失败" toView:self.view];
            break;
    }
}

#pragma mark - 重新加载某个地址
- (void)requestWithUrlStr:(NSString*)urlStr
{
    if (urlStr.length > 0)
    {
        NSURLRequest *webRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10];
        [self.webView loadRequest:webRequest];
    }
}



#pragma mark - 导航按钮

- (UIBarButtonItem*)backButtonItem{
    if (!_backButtonItem) {
        UIImage* backItemImage = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        //        UIImage* backItemHlImage = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        UIButton* backButton = [[UIButton alloc] init];
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        [backButton setTitleColor:self.navigationController.navigationBar.tintColor forState:UIControlStateNormal];
        [backButton setTitleColor:[self.navigationController.navigationBar.tintColor colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        [backButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [backButton setImage:backItemImage forState:UIControlStateNormal];
        //        [backButton setImage:backItemHlImage forState:UIControlStateHighlighted];
        //        [backButton sizeToFit];
        backButton.frame = CGRectMake(0, 0, 50, 44);
        [backButton zh_centerHorizontalImageAndTitleWithTheirSpace:10.f];
        //              [backButton setBackgroundColor:[UIColor redColor]];
        [backButton addTarget:self action:@selector(customBackItemAction:) forControlEvents:UIControlEventTouchUpInside];
        _backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    return _backButtonItem;
}




- (UIBarButtonItem*)closeButtonItem{
    if (!_closeButtonItem) {
        
        UIButton* backButton = [[UIButton alloc] init];
        [backButton setTitle:@"关闭" forState:UIControlStateNormal];
        [backButton setTitleColor:self.navigationController.navigationBar.tintColor forState:UIControlStateNormal];
        [backButton setTitleColor:[self.navigationController.navigationBar.tintColor colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        [backButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [backButton sizeToFit];
        //        [backButton setBackgroundColor:[UIColor redColor]];
        [backButton addTarget:self action:@selector(closeButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
        _closeButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    return _closeButtonItem;
}



//不要用animated，不然有bug；
- (void)updateNavigationItems
{
    if ([self.webView canGoBack])
    {
        NSArray *items = [self zhNavigationItem_leftOrRightItemReducedSpaceToMagin:-7 withItems:@[self.backButtonItem,self.closeButtonItem,self.negativeSpacerItem]];
        [self.navigationItem setLeftBarButtonItems:items animated:NO];
    }
    else
    {
        NSInteger numItems = Device_SYSTEMVERSION_Greater_THAN_OR_EQUAL_TO(11)?3:4;
        if (self.navigationItem.leftBarButtonItems.count==numItems)
        {
            NSArray *items = [self zhNavigationItem_leftOrRightItemReducedSpaceToMagin:-7 withItems:@[self.backButtonItem,self.negativeSpacerItem]];
            [self.navigationItem setLeftBarButtonItems:items animated:NO];
        }
    }
    
}
//在iOS11，多增加一个 view
- (UIBarButtonItem *)negativeSpacerItem
{
    if (!_negativeSpacerItem)
    {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = 10;
        _negativeSpacerItem = negativeSpacer;
    }
    return _negativeSpacerItem;
}

#pragma mark -导航按钮事件

- (void)customBackItemAction:(UIButton *)sender
{
    [self goBack];
    //    if (self.customH5GoBackDic)
    //    {
    //        NSString *customGoBackHandler = [self.customH5GoBackDic objectForKey:@"customGoBackHandler"];
    //        NSString *str = [NSString stringWithFormat:@"(%@)()",customGoBackHandler];
    //        NSString *cangoback = [self.webView stringByEvaluatingJavaScriptFromString:str];
    //
    //        if ([cangoback isEqualToString:@"Y"]) {
    //
    //            [self goBack];
    //            self.customH5GoBackDic = nil;
    //        }
    //    }
    //    else
    //    {
    //        [self goBack];
    //    }
}

- (void)goBack
{
    if ([self.webView canGoBack])
    {
        NSLog(@"goBack");
        [self.webView goBack];
    }
    else
    {
        [self closeButtonItemAction:nil];
    }
}

- (void)closeButtonItemAction:(id)sender
{
    NSLog(@"close");
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    if ([self.webView isLoading])
    {
        [self.webView stopLoading];
    }
//    self.webView.configuration.preferences.javaScriptEnabled = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

//分享
-(void)shareAction:(id)sender
{
    // 默认图片地址
    NSString *imageStr = @"http://public-read-bkt-oss.oss-cn-hangzhou.aliyuncs.com/app/icon/logo_zj.png";
    NSString *shareUrl;
    if (self.urlArrayM.count>0) {
        NSURL* url = self.urlArrayM.firstObject;
        shareUrl =url.absoluteString;
    }else{
        shareUrl = self.webView.URL.absoluteString;
    }
    if (shareUrl)
    {
//        [WYSHARE shareSDKWithImage:imageStr Title:self.navigationItem.title Content:@"用了义采宝，生意就是好!" withUrl:shareUrl];
    }
}




#pragma  mark - ---------webViewJavascriptBridge------
-(void)addWebViewJavascriptBridge
{
    //WebViewJavascriptBridge
    // 开启日志
    [WKWebViewJavascriptBridge enableLogging];
    //  实例化WebViewJavascriptBridge,建立JS与OjbC的沟通桥梁
    self.bridge = [WKWebViewJavascriptBridge bridgeForWebView:_webView];
    // 添加webviewDelegate
    [self.bridge setWebViewDelegate:self];
    // JS主动调用OjbC的方法
    //  注册事件名，用于给JS端调用的处理器，并定义用于响应的处理逻辑；
    //  data就是JS所传的参数，不一定需要传,OC端通过responseCallback回调JS端，JS就可以得到所需要的数据
    
    //-----结束当前页面(返回上一层)，无参
    [self.bridge registerHandler:@"finish" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self finish];
    }];
    //从堆栈中移除并销毁当前H5页面
    [self.bridge registerHandler:@"dellocH5" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self dellocH5];
    }];
    
    //----调用分享(share)，参数为分享的标题以及点击的链接地址{'title':xxx,'text':xxx,'link':xxx,'image':xxx}
    [self.bridge registerHandler:@"share" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self share:data];
    }];
    //----跳转到大图浏览(previewImages)，参数为下标和图片数组
    [self.bridge registerHandler:@"previewImages" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self previewImages:data];
    }];
    //----设置标题（setTitle)
    [self.bridge registerHandler:@"setTitle" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self setNavTitle:data];
    }];
    //----设置导航右侧按钮(setRight)
    [self.bridge registerHandler:@"setRight" handler:^(id data, WVJBResponseCallback responseCallback) {
        _btnFun = data;
        [self setRight:data];
    }];
    //----js跳转native页面
    [self.bridge registerHandler:@"route" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self route:data];
        
    }];
    
    //产品管理列表状态更新
    [self.bridge registerHandler:@"productChangeType" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self postNotiToProdectList];
    }];
    //反馈给js传值value
    [_bridge registerHandler:@"h5NeedData" handler:^(id data, WVJBResponseCallback responseCallback) {
 
        [self h5NeedData:responseCallback];
    }];
}

#pragma mark --------JS调用原生方法实现------------
//1.结束当前页面(finish)，无参
- (void)finish{
    [self.navigationController popViewControllerAnimated:YES];
}

//2.调用分享(share)，参数为分享的标题以及点击的链接地址
-(void)share:(NSDictionary *)dic
{
//   [WYSHARE shareSDKWithImage:[dic objectForKey:@"image"] Title:[dic objectForKey:@"title"] Content:[dic objectForKey:@"text"] withUrl:[dic objectForKey:@"link"]];
}


//3.跳转到大图浏览(previewImages)，参数为下标和图片数组
-(void)previewImages:(NSDictionary *)dic{
    //大图浏览
    NSInteger index = [[dic objectForKey:@"position"] integerValue];
    self.picArray = [dic objectForKey:@"images"];
    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:index imageCount:_picArray.count datasource:self];
    browser.browserStyle = XLPhotoBrowserStyleCustom;
    browser.pageControlStyle = XLPhotoBrowserPageControlStyleClassic;
}

#pragma mark  XLPhotoBrowserDatasource
- (NSURL *)photoBrowser:(XLPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    return _picArray[index];
}


//4.设置标题（setTitle)
-(void)setNavTitle:(NSDictionary *)dic{
    [self setTitle:[dic objectForKey:@"title"]];
}

//5.设置导航右侧按钮(setRight)
-(void)setRight:(NSDictionary *)dic{
    NSMutableArray *btnArray = [dic objectForKey:@"items"];
    if (btnArray.count == 1)
    {
        self.rrbtnDic = btnArray[0];
        NSString *icon = [self.rrbtnDic objectForKey:@"icon"];
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] init];
        if (icon.length)
        {
            rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:icon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rrbtnAction)];
            //            UIImage *backImg = [UIImage zh_imageWithColor:[UIColor redColor] andSize:[UIImage imageNamed:icon].size];
            //            [rightBarButtonItem setBackgroundImage:backImg forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        }else
        {
            rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[self.rrbtnDic objectForKey:@"text"] style:UIBarButtonItemStylePlain target:self action:@selector(rrbtnAction)];
        }
        NSArray *items = @[rightBarButtonItem];
        [self.navigationItem setRightBarButtonItems:items animated:YES];
    }
    else if (btnArray.count == 2)
    {
        self.lrbtnDic = btnArray[0];
        NSString *icon = [self.lrbtnDic objectForKey:@"icon"];
        
        UIBarButtonItem *rightBarButtonItem_first = [[UIBarButtonItem alloc] init];
        if (icon.length) {
            rightBarButtonItem_first = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:icon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rlbtnAction)];
        }else{
            rightBarButtonItem_first = [[UIBarButtonItem alloc] initWithTitle:[self.lrbtnDic objectForKey:@"text"] style:UIBarButtonItemStylePlain target:self action:@selector(rlbtnAction)];
        }
        self.rrbtnDic = btnArray[1];
        NSString *icon2 = [self.rrbtnDic objectForKey:@"icon"];
        UIBarButtonItem *rightBarButtonItem_second = [[UIBarButtonItem alloc] init];
        if (icon2.length)
        {
            rightBarButtonItem_second = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:icon2] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rrbtnAction)];
            
        }else{
            rightBarButtonItem_second = [[UIBarButtonItem alloc] initWithTitle:[self.rrbtnDic objectForKey:@"text"] style:UIBarButtonItemStylePlain target:self action:@selector(rrbtnAction)];
        }
        NSArray *items = @[rightBarButtonItem_second,rightBarButtonItem_first];
        [self.navigationItem setRightBarButtonItems:items animated:YES];
    }
    else
    {
        self.navigationItem.rightBarButtonItems = nil;
    }
}

#pragma mark 右侧导航按钮事件
-(void)rrbtnAction{
    NSString *idstr = [self.rrbtnDic objectForKey:@"id"];
    NSString *successStr = [self.btnFun objectForKey:@"onSuccess"];
    NSString *str = [NSString stringWithFormat:@"(%@)(%@)",successStr,idstr];
    //    [self.webView stringByEvaluatingJavaScriptFromString:str];
    [self.webView evaluateJavaScript:str completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
    }];
    
}

-(void)rlbtnAction{
    NSString *idstr = [self.lrbtnDic objectForKey:@"id"];
    NSString *successStr = [self.btnFun objectForKey:@"onSuccess"];
    NSString *str = [NSString stringWithFormat:@"(%@)(%@)",successStr,idstr];
    //    [self.webView stringByEvaluatingJavaScriptFromString:str];
    [self.webView evaluateJavaScript:str completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
    }];
}

//6.js跳转native页面
-(void)route:(NSDictionary *)dic{
    
//    [[WYUtility dataUtil]routerWithName:[dic objectForKey:@"url"] withSoureController:self];
}
//从堆栈中移除并销毁当前H5页面
-(void)dellocH5
{
    self.needDellocH5 = YES; //3.1.0版本后开始使用该方法标记再移除,之前版本使用下方法，但下方法不能H5加载过程中进行跳转销毁

//    NSMutableArray *arrayM = [NSMutableArray arrayWithArray:self.navigationController.childViewControllers];
//    [arrayM removeObject:self];
//    [self.navigationController setViewControllers:arrayM animated:NO];
}

//7.resume事件-返回时通知h5刷新页面
-(void) resume
{
    NSString *str = [NSString stringWithFormat:@"(function () {var event = new Event('resume');document.dispatchEvent(event);})()"];
    [self.webView evaluateJavaScript:str completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        NSLog(@"obj = %@,error =%@",obj,error);
    }];
}


// 8.更新产品列表
- (void)postNotiToProdectList
{
//    [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_updatePrivacy object:nil];
//    [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_updatePublic object:nil];
//    [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_updateSoldouting object:nil];
}

// 9.h5需要的数据
- (void)h5NeedData:(WVJBResponseCallback)responseCallback
{
    NSString *idfa = [[UIDevice currentDevice]getIDFAUUIDString];
    NSDictionary *dic = @{@"deviceId":idfa};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    responseCallback(jsonString);
}



#pragma mark - 请求失败／列表为空时候的代理请求

- (void)zxEmptyViewUpdateAction
{
    NSURL* url = self.urlArrayM.firstObject;
    [self requestWithUrlStr:url.absoluteString];
}


#pragma mark -  获取自定义当前版本（后台约定）
- (NSString *)getCurrentAppVersion {
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *ttid = [NSString stringWithFormat:@"%@_ysb@iphone",app_Version];
    return ttid;
}


# pragma mark - 刷新当前页面数据
- (void)reloadData
{
    [self.webView reload];
}


#pragma mark - 加载纯外部链接网页
//加载纯外部链接网页
-(void)loadWebPageWithURLString:(NSString *)urlString
{
    self.webLoadType = WebLoadType_URLString;
    if (!urlString)
    {
        return;
    }
    //音乐；
//  self.URLString = @"http://183280454.scene.eqxiu.com/s/3a1oDSh8?eqrcode=1&from=groupmessage&isappinstalled=0";
//    self.URLString = @"http://mp.weixin.qq.com/s/Q1pVsi3w9b98k8gm_WwbjQ";
    self.URLString = urlString;
}

- (void)setWebUrl:(NSString *)webUrl
{
    self.URLString = webUrl;
}
#pragma mark - 加载本地网页

- (void)loadWebHTMLSringWithResource:(NSString *)name
{
    self.localFileName = name;
    self.webLoadType = WebLoadType_LocalHTMLFile;
}

#pragma mark - 加载本地文件数据

//@"test.wps" :@"application/msword"
- (void)loadFileResource:(NSString *)name ofType:(nullable NSString *)ext MIMEType:(NSString *)mimeType
{
    if (!name || !mimeType)
    {
        NSLog(@"参数不够");
        return;
    }
    self.localFileName = name;
    self.localFileType = ext;
    self.localFileMimeType = mimeType;
    self.webLoadType = WebLoadType_LocalFile;
}

#pragma mark - 加载本地txt文件的text文本

- (void)loadLocalText:(NSString *)content
{
    self.localTxtFileContent = content;
    self.webLoadType = WebLoadType_LocalFileContent;
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
