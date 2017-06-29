//
//  LoginViewController.h
//  CollagePicture
//
//  Created by 朱新明 on 16/12/21.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *whiteBgView;

@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;


- (IBAction)touchDownAction:(UIControl *)sender;

- (IBAction)passwordKeyReturnAction:(UITextField *)sender;

- (IBAction)goBackAction:(UIBarButtonItem *)sender;

- (IBAction)loginAction:(UIButton *)sender;
- (IBAction)sinaLoginAction:(UIButton *)sender;

- (IBAction)weiXinLoginAction:(UIButton *)sender;
- (IBAction)qqLoginAction:(UIButton *)sender;
@end
