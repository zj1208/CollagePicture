//
//  LoginViewController.h
//  CollagePicture
//
//  Created by simon on 16/12/21.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *whiteBgView;

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;


//点击界面
- (IBAction)touchDownAction:(UIControl *)sender;

//点击键盘完成键
- (IBAction)passwordKeyReturnAction:(UITextField *)sender;

//返回按钮事件
- (IBAction)goBackAction:(UIBarButtonItem *)sender;


//登录按钮事件
- (IBAction)loginAction:(UIButton *)sender;



//新浪登录
- (IBAction)sinaLoginAction:(UIButton *)sender;

//微信登录
- (IBAction)weiXinLoginAction:(UIButton *)sender;

//qq登录
- (IBAction)qqLoginAction:(UIButton *)sender;
@end
