//
//  UIWindow+ZXHierarchy.h
//  YiShangbao
//
//  Created by simon on 2017/4/24.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  4.24 新增类目
//  2018.8.01 增加获取键盘window，可见window的方法；
//  2019.06.11 增加注释；
//  2020.2.10 修改zx_currentViewController;
//  2020.2.20 优化

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (ZXHierarchy)

/**
 Returns the current Top Most ViewController in hierarchy.
 */
@property (nullable, nonatomic, readonly, strong) UIViewController *zx_topMostWindowController;


///  返回topestMostWindowController堆栈中的topViewController；如果是tabBarController，则返回tabBarController的选中控制器，如果当前没有选中的viewControoller，则返回tabBarController的第一个控制器；
///  [[[[UIApplication sharedApplication]delegate]window] zx_currentViewController]
///  注意：在UIAlertController事件回调中是已经dismiss后的，所以如果获取zx_currentViewController跟UIAlertController一点关系也没有；
@property (nullable, nonatomic, readonly, strong) UIViewController *zx_currentViewController;


// 获取UIApplication的键盘window； 2018/08/01
+ (nullable UIWindow *)zx_getRemoteKeyboardWindow;


// 获取UIApplication的最上层可见window，除了键盘window就是keyWindow； 2018/08/01
+ (nullable UIWindow *)zx_getFrontVisibleWindow;


// 获取UIApplication额最上层可见window;
+ (nullable UIWindow *)zx_getFrontWindow;



/// iPhoneX系列 ? (20.f+24.f) : (20.f)) ,
/// 注意：在viewDidLoad中self.view.window 还是nil，需要用kAPP_MainWindow来获取；
/// 如果状态栏隐藏，则statusBarFrame属性的值为CGRectZero。
@property (nonatomic, assign, readonly) CGFloat zx_safeAreaStatusBarHeight;

/// iPhoneX系列 ? (34) : (0))
@property (nonatomic, assign, readonly) CGFloat zx_safeAreaLayoutNormalBottom;

@end

NS_ASSUME_NONNULL_END
