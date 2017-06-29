//
//  ZXWebViewController.m
//  ICBC
//
//  Created by 朱新明 on 15/2/10.
//  Copyright (c) 2015年 朱新明. All rights reserved.
//

#import "ZXWebViewController.h"
#import "UIViewController+MBProgressHUD.h"
#import "WebViewJavascriptBridge.h"

typedef NS_ENUM(NSInteger, WebLoadType) {
    
    WebLoadType_URLString =0,//网络html地址
    WebLoadType_LocalHTMLFile =1,//本地html文件
    WebLoadType_LocalFileContent = 2,//本地纯文本文件
    WebLoadType_LocalFile =3, //本地文件
};


@interface ZXWebViewController ()<UIWebViewDelegate>

@property(nonatomic, strong) UIWebView *webView;
//标题
@property (nonatomic, copy) NSString *barTitle;



//加载类型
@property (nonatomic) WebLoadType webLoadType;


//1.网络地址
@property (nonatomic, copy) NSString *urlStr;


//2.本地文件资源
//文件名/或本地html名
@property (nonatomic, copy)NSString *localFileName;
//文件类型
@property (nonatomic, copy)NSString *localFileType;
@property (nonatomic, copy)NSString *localFileMimeType;


//3.本地文件txt数据
@property (nonatomic, copy)NSString *localTxtFileContent;


//导航条按钮
@property (nonatomic,strong) UIBarButtonItem *backButtonItem;

@property (nonatomic, strong) UIBarButtonItem *closeButtonItem;


@property (nonatomic, strong) UIBarButtonItem *shareButtonItem;


@property (nonatomic, strong) WebViewJavascriptBridge *bridge;

@end

@implementation ZXWebViewController



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
    self.view.backgroundColor = [UIColor whiteColor];
    self.hidesBottomBarWhenPushed = YES;
    //设置导航条
    [self setupNav];
    //添加webView
    [self setupWebView];
    //根据不同业务加载数据
    [self webViewRequestLoadType];
    //添加WebViewJavascriptBridge
    [self addWebViewJavascriptBridge];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.webView.scrollView flashScrollIndicators];
}



