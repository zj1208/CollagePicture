//
//  LoginViewController.m
//  CollagePicture
//
//  Created by simon on 16/12/21.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UserModel.h"
#import "AppDelegate.h"


static NSInteger const PHONE_MAXLENGTH  = 11;

@interface LoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewLayoutHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginBtnLayoutHeight;

@property (nonatomic, strong) id localeChangeObserver;

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

- (void)dealloc
{
   [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - setUI

- (void)setUI
{
    [self.navigationController zx_navigationBar_allBackIndicatorImage:@"back_onlyImage" isOriginalImage:YES];
    [self.navigationController zx_navigationBar_barItemColor:UIColorFromRGB_HexValue(0x222222)];
    
    self.userNameTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.userNameTextField.delegate = self;

    [self.loginBtn zx_setBorderWithCornerRadius:LCDScale_5Equal6_To6plus(40.f)/2 borderWidth:1.f borderColor:nil];
    [self.loginBtn zx_changeAlphaWithCurrentUserInteractionEnabled:NO];
    [self.loginBtn addTarget:self action:@selector(loginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.whiteBgView zx_setBorderWithCornerRadius:2.f borderWidth:1.f borderColor:[UIColor whiteColor]];
    
    UIFont *font = nil;
    if (@available(iOS 9.0,*)) {
       font  = [UIFont monospacedDigitSystemFontOfSize:14 weight:UIFontWeightRegular];
    }
    else{
        font = [UIFont fontWithName:@"Courier" size:14];
    }
    self.userNameTextField.font = font;
    self.passwordTextField.font =font;
}



#pragma mark - setData

- (void)setData
{

    __weak typeof(self) weakSelf = self;
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    self.localeChangeObserver = [center addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {

        [weakSelf signInBtnChangeAlpha:note];
    }];
    
    
    // block对局部变量的引用：center使用weak，所以block对局部变量center是弱引用； block块对局部变量token是强引用；
    // 通知中心对观察者的引用：center默认是强引用观察者对象的，由于center使用了__weak，所以通知中心只是弱引用token
//    NSNotificationCenter * __weak center1 = [NSNotificationCenter defaultCenter];
//    id __block token1 = [center1 addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
//
//        [self signInBtnChangeAlpha:note];
//        [center1 removeObserver:token1];
//        token1 = nil;
//    }];
}


- (void)signInBtnChangeAlpha:(NSNotification *)notification
{
    NSString *str = [NSString zx_filterStringWithWhitespaceAndLine:self.userNameTextField.text];
    BOOL flag = str.length==11&&self.passwordTextField.text.length>3?YES:NO;
    [self.loginBtn zx_changeAlphaWithCurrentUserInteractionEnabled:flag];
}




- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:self.userNameTextField])
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



#pragma mark - action
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
- (void)loginBtnAction:(UIButton *)sender {
    
    [self validatePhoneAndPassword];
}


- (void)validatePhoneAndPassword
{
    NSString *userName = [NSString zx_filterStringWithWhitespaceAndLine:self.userNameTextField.text];
    NSString *password = [NSString zx_filterStringWithWhitespaceAndLine:self.passwordTextField.text];;
    if (![UITextField zx_validatePhoneNumber:userName])
    {
      [MBProgressHUD zx_showError:@"您输入的手机号码错误，请核实后重新输入" toView:self.view];
    }
    else if (password.length == 0)
    {
        [MBProgressHUD zx_showError:NSLocalizedString(@"密码不能为空", nil) toView:self.view];
    }
    else if (password.length<4 ||password.length>12)
    {
        [MBProgressHUD zx_showError:NSLocalizedString(@"请填写有效的密码长度", nil) toView:self.view];
    }
    else if (![UITextField zx_validatePassword:password])
    {
        [MBProgressHUD zx_showError:NSLocalizedString(@"请使用数字或字母的密码", nil) toView:self.view];
    }
    else
    {
//        一旦用了这个方法，MBProgressHUD不能用window，会被移除？
        [[UIApplication sharedApplication]sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
        [self requestDataWithLoginPassword:password];
    }
}

- (void)requestDataWithLoginPassword:(NSString *)password
{
    [MBProgressHUD zx_showLoadingWithStatus:@"正在登录" toView:self.view];
    WS(weakSelf);
    [BmobUser loginInbackgroundWithAccount:self.userNameTextField.text andPassword:password block:^(BmobUser *user, NSError *error) {
        
        if (user)
        {
            NSLog(@"user =%@",user);
            UserModel *userModel = [[UserModel alloc] init];
            userModel.userId = @([user.objectId integerValue]);
            userModel.phone = user.mobilePhoneNumber;
            userModel.userName = user.username;
            [UserInfoUDManager setUserData:userModel];
            [UserInfoUDManager login];
            [UserInfoUDManager setUserId:user.objectId];
            [MBProgressHUD zx_hideHUDForView:nil];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            [MBProgressHUD zx_showError:@"您输入的用户名或密码错误，请重新输入" toView:weakSelf.view];
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
