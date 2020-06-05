//
//  MyCenterController.m
//  Baby
//
//  Created by simon on 16/1/14.
//  Copyright © 2016年 simon. All rights reserved.
//
#import "MyCenterController.h"


#import "ZXOrientationNaController.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

#import "GuideShopHomeController.h"
#import "ZXAlphaTransitionDelegate.h"
#import "ZXAdvModalController.h"
#import "CheckVersionManager.h"

#import "ZXCustomNavigationBar.h"
#import "SetViewController.h"
#import "MakingPhotoController.h"

@interface MyCenterController ()<ZXAdvModalControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) ZXCustomNavigationBar *customNavigationBar;

@property (nonatomic, strong) UIImageView * topImageView;
@property (nonatomic, assign) CGFloat contentInsetTop;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopLayoutConstraint;


///广告弹窗
@property (nonatomic, strong) ZXAlphaTransitionDelegate *transitonModelDelegate;

/// 列表数据
@property (nonatomic, copy) NSArray *listTitleArr;


@end

@implementation MyCenterController


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUI];
    [self setData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];

    if (self.presentedViewController)
    {
        return;
    }
    UIInterfaceOrientation currentDirection = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(currentDirection))
    {
        ZXOrientationNaController *nav = (ZXOrientationNaController *)self.navigationController;
        [nav rotateToDirection:UIInterfaceOrientationPortrait];
    }
    id<UIViewControllerTransitionCoordinator>tc = self.transitionCoordinator;
    if (tc && [tc initiallyInteractive])
    {
        if (@available(iOS 10.0, *))
        {
            [tc notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                if ([context isCancelled])
                {
                    UIViewController *fromViewController = [context viewControllerForKey: UITransitionContextFromViewControllerKey];
                    if (![fromViewController isKindOfClass:NSClassFromString(@"MyLevelViewController")])
                    {
                        [self.navigationController setNavigationBarHidden:NO animated:animated];
                    }
                }
            }];
        }
        else
        {
            [tc notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                if ([context isCancelled])
                {
                    UIViewController *fromViewController = [context viewControllerForKey: UITransitionContextFromViewControllerKey];
                    if (![fromViewController isKindOfClass:NSClassFromString(@"MyLevelViewController")])
                    {
                        [self.navigationController setNavigationBarHidden:NO animated:animated];
                    }                }
            }];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.presentedViewController)
    {
        return;
    }
    if (self.transitionCoordinator != nil)
    {
        //非交互式回调,完成转场了再设置navigationBar是否隐藏已经无意义了,所以completion的block不用
        BOOL flag  = [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            UIViewController *toViewController = [context viewControllerForKey: UITransitionContextToViewKey];
            if (![toViewController isKindOfClass:NSClassFromString(@"MyLevelViewController")])
            {
                [self.navigationController setNavigationBarHidden:NO animated:animated];
            }
        } completion:nil];
        //交互式中断
        if (!flag)
        {
            UIViewController *toViewController = self.navigationController.topViewController;
            if (![toViewController isKindOfClass:NSClassFromString(@"MyLevelViewController")])
            {
                [self.navigationController setNavigationBarHidden:NO animated:animated];
            }
        }
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    if ([WYUserDefaultManager getNewNewFunctionGuide_ShopHomeV1])
//    {
//        [self checkAppVersionAndNotificationPush];
//    }
    NSArray *arr = @[@"1",@"2",@"3"];
//    NSLog(@"%@",arr);
    
//    NSLog(@"%@",arr.description);
    NSLog(@"%@",arr);
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.customNavigationBar.frame = CGRectMake(0, 0, LCDW, kHEIGHT_SAFEAREA_NAVBAR);
    self.tableViewTopLayoutConstraint.constant = kHEIGHT_SAFEAREA_NAVBAR;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


#pragma mark - UI

- (void)setUI
{
    [self setApperanceForSigleNavController:self.navigationController];
    [self addCustomNavigationBarView];
    [self setHeaderView];

    self.tableView.estimatedRowHeight = 45;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc] init];
    //添加背景放大imageView
    [self addScaleImageView];
    
//    [self lauchFirstNewFunction];
}

/// 系统导航条通用设置
- (void)setApperanceForSigleNavController:(UINavigationController *)navigationController
{
    [navigationController zx_navigationBar_allBackIndicatorImage:@"back_onlyImage" isOriginalImage:YES];
    [navigationController zx_navigationBar_barItemColor:UIColorFromRGB_HexValue(0x222222)];
    [navigationController zx_navigationBar_titleColor:UIColorFromRGB_HexValue(0x222222) titleFont:[UIFont boldSystemFontOfSize:17.f]];
}

