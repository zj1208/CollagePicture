//
//  SetViewController.m
//  CollagePicture
//
//  Created by simon on 16/11/18.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "SetViewController.h"
#import "SDImageCache.h"

#import "CheckVersionAPI.h"


@interface SetViewController ()<CheckVersionDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UILabel *accountTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *changePassWordTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *aboutTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *goAppStoreTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *currentVersionTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *cleanMemoryTitleLab;


@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
    [self setUI];
    [self setData];
}

- (void)setUI
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"ECECEC"];
    self.tableView.separatorColor =  self.view.backgroundColor;
    self.tableView.estimatedRowHeight = 45;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.versionLab.text = [NSString stringWithFormat:@"V %@",APP_Version];
    [self reloadVersionUI];
    [self dynamicTitleLabelFont];
}

- (void)dynamicTitleLabelFont
{
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    self.accountTitleLab.font = font;
    self.changePassWordTitleLab.font = font;
    self.aboutTitleLab.font = font;
    self.goAppStoreTitleLab.font =font;
    self.currentVersionTitleLab.font =font;
    self.cleanMemoryTitleLab.font =font;
    
    UIFont *font_detail = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    self.versionLab.font = font_detail;
    self.cacheSizeLab.font = font_detail;
    
    if (@available(iOS 10.0, *))
    {
        self.accountTitleLab.adjustsFontForContentSizeCategory = YES;
        self.changePassWordTitleLab.adjustsFontForContentSizeCategory = YES;
        self.aboutTitleLab.adjustsFontForContentSizeCategory =YES;
        self.goAppStoreTitleLab.adjustsFontForContentSizeCategory = YES;
        self.currentVersionTitleLab.adjustsFontForContentSizeCategory = YES;
        self.cleanMemoryTitleLab.adjustsFontForContentSizeCategory = YES;
        self.versionLab.adjustsFontForContentSizeCategory = YES;
        self.cacheSizeLab.adjustsFontForContentSizeCategory = YES;
    }
}

- (void)reloadVersionUI
{    
    float tempSize = [[SDImageCache sharedImageCache] getSize]/1024.0/1024;
    NSString *sizeStr =tempSize>=1?[NSString stringWithFormat:@"%.2fM",tempSize]:[NSString stringWithFormat:@"%.2fK",tempSize*1024];
    
    self.cacheSizeLab.text =sizeStr;
}

- (void)setData{
    
    if (@available(iOS 10.0, *))
    {
        
    }
    else
    {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateFonts:) name:UIContentSizeCategoryDidChangeNotification object:nil];
    }
}

- (void)updateFonts:(id)sender
{
//    static NSDictionary *cellHeight;
//
//    if (!cellHeight) {
//
//        cellHeight = @{UIContentSizeCategoryExtraSmall: @44,// 没有 Accessibility 是普通字体的大小
//                       UIContentSizeCategorySmall: @44,
//                       UIContentSizeCategoryMedium: @44,
//                       UIContentSizeCategoryLarge: @44,
//                       UIContentSizeCategoryExtraLarge: @55,
//                       UIContentSizeCategoryExtraExtraLarge: @65,
//                       UIContentSizeCategoryExtraExtraExtraLarge: @75,
//                       UIContentSizeCategoryAccessibilityMedium: @75, // 注意这个是更大字体的方法
//                       UIContentSizeCategoryAccessibilityLarge: @85,
//                       UIContentSizeCategoryAccessibilityExtraLarge: @95,
//                       UIContentSizeCategoryAccessibilityExtraExtraLarge: @105,
//                       UIContentSizeCategoryAccessibilityExtraExtraExtraLarge: @115};
//    }
//
//    // Application 单例自带方法判断内容尺寸
//    NSString *tableViewSize = [[UIApplication sharedApplication] preferredContentSizeCategory];
//    // 根据尺寸在 cellHeight 字典中选择相应的行高
//    NSNumber *tableViewRowHeight = cellHeight[tableViewSize];
//
//    self.tableView.rowHeight = tableViewRowHeight.floatValue;
//
    [self.tableView reloadData];
    [self dynamicTitleLabelFont];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([UserInfoUDManager isLogin])
    {
        return 4;
    }
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==2)
    {
        return 30;
    }
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==1)
    {
        switch (indexPath.row)
        {
            case 0:;break;
            case 1: [self zx_goAppStoreWithAppId:kAPPID]; break;
            case 2: [self checkVersionUpdate]; break;
            default:
                break;
        }
    }
    
    if (indexPath.section ==2)
    {
        switch (indexPath.row)
        {
            case 0:[self showCacheAlertView]; break;
            default:
                break;
        }
        
    }
    if (indexPath.section ==3)
    {
        [self loginOut];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)loginOut
{
    WS(weakSelf);
    [UIAlertController zx_presentActionSheetInViewController:self withTitle:@"通知" message:@"您确定要退出登录吗？" cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex ==alertController.destructiveButtonIndex)
        {
            [MBProgressHUD zx_showLoadingWithStatus:@"正在退出" toView:nil];
            [UserInfoUDManager loginOut];
            [BmobUser logout];
            [MBProgressHUD zx_hideHUDForView:nil];
            [weakSelf.tableView reloadData];
        }

    }];
}



#pragma  mark - 清除缓存

- (void)showCacheAlertView
{
    WS(weakSelf);
    [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:@"通知" message:@"要清除所有缓存数据吗" cancelButtonTitle:@"取消" cancleHandler:nil doButtonTitle:@"确定" doHandler:^(UIAlertAction * _Nonnull action) {
    
        [weakSelf clearedMemoryUpdateUI];
        }];
}

-(void)clearedMemoryUpdateUI
{
    [MBProgressHUD zx_showLoadingWithStatus:@"正在清理缓存..." toView:nil];
    [[SDImageCache sharedImageCache]clearMemory];
    [[SDImageCache sharedImageCache]clearDiskOnCompletion:^{
        
        [MBProgressHUD zx_showSuccess:@"已清楚所有缓存" toView:nil];
        [self reloadVersionUI];
    }];
}



#pragma mark - VersionUpdate请求版本数据

-(void)checkVersionUpdate
{
    CheckVersionAPI *checkVersion = [CheckVersionAPI shareInstance];
    checkVersion.delegate = self;
    [checkVersion checkVersionUpdateWithController:self];
}

- (void)zxCheckVersionWithNewVersion:(CheckVersionAPI *)versionAPI
{
    WS(weakSelf);
    [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:APP_Name message:@"有新版本，是否升级？" cancelButtonTitle:@"取消" cancleHandler:nil doButtonTitle:@"升级" doHandler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf zx_goAppStoreWithAppId:kAPPID];

    }];
}

- (void)zxCheckVersionWithNoNewVersion:(CheckVersionAPI *)versionAPI
{
    [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:APP_Name message:@"现在已经是最新版本了" cancelButtonTitle:nil cancleHandler:nil doButtonTitle:@"好的" doHandler:nil];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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



@end
