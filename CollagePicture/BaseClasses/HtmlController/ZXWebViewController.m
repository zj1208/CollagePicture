//
//  ZXWebViewController.m
//  ···
//
//  Created by 朱新明 on 15/2/10.
//  Copyright (c) 2015年 朱新明. All rights reserved.
//

#import "ZXWebViewController.h"
#import "UIViewController+MBProgressHUD.h"
#import "WebViewJavascriptBridge.h"
#import "ZXEmptyViewController.h"
#import "UserInfoUDManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "XLPhotoBrowser.h"
//#import "HKMBProgressHUD+WYLoadingGif.h"

#define  isIphoneX (LCDW == 375.f && LCDH == 812.f ? YES : NO)
#define  NAVIBARHEIGHT    (isIphoneX ? (44.f+44.f) : (44.f+20.f))
#define  STATEBARHEIGHT    (isIphoneX ? (44.f) : (20.f))
#define  TABBARSAFEHEIGHT    (isIphoneX ? (34.f) : 0)

typedef NS_ENUM(NSInteger, WebLoadType) {
    
    WebLoadType_URLString =0,//网络html地址
    WebLoadType_LocalHTMLFile =1,//本地html文件
    WebLoadType_LocalFileContent = 2,//本地纯文本文件
    WebLoadType_LocalFile =3, //本地文件
};


@interface ZXWebViewController ()<UIWebViewDelegate,ZXEmptyViewControllerDelegate,XLPhotoBrowserDatasource>

//标题
@property (nonatomic, copy) NSString *barTitle;

// 导航条按钮;
// 返回按钮
@property (nonatomic, strong)UIBarButtonItem *backButtonItem;
// 关闭按钮
@property (nonatomic, strong)UIBarButtonItem *closeButtonItem;
// 填充间距按钮
@property (nonatomic, strong)UIBarButtonItem *negativeSpacerItem;
// 右侧分享按钮
@property (nonatomic, strong)UIBarButtonItem *shareButtonItem;
// 右侧更多按钮
@property (nonatomic, strong)UIBarButtonItem *moreButtonItem;


// 进度条
@property (nonatomic, strong) UIProgressView *progressView;


@property (nonatomic, strong)ZXEmptyViewController *emptyViewController;



//加载类型
@property (nonatomic) WebLoadType webLoadType;

//1.网络地址
@property (nonatomic, copy) NSString *URLString;
//2.本地文件资源
//文件名/或本地html名
@property (nonatomic, copy)NSString *localFileName;
//文件类型
@property (nonatomic, copy)NSString *localFileType;
@property (nonatomic, copy)NSString *localFileMimeType;
//3.本地文件txt数据
@property (nonatomic, copy)NSString *localTxtFileContent;

@property (nonatomic, strong) WebViewJavascriptBridge *bridge;

@property (nonatomic, strong) NSMutableDictionary *btnFun;
@property (nonatomic, strong) NSMutableDictionary *rrbtnDic;
@property (nonatomic, strong) NSMutableDictionary *lrbtnDic;

@property(nonatomic, copy)NSArray *picArray;

@property (nonatomic, assign) BOOL needDellocH5; //h5跳原生后，从堆栈中移除

//URL数组
@property(nonatomic, strong) NSMutableArray *urlArrayM;

@end

@implementation ZXWebViewController


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
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUI];
    //初始化数据
    [self setData];
    
    //设置userAgent
    [self userAgent];
    
    //添加WebViewJavascriptBridge
    [self addWebViewJavascriptBridge];
    
    //根据不同业务加载数据
    [self webViewRequestLoadType];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (!self.bridge) {
        [self addWebViewJavascriptBridge]; //重新建立桥街,直接代理设置nil好像无效
    }

    if (self.presentedViewController)
    {//h5调用系统相册、相机、文件系统后不resume(下面这两个类)
//        [self.presentedViewController isKindOfClass:[UIImagePickerController class]];
//        [self.presentedViewController isKindOfClass:[UIDocumentPickerViewController class]];
    }else{
        [self resume];//h5内路由跳转原生后，返回回来的时候，通知H5刷新页面
    }
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
    // Dispose of any resources that can be recreated.
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}
- (void)dealloc
{
    NSLog(@"deallocWebview");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UI

- (void)setUI
{
    // 设置导航条
    [self setupNav];
    // 添加webView
    [self addWebView];
    // 添加空视图
    [self addEmptyView];
    
    if (@available(iOS 11.0, *)){
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}



#pragma mark -初始化WebView

- (void)addWebView
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, NAVIBARHEIGHT, LCDW, LCDH-NAVIBARHEIGHT-TABBARSAFEHEIGHT)];
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    webView.backgroundColor = self.view.backgroundColor;
//    webView.backgroundColor = [UIColor redColor];
    webView.dataDetectorTypes = !UIDataDetectorTypeAddress;
    webView.mediaPlaybackRequiresUserAction = NO;
    webView.allowsInlineMediaPlayback = YES;
    if ([webView respondsToSelector:@selector(allowsPictureInPictureMediaPlayback)])
    {
        webView.allowsPictureInPictureMediaPlayback = YES;
    }
    self.webView = webView;
    [self.view addSubview:self.webView];    
}



