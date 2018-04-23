//
//  WKWebViewController.h
//  
//
//  Created by 杨建亮 on 2017/10/20.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  2017.12.22
//  更改默认分享 标题没有的问题；调试cookie
//  2018.3.29 修改第二个wkWebView无法加载请求的bug；
//  2018.4.2 优化加载超链接的方法；优化没有登录不加载cookie判断；
//  2018.4.12 修改分享组件；
//  2018.4.16 优化程序；


#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "ZXWebViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface WYWKWebViewController: UIViewController

@property (nonatomic, strong) WKWebView  *webView;

//1.网络地址
@property (nonatomic, copy) NSString *webUrl;

// 初始化;指定固定标题
- (instancetype)initWithBarTitle:(nullable NSString *)aTitle;

//1.加载网络html页面
- (void)loadWebPageWithURLString:(NSString *)urlString;

/**
 2.加载本地html网页
 
 @param name 本地HTML文件名
 */
- (void)loadWebHTMLSringWithResource:(NSString *)name;

//3.加载本地html字符串
- (nullable WKNavigation *)loadHTMLString:(NSString *)html baseURL:(nullable NSURL *)baseURL;

//4.加载本地文件数据 有bug；无法实现；

- (void)loadFileResource:(NSString *)name ofType:(nullable NSString *)ext MIMEType:(NSString *)mimeType NS_AVAILABLE_IOS(9_0);

//5. 加载纯文本数据在webView显示
- (void)loadLocalText:(NSString *)content NS_AVAILABLE_IOS(9_0);




// 刷新最新数据
- (void)reloadData;

@end

NS_ASSUME_NONNULL_END


// 当需要放到tabBar主页面的时候
/*
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发布求购";
    WYWKWebViewController *moreVc = [[WYWKWebViewController alloc] init];
    moreVc.webUrl = [NSString stringWithFormat:@"%@/ycb/page/ycbPurchaseForm.html",[WYUserDefaultManager getkAPP_H5URL]];
    [self addChildViewController:moreVc];
    [self.view addSubview:moreVc.view];
}
*/
