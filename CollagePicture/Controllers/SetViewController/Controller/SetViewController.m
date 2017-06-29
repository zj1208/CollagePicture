//
//  SetViewController.m
//  CollagePicture
//
//  Created by 朱新明 on 16/11/18.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "SetViewController.h"
#import "SDImageCache.h"

#import "CheckVersionAPI.h"


@interface SetViewController ()<CheckVersionDelegate,UIActionSheetDelegate>


@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
    

    [self setUI];
    

      
}

- (void)setUI
{
    self.versionLab.text = APP_Version;
    [self reloadVersionUI];

}


- (void)reloadVersionUI
{
    float tempSize = [[SDImageCache sharedImageCache] getSize]/1024.0/1024;
    NSString *sizeStr =tempSize>=1?[NSString stringWithFormat:@"%.2fM",tempSize]:[NSString stringWithFormat:@"%.2fK",tempSize*1024];
    
    self.cacheSizeLab.text =sizeStr;
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
            case 1: [self goAppStore]; break;
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
    [UIAlertController zx_presentAlertInViewController:self withTitle:@"通知" message:@"要清除所有缓存数据吗" cancelButtonTitle:@"取消" cancleHandler:nil doButtonTitle:@"确定" doHandler:^(UIAlertAction * _Nonnull action) {
    
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
    [UIAlertController zx_presentAlertInViewController:self withTitle:APP_Name message:@"有新版本，是否升级？" cancelButtonTitle:@"取消" cancleHandler:nil doButtonTitle:@"升级" doHandler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf goAppStore];

    }];
}

- (void)zxCheckVersionWithNoNewVersion:(CheckVersionAPI *)versionAPI
{
    [UIAlertController zx_presentAlertInViewController:self withTitle:APP_Name message:@"现在已经是最新版本了" cancelButtonTitle:nil cancleHandler:nil doButtonTitle:@"好的" doHandler:nil];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
