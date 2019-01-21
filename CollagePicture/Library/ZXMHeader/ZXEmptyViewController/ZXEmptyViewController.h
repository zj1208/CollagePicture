//
//  ZXEmptyViewController.h
//  YiShangbao
//
//  Created by simon on 17/3/9.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
// 2018.1.03
// 新增一些方法，调节属性；

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#ifndef UIColorFromRGB_HexValue
#define UIColorFromRGB_HexValue(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbValue & 0xFF))/255.0f alpha:1.f]

#define UIColorFromRGBA_HexValue(rgbValue,A) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbValue & 0xFF))/255.0f alpha:A]
#endif

#ifndef LCDW
#define LCDW ([[UIScreen mainScreen] bounds].size.width)
#define LCDH ([[UIScreen mainScreen] bounds].size.height)
//设置iphone6尺寸比例/竖屏,UI所有设备等比例缩放
#define LCDScale_iPhone6_Width(X)    ((X)*LCDW/375)
#endif

@class ZXEmptyViewController;
@protocol ZXEmptyViewControllerDelegate <NSObject>

- (void)zxEmptyViewUpdateAction;

@optional
// 重写底部按钮区域视图
- (nullable UIView *)viewForFooterButtonInZxEmptyViewController:(ZXEmptyViewController *)emptyView;
@end



#define ZXEmptyRequestFaileImage  [UIImage imageNamed:@"reqeustFailure"]

static NSString * ZXEmptyRequestFaileTitle = @"数据加载失败~ ";

@interface ZXEmptyViewController : UIViewController

@property (nullable, nonatomic, weak) id<ZXEmptyViewControllerDelegate>delegate;

@property (nonatomic, strong) UILabel *label;

//整体内容偏移调节
@property (nonatomic, assign) CGSize contentOffest;

// 自定义按钮添加设置
@property (nonatomic, strong) UIButton *customButton;


//+ (instancetype)sharedInstance;


// 添加氛围图（数据空氛围图，请求失败氛围图）
- (void)addEmptyViewInController:(UIViewController *)viewController hasLocalData:(BOOL)flag error:(nullable NSError *)error emptyImage:(nullable UIImage *)emptyImage emptyTitle:(nullable NSString *)title updateBtnHide:(BOOL)hide;

// 移除氛围图,如果有本地数据就移除，如果没有本地数据就不移除；
- (void)hideEmptyViewInController:(UIViewController *)viewController  hasLocalData:(BOOL)flag;

// 直接移除氛围图
- (void)hideEmptyViewInController:(UIViewController *)viewController;
@end

NS_ASSUME_NONNULL_END


/////////////////--例如--////////////////////
//例1:列表
/*
- (void)setUI
{
    self.tableView.backgroundColor = WYUISTYLE.colorBGgrey;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerNib:[UINib nibWithNibName:Xib_OrderProductCell bundle:nil] forCellReuseIdentifier:reuse_Cell];
    [self.tableView registerNib:[UINib nibWithNibName:Xib_OrderCellFooterView bundle:nil] forHeaderFooterViewReuseIdentifier:reuse_FooterView];
    [self.tableView registerNib:[UINib nibWithNibName:Xib_OrderCellHeaderView bundle:nil] forHeaderFooterViewReuseIdentifier:reuse_HeaderView];
    
    ZXEmptyViewController *emptyVC =[[ZXEmptyViewController alloc] init];
    emptyVC.delegate = self;
    self.emptyViewController = emptyVC;
}

 //自己移除；
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_emptyViewController hideEmptyViewInController:self];
    [self.tableView.mj_header beginRefreshing];
}


- (void)headerRefresh
{
    WS(weakSelf);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [[[AppAPIHelper shareInstance]hsOrderManagementApi]getOrderListWithRoleType:[WYUserDefaultManager getUserTargetRoleType] orderStatus:0 search:self.searchBar.text pageNo:1 pageSize:@(10) success:^(id data,PageModel *pageModel) {
            
            [weakSelf.dataMArray removeAllObjects];
            [weakSelf.dataMArray addObjectsFromArray:data];
            [_emptyViewController addEmptyViewInController:weakSelf hasLocalData:_dataMArray.count error:nil emptyImage:[UIImage imageNamed:@"无人接单"] emptyTitle:@"没有搜到相关订单信息" updateBtnHide:YES];
            [weakSelf.tableView reloadData];
            _pageNo = 1;
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf footerWithRefreshing:[pageModel.totalCount integerValue]];
            
        } failure:^(NSError *error) {
            
            [weakSelf.tableView.mj_header endRefreshing];
            
            [_emptyViewController addEmptyViewInController:weakSelf hasLocalData:_dataMArray.count error:error emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];
            
        }];
    }];
}

- (void)footerWithRefreshing:(NSInteger)totalCount
{
    if (self.dataMArray.count<=totalCount)
    {
        if (self.tableView.mj_footer)
        {
            self.tableView.mj_footer = nil;
        }
        return;
    }
    WS(weakSelf);
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        
        [[[AppAPIHelper shareInstance]hsOrderManagementApi]getOrderListWithRoleType:[WYUserDefaultManager getUserTargetRoleType] orderStatus:0 search:self.searchBar.text pageNo:_pageNo+1 pageSize:@(10) success:^(id data,PageModel *pageModel) {
            
            [weakSelf.dataMArray addObjectsFromArray:data];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_footer endRefreshing];
            _pageNo ++;
            if (weakSelf.dataMArray.count==totalCount)
            {
                weakSelf.tableView.mj_footer = nil;
            }
        } failure:^(NSError *error) {
            
            [weakSelf.tableView.mj_footer endRefreshing];
            [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
        }];
    }];
}


- (void)zxEmptyViewUpdateAction
{
    [self.tableView.mj_header beginRefreshing];
}

*/


//例2:model模型数据
/*
- (void)requestData
{
    [ProductMdoleAPI getMyShopMainInfoWithShopId:[UserInfoUDManager getShopId] Success:^(id data) {
        
        _shopInfoModel = nil;
        _shopInfoModel = [[ShopMainInfoModel alloc] init];
        _shopInfoModel = data;
        [_emptyViewController hideEmptyViewInController:weakSelf hasLocalData:_shopInfoModel?YES:NO];
        if (_shopInfoModel)
        {
            _stausBarStyle = UIStatusBarStyleLightContent;
            [self setNeedsStatusBarAppearanceUpdate];
        }
        [_collectionView reloadData];
        
        
    } failure:^(NSError *error) {
        
        [_emptyViewController addEmptyViewInController:weakSelf hasLocalData:_shopInfoModel?YES:NO error:error emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];
    }];
}
*/