- (UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.frame = CGRectMake(0, NAVIBARHEIGHT, self.view.bounds.size.width, 2);
        _progressView.trackTintColor = [UIColor clearColor];
        //        _progressView.progressTintColor = [WYUISTYLE colorWithHexString:@"4C81FF"];
        _progressView.progressTintColor = [UIColor greenColor];
    }
    return _progressView;
}

- (void)addEmptyView
{
    ZXEmptyViewController *emptyVC =[[ZXEmptyViewController alloc] init];
    emptyVC.view.frame = self.view.frame;
    emptyVC.delegate = self;
    self.emptyViewController = emptyVC;
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
    if(rangeDuiBa.location == NSNotFound&& rangeCFB.location == NSNotFound)
    { //屏蔽兑吧域名，兑吧界面不展示分享
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareAction:)];
        NSArray *rightItems = @[rightBarButtonItem];
        [self.navigationItem setRightBarButtonItems:rightItems animated:NO];
    }

}


#pragma mark - initData初始化数据

- (void)setData
{
    //加载数据
    self.picArray = [[NSMutableArray alloc] init];
    _btnFun = [NSMutableDictionary new];
    _lrbtnDic = [NSMutableDictionary new];
    _rrbtnDic = [NSMutableDictionary new];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateInfo:) name:Noti_ProductManager_Edit_goBackUpdate object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginIn:) name:kNotificationUserLoginIn object:nil];
}

#pragma mark-通知selector
- (void)updateInfo:(id)notification
{
    [self.webView reload];
}

- (void)loginIn:(id)notification
{
    [self.webView reload];
}



#pragma mark - 设置user-agent
//"User-Agent" = "Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Mobile/15A372microants-4-2.4.0.0";

- (void)userAgent
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *oldAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *newAgent = nil;
    //microants-xx-版本号
    NSRange range = [oldAgent rangeOfString:@"microants"];
    NSString *customString = [NSString stringWithFormat:@"microants-%ld-%@",(long)[WYUserDefaultManager getUserTargetRoleType],APP_Version];
    if (range.location != NSNotFound)
    {
        NSArray *array = [oldAgent componentsSeparatedByString:@"microants"];
        newAgent = [NSString stringWithFormat:@"%@%@",array[0],customString];
    }
    else
    {
        newAgent = [oldAgent stringByAppendingString:customString];
    }
    //regist the new agent
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
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


- (NSMutableArray *)urlArrayM
{
    if (!_urlArrayM)
    {
        _urlArrayM = [NSMutableArray array];
    }
    return _urlArrayM;
}


# pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    [MBProgressHUD zx_showGifWithGifName:@"loading" toView:self.view];
//     [HKMBProgressHUD wy_loadingShow:self.view];
 
    NSLog(@"%@",self.view.subviews);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//    [MBProgressHUD zx_hideHUDForView:self.view];
//    [HKMBProgressHUD wy_loadingDissmiss:self.view];

    [_emptyViewController hideEmptyViewInController:self hasLocalData:YES];

    NSString *doTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (!self.barTitle && doTitle.length>0)
    {
        self.navigationItem.title = doTitle;
    }
    [self updateNavigationItems];
    [self.urlArrayM removeAllObjects];
}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    [HKMBProgressHUD wy_loadingDissmiss:self.view];
    NSLog(@"%@",error);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if ([error code] == NSURLErrorCancelled)
    {
        NSLog(@"取消了");
        return;
    }
    //二个app之间跳转
    else if ([error code] == 102)
    {
        NSLog(@"帧框加载已中断");
        return;
    }
    
    [_emptyViewController addEmptyViewInController:self hasLocalData:NO error:error emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%@",request.URL);
    [self.urlArrayM addObject:request.URL];
    //    NSLog(@"%@",request.allHTTPHeaderFields);
    //    NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:request.allHTTPHeaderFields forURL:request.URL];
    //    NSLog(@"cookies=%@",cookies);
    //
    //    NSLog(@"%@",request.HTTPMethod);
    //    NSLog(@"%@",request.HTTPBody);
    //    NSLog(@"%@",request.HTTPBodyStream);
    //    NSLog(@"%@",@(request.HTTPShouldUsePipelining));
    //    NSLog(@"%@",@(request.HTTPShouldHandleCookies));
    return ![self payWithAliPayWithRequest:request];
    
}


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
//    return YES;
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


