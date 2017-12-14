//
//  AboutViewController.m
//  CollagePicture
//
//  Created by 朱新明 on 16/12/2.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "AboutViewController.h"

#import <YWFeedbackFMWK/YWFeedbackViewController.h>
#import <YWFeedbackFMWK/YWFeedbackKit.h>

@interface AboutViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSArray *dataArray;
@property (nonatomic, strong) YWFeedbackKit *feedbackKit;

@end

@implementation AboutViewController

static NSString *const XTableViewCellIdentifier = @"Cell";
static NSString * const kFeedbackAppKey = @"23557047";
static NSString * const kFeedbackAppSecret = @"******";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.versionLab.text = [NSString stringWithFormat:@"版本号 %@",APP_Version];
    
    self.dataArray = @[@"版本说明",@"反馈",@"隐私权政策",@"版权信息"];
    
    
}

#pragma mark getter
- (YWFeedbackKit *)feedbackKit {
    if (!_feedbackKit) {
        _feedbackKit = [[YWFeedbackKit alloc] initWithAppKey:kFeedbackAppKey appSecret:kFeedbackAppSecret];
    }
    return _feedbackKit;
}
- (void)openFeedbackViewController
{
    /** 设置App自定义扩展反馈数据 */
    self.feedbackKit.extInfo = @{@"loginTime":[[NSDate date] description],
                                 @"visitPath":@"登陆->关于->反馈",
                                 @"userid":@"yourid",
                                 @"应用自定义扩展信息":@"开发者可以根据需要设置不同的自定义信息，方便在反馈系统中查看"};
    WS(weakSelf);
    [self.feedbackKit makeFeedbackViewControllerWithCompletionBlock:^(BCFeedbackViewController *viewController, NSError *error) {
        if (viewController !=nil)
        {
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
            
            [weakSelf presentViewController:nav animated:YES completion:nil];
            //如果用push，会有bug，待问技术支持解决
            //[weakSelf.navigationController pushViewController:viewController animated:YES];
            
            NSLog(@"%@",viewController.navigationItem);
            [viewController setCloseBlock:^(UIViewController *aParentController){
                [aParentController dismissViewControllerAnimated:YES completion:nil];
               // [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        }
        else
        {
            /** 使用自定义的方式抛出error时，此部分可以注释掉 */
            NSString *title = [error.userInfo objectForKey:@"msg"]?:@"接口调用失败，请保持网络通畅！";
//            [[TWMessageBarManager sharedInstance] showMessageWithTitle:title
//                                                           description:nil
//                                                                  type:TWMessageBarMessageTypeError]
        }
    }];
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
        [self openFeedbackViewController];
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
