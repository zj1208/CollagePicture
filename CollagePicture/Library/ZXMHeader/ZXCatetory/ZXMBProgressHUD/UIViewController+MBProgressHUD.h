//
//  UIViewController+MBProgressHUD.h
//  ICBC
//
//  Created by 朱新明 on 15/2/5.
//  Copyright (c) 2015年 朱新明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface UIViewController (MBProgressHUD)


- (void)zhHUD_showWithStatus:(NSString*)aText;

/**

 */
- (void)zhHUD_showHUDAddedTo:(UIView*)view labelText:(NSString *)aText;


/**
 * @brief 在view上显示错误提示语，2秒钟后自动隐藏
 */
- (MBProgressHUD *)zhHUD_showErrorWithStatus:(NSString *)aText;


/**
 2秒后自动隐藏
 
 调用了zhHUD_showSuccessWithStatus:(NSString *)aText afterDelay:(CGFloat)delay
 */

- (void)zhHUD_showSuccessWithStatus:(NSString *)aText;


//在view上显示成功提示语，n秒钟后自动隐藏
- (void)zhHUD_showSuccessWithStatus:(NSString *)aText afterDelay:(CGFloat)delay;


/**
 *  隐藏hud
 *
 *  @param view   在哪个图上隐藏
 */
- (void)zhHUD_hideHUDForView:(UIView *)view;


- (void)zhHUD_hideHUD;


- (void)zhHUD_showGifPlay;


@end
