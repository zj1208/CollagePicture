//
//  AlertChoseController.h
//  YiShangbao
//
//  Created by simon on 2017/9/21.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXTransitionModalDelegate.h"

//static NSString *const SBID_AlertChoseController = @"AlertChoseControllerID";

NS_ASSUME_NONNULL_BEGIN

@protocol ZXAlertChoseControllerDelegate;

@interface AlertChoseController : UIViewController

@property (nonatomic, weak) id<ZXAlertChoseControllerDelegate>btnActionDelegate;

@property (nonatomic, copy) NSString *alertTitle;

@property (nonatomic, strong) NSDictionary *userInfo;

@property (nonatomic ,assign) BOOL addTextField;

@property (nonatomic, copy) NSArray *titles;

@property (nonatomic, copy) NSString *textViewPlaceholder;

- (IBAction)cancleButtonAction:(id)sender;

- (IBAction)doButtonAction:(id)sender;
@end



@protocol ZXAlertChoseControllerDelegate <NSObject>

@optional

/**
 确定回调
 
 @param controller self
 */

- (void)zx_alertChoseController:(AlertChoseController *)controller clickedButtonAtIndex:(NSInteger)buttonIndex content:(NSString *)content userInfo:(nullable NSDictionary *)userInfo;

@end

NS_ASSUME_NONNULL_END

/*
- (void)deleteCellAction:(id)sender
{
    if (!self.transitonModelDelegate)
    {
        self.transitonModelDelegate = [[ZXTransitionModalDelegate alloc] init];
    }
    self.transitonModelDelegate.contentSize = CGSizeMake(LCDScale_iphone6_Width(295), LCDScale_iphone6_Width(407));
    
    AlertChoseController *vc = [[AlertChoseController alloc] initWithNibName:@"AlertChoseController" bundle:nil];
    vc.addTextField = YES;
    vc.btnActionDelegate = self;
    vc.titles = @[@"这个商品我没有",@"起订量太低，做不了",@"采购信息不够详细",@"采购商不靠谱",@"这个是低价库存求购"];
    vc.textViewPlaceholder = @"请输入其它原因";
    vc.alertTitle = @"不再展示此条生意";
    NSIndexPath *indexPath = [self.tableView zh_getIndexPathFromTableViewOrCollectionViewWithConvertView:sender];
    WYTradeModel *model = [self.dataMArray objectAtIndex:indexPath.section];
    vc.userInfo = @{@"tradeId":model.postId};
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.transitioningDelegate = self.transitonModelDelegate;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)zx_alertChoseController:(AlertChoseController *)controller clickedButtonAtIndex:(NSInteger)buttonIndex content:(NSString *)content userInfo:(nullable NSDictionary *)userInfo
{
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:nil];
    [[[AppAPIHelper shareInstance]getTradeMainAPI]postTradeCloseSubjectWithTradeId:[userInfo objectForKey:@"tradeId"] reason:content success:^(id data) {
        
        [_tableView.mj_header beginRefreshing];
        [MBProgressHUD zx_showSuccess:@"您成功已关闭该条求购" toView:nil];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
        
    }];
}
*/
