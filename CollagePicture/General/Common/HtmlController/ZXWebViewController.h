//
//  ZXWebViewController.h
//  ···
//
//  Created by simon on 15/2/10.
//  Copyright (c) 2015年 simon. All rights reserved.
//
//  简介：webView中所有设计的内容（不包括滚动列表）不要被屏幕圆角、上方传感器区域和下方home键指示器区域遮挡，要在安全区域safeArea布局content；但是webView中底部有可能会有按钮，除非前端做适配；
// （1）支持3DTouch预览的向上滑动事件处理-分享；（2）iOS9及以上使用约束设置webView，保留自动调整scrollView的inset的效果；相反使用frame设置，同时设置self.automaticallyAdjustsScrollViewInsets = NO;

//  2017.12.14 更改默认分享 标题没有的问题；
//  2018.3.26 修改请求失败的时候，重新请求url的问题,分享URL地址的问题；新增url数组；
//  2018.4.4  增加当prsent弹出相机的时候，返回的时候不刷新当前h5页面
//  2018.4.12 修改分享组件；
//  2018.5.28 修改WebViewJavascriptBridge/delloc没释放的问题；
//  2018.6.22 修改支付宝支付后回调支付不成功造出页面刷新的问题；
//  2018.7.05  修改请求中遇到内部无效协议请求的，不是最终请求，造成错误页面覆盖；
//  2018.7.26  支持3DTouch预览的向上滑动事件处理-分享；
//  2018.7.30  iOS及以上修改webView的frame设置改为约束设置；


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



NS_CLASS_AVAILABLE_IOS(7_0)@interface ZXWebViewController : UIViewController


@property (nonatomic, strong) UIWebView *webView;
//1.网络地址
@property (nonatomic, copy) NSString *webUrl;

// 初始化;指定固定标题
- (instancetype)initWithBarTitle:(nullable NSString *)aTitle;
//标题
@property (nonatomic, copy) NSString *barTitle;

//1.加载网络html页面
-(void)loadWebPageWithURLString:(NSString *)urlString;

/**
 2.加载本地html网页
 
 @param name 本地HTML文件名
 */
- (void)loadWebHTMLSringWithResource:(NSString *)name;

//3.加载本地文件数据; 有bug；无法实现；
- (void)loadFileResource:(NSString *)name ofType:(nullable NSString *)ext MIMEType:(NSString *)mimeType;

//加载纯文本数据在webView显示
- (void)loadLocalText:(NSString *)content;


// 刷新最新数据
- (void)reloadData;
@end


NS_ASSUME_NONNULL_END
/**
如果ZXWebViewController作为父类，则子类的下面属性
 
NSLog(@"%@",@(self.edgesForExtendedLayout));
NSLog(@"%@",@(self.automaticallyAdjustsScrollViewInsets));

就没有实际效果了；  继承于他的时候，子类要重新设置frame，y轴从64开始；
*/
