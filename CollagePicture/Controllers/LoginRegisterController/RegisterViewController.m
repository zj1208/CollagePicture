//
//  RegisterViewController.m
//  CollagePicture
//
//  Created by simon on 16/12/19.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "RegisterViewController.h"
#import "FullTextViewController.h"
#import "UserModel.h"


static NSInteger const PHONE_MAXLENGTH  = 11;
static NSInteger const VerfiCode_MAXLENGTH  = 6;


@interface RegisterViewController ()<UITextFieldDelegate>

@property (nonatomic,strong)NSTimer *smsDownTimer;
@property (nonatomic,assign)NSInteger smsDownSeconds;

@end

@implementation RegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUI];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)setUI
{
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.tableHeaderView.frame = ZX_FRAME_H(self.tableHeaderView, LCDH-HEIGHT_NAVBAR-HEIGHT_TABBARSAFE);
    
    self.userNameField.delegate = self;
    self.verificationCodeField.delegate = self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger maxLength = 0;
    if ([textField isEqual:self.userNameField]||[textField isEqual:self.verificationCodeField])
    {
       maxLength =[textField isEqual:self.userNameField]? PHONE_MAXLENGTH:VerfiCode_MAXLENGTH;
        if (range.location>= maxLength)
        {
            textField.text = [textField.text substringToIndex:maxLength];
            return NO;
        }
    }
       return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.backgroundColor = [UIColor blueColor];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation





#pragma mark - 请求验证码

- (IBAction)requestSmsCodeBtnAction:(UIButton *)sender {
    
    NSString *phoneNumber = [NSString zhFilterInputTextWithWittespaceAndLine:self.userNameField.text];

    if (![UITextField zx_validatePhoneNumber:phoneNumber])
    {
        [MBProgressHUD zx_showError:@"请您输入正确的手机号码" toView:nil];
        return;
    }
//     检查手机号是否已经注册？
    [self requestFindAccountIsRegister];
}


#pragma mark - 请求判断这个手机号是否已经注册过

- (void)requestFindAccountIsRegister
{
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:nil];
    NSString *phoneNumber = [NSString zhFilterInputTextWithWittespaceAndLine:self.userNameField.text];

    WS(weakSelf) ;
    BmobQuery *query = [BmobQuery queryForUser];
    [query whereKey:@"username" equalTo:phoneNumber];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error)
        {
            if (error.code ==20002)
            {
                [MBProgressHUD zx_showError:@"您的网络出问题了" toView:nil];
            }
            else
            {
                [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
            }
        }
        else
        {
            if (array.count>0)
            {
                [MBProgressHUD zx_showError:@"这个手机号已经注册过了" toView:nil];
            }
            else
            {
                [weakSelf requestSMSCode];
            }
        }
    }];
}

- (void)requestSMSCode
{
    NSString *phoneNumber = [NSString zhFilterInputTextWithWittespaceAndLine:self.userNameField.text];
    //我暂时没有自定义模版，用系统短信
    WS(weakSelf);
    [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:phoneNumber andTemplate:nil resultBlock:^(int number, NSError *error) {
        
        if (error)
        {
            [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
        }
        else
        {
            NSLog(@"smsID:%d",number);
            [MBProgressHUD zx_showSuccess:NSLocalizedString(@"已发送验证码", nil) toView:nil];
            [weakSelf smsCodeRequestSuccess];
        }
    }];
}

#pragma mark - 验证码获取成功后执行

- (void)smsCodeRequestSuccess
{
    self.verfiCodeBtn.enabled = NO;
    self.verfiCodeBtn.backgroundColor = [UIColor lightGrayColor];
    self.smsDownSeconds = 60;
    
    self.smsDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(downTimeWithSeconds:) userInfo:nil repeats:YES];
    [self.smsDownTimer fire];
}

- (void)downTimeWithSeconds:(NSTimer *)timer
{
    if (self.smsDownSeconds ==0)
    {
        self.verfiCodeBtn.enabled = NO;
        self.verfiCodeBtn.backgroundColor = [UIColor orangeColor];
        [self.verfiCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.smsDownTimer invalidate];
    }else
    {
        [self.verfiCodeBtn setTitle:[[NSNumber numberWithInt:(int)self.smsDownSeconds] description] forState:UIControlStateNormal];
        self.smsDownSeconds--;
    }
}

- (IBAction)registerAction:(UIButton *)sender {
    
    [self validatePhoneAndPassword];
}


- (void)validatePhoneAndPassword
{
    NSString *mobilePhoneNumer = [NSString zhFilterInputTextWithWittespaceAndLine:self.userNameField.text];
    NSString *password = [NSString zhFilterInputTextWithWittespaceAndLine:self.passwordField.text];;
    if (![UITextField zx_validatePhoneNumber:mobilePhoneNumer])
    {
        [MBProgressHUD zx_showError:@"您输入的手机号码错误，请核实后重新输入" toView:self.view];
    }
    else if ([NSString zhFilterInputTextWithWittespaceAndLine:self.verificationCodeField.text].length==0)
    {
        [MBProgressHUD zx_showError:@"请输入验证码" toView:self.view];
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
    else if (![self.passwordField.text isEqualToString:self.passwordAgainField.text])
    {
        [MBProgressHUD zx_showError:@"二次密码不一样，请重新输入" toView:self.view];
    }
    else
    {
        [[UIApplication sharedApplication]sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
      
        [self requestFindAccountIsRegister];
    }
}





#pragma mark - 注册

- (void)requestRegisterAccount
{
    [MBProgressHUD zx_showLoadingWithStatus:NSLocalizedString(@"正在注册...", nil) toView:nil];

    WS(weakSelf);
    [BmobUser signOrLoginInbackgroundWithMobilePhoneNumber:self.userNameField.text SMSCode:self.verificationCodeField.text andPassword:self.passwordField.text block:^(BmobUser *user, NSError *error) {
        
        if (user)
        {
            NSLog(@"注册成功：%@",user);
            
            UserModel *userModel = [[UserModel alloc] init];
            userModel.userId = @([user.objectId integerValue]);
            userModel.phone = user.mobilePhoneNumber ;
            userModel.username = user.username;
            [UserInfoUDManager setUserData:userModel];
            [UserInfoUDManager loginIn];

            [MBProgressHUD zx_showSuccess:@"注册成功" toView:nil];
            
            [weakSelf performSelector:@selector(registerSuccess) withObject:nil afterDelay:2.f];
        }
        else
        {
            if (error.code==207)
            {
                [MBProgressHUD zx_showError:@"验证码有误" toView:nil];
            }
            else
            {
                [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
            }
        }
    }];

}

//15757126387
- (void)registerSuccess
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - 用户协议

- (IBAction)userAgreementAction:(UIButton *)sender {
    
    FullTextViewController *textViewVC = [[FullTextViewController alloc] initWithBarTitle:@"用户服务协议"];
    [textViewVC loadLocalUserServiceAgreementOfFixResourceWithCompany:@"美颜拼图公司" appName:APP_Name];
    [self.navigationController pushViewController:textViewVC animated:YES];
}


//移除第一响应事件
- (IBAction)touchDownAction:(UIControl *)sender {
    
    [[UIApplication sharedApplication]sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}


//点击完成键盘
- (IBAction)keywordReturnAction:(UITextField *)sender {
    
    [sender resignFirstResponder];
//    [self.loginBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
}

@end
