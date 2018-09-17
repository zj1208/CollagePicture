//
//  LoginViewController.m
//  CollagePicture
//
//  Created by 朱新明 on 16/12/21.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UserModel.h"
#import "AppDelegate.h"


static NSInteger const PHONE_MAXLENGTH  = 11 ;

@interface LoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewLayoutHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginBtnLayoutHeight;

@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    [self setData];
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.bgViewLayoutHeight.constant = LCDScale_5Equal6_To6plus(101.f);
    self.loginBtnLayoutHeight.constant = LCDScale_5Equal6_To6plus(40.f);
}


#pragma mark - setUI

- (void)setUI
{
//    [(AppDelegate *)APP_Delegate setApperanceForSigleNavController:self];
    [self.navigationController xm_navigationBar_Single_BackIndicatorImage:@"back_onlyImage" isOriginalImage:YES];
    [self xm_navigationBar_barItemColor:UIColorFromRGB_HexValue(0x222222)];
    
    [self.loginBtn zh_userInteractionEnabledWithAlpha:NO];
    self.userNameField.delegate = self;
    
    [self.whiteBgView setCornerRadius:2.f borderWidth:1.f borderColor:[UIColor whiteColor]];
    [self.loginBtn setCornerRadius:LCDScale_5Equal6_To6plus(40.f)/2 borderWidth:1.f borderColor:nil];
}



#pragma mark - setData

- (void)setData
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(signInBtnChangeAlpha:) name:UITextFieldTextDidChangeNotification object:nil];
}


- (void)signInBtnChangeAlpha:(NSNotification *)notification
{
    NSString *str = [NSString zhFilterInputTextWithWittespaceAndLine:self.userNameField.text];
    [self.loginBtn zh_userInteractionEnabledWithAlpha:str.length==11&&self.passwordTextField.text.length>3?YES:NO];
}




- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:self.userNameField])
    {
        if (range.location>= PHONE_MAXLENGTH)
        {
            textField.text = [textField.text substringToIndex:PHONE_MAXLENGTH];
            return NO;
        }

    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
   [[NSNotificationCenter defaultCenter]removeObserver:self];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//移除第一响应事件
- (IBAction)touchDownAction:(UIControl *)sender {
    
    [[UIApplication sharedApplication]sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}


//点击完成键盘
- (IBAction)passwordKeyReturnAction:(UITextField *)sender {
    
    [sender resignFirstResponder];
    [self.loginBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
}

//返回
- (IBAction)goBackAction:(UIBarButtonItem *)sender {
    
    [self touchDownAction:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//登录按钮点击事件
- (IBAction)loginAction:(UIButton *)sender {
    
    [self validatePhoneAndPassword];
}

- (void)validatePhoneAndPassword
{
    NSString *userName = [NSString zhFilterInputTextWithWittespaceAndLine:self.userNameField.text];
    NSString *password = self.passwordTextField.text;
    NSString *passError = [UITextField zh_TextFieldPassword:password];
    if (![UITextField xm_validatePhoneNumber:userName])
    {
      [MBProgressHUD zx_showError:@"您输入的手机号码错误，请核实后重新输入" toView:self.view];
    }
    else if (passError.length>0)
    {
        [MBProgressHUD zx_showError:passError toView:self.view];
    }
    else
    {
        [[UIApplication sharedApplication]sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
        [self requestDataWithLoginPassword:password];
    }
}

- (void)requestDataWithLoginPassword:(NSString *)password
{
    [MBProgressHUD zx_showLoadingWithStatus:@"正在登录" toView:nil];
    WS(weakSelf);
    [BmobUser loginInbackgroundWithAccount:self.userNameField.text andPassword:password block:^(BmobUser *user, NSError *error) {
        
        if (user)
        {
            NSLog(@"user =%@",user);
            UserModel *userModel = [[UserModel alloc] init];
            userModel.userId = @([user.objectId integerValue]);
            userModel.phone = user.mobilePhoneNumber;
            userModel.username = user.username;
            [UserInfoUDManager setUserData:userModel];
            [UserInfoUDManager loginIn];
            [UserInfoUDManager setUserId:user.objectId];
            [MBProgressHUD zx_hideHUDForView:nil];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            [MBProgressHUD zx_showError:@"您输入的用户名或密码错误，请重新输入" toView:nil];
        }
    }];
}

- (IBAction)sinaLoginAction:(UIButton *)sender {
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Sina currentViewController:nil completion:^(id result, NSError *error) {
        
        if (error)
        {
            [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
        }
        else {
            UMSocialUserInfoResponse *resp = result;
            
            // 授权信息
            NSLog(@"Sina uid: %@", resp.uid);
            NSLog(@"Sina accessToken: %@", resp.accessToken);
            NSLog(@"Sina refreshToken: %@", resp.refreshToken);
            NSLog(@"Sina expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"Sina name: %@", resp.name);
            NSLog(@"Sina iconurl: %@", resp.iconurl);
            NSLog(@"Sina gender: %@", resp.gender);
            
            // 第三方平台SDK源数据
            NSLog(@"Sina originalResponse: %@", resp.originalResponse);
            
            NSString *token =  resp.accessToken;
            NSString *uid = resp.uid;
            NSDate *date = resp.expiration;
            //得到的新浪微博授权信息，请按照例子来生成NSDictionary
            NSDictionary *dic = @{@"access_token":token,@"uid":uid,@"expirationDate":date};
            [BmobUser loginInBackgroundWithAuthorDictionary:dic platform:BmobSNSPlatformSinaWeibo block:^(BmobUser *user, NSError *error) {
                
                if (user)
                {
                    NSLog(@"user =%@",user);
                    if (!user.mobilePhoneNumber)
                    {
                        [self performSegueWithIdentifier:segue_ThirdBindingSegue sender:self];
                    }
                    else
                    {
                       // [UserInfoUDManager setUserData:user];
                    }
                }
            }];
        }
    }];
}

- (IBAction)weiXinLoginAction:(UIButton *)sender {
}

- (IBAction)qqLoginAction:(UIButton *)sender {
}
@end