/// 添加自定义导航条
- (void)addCustomNavigationBarView
{
//    _stausBarStyle =UIStatusBarStyleDefault;
    [self.view addSubview:self.customNavigationBar];
    [self.customNavigationBar.rightBarButton1 setImage:[UIImage imageNamed:@"icon_shezhi"] forState:UIControlStateNormal];
    [self.customNavigationBar.rightBarButton1 addTarget:self action:@selector(setterButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setHeaderView
{
    self.nameBtn.hidden = YES;
    self.signatureLab.text = @"未填写";
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    self.signatureLab.font = font;
    self.signatureLab.adjustsFontForContentSizeCategory = YES;
    [self.headBtn zx_setBorderWithCornerRadius:32 borderWidth:1 borderColor:[UIColor clearColor]];
    [self.headBtn zh_setButtonImageViewScaleAspectFill];
}

///添加背景放大imageView，前提是collectionView的背景要透明
- (void)addScaleImageView
{
    self.contentInsetTop = 0;
//    self.tableView.contentInset = UIEdgeInsetsMake(64-20, 0, 0, 0);
//    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64-20+ _contentInsetTop, 0, 0, 0);
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:self.topImageView belowSubview:self.tableView];
//   self.topImageView.hidden = YES;
}


- (ZXCustomNavigationBar *)customNavigationBar{
    if(!_customNavigationBar)
    {
        ZXCustomNavigationBar *navigationBar = [ZXCustomNavigationBar zx_viewFromNib];
        [navigationBar zx_setBarBackgroundColor:UIColorFromRGB_HexValue(0xED7C34)];
//        navigationBar.hidden = YES;
        _customNavigationBar = navigationBar;
    }
    return _customNavigationBar;
}

- (UIImageView *)topImageView
{
    if (!_topImageView)
    {
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, LCDW, LCDW*100.f/375.0)];
        view.backgroundColor = UIColorFromRGB_HexValue(0xED7C34);
        _topImageView = view;
    }
    return _topImageView;
}

#pragma mark-

- (void)setData
{
    [self addNotification];
    [self requestMyInfomation];

    [self zx_testData];
    
    NSDictionary *dic0 =@{@"type":@"makeTemplate",@"title":@"照片拼图",@"imageName":@"m_iconAlbum"};
    NSDictionary *dic1 = @{@"type":@"search",@"title":@"搜索",@"imageName":@"m_iconGrowth"};
    NSDictionary *dic2 = @{@"type":@"prefecture",@"title":@"首页专区",@"imageName":@"m_iconCloud"};
    NSDictionary *dic3 = @{@"type":@"amap",@"title":@"地图配送任务",@"imageName":@"m_iconCloud"};
    self.listTitleArr = @[dic0,dic1,dic2,dic3];
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginNotification:) name:kNotificationUserLogin object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logoutNotification:) name:kNotificationUserLogout object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateUserInfo:) name:kNotificationUpdateUserInfo object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(contentSizeChange:) name:UIContentSizeCategoryDidChangeNotification object:nil];
}

- (void)zx_testData
{
    static NSInteger num = 1;
    NSInteger (^getFull)(NSInteger var) = ^(NSInteger var){
        num = 3;
        return num +var;
    };
    // Try changing the non-local variable (it won't change the block)
    num = 2;
    NSLog(@"%ld",(long)getFull(3));
    
}

- (NSArray *)listTitleArr
{
    if (!_listTitleArr) {
        _listTitleArr = [NSArray array];
        
    }
    return _listTitleArr;
}

#pragma mark - 新功能引导

//第一步
- (void)lauchFirstNewFunction
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newFunctionGuideOfNextStep:) name:@"NewFunctionGuide_ShopHomeV1_Dismiss" object:nil];
    if (![WYUserDefaultManager getNewNewFunctionGuide_ShopHomeV1])
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        GuideShopHomeController *vc = [sb instantiateViewControllerWithIdentifier:SBID_GuideShopHomeController];
        [self.navigationController addChildViewController:vc];
        [self.navigationController.view addSubview:vc.view];
    }
}

- (void)newFunctionGuideOfNextStep:(id)noti
{
    [self checkAppVersionAndNotificationPush];
}

