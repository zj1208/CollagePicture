//
//  MyCenterController.m
//  Baby
//
//  Created by simon on 16/1/14.
//  Copyright © 2016年 simon. All rights reserved.
//
#import "MyCenterController.h"
#import "UIButton+WebCache.h"
#import "MakingPhotoController.h"
#import "OrientationNaController.h"
#import "AppDelegate.h"


static NSInteger IndexSection_Set =1;


@interface MyCenterController ()

//导航条按钮
@property (nonatomic,strong) UIBarButtonItem *backButtonItem;

@property (nonatomic, strong) UIBarButtonItem *closeButtonItem;


@end

@implementation MyCenterController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = YES;

    [self setUpUI];
    [self setUpData];
    [self requestMyInfomation];
    
//    //观察者对象
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateUserInfo:) name:kNotificationUpdateUserInfo object:nil];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    id<UIViewControllerTransitionCoordinator>tc = self.transitionCoordinator;
    if (tc && [tc initiallyInteractive])
    {
        [tc notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            if (![context isCancelled])
            {
                [self zhNavigationBar_BackgroundAlpah:0.f];
            }
        }];
    }
    else
    {
        [self zhNavigationBar_BackgroundAlpah:0.f];
    }

    UIInterfaceOrientation currentDirection = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(currentDirection))
    {
        OrientationNaController *nav = (OrientationNaController *)self.navigationController;
        [nav rotateToDirection:UIInterfaceOrientationPortrait];
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];

    if (!self.presentedViewController)
    {
        [self zhNavigationBar_BackgroundAlpah:1.f];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - UI

- (void)setUpUI
{
    [APP_Delegate setApperanceForSigleNavController:self];

    self.nameBtn.hidden = YES;
    self.signatureLab.text = @"未填写";
    
    [self.headBtn setCornerRadius:32 borderWidth:1 borderColor:[UIColor clearColor]];
    [self.headBtn zh_setButtonImageViewScaleAspectFill];
    
    
//    [self.headBtn sd_setImageWithURL:nil forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholdPhoto"]];

//    self.signatureLab.text = nil;
//    [self.nameBtn setTitle:nil forState:UIControlStateNormal];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)setUpData
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginIn:) name:kNotificationUserLoginIn object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginOut:) name:kNotificationUserLoginOut object:nil];
}



#pragma mark - 登陆
//登陆的时候需要重新刷新数据；
- (void)loginIn:(id)notification
{
    [self setPersonalInfomation];
}

#pragma mark - 退出

- (void)loginOut:(id)notification
{
    [self removePersonalInfomation];
}

- (void)removePersonalInfomation
{
    [self.headBtn sd_setImageWithURL:nil forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholdPhoto"]];
    self.nameBtn.hidden = YES;
    self.loginInBtn.hidden = !self.nameBtn.hidden;
    self.signatureLab.text = @"未填写";
}

- (void)setPersonalInfomation
{
    [self.headBtn sd_setImageWithURL:nil forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholdPhoto"]];

    self.nameBtn.hidden = NO;
    self.loginInBtn.hidden = !self.nameBtn.hidden;
    
    //可以用bmob的，也可以用自己封装的UserInfoUDManager
    BmobUser *bUser = [BmobUser currentUser];
    [self.nameBtn setTitle:bUser.username forState:UIControlStateNormal];
    
//    NSString *st = [NSString stringWithFormat:@"签名: %@",self.userCenterModel.sign];
//    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:st];
//    [attributed setAttributes:@{NSForegroundColorAttributeName:AppColor} range:NSMakeRange(0, 3)];
//    self.signatureLab.attributedText = attributed;

}




/**
 *  请求我的信息
 */
- (void)requestMyInfomation
{
//    [self zhHUD_showHUDAddedTo:self.view labelText:@"正在加载..."];
//    WS(weakSelf);
//    [[[AppAPIHelper shareInstance] getUserModelAPI]getMyInfomation:^(id data) {
//        
//        [UserInfoUDManager setUserData:data];
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        
//    } error:^(NSError *error) {
//        
//        [weakSelf zhHUD_showErrorWithStatus:[error localizedDescription]];
//    }];
}



- (void)updateUserInfo:(id)notification
{
//    UserModel *model= [UserInfoUDManager getUserData];
//    
//    NSString *title = nil;
//    if (model.userName.length==0 ||!model.userName)
//    {
//        title = [model.phone stringValue];
//    }
//    else
//    {
//        title = model.userName;
//    }
//    [self.nameBtn setTitle:title forState:UIControlStateNormal];
//    [self.nameBtn updateConstraints];
//
//    if (model.autograph.length==0 ||!model.autograph)
//    {
//        self.signatureLab.text = @"无签名，不显示，有签名，再显示!";
//    }
//    else
//    {
//        self.signatureLab.text =model.autograph ;
//    }
//    
//    [self.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.headURL] forState:UIControlStateNormal placeholderImage:AppPlaceholderHeadImage];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return LCDScale_5Equal6_To6plus(10);
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return LCDScale_5Equal6_To6plus(10);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return LCDScale_5Equal6_To6plus(45);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     if (indexPath.section==IndexSection_Set)
    {
           [self pushStoryboardViewControllerWithStoryboardName:sb_SetStoryboard identifier:SBID_SetControllerID withData:nil];
    }
    
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
//
//    // Configure the cell...
//    return cell;
//}


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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *vc = segue.destinationViewController;
    
//    if ([vc isKindOfClass:[MakingPhotoController class]])
//    {
//        [vc setValue:@(13) forKey:@"pageCount"];
//        [vc setValue:@"测试创建相册" forKey:@"albumTitle"];
//        [vc setValue:@(1) forKey:@"albumId"];
//        [vc setValue:@(129) forKey:@"price"];
//        
//    }
}

/**
 *  跳转我的个人信息页面
 *
 *  @param sender sender description
 */
- (IBAction)pushMyInfomation:(UIButton *)sender
{
    id controller = [[NSClassFromString(@"MineViewController") alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}



/**
 *  跳转消息列表页面
 *
 *  @param sender sender description
 */

-(void)pushMessageAction:(UIButton *)sender
{
//    self.tabBarController.tabBar.hidden = YES;
    [self.messageBtn setImage:[UIImage imageNamed:@"m_iconMessage"] forState:UIControlStateNormal];
//    MessageViewController *controller = [[NSClassFromString(@"MessageViewController") alloc] init];
//    controller.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)loginInActioin:(UIButton *)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:sb_LoginStoryboard bundle:[NSBundle mainBundle]];
    UINavigationController *loginViewController = [sb instantiateInitialViewController];
    [self presentViewController:loginViewController animated:YES completion:nil];
}
@end
