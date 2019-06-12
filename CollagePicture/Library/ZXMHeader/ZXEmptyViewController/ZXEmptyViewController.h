//
//  ZXEmptyViewController.h
//  YiShangbao
//
//  Created by simon on 17/3/9.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
// 2018.1.03 新增一些方法，调节属性；
// 2019.6.03 修改注释


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

// title:@"数据加载失败~ " image:@"reqeustFailure"
// title:@"暂无新消息～"   image :@"空消息"
// title:@"您还没有相关订单"   image :@"empty_konShuJu"
// title:@"没有找到相关产品~"  image :   @"searchproductempty"
// title:@""                image :   @"searchshopempty"
// title:@"暂无数据"          image :   @"我的接单生意为空"
// title:@"数据空空如也～"     image :   @"我的接单生意为空"
// title:@"没有搜索到相关产品,\n检查下您的关键词是否正确哦～"          image :   @"无人接单"
// title:@"您还没有上传产品噢～\n快去“商铺-产品管理”里面上传您的产品吧！":@"该分类下还没有产品，快添加些产品吧~";
// image :   @"我的接单生意为空"
// title:@"暂无数据"     image :   @"空经侦"
// title:@"加载失败，请重新预览"     image :   @"reqeustFailure"
// title:@"\n暂无相关单据信息~"     image :   @"reqeustFailure"
// title:@"您还没有接过生意，赶紧去接单吧～"     image :   @"我的接单生意为空"
// title:@"暂时没有与您相关的信息，\n完善商铺经营信息可获得更多相关生意～"     image :   @"我的接单生意为空"
// title:@"暂无相关客户信息"     image :   @"开单氛围图"
// title:@"您还没有客户，快去添加客户吧~"     image :   @"开单氛围图"


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
#import "ZXEmptyViewController.h"
<ZXEmptyViewControllerDelegate>
@property (nonatomic, strong) ZXEmptyViewController *emptyViewController;

 
- (void)setUI
{
    self.tableView.backgroundColor = WYUISTYLE.colorBGgrey;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerNib:[UINib nibWithNibName:Xib_OrderProductCell bundle:nil] forCellReuseIdentifier:reuse_Cell];
    [self.tableView registerNib:[UINib nibWithNibName:Xib_OrderCellFooterView bundle:nil] forHeaderFooterViewReuseIdentifier:reuse_FooterView];
    [self.tableView registerNib:[UINib nibWithNibName:Xib_OrderCellHeaderView bundle:nil] forHeaderFooterViewReuseIdentifier:reuse_HeaderView];
}
 
- (ZXEmptyViewController *)emptyViewController
{
    if (!_emptyViewController) {
        
        ZXEmptyViewController *emptyVC = [[ZXEmptyViewController alloc] init];
        emptyVC.delegate = self;
        _emptyViewController = emptyVC
        }
        return _emptyViewController;
    }
 //自己移除；
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.emptyViewController hideEmptyViewInController:self];
    [self.tableView.mj_header beginRefreshing];
}
- (void)headerRefresh
{
    WS(weakSelf);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf requestHeaderData];
    }];
}
- (void)requestHeaderData
{
    WS(weakSelf);
    [[[AppAPIHelper shareInstance]hsOrderManagementApi]getOrderListWithRoleType:[WYUserDefaultManager getUserTargetRoleType] orderStatus:0 search:self.searchBar.text pageNo:1 pageSize:@(10) success:^(id data,PageModel *pageModel) {
        
        [weakSelf.dataMArray removeAllObjects];
        [weakSelf.dataMArray addObjectsFromArray:data];
        [weakSelf emptyViewController addEmptyViewInController:weakSelf hasLocalData:weakSelf.dataMArray.count>0?YES:NO error:nil emptyImage:[UIImage imageNamed:@"无人接单"] emptyTitle:@"没有搜到相关订单信息" updateBtnHide:YES];
        [weakSelf.tableView reloadData];
        weakSelf.pageNo = 1;
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf footerWithRefreshingMorePage:[pageModel.totalPage integerValue]>1?YES:NO];
        
    } failure:^(NSError *error) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        
        [weakSelf.emptyViewController addEmptyViewInController:weakSelf hasLocalData:weakSelf.dataMArray.count>0?YES:NO error:error emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];
    }];
}
    
    

- (void)footerWithRefreshingMorePage:(BOOL)flag
{
    if (!flag)
    {
        if (self.tableView.mj_footer)
        {
            self.tableView.mj_footer = nil;
        }
        return;
    }
    WS(weakSelf);
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf requestFooterData];
    }];
}
    
- (void)requestFooterData
{
    WS(weakSelf);
    [[[AppAPIHelper shareInstance]hsOrderManagementApi]getOrderListWithRoleType:[WYUserDefaultManager getUserTargetRoleType] orderStatus:0 search:self.searchBar.text pageNo:_pageNo+1 pageSize:@(10) success:^(id data,PageModel *pageModel) {
        
        [weakSelf.dataMArray addObjectsFromArray:data];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
        weakSelf.pageNo ++;
        if (weakSelf.dataMArray.count==totalCount)
        {
            weakSelf.tableView.mj_footer = nil;
        }
    } failure:^(NSError *error) {
        
        [weakSelf.tableView.mj_footer endRefreshing];
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
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
