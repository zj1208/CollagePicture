//
//  RegisterViewController.h
//  CollagePicture
//
//  Created by 朱新明 on 16/12/19.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoMenuTextField.h"
@interface RegisterViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet NoMenuTextField *userNameField;

@property (weak, nonatomic) IBOutlet UITextField *verificationCodeField;

@property (weak, nonatomic) IBOutlet UIButton *verfiCodeBtn;

@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UITextField *passwordAgainField;



- (IBAction)requestSmsCodeBtnAction:(UIButton *)sender;

- (IBAction)registerAction:(UIButton *)sender;

- (IBAction)userAgreementAction:(UIButton *)sender;

@end
