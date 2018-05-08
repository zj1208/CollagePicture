//
//  UIWindow+ZXHierarchy.h
//  YiShangbao
//
//  Created by simon on 2018/4/24.
//  Copyright © 2018年 com.Microants. All rights reserved.
//
//  4.24 新增类目

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (ZXHierarchy)

/**
 Returns the current Top Most ViewController in hierarchy.
 */
@property (nullable, nonatomic, readonly, strong) UIViewController *zh_topMostWindowController;


// 返回topestMostWindowController堆栈中的topViewController；
// [[[[UIApplication sharedApplication]delegate]window] zh_currentViewController]
@property (nullable, nonatomic, readonly, strong) UIViewController *zh_currentViewController;
//- (UIViewController*)zh_currentViewController;

@end

NS_ASSUME_NONNULL_END