-(void)viewWillDisappear:(BOOL)animated
{
    if ([self.webView isLoading])
    {
        [self.webView stopLoading];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [super viewWillDisappear:animated];
}

- (void)reloadData
{
    [self.webView reload];
}
#pragma mark - 导航条
- (void)setupNav
{
    self.title = self.barTitle;
    
    
    NSArray *items = [self zhNavigationItem_leftOrRightItemReducedSpaceToMagin:-7 withItems:@[self.backButtonItem]];
    self.navigationItem.leftBarButtonItems = items;
    

}

-(UIBarButtonItem*)backButtonItem{
    if (!_backButtonItem) {
        UIImage* backItemImage = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImage* backItemHlImage = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        UIButton* backButton = [[UIButton alloc] init];
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        [backButton setTitleColor:self.navigationController.navigationBar.tintColor forState:UIControlStateNormal];
        [backButton setTitleColor:[self.navigationController.navigationBar.tintColor colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        [backButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [backButton setImage:backItemImage forState:UIControlStateNormal];
        [backButton setImage:backItemHlImage forState:UIControlStateHighlighted];
//        [backButton sizeToFit];
        backButton.frame = CGRectMake(0, 0, 50, 44);
        [backButton zh_centerHorizontalImageAndTitleWithTheirSpace:10.f];
        [backButton setAdjustsImageWhenHighlighted:NO];
//      [backButton setBackgroundColor:[UIColor redColor]];
        [backButton addTarget:self action:@selector(customBackItemClicked) forControlEvents:UIControlEventTouchUpInside];
        _backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    return _backButtonItem;
}

-(UIBarButtonItem*)closeButtonItem{
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



- (void)customBackItemClicked
{
    if ([self.webView canGoBack])
    {
        [self.webView goBack];
    }
    else
    {
        [self closeButtonItemAction:nil];
    }
}

- (void)closeButtonItemAction:(id)sender
{
    if (self.presentingViewController)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        if ([self.webView isLoading])
        {
            [self.webView stopLoading];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }

}

#pragma mark - 加载纯外部链接网页
//加载纯外部链接网页

-(void)loadWebPageWithUrlString:(NSString *)urlString
{
    self.webLoadType = WebLoadType_URLString;
    if (!urlString)
    {
        return;
    }
    self.urlStr = urlString;
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
}

#pragma mark - 加载本地txt文件的text文本

- (void)loadLocalText:(NSString *)content
{
    self.localTxtFileContent = content;
    self.webLoadType = WebLoadType_LocalFileContent;

}


#pragma mark - 初始化WebView

- (void)setupWebView
{
    UIWebView *webView = [[UIWebView alloc] init];
    webView.backgroundColor = [UIColor whiteColor];
    webView.opaque = NO;//透明，默认是YES不透明
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    webView.dataDetectorTypes = UIDataDetectorTypePhoneNumber|UIDataDetectorTypeLink;
    self.webView = webView;
    [self.view addSubview:self.webView];
    
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
}


#pragma mark - 加载各种不同数据

- (void)webViewRequestLoadType
{
    switch (self.webLoadType)
    {
        case WebLoadType_URLString:
            [self loadRequestWebPageWithUrlString];
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

#pragma mark -响应不同加载
//加载纯外部链接网页
- (void)loadRequestWebPageWithUrlString
{
    NSURL *url = [NSURL URLWithString:[self.urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    
      
    [self.webView loadRequest:request];

}


//加载本地文件资源：- (void)loadData:(NSData *)data MIMEType:(NSString *)MIMEType textEncodingName:(NSString *)textEncodingName baseURL:(NSURL *)baseURL;
- (void)loadRequestFileResource:(NSString *)name ofType:(nullable NSString *)ext MIMEType:(NSString *)mimeType
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:ext];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSData *data = [NSData dataWithContentsOfFile:path];
    [self.webView loadData:data MIMEType:mimeType textEncodingName:@"UTF-8" baseURL:url];

}

//加载本地txt文件的text文本
- (void)loadRequestLocalText:(NSString *)content
{
    // 判断是否可以无损转化编码
    if ([content canBeConvertedToEncoding:NSUTF8StringEncoding])
    {
        NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]];
        
        [self.webView loadData:data MIMEType:@"text/plain" textEncodingName:@"UTF-8" baseURL:url];
    }
}

//加载本地html文件

- (void)loadRequestLocalHTMLWithResource:(NSString *)name{
    //获取JS所在的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"html"];
    //获得html内容
    NSString *html = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //加载js
    [self.webView loadHTMLString:html baseURL:[[NSBundle mainBundle] bundleURL]];
}



#pragma mark - WebViewJavascriptBridge

- (void)addWebViewJavascriptBridge
{
    //    启用日志记录
    [WebViewJavascriptBridge enableLogging];
    //    实例化WebViewJavascriptBridge,建立JS与OjbC的沟通桥梁
    self.bridge= [WebViewJavascriptBridge bridgeForWebView:self.webView];
    //   设置webView的代理，
    [self.bridge setWebViewDelegate:self];
    //    注册事件名，用于给JS端调用的处理器，并定义用于响应的处理逻辑；
    //js的finish事件回调native结束事件
    [self.bridge registerHandler:@"finish" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"finish-data=%@",data);
    }];
    //    js的share事件回调native分享事件
    [self.bridge registerHandler:@"share" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"share-data=%@",data);
        //同时可以反馈给js传值value
        if (responseCallback)
        {
            //            responseCallback(@{@"name":@"simon"});
        }
    }];


    [self.bridge registerHandler:@"setTitle" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        self.title = [data objectForKey:@"title"];
    }];
//    [self.bridge callHandler:@"setTitle" data:nil responseCallback:^(id responseData) {
//        
//        NSLog(@"%@",responseData);
//    }];
    [self.bridge registerHandler:@"previewImages" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"previewImages-data=%@",data);
        
    }];
    
    
}



- (void)updateNavigationItems
{
    if ([self.webView canGoBack])
    {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = 10;
        NSArray *items = [self zhNavigationItem_leftOrRightItemReducedSpaceToMagin:-7 withItems:@[self.backButtonItem,self.closeButtonItem,negativeSpacer]];
        [self.navigationItem setLeftBarButtonItems:items animated:NO];
    }
    else
    {
        if (self.navigationItem.leftBarButtonItems.count>2)
        {
            NSArray *items = [self zhNavigationItem_leftOrRightItemReducedSpaceToMagin:-7 withItems:@[self.backButtonItem]];
            [self.navigationItem setLeftBarButtonItems:items animated:YES];
        }
    }

}


# pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self zhHUD_showGifPlay];
    NSLog(@"%@",self.view.subviews);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *doTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (!self.barTitle && doTitle.length>0)
    {
        self.title = doTitle;
    }
    [self updateNavigationItems];

    [self zhHUD_hideHUD];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%@",error);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if ([error code] == NSURLErrorCancelled) {
        NSLog(@"取消了的不提示");
        return;
    }
    [self zhHUD_showErrorWithStatus:[error localizedDescription]];

}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%@",request.URL.absoluteString);
    NSLog(@"%@",request.allHTTPHeaderFields);
//    NSLog(@"%@",request.HTTPMethod);
//    NSLog(@"%@",request.HTTPBody);
//    NSLog(@"%@",request.HTTPBodyStream);
//    NSLog(@"%@",@(request.HTTPShouldUsePipelining));
//    NSLog(@"%@",@(request.HTTPShouldHandleCookies));
    
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

@end
