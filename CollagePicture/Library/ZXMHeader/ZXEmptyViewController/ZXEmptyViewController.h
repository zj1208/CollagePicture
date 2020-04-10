//
//  ZXEmptyViewController.h
//  YiShangbao
//
//  Created by simon on 17/3/9.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
// 简介：空数据或请求失败的提示页面，支持[氛围图+title+updateBtn+重请事件];也支持[氛围图+title+解决方案按钮+全屏点击重请事件],重请事件会直接检查网络，无网络会直接提示;点击解决方案按钮会跳转到解决方案提示页面；点击屏幕不会连续触发事件；

//  藕和 MBProgressHUD，Masnary,AFNetworkReachabilityManager第三方；
// 没法兼容全部视图区域，是直接加入到控制器的view上，导致tabViewController，或者隐藏导航条等地方，不能正常显示，只能自己调节设置frame，或者调节contentOffest内容偏移；

// 2018.1.03 新增一些方法，调节属性；
// 2019.6.03 修改注释
// 2019.12.06 优化代码，增加解决方案按钮及事件，点击屏幕事件，增加无网络直接判断；
// 2020.02.06 优化代码，网络跳转修改；
// 2020.04.08 优化代码;

#import <UIKit/UIKit.h>
#import "MBProgressHUD+ZXCategory.h"

NS_ASSUME_NONNULL_BEGIN

#ifndef UIColorFromRGB_HexValue
#define UIColorFromRGB_HexValue(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbValue & 0xFF))/255.0f alpha:1.f]

#define UIColorFromRGBA_HexValue(rgbValue,A) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbValue & 0xFF))/255.0f alpha:A]
#endif

#ifndef LCDW
#define LCDW ([[UIScreen mainScreen] bounds].size.width)
#define LCDH ([[UIScreen mainScreen] bounds].size.height)
//设置iphone6尺寸比例/竖屏,UI所有设备等比例缩放
#define LCDScale_iPhone6(X)    ((X)*LCDW/375)
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
// title:@"您还没有上传产品噢～\n快去“商铺-产品管理”里面上传您的产品吧！":@"该分类下还没有产品，快添加些产品吧~"; image :   @"我的接单生意为空"
// title:@"您还没有接过生意，赶紧去接单吧～"     image :   @"我的接单生意为空"
// title:@"暂时没有与您相关的信息，\n完善商铺经营信息可获得更多相关生意～"     image :   @"我的接单生意为空"


#define ZXEmptyRequestFaileImage  [UIImage imageNamed:@"chs_reqeustFailure"]
//static NSString * const ZXEmptyRequestFaileTitle = @"数据加载失败~ ";
static NSString * const ZXEmptyRequestFaileTitle = @"";

/*
ZXEmptyViewController的view加入到一个隐藏系统navigationBar的控制器view上时，会覆盖整个控制器view；
调节方式如下：
self.emptyViewController.view.frame = CGRectMake(0, HEIGHT_NAVBAR, LCDW, LCDH-HEIGHT_NAVBAR);
 */

//是否点击屏幕回调代理方法执行刷新数据
typedef NS_ENUM(NSInteger, ZXEmptyViewTouchEventType)
{
    /// 默认不支持点击空白区域点击回调
    ZXEmptyViewTouchEventTypeNoUpdate = 0,
    ZXEmptyViewTouchEventTypeUpdate = 1,
};

///按钮点击事件类型
typedef NS_ENUM(NSInteger, ZXEmptyViewButtonActionType)
{
    ///重新加载
    ZXEmptyViewButtonActionType_ReRequest = 0,
    ///解决方案
    ZXEmptyViewButtonActionType_ErrorSolution = 1,
    ///自定义
    ZXEmptyViewButtonActionType_Custom = 2,
};

@interface ZXEmptyViewController : UIViewController

@property (nullable, nonatomic, weak) id<ZXEmptyViewControllerDelegate>delegate;

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UIButton *centerButton;
@property (nonatomic, assign) ZXEmptyViewButtonActionType buttonActionType;


/// 整体内容偏移调节(textLabel,imageView,updateBtn一起调节)
@property (nonatomic, assign) CGSize contentOffest;

/// 是否在textLabel展示error的code码
@property (nonatomic, assign) BOOL showErrorCodeOnLabelText;

/// 是否在toast上展示error的code码
@property (nonatomic, assign) BOOL showErrorCodeOnToastText;

/// 是否在加载完成显示self的同时显示错误toast;
@property (nonatomic, assign) BOOL showEmptyViewWithErrorToast;

/// 在空数据氛围图的时候（不是error错误视图），是否隐藏按钮；默认隐藏
@property (nonatomic, assign) BOOL emptyViewCenterButtonHide;

/// 是否点击错误视图事件回调；默认YES；
@property (nonatomic, assign) BOOL touchErrorViewIsAction;