- (UIBarButtonItem*)closeButtonItem
{
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
        NSArray *items = [self zhNavigationItem_leftOrRightItemReducedSpaceToMagin:-7 withItems:@[self.backButtonItem,self.closeButtonItem,_negativeSpacerItem]];
        [self.navigationItem setLeftBarButtonItems:items animated:NO];
    }
    else
    {
        NSInteger numItems = Device_SYSTEMVERSION_Greater_THAN_OR_EQUAL_TO(11)?3:4;
        if (self.navigationItem.leftBarButtonItems.count == numItems)
        {
            NSArray *items = [self zhNavigationItem_leftOrRightItemReducedSpaceToMagin:-7 withItems:@[self.backButtonItem,_negativeSpacerItem]];
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

#pragma mark-按钮事件

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
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)shareAction:(id)sender
{
    //分享
    NSString *imageStr = @"http://public-read-bkt-oss.oss-cn-hangzhou.aliyuncs.com/app/icon/logo_zj.png";
    
    NSString *shareUrl;
    if (self.urlArrayM.count>0) {
        NSURL* url = self.urlArrayM.firstObject;
        shareUrl =url.absoluteString;
    }else{
        shareUrl = self.webView.request.URL.absoluteString;
    }
//    [WYSHARE shareSDKWithImage:imageStr Title:self.title Content:@"用了义采宝，生意就是好!" withUrl:shareUrl];
}


#pragma  mark - webViewJavascriptBridge

-(void)addWebViewJavascriptBridge
{
    //  启用日志记录
    [WebViewJavascriptBridge enableLogging];
    //  实例化WebViewJavascriptBridge,建立JS与OjbC的沟通桥梁
    self.bridge= [WebViewJavascriptBridge bridgeForWebView:self.webView];
    //  设置webView的代理，
    [self.bridge setWebViewDelegate:self];
    //  注册事件名，用于给JS端调用的处理器，并定义用于响应的处理逻辑；
    //  data就是JS所传的参数，不一定需要传,OC端通过responseCallback回调JS端，JS就可以得到所需要的数据

    // js的finish事件回调native结束事件
    //-----结束当前页面(finish)，无参
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
    
    //----设置标题（setTitle)//每次页面显示都会重新去js脚本中获取；
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
    //    "type" : "bussinessCardDetail",
//    [WYSHARE shareSDKWithImage:[dic objectForKey:@"image"] Title:[dic objectForKey:@"title"] Content:[dic objectForKey:@"text"] withUrl:[dic objectForKey:@"link"]];
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

#pragma mark-XLPhotoBrowserDatasource
- (NSURL *)photoBrowser:(XLPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    return _picArray[index];
}


//4.设置标题（setTitle)
-(void)setNavTitle:(NSDictionary *)dic
{
    [self setTitle:[dic objectForKey:@"title"]];
}


//5.设置导航右侧按钮(setRight)
-(void)setRight:(NSDictionary *)dic
{
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

#pragma mark-右侧导航按钮事件
-(void)rrbtnAction{
    NSString *idstr = [self.rrbtnDic objectForKey:@"id"];
    NSString *successStr = [self.btnFun objectForKey:@"onSuccess"];
    NSString *str = [NSString stringWithFormat:@"(%@)(%@)",successStr,idstr];
    [self.webView stringByEvaluatingJavaScriptFromString:str];
}

-(void)rlbtnAction{
    NSString *idstr = [self.lrbtnDic objectForKey:@"id"];
    NSString *successStr = [self.btnFun objectForKey:@"onSuccess"];
    NSString *str = [NSString stringWithFormat:@"(%@)(%@)",successStr,idstr];
    [self.webView stringByEvaluatingJavaScriptFromString:str];
}


//6.js跳转native页面
-(void)route:(NSDictionary *)dic
{
//    [[WYUtility dataUtil]routerWithName:[dic objectForKey:@"url"] withSoureController:self];
}
//从堆栈中移除并销毁当前H5页面
-(void)dellocH5
{
    self.needDellocH5 = YES;
//    NSMutableArray *arrayM = [NSMutableArray arrayWithArray:self.navigationController.childViewControllers];
//    [arrayM removeObject:self];
//    [self.navigationController setViewControllers:arrayM animated:NO];
}
//7.resume事件
-(void)resume
{
    NSString *str = [NSString stringWithFormat:@"(function () {var event = new Event('resume');document.dispatchEvent(event);})()"];
    [self.webView stringByEvaluatingJavaScriptFromString:str];
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

//self.webView.request.URL.absoluteString 在加载失败的时候是空的
- (void)zxEmptyViewUpdateAction
{
    NSURL* url = self.urlArrayM.firstObject;
    [self requestWithUrlStr:url.absoluteString];
}

#pragma mark - 在webView中显示报告错误；（目前没用）

- (void)reportErrorInsideWebView:(NSError *)error
{
    NSString* errorString = [NSString stringWithFormat:
                             @"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\" \"http://www.w3.org/TR/html4/strict.dtd\"><html><head><meta http-equiv='Content-Type' content='text/html;charset=utf-8'><title></title></head><body><div style='width: 100%%; text-align: center; font-size: 36pt; color: red;'>An error occurred:<br>%@</div></body></html>",
                             error.localizedDescription];
    [self.webView loadHTMLString:errorString baseURL:nil];
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

@end
