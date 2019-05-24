//
//  UIWindow+ZXHierarchy.h
//  YiShangbao
//
//  Created by simon on 2018/4/24.
//  Copyright © 2018年 com.Microants. All rights reserved.
//
//  4.24 新增类目
//  2018.8.01 增加获取键盘window，可见window的方法；

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (ZXHierarchy)

/**
 Returns the current Top Most ViewController in hierarchy.
 */
@property (nullable, nonatomic, readonly, strong) UIViewController *zx_topMostWindowController;


// 返回topestMostWindowController堆栈中的topViewController；
// [[[[UIApplication sharedApplication]delegate]window] zh_currentViewController]
@property (nullable, nonatomic, readonly, strong) UIViewController *zx_currentViewController;
//- (UIViewController*)zh_currentViewController;

// 获取UIApplication的键盘window； 2018/08/01
+ (nullable UIWindow *)zx_getRemoteKeyboardWindow;

// 获取UIApplication的最上层可见window，除了键盘window就是keyWindow； 2018/08/01
+ (nullable UIWindow *)zx_getFrontVisibleWindow;

// 获取UIApplication额最上层可见window;
+ (nullable UIWindow *)zx_getFrontWindow;
@end

NS_ASSUME_NONNULL_END
