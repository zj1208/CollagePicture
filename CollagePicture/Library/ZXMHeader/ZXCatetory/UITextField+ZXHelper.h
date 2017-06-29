//
//  UITextField+ZXHelper.h
//  CollagePicture
//
//  Created by xielei on 15/12/20.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (ZXHelper)
#pragma mark-(只能多排除一些错误可能性,不能全部排除)
/**
 *	@brief	通过区分字符串 验证 邮箱的合法性;
 *	@param  email  邮箱;
 *	@return	YES／NO
 */
+ (BOOL)zhu_validateEmail:(nullable NSString *)email;


/**
 *	@brief	利用正则表达式验证 邮箱的合法性
 *	@param  email    邮箱
 *	@return	YES／NO
 */
+ (BOOL)zhu_validateEmail2:(nullable NSString *)email;


/**
 *	@brief	利用正则表达式验证 手机号合法性
 *	@param  phone    手机号字符串
 *	@return	YES／NO
 */

+ (BOOL)zhu_validatePhoneNumber:(nullable NSString *)phone;

/**
 *	@brief	利用正则表达式验证 密码合法性,使用数字或字母的密码
 *	@param  pass  密码
 *	@return	YES／NO  -NO-@"请使用数字或字母的密码"
 */

+ (BOOL)zhu_validatePassword:(NSString *)pass;



/**
 *	@brief	验证 密码合法性---业务中使用，包括验证使用数字或字母的密码
 *	@param  str   密码
 *	@return
NSString *title = [UITextField zhuTextFieldPassword:self.passwordField.text];
 if (title.length>0)
 {
 [SVProgressHUD showErrorWithStatus:title maskType:SVProgressHUDMaskTypeBlack];
 }
 else
 {
 
 }

 */
+ (NSString *)zhu_TextFieldPassword:(NSString *)str;



/** //有问题:出来的时候,慢一点;  退出键盘的时候,也延迟移除;不能同步
 *	@brief	自定义数字键盘,在数字键盘添加完成按钮;
 */
- (void)zhu_keyboardToAddFinishButton;



+ (BOOL)zhLimitPayMoneyDot:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string dotPreBits:(int)dotPreBits dotAfterBits:(int)dotAfterBits;


//利用代理方法：- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//设置textField最多输入几个文字，支持表情，支持删除键；回调剩余还有几个文字；

+ (BOOL)zhLimitRemainText:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string maxLength:(NSInteger)maxLength remainTextNum:(void(^)(NSInteger remainLength))remainTextBlock
;

@end

NS_ASSUME_NONNULL_END
