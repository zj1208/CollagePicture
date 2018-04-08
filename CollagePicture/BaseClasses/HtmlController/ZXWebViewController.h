//
//  ZXWebViewController.h
//  ···
//
//  Created by 朱新明 on 15/2/10.
//  Copyright (c) 2015年 朱新明. All rights reserved.
//  2017.12.14 更改默认分享 标题没有的问题；
//  2018.3.26 修改请求失败的时候，重新请求url的问题,分享URL地址的问题；新增url数组；
//  2018.4.4  增加当prsent弹出相机的时候，返回的时候不刷新当前h5页面

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



NS_CLASS_AVAILABLE_IOS(7_0)@interface ZXWebViewController : UIViewController


@property (nonatomic, assign) BOOL noShareItem;

@property (nonatomic, strong) UIWebView *webView;
//1.网络地址
@property (nonatomic, copy) NSString *webUrl;

// 初始化;指定固定标题
- (instancetype)initWithBarTitle:(nullable NSString *)aTitle;


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
