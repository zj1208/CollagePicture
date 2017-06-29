//
//  ZXEmptyViewController.h
//  YiShangbao
//
//  Created by simon on 17/3/9.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZXEmptyViewControllerDelegate <NSObject>

- (void)zxEmptyViewUpdateAction;

@end

#define ZXEmptyRequestFaileImage  [UIImage imageNamed:@"加载失败"]

static NSString * ZXEmptyRequestFaileTitle = @"数据加载失败~ ";

@interface ZXEmptyViewController : UIViewController

@property (nullable, nonatomic, weak) id<ZXEmptyViewControllerDelegate>delegate;

+ (instancetype)getInstance;


// 添加氛围图（数据空氛围图，请求失败氛围图）
- (void)addEmptyViewInController:(UIViewController *)viewController hasLocalData:(BOOL)flag error:(nullable NSError *)error emptyImage:(nullable UIImage *)emptyImage emptyTitle:(nullable NSString *)title updateBtnHide:(BOOL)hide;
// 隐藏氛围图
- (void)hideEmptyViewInController:(UIViewController *)viewController  hasLocalData:(BOOL)flag;
@end

NS_ASSUME_NONNULL_END


/*
[ProductMdoleAPI getMyShopMainInfoWithShopId:[UserInfoUDManager getShopId] Success:^(id data) {
    
    _shopInfoModel = nil;
    ShopMainInfoModel *model = [[ShopMainInfoModel alloc] init];
    self.shopInfoModel = model;
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
*/
