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

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

#import "ZXAlphaTransitionDelegate.h"
#import "ZXAdvModalController.h"
#import "CheckVersionManager.h"

static NSInteger IndexSection_Set =1;


@interface MyCenterController ()<ZXAdvModalControllerDelegate>

//导航条按钮
@property (nonatomic,strong) UIBarButtonItem *backButtonItem;

@property (nonatomic, strong) UIBarButtonItem *closeButtonItem;

//广告弹窗
@property (nonatomic, strong) ZXAlphaTransitionDelegate *transitonModelDelegate;

@end

@implementation MyCenterController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = YES;

    [self setUI];
    [self setUpData];
    [self requestMyInfomation];
    
//    //观察者对象
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateUserInfo:) name:kNotificationUpdateUserInfo object:nil];
    
}

#pragma mark - 新功能引导
//第一步
- (void)newFunctionGuideOfNextStep:(id)noti
{
    [self checkAppVersionAndNotificationPush];
}
- (void)lauchFirstNewFunction
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newFunctionGuideOfNextStep:) name:@"NewFunctionGuide_ShopHomeV1_Dismiss" object:nil];
//    if (![WYUserDefaultManager getNewNewFunctionGuide_ShopHomeV1])
//    {
//        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        GuideShopHomeController *vc = [sb instantiateViewControllerWithIdentifier:SBID_GuideShopHomeController];
//        [self.tabBarController addChildViewController:vc];
//        [self.tabBarController.view addSubview:vc.view];
//    }
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
                [self xm_navigationBar_BackgroundAlpah:0.f];
            }
        }];
    }
    else
    {
        [self xm_navigationBar_BackgroundAlpah:0.f];
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
    
//    if ([WYUserDefaultManager getNewNewFunctionGuide_ShopHomeV1])
//    {
//        [self checkAppVersionAndNotificationPush];
//    }

}


- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];

    if (!self.presentedViewController)
    {
        [self xm_navigationBar_BackgroundAlpah:1.f];
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

- (void)setUI
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
    self.signatureLab.text = NSLocalizedString(@"未填写", nil);
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
        [self xm_pushStoryboardViewControllerWithStoryboardName:sb_SetStoryboard identifier:SBID_SetControllerID withData:nil];
    }
    
    if (indexPath.section == 0 && indexPath.row == 1)
    {
   
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


#pragma mark - 先检查通知跳转再检查更新
//第三步：先检查推送通知跳转再检查版本更新，如果通知跳转下一页，返回来继续下一步检查更新

- (void)checkAppVersionAndNotificationPush
{
    if ([WYUserDefaultManager isOpenAppRemoteNoti])
    {
        BOOL pushed;
//        BOOL pushed = [[WYUtility dataUtil]routerWithName:[WYUserDefaultManager getDidFinishLaunchRemoteNoti] withSoureController:self];
        if (!pushed)
        {
            [self checkAppVersion];
        }
    }
    else{
        
        [self checkAppVersion];
    }
}

#pragma mark -检查版本更新请求
//第四步：检查完版本更新，再请求广告弹窗
- (void)checkAppVersion
{
    WS(weakSelf);
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //        版本更新
        [[CheckVersionManager sharedInstance]checkAppVersionWithNextStep:^{
            
            [weakSelf launchHomeAdvViewOrUNNotificationAlert];
        }];
    });
}



//第五步：检查完请求广告弹窗，再检查推送通知是否关闭
#pragma mark - 请求广告弹窗图

- (void)launchHomeAdvViewOrUNNotificationAlert
{
    
    [WYUserDefaultManager addTodayAppLanchAdvTimes];
    if ([WYUserDefaultManager isCanLanchAdvWithMaxTimes:@(8)])
    {
        ZXAdvModel *zxModel =[[ZXAdvModel alloc]initWithDesc:@"义乌市场导航图免费招商" picString:@"http://public-read-bkt.microants.cn/4/adv/JepEashhh5rQ4F2CpGBQWfdJSTz6af4G.jpg" url:@"https://mp.weixin.qq.com/s/bySiG3U8ku0MFixAsee8fQ" advId:@(75)];
//        advArrModel *advItemModel = [_advmodel.advArr firstObject];
        [self launchHomeAdvView:zxModel];
    }
    else
    {
        [self addUNNotificationAlert];
    }

//    [[[AppAPIHelper shareInstance] getMessageAPI] GetAdvWithType:@1005 success:^(id data) {
//
//        _advmodel = (AdvModel *)data;
//        if (_advmodel.advArr.count>0)
//        {
//                        [WYUserDefaultManager addTodayAppLanchAdvTimes];
//                        if ([WYUserDefaultManager isCanLanchAdvWithMaxTimes:@(_advmodel.num)])
//                        {
//            advArrModel *advItemModel = [_advmodel.advArr firstObject];
//            [self firstNewFunction:advItemModel];
//                        }
//                        else
//                        {
//                            [self addUNNotificationAlert];
//                        }
//        }
//        else
//        {
//            [self addUNNotificationAlert];
//        }
//        
//    } failure:^(NSError *error) {
//        
//        [self addUNNotificationAlert];
//    }];
}

#pragma mark launchAdv

- (void)launchHomeAdvView:(ZXAdvModel *)model
{
    if (!self.transitonModelDelegate)
    {
        self.transitonModelDelegate = [[ZXAlphaTransitionDelegate alloc] init];
    }
    ZXAdvModalController *vc = [[ZXAdvModalController alloc] initWithNibName:nil bundle:nil];
    vc.btnActionDelegate = self;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.transitioningDelegate = self.transitonModelDelegate;
    vc.advModel = model;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma  mark -  广告图按钮点击回调代理
- (void)zx_advModalController:(ZXAdvModalController *)controller advItem:(ZXAdvModel *)advModel
{
//    [MobClick event:kUM_c_indexbanner];
    NSString *advid = [NSString stringWithFormat:@"%@",advModel.advId];
//    [self requestClickAdvWithAreaId:@2006 advId:advid];
    //业务逻辑的跳转
//    [[WYUtility dataUtil]cheackAdvURLToControllerWithSoureController:self.navigationController advUrlString:advModel.url];
}

#pragma mark - 检查用户通知关闭 及提示
//第六步：检查推送通知是否关闭
- (void)addUNNotificationAlert
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0)
    {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            
            if (settings.authorizationStatus ==UNAuthorizationStatusDenied)
            {
                [self presentNotiAlert];
            }
        }];
    }
    else
    {
        UIUserNotificationSettings * notiSettings = [[UIApplication sharedApplication]currentUserNotificationSettings];
        if (notiSettings.types == UIUserNotificationTypeNone)
        {
            [self presentNotiAlert];
        }
    }
}
- (void)presentNotiAlert
{
    if ([WYUserDefaultManager isCanPresentAlertWithIntervalDay:7])
    {
        NSString *title = [NSString stringWithFormat:@"您忘了开启通知\n赚钱的好机会没法告诉你"];
        [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:title message:nil cancelButtonTitle:@"暂不打开" cancleHandler:nil doButtonTitle:@"立即开启" doHandler:^(UIAlertAction * _Nonnull action) {
            
            NSURL *openUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication]respondsToSelector:@selector(openURL:options:completionHandler:)])
            {
                [[UIApplication sharedApplication] openURL:openUrl options:@{} completionHandler:nil];
            }
            else
            {
                [[UIApplication sharedApplication] openURL:openUrl];
            }
        }];
    }
}

@end