//-------------------------- Button 相关 --------------------------//
/**
 按钮字体, 大小default is 14.f
 */
@property (nonatomic, strong) UIFont  *actionBtnFont;
/**
 按钮的高度, default is 30.f
 */
@property (nonatomic, assign) CGFloat  actionBtnHeight;

/**
 按钮的宽度, default is 120.f
 */
@property (nonatomic, assign) CGFloat  actionBtnWidth;


/// 按钮宽带是否自动适配
@property (nonatomic, assign) BOOL  actionBtnWidthAutomic;

/**
 按钮的圆角大小, default is 0
 */
@property (nonatomic, assign) CGFloat  actionBtnCornerRadius;
/**
 按钮边框border的宽度, default is 0
 */
@property (nonatomic, assign) CGFloat  actionBtnBorderWidth;
/**
 按钮边框颜色
 */
@property (nonatomic, strong) UIColor  *actionBtnBorderColor;
/**
 按钮文字颜色
 */
@property (nonatomic, strong) UIColor  *actionBtnTitleColor;
/**
 按钮背景颜色
 */
@property (nonatomic, strong) UIColor  *actionBtnBackGroundColor;

/**
 按钮 与 (标题或图片) 之间的间距, default is 30.
 */
@property (nonatomic, assign) CGFloat  actionBtnMargin;



///  添加及移除氛围图（数据空氛围图，请求失败氛围图）：
/// @param viewController <#viewController description#>
/// @param flag <#flag description#>
/// @param error <#error description#>
/// @param emptyImage <#emptyImage description#>
/// @param title <#title description#>
/// @param hide <#hide description#>
- (void)zx_addEmptyViewWithUpdateBtnInController:(UIViewController *)viewController hasLocalData:(BOOL)flag error:(nullable NSError *)error emptyImage:(nullable UIImage *)emptyImage emptyTitle:(nullable NSString *)title centerButtonHide:(BOOL)hide;

/// 添加及移除氛围图（数据空氛围图，请求失败氛围图）：“查看解决方案”按钮(2019-12-06)
/// @param viewController <#viewController description#>
/// @param flag <#flag description#>
/// @param error <#error description#>
/// @param emptyImage <#emptyImage description#>
/// @param title <#title description#>
- (void)zx_addEmptyViewInController:(UIViewController *)viewController hasLocalData:(BOOL)flag error:(nullable NSError *)error emptyImage:(nullable UIImage *)emptyImage emptyTitle:(nullable NSString *)title;


/// 直接移除氛围图
- (void)zx_hideEmptyViewInContainerViewConroller;

+ (void)zx_makeToastInViewController:(UIViewController *)viewController withError:(NSError *)error;
@end

NS_ASSUME_NONNULL_END


/////////////////--例如--////////////////////
//例1:列表
/*
#import "ZXEmptyViewController.h"
@interface SearchResultsController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,CAAnimationDelegate,ZXEmptyViewControllerDelegate>
 
@property (nonatomic, strong) ZXEmptyViewController *emptyViewController;
@end
 
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
        
        _emptyViewController = [[ZXEmptyViewController alloc] init];
        _emptyViewController.delegate = self;
    }
    return _emptyViewController;
}
 //自己移除；
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.emptyViewController zx_hideEmptyViewInContainerViewConroller];
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
        [weakSelf.emptyViewController zx_addEmptyViewInController:weakSelf hasLocalData:weakSelf.dataMArray.count>0?YES:NO error:nil emptyImage:[UIImage imageNamed:@"无人接单"] emptyTitle:@"没有搜到相关订单信息"];
        [weakSelf.tableView reloadData];
        weakSelf.pageNo = 1;
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf footerWithRefreshingMorePage:[pageModel.totalPage integerValue]>1?YES:NO];
        
    } failure:^(NSError *error) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        
        [weakSelf.emptyViewController zx_addEmptyViewInController:weakSelf hasLocalData:weakSelf.dataMArray.count>0?YES:NO error:error emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle];
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
- (void)setData
{
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:self.view];
    WS(weakSelf);
    [[UserModelHttpAPI shareInstance]postInfoWithSuccess:^(id  _Nullable data) {
        
        [MBProgressHUD zx_hideHUDForView:weakSelf.view];
        weakSelf.userModel = nil;
        weakSelf.userModel = [[CHSUserModel alloc] init];
        weakSelf.userModel = data;
        [weakSelf.emptyViewController zx_hideEmptyViewInContainerViewConroller];
        [weakSelf releadData];
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD zx_hideHUDForView:weakSelf.view];
        [weakSelf.emptyViewController zx_addEmptyViewInController:weakSelf hasLocalData:weakSelf.userModel?YES:NO error:error emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle];

    }];
}
*/
