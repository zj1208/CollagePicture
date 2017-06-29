//
//  FourViewController.m
//  wqk8
//
//  Created by xielei on 15/11/9.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "FourViewController.h"
//#import "MyCenterCell1.h"
//#import "HeaderView.h"
//#import "UserModel.h"
static NSString * const reuseIdentifier1 = @"Cell1";
@interface FourViewController ()<UIViewControllerTransitioningDelegate>

//@property(nonatomic,strong)NSArray *dataArray;
//
//@property(nonatomic,strong)ModalAnimation *modalAnimation;
//@property(nonatomic,strong)HeaderView *headerView;
@end

@implementation FourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
//    [self zhuNavigationBar_appearance_systemBack_noTitle];
    
//    self.tableView = [self.tableView initWithFrame:self.tableView.frame style:UITableViewStyleGrouped];
//    
//    NSDictionary *section1 =@{@"账户":@"account_"};
//    NSDictionary *section2 =@{@"奖励":@"resume_"};
//    NSDictionary *section3 =@{@"活动":@"activity_",@"收藏":@"attention_",@"待请":@"Stay_please_"};
//    NSDictionary *section4 =@{@"礼物":@"gift_",@"动态":@"dynamic_condition_"};
//    NSDictionary *section5 =@{@"设置":@"set_"};
//    
//    self.dataArray =@[section1,section2,section3,section4,section5];
    
    self.tableView.rowHeight = 50;
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登陆" style:UIBarButtonItemStyleDone target:self action:@selector(loginIn)];
    
//    HeaderView *headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), LCDScale(200))];
//    self.tableView.tableHeaderView = headerView;
//    [headerView.signatureBtn addTarget:self action:@selector(signatureAction) forControlEvents:UIControlEventTouchUpInside];
//    self.headerView = headerView;
    
    
//    self.modalAnimation = [[ModalAnimation alloc] init];
    
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self.headerView setData:model];

}
//- (void)signatureAction
//{
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"PersonalCentre" bundle:nil];
//    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"SignatureControllerID"];
//    [self.navigationController pushViewController:vc animated:YES];
//    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
//
//}


- (void)loginIn
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"RegisterLogin" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ModalControllerID"];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.transitioningDelegate = self;
    [self presentViewController:vc animated:YES completion:nil];
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"RegisterLogin" bundle:nil];
//    UIViewController *vc = [sb instantiateInitialViewController];
//    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [self.navigationController presentViewController:vc animated:YES completion:^{
//        if ([UserInfoUDManager isLogin])
//        {
//            [UserInfoUDManager loginOut];
//        }
//    }];

}

#pragma mark-UIViewControllerTransitionDelegate

//- (nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
//{
//    self.modalAnimation.type = AnimationTypePresent;
//    return self.modalAnimation;
//}
//
//- (nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
//{
//    self.modalAnimation.type = AnimationTypeDismiss;
//    return self.modalAnimation;
//}
//

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//
//    return 5;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    switch (section)
//    {
//        case 2:return 3;break;
//        case 3:return 2;break;
//        default:return 1;
//            break;
//    }
//    return 0;
//}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//   
//    MyCenterCell1* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier1];
//    if (cell ==nil)
//    {
//        cell = (MyCenterCell1 *)[[MyCenterCell1 alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier1];
//       
//    }
//    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.section];
//    NSString *key = [[dic allKeys]objectAtIndex:indexPath.row];
//    cell.textLabel.text = key;
//    cell.imageView.image =[UIImage imageNamed:[dic valueForKey:key]];
//    
//    UserOutPutBean *model = [[UserModel getInstance]userOutPutBean];
//
//    if (indexPath.section==1||(indexPath.section==2&&indexPath.row==2))
//    {
//        cell.detailTextLabel.text = nil;
//        cell.promotBtn.hidden = NO;
//
//        if (indexPath.section==1)
//        {
//         
//            [cell.promotBtn zhu_iconWithTitle:@"992" height:20];
//        }
//        else
//        {
//            [cell.promotBtn zhu_iconWithTitle:@"43" height:20];
//        }
//
//    }
//    else
//    {
//        cell.promotBtn.hidden = YES;
//
//        if (indexPath.section==0)
//        {
//            cell.detailTextLabel.text = [NSString stringWithFormat:@"余额%@元",model.balance];
//        }
//        if (indexPath.section==2 &&indexPath.row ==0)
//        {
//            NSString *st = [NSString stringWithFormat:@"好评%.1f",50.0];
//            cell.detailTextLabel.text = [st stringByAppendingString:@"%"];
//        }
//        if (indexPath.section==3 &&indexPath.row ==0)
//        {
//            NSString *st = [NSString stringWithFormat:@"好评%.1f",90.0];
//            cell.detailTextLabel.text = [st stringByAppendingString:@"%"];
//        }
//
//
//    }
//  
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    // Configure the cell...
//    
//    return cell;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==4)
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"PersonalCentre" bundle:nil];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"SetControllerID"];
        [self.navigationController pushViewController:vc animated:YES];

    }
    if (indexPath.section==2 && indexPath.row==0)
    {
      id class = [[NSClassFromString(@"MyTreatViewControl") alloc]init];
        [self.navigationController pushViewController:class animated:YES];

    }
    if (indexPath.section ==0)
    {
//        RePasswordController *vc = [[RePasswordController alloc] init];
//        vc.password = @"111";
//        [self.navigationController pushViewController:vc animated:YES];
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
