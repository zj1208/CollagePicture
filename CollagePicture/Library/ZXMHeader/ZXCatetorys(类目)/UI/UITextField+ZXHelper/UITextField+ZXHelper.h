//
//  UITextField+ZXHelper.h
//  Baby
//
//  Created by xielei on 15/12/20.
//  Copyright © 2015年 sina. All rights reserved.
//
// 2017.12.27 限制小数，前几位后几位，优化；
// 2020.8.20 增加验证手机号有效方法的注释，推荐不使用；

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (ZXHelper)


#pragma mark - 字符串的邮箱／手机号／URL／密码等验证

#pragma mark-(只能多排除一些错误可能性,不能全部排除)
/**
 *    @brief    通过区分字符串 验证 邮箱的合法性;
 *    @param  email  邮箱;
 *    @return    YES／NO
 */
+ (BOOL)zx_validateEmail:(nullable NSString *)email;


/**
 *    @brief    利用正则表达式验证 邮箱的合法性
 *    @param  email    邮箱
 *    @return    YES／NO
 */
+ (BOOL)zx_validateEmail2:(nullable NSString *)email;


/**
 *    @brief    利用正则表达式验证 手机号合法性
 *    @param  phone    手机号字符串
 *    @return    YES／NO
 *  注意：这个手机号验证已经不符合最新的发展了,目前还有很多额外的号码段，所以最好放开，不要验证，即将废弃；
 *  #pragma mark - 例如：请求验证码
 - (void)requestSmsCodeBtnAction:(UIButton *)sender {
     
     NSString *phoneNumber = [NSString zx_filterStringWithWhitespaceAndLine:self.loginContainerView.phoneTextField.text];

     if (![UITextField zx_validatePhoneNumber:phoneNumber])
     {
         [MBProgressHUD zx_showError:@"请您输入正确的手机号码" toView:nil];
         return;
     }
     [self requestSMSCode];
 }
 */

+ (BOOL)zx_validatePhoneNumber:(nullable NSString *)phone;


/**
 *    @brief    利用正则表达式验证 密码合法性,判断是否有数字或字母的密码
 *    @param  pass  密码
 *    @return    YES／NO  -NO-@"请使用数字或字母的密码"
 */

+ (BOOL)zx_validatePassword:(NSString *)pass;

/**
 *    @brief    利用正则表达式验证 密码合法性,判断是否同时使用数字和字母，且只能是数字和字母的密码，不可输入特殊字符
 *    @param  pass  密码
 *    @return    YES／NO  -NO-@"请使用数字和字母组合的密码"
 */
+ (BOOL)zx_validatePassword2WithOnlyLetterAndDigital:(NSString *)pass;

// 判断是否同时包含数字和字母，可输入特殊字符；
+ (BOOL)zx_validatePassword3WithContainLetterAndDigital:(NSString *)pass;



//验证url网址，链接是否正常
+ (BOOL)zx_validateURL:(NSString *)url;


#pragma mark - textField输入限制

/**
 限制输入textField小数点前面几位，小数点后面几位；

 @param textField textField
 @param range range
 @param string string
 @param dotPreBits 小数点前面最多几位
 @param dotAfterBits 小数点后面最多几位
 @return 是否允许输入；
 */
+ (BOOL)zx_limitPayMoneyDot:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
          replacementString:(NSString *)string
                 dotPreBits:(int)dotPreBits
               dotAfterBits:(int)dotAfterBits;


//利用代理方法：- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//设置textField最多输入几个文字，支持表情，支持删除键；回调剩余还有几个文字；

+ (BOOL)zx_limitRemainText:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
         replacementString:(NSString *)string
                 maxLength:(NSInteger)maxLength
             remainTextNum:(nullable void(^)(NSInteger remainLength))remainTextBlock
;



//+ (nullable NSString *)zh_TextFieldPassword:(NSString *)str;



/** //有问题:出来的时候,慢一点;  退出键盘的时候,也延迟移除;不能同步
 *    @brief    自定义数字键盘,在数字键盘添加完成按钮;
 */
- (void)zx_keyboardToAddFinishButton;


@end

NS_ASSUME_NONNULL_END
