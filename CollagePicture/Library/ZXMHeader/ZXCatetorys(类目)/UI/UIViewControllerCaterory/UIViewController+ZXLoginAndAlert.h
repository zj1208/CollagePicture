//
//  UIViewController+ZXLoginAndAlert.h
//  CollagePicture
//
//  Created by simon on 15/7/6.
//  Copyright (c) 2015年 . All rights reserved.
//
//  3.14 增加方法
//  2019.06.12  修复内存警告；

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface UIViewController (ZXLoginAndAlert)


/**
 判断是否有登录过，如果没有登录则弹出登录界面
 
 @param isLogin 是否登录
 @return 返回是否登录过；
 */
- (BOOL)zx_performActionWithIsLogin:(BOOL)isLogin;

/**
 判断是否有登录过，如果没有登录则弹出登录界面

 @param flag 是否需要弹出警告提示
 @return 返回是否登录过；
 */

- (BOOL)zx_performActionWithIsLogin:(BOOL)isLogin withPopAlertView:(BOOL)flag;

/**
 判断是否有登录过，如果没有登录弹出登录界面； 如果登录过则执行action事件

 @param action 如果是登录的，则执行这个事件；
 */

- (void)zx_performIsLoginAction:(BOOL)isLogin withSelector:(nonnull SEL)action withPopAlertView:(BOOL)flag;



- (void)zx_performIsLoginAction:(BOOL)isLogin withSelector:(nonnull SEL)aSelector withObject:(id)object1 withObject:(id)object2 withPopAlertView:(BOOL)flag;




- (void)zx_presentLoginController;




@end

NS_ASSUME_NONNULL_END
