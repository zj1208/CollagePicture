//
//  AboutViewController.m
//  CollagePicture
//
//  Created by simon明 on 16/12/2.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation AboutViewController

static NSString *const XTableViewCellIdentifier = @"Cell";
static NSString * const kFeedbackAppKey = @"23557047";
static NSString * const kFeedbackAppSecret = @"bf08c742e1baba2c11df06219282a2a3";

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = NSLocalizedString(@"关于", nil);
    self.versionLab.text = [NSString stringWithFormat:@"版本号 %@",kAPP_Version];
    self.dataArray = @[@"版本说明",@"反馈",@"隐私权政策",@"版权信息"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:XTableViewCellIdentifier forIndexPath:indexPath];
    if (self.dataArray.count>0)
    {
        cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row ==3)
    {
        [self performSegueWithIdentifier:segue_copyrightController sender:self];
    }
    else if (indexPath.row ==1)
    {
    }
    else if (indexPath.row ==2)
    {
         [self performSegueWithIdentifier:segue_PrivacyListController sender:self];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