#pragma mark - 先检查通知跳转再检查更新
//第三步：先检查推送通知跳转再检查版本更新，如果通知跳转下一页，返回来继续下一步检查更新
- (void)checkAppVersionAndNotificationPush
{
    if ([WYUserDefaultManager isOpenAppRemoteNoti])
    {
        BOOL pushed = NO;
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
    /*
    WS(weakSelf);
    [[[AppAPIHelper shareInstance] getMessageAPI] GetAdvWithType:@1005 success:^(id data) {
        
        weakSelf.advmodel = (AdvModel *)data;
        if (weakSelf.advmodel.advArr.count>0)
        {
            [WYUserDefaultManager addTodayAppLanchAdvTimes];
            if ([WYUserDefaultManager isCanLanchAdvWithMaxTimes:@(weakSelf.advmodel.num)])
            {
                advArrModel *advItemModel = [weakSelf.advmodel.advArr firstObject];
                [weakSelf launchHomeAdvView:advItemModel];
            }
            else
            {
                [weakSelf addUNNotificationAlert];
            }
        }
        else
        {
            [weakSelf addUNNotificationAlert];
        }
        
    } failure:^(NSError *error) {
        
        [weakSelf addUNNotificationAlert];
    }];
     */
//    不请求，模拟一定弹出
    [WYUserDefaultManager addTodayAppLanchAdvTimes];
    if ([WYUserDefaultManager isCanLanchAdvWithMaxTimes:@(8)])
    {
        ZXAdvModel *zxModel =[[ZXAdvModel alloc]initWithDesc:@"义乌市场导航图免费招商" picString:@"http://public-read-bkt.microants.cn/4/adv/JepEashhh5rQ4F2CpGBQWfdJSTz6af4G.jpg" url:@"https://mp.weixin.qq.com/s/bySiG3U8ku0MFixAsee8fQ" advId:@(75)];
        [self launchHomeAdvView:zxModel];
    }
    else
    {
        [self addUNNotificationAlert];
    }
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
//    NSString *advid = [NSString stringWithFormat:@"%@",advModel.advId];
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


#pragma mark- 请求我的信息

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





#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listTitleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return LCDScale_iPhone6(10);
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDictionary *dic = [self.listTitleArr objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[dic objectForKey:@"imageName"]];
    cell.textLabel.text = [dic objectForKey:@"title"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSDictionary *dic = [self.listTitleArr objectAtIndex:indexPath.row];
    NSString *type = [dic objectForKey:@"type"];
    if ([type isEqualToString:@"makeTemplate"])
    {
        [self performSegueWithIdentifier:@"TemplateListController" sender:nil];
    }
    else if ([type isEqualToString:@"search"])
    {
        [self pushSearchVc];
    }
    else if ([type isEqualToString:@"prefecture"])
    {
        [self pushPrefectureVc];
    }
    else if ([type isEqualToString:@"amap"])
    {
        [self pushAMapTask];
    }
}

#pragma mark-

- (void)pushSearchVc
{
    Class cls = NSClassFromString(@"SearchViewController");
    id obj = [[cls alloc]init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:obj];
     nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)pushPrefectureVc
{
    Class cls = NSClassFromString(@"HomeViewController");
    id obj = [[cls alloc]init];
    [self.navigationController pushViewController:obj animated:YES];
}

- (void)pushAMapTask
{
    Class class = NSClassFromString(@"CHSDistributionTaskController");
    UIViewController *vc = [class new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
#pragma mark - UISCrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //注意,默认偏移为0
    CGFloat offsetY = scrollView.contentOffset.y + scrollView.contentInset.top;
//    NSLog(@"%f,%f,%f",scrollView.contentOffset.y,scrollView.contentInset.top,offsetY);
//    往下拉，topImageView放大
    if (offsetY <= 0) {
        
        CGRect frame = self.topImageView.frame;
        frame.size.height= kHEIGHT_SAFEAREA_NAVBAR+_contentInsetTop+ ABS(offsetY);
        self.topImageView.frame = frame;
        
        [self.customNavigationBar zx_setBarBackgroundContainerAlpha:0 animated:YES];
    }
    else
    {
        CGFloat alpha = (offsetY>0 && offsetY<=64)? offsetY/64:1.f;
        [self.customNavigationBar zx_setBarBackgroundContainerAlpha:alpha animated:YES];
        
        if (alpha >0.5)
        {
            self.customNavigationBar.title = NSLocalizedString(@"我的", nil);
            //            _stausBarStyle = UIStatusBarStyleDefault;
            //            [self setNeedsStatusBarAppearanceUpdate];
        }
        else
        {
            self.customNavigationBar.title = nil;
            //            _stausBarStyle = UIStatusBarStyleLightContent;
            //            [self setNeedsStatusBarAppearanceUpdate];
        }
        CGRect frame = self.topImageView.frame;
        frame.size.height= kHEIGHT_SAFEAREA_NAVBAR+_contentInsetTop;
        self.topImageView.frame = frame;
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    UIViewController *vc = segue.destinationViewController;
}


#pragma mark - action

///跳转我的个人信息页面
- (IBAction)pushMyInfomation:(UIButton *)sender
{
    id controller = [[NSClassFromString(@"MineViewController") alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}


- (IBAction)loginInActioin:(UIButton *)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:storyboard_Login bundle:[NSBundle mainBundle]];
    UINavigationController *loginNav = [sb instantiateInitialViewController];
    loginNav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:loginNav animated:YES completion:nil];
}


- (void)setterButtonAction:(id)sender
{
    [self.navigationController zx_pushStoryboardViewControllerWithStoryboardName:storyboard_Set identifier:NSStringFromClass([SetViewController class]) withData:nil];
}

- (void)pushMessageAction:(UIButton *)sender
{

}


#pragma mark - Action-通知

- (void)contentSizeChange:(id)sender
{
    [self.tableView reloadData];
}

#pragma mark -登陆
//登陆的时候需要重新刷新数据；
- (void)loginNotification:(id)notification
{
    [self setPersonalInfomation];
}

#pragma mark - 退出

- (void)logoutNotification:(id)notification
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
    [self.headBtn sd_setImageWithURL:nil forState:UIControlStateNormal placeholderImage:AppPlaceholderImage_Head];

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

@end
