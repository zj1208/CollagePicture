//
//  WKWebViewController.h
//  
//
//  Created by simon on 2017/10/20.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

//  简介：webView中所有设计的内容（不包括滚动列表）不要被屏幕圆角、上方传感器区域和下方home键指示器区域遮挡，要在安全区域safeArea布局content；但是webView中底部有可能会有按钮，除非前端做适配；
//  （1）支持3DTouch预览的向上滑动事件处理-分享；（2）iOS9及以上使用约束设置webView，保留自动调整scrollView的inset的效果；相反使用frame设置，同时设置self.automaticallyAdjustsScrollViewInsets = NO;

//  注意：1.如果用self.view.frame设置webView的frame，微信的页面（https://mp.weixin.qq.com）会往上偏移；如果用计算大小设置，当vc整个页面作为子控制器展示预览view的时候-如3DTouch预览，顶部导航条空白区域会留白；所以iOS9及以上系统需要改为约束设置；
//  2.WKWebView框架 还需要重点学习研究！

//  待解决问题？
//  （1）itunes跳转,超链接跳转，h5本地文件加载；需要重新测试？
// （2）长按图片会有弹窗；应该去除；

//  2017.12.22 更改默认分享 标题没有的问题；调试cookie
//  2018.3.29 修改第二个wkWebView无法加载请求的bug；
//  2018.4.2 优化加载超链接的方法；优化没有登录不加载cookie判断；
//  2018.4.12 修改分享组件；
//  2018.5.9 优化代码
//  2018.5.28 修改WebViewJavascriptBridge/delloc没释放的问题；
//  2018.6.22 修改支付宝支付后回调支付不成功造出页面刷新的问题；
//  2018.7.05  修改请求中遇到内部无效协议请求的，不是最终请求，造成错误页面覆盖；
//  2018.7.26  支持3DTouch预览的向上滑动事件处理-分享；
//  2018.7.30  iOS及以上修改webView的frame设置改为约束设置；
//  2020.02.06  优化独立容器，针对urlString做是否需要百分比编码做判断处理；

//  2020.02.25  增加WKUIDelegate，针对js调用的三种警告弹窗面板做相应处理；

//  2020.03.05  增加属性：标题颜色，标题默认颜色；增加设置标题颜色实例方法；

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface ZXWKWebViewController: UIViewController

@property (nonatomic, strong) WKWebView  *webView;

//1.网络地址
@property (nonatomic, copy) NSString *webUrl;

// 初始化;指定固定标题
- (instancetype)initWithBarTitle:(nullable NSString *)aTitle;
// 标题-保证默认分享的时候能取到标题和链接
@property (nonatomic, copy) NSString *barTitle;


//1.加载网络html页面
- (void)loadWebPageWithURLString:(NSString *)urlString;

/**
 2.加载本地html网页
 
 @param name 本地HTML文件名
 */
- (void)loadWebHTMLSringWithFileResource:(NSString *)name;

//3.加载本地html字符串
- (nullable WKNavigation *)loadHTMLString:(NSString *)html baseURL:(nullable NSURL *)baseURL;

//4.加载本地文件数据 有bug；无法实现；

- (void)loadFileResource:(NSString *)name ofType:(nullable NSString *)ext MIMEType:(NSString *)mimeType NS_AVAILABLE_IOS(9_0);

//5. 加载纯文本数据在webView显示
- (void)loadLocalText:(NSString *)content NS_AVAILABLE_IOS(9_0);

@property (nonatomic, assign) BOOL appearNavigationBarHide;

// 刷新最新数据
- (void)reloadData;

//用于退出当前栈顶web控制器
- (void)exitWebViewApp;


/// 改变TitleBar的颜色
/// @param color 色值
- (void)setTitleColor:(UIColor *)color;

/// 改变TitleBar的颜色
/// @param color 色值
/// @param reset 是否重置为默认颜色，默认NO
- (void)setTitleColor:(UIColor *)color reset:(BOOL)reset;


/// 应用于导航项和导航栏按钮项的着色颜色。
/// @param color color
- (void)setTintColor:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END


// 当需要放到tabBar主页面的时候
/*
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发布求购";
    ZXWKWebViewController *vc = [[ZXWKWebViewController alloc] init];
    vc.webUrl = [NSString stringWithFormat:@"%@/ycb/page/ycbPurchaseForm.html",[WYUserDefaultManager getkAPP_H5URL]];
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
}
*/
