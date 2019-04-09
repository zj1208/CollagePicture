//
//  RegisterViewController.h
//  CollagePicture
//
//  Created by simon on 16/12/19.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXNoMenuTextField.h"

@interface RegisterViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet ZXNoMenuTextField *userNameField;

// 验证码
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeField;

// 验证码按钮
@property (weak, nonatomic) IBOutlet UIButton *verfiCodeBtn;

// 密码
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

// 重复密码
@property (weak, nonatomic) IBOutlet UITextField *passwordAgainField;


// 点击界面
- (IBAction)touchDownAction:(UIControl *)sender;

// 点击键盘完成键
- (IBAction)keywordReturnAction:(UITextField *)sender;

// 发送验证码按钮事件
- (IBAction)requestSmsCodeBtnAction:(UIButton *)sender;

// 注册按钮事件
- (IBAction)registerAction:(UIButton *)sender;

// 用户协议
- (IBAction)userAgreementAction:(UIButton *)sender;

@end
