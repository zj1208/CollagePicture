//
//  ZXTwoLevelMenuListView.h
//  MobileCaiLocal
//
//  Created by simon on 2019/11/27.
//  Copyright © 2019 timtian. All rights reserved.
//
//  简介 ：二级列表，左边是个tableView一级列表，右边是个collectionView二级列表；tableView的cell选中后，调用展示对应的数据数组在二级列表中展示；支持默认选中一级列表第一item，记录上次选中的有效一级列表item和二级列表item；

#import <UIKit/UIKit.h>
#import "ZXOverlay.h"
#import "ZXLeftFirstLevelMenuListView.h"
#import "ZXRightSecondLeveMenuListView.h"

NS_ASSUME_NONNULL_BEGIN

@class ZXTwoLevelMenuListView;
@protocol ZXTwoLevelMenuListViewDataSource <NSObject>

@required

/// 回调返回左边第一级列表item的title;
/// @param menuListView <#menuListView description#>
/// @param indexPath <#indexPath description#>
- (nullable NSString *)zx_twoLevelMenuListView:(ZXTwoLevelMenuListView *)menuListView titleForLeftFirstLevelRowAtIndexPath:(nonnull NSIndexPath *)indexPath;

- (NSInteger)zx_twoLevelMenuListView:(ZXTwoLevelMenuListView *)menuListView numberOfRowsInLeftFirstLevelSection:(NSInteger)section;


/// 回调返回右边第二级列表item的title;
/// @param menuListView <#menuListView description#>
/// @param indexPath <#indexPath description#>
- (nullable NSString *)zx_twoLevelMenuListView:(ZXTwoLevelMenuListView *)menuListView titleForRightSecondLevelRowAtIndexPath:(nonnull NSIndexPath *)indexPath;

- (NSInteger)zx_twoLevelMenuListView:(ZXTwoLevelMenuListView *)menuListView numberOfRowsInRightSecondLevelSection:(NSInteger)section;

@end

@protocol ZXTwoLevelMenuListViewDelegate <NSObject>

@optional

///**
// *  选中左边第一级列表item的回调；
// */
//- (void)zx_twoLevelMenuListView:(ZXTwoLevelMenuListView *)menuListView didSelectLeftFirstLevelItemAtIndexPath:(NSIndexPath *)indexPath;


/// 选中右边第二级列表item的回调；
- (void)zx_twoLevelMenuListView:(ZXTwoLevelMenuListView *)menuListView didSelectRightSecondLevelItemAtIndexPath:( NSIndexPath *)indexPath;

/// 关闭弹框
- (void)zx_dismissViewWithTwoLevelMenuListView:(ZXTwoLevelMenuListView *)menuListView;
@end

@interface ZXTwoLevelMenuListView : UIView<ZXOverlayDelegate>

@property (nonatomic, strong) ZXLeftFirstLevelMenuListView *leftFirstLevelMenuView;
@property (nonatomic, strong) ZXRightSecondLeveMenuListView *rightSecondLevelMenuView;


@property (nonatomic, weak) id<ZXTwoLevelMenuListViewDataSource>dataSource;
@property (nonatomic, weak) id<ZXTwoLevelMenuListViewDelegate>delegate;


/// 设置一级列表的frame的width；一级列表width+二级列表width = self.bound.width；
@property (nonatomic) CGFloat leftFirstLevelMenuViewWidth;



- (void)reloadData;

- (NSIndexPath *)indexPathForFirstLevelTableViewSelectedRow;


- (void)showInView:(UIView *)view;
- (void)dismissViewWithCompletion:(void (^ __nullable)(BOOL finished))completion;
@end

NS_ASSUME_NONNULL_END

//例如
/*
#pragma mark - titleBtnAction

- (void)titleBtnAction:(UIButton *)sender
{
    if (self.twoLevelDicMArray.count==0) {
        return;
    }
    sender.selected = !sender.selected;
    if (sender.selected) {

        [self.navigationItemTitleBtn setImage:[UIImage imageNamed:@"icon_arrowUp"] forState:UIControlStateNormal];
        [self.twoLevelMenuListView showInView:self.view];
    }else
    {
        [self.navigationItemTitleBtn setImage:[UIImage imageNamed:@"icon_arrowDown"] forState:UIControlStateNormal];
        [self.twoLevelMenuListView dismissViewWithCompletion:nil];
    }
}

#pragma mark -Delegate


- (NSString *)zx_twoLevelMenuListView:(ZXTwoLevelMenuListView *)menuListView titleForLeftFirstLevelRowAtIndexPath:(NSIndexPath *)indexPath
{
    RedpaperCategoryModel *model  = [self.twoLevelDicMArray objectAtIndex:indexPath.row];
    return model.bigTypeName;
}

- (NSInteger)zx_twoLevelMenuListView:(ZXTwoLevelMenuListView *)menuListView numberOfRowsInLeftFirstLevelSection:(NSInteger)section
{
    return self.twoLevelDicMArray.count;
}

- (NSString *)zx_twoLevelMenuListView:(ZXTwoLevelMenuListView *)menuListView titleForRightSecondLevelRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *groupIndexPath = [menuListView indexPathForFirstLevelTableViewSelectedRow];
    RedpaperCategoryModel *model  = [self.twoLevelDicMArray objectAtIndex:groupIndexPath.row];
    RedpaperCategoryModelSecondLevel *model2 = [model.redPaperMiddleTypeList objectAtIndex:indexPath.item];
    return model2.middleTypeName;
    
}

- (NSInteger)zx_twoLevelMenuListView:(ZXTwoLevelMenuListView *)menuListView numberOfRowsInRightSecondLevelSection:(NSInteger)section
{
    NSIndexPath *groupIndexPath = [menuListView indexPathForFirstLevelTableViewSelectedRow];
    RedpaperCategoryModel *model  = [self.twoLevelDicMArray objectAtIndex:groupIndexPath.row];
    return model.redPaperMiddleTypeList.count;
}


- (void)zx_twoLevelMenuListView:(ZXTwoLevelMenuListView *)menuListView didSelectRightSecondLevelItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.twoLevelMenuListView dismissViewWithCompletion:nil];

    NSIndexPath *groupIndexPath = [menuListView indexPathForFirstLevelTableViewSelectedRow];
    RedpaperCategoryModel *model  = [self.twoLevelDicMArray objectAtIndex:groupIndexPath.row];
    RedpaperCategoryModelSecondLevel *model2 = [model.redPaperMiddleTypeList objectAtIndex:indexPath.item];
    [self.navigationItemTitleBtn setTitle:model2.middleTypeName forState:UIControlStateNormal];
    self.navigationItemTitleBtn.selected = !self.navigationItemTitleBtn.selected;
    self.isCategoryToRequestGoods = YES;
    self.bigTypeCode = model.bigTypeCode;
    self.middleTypeCode = model2.middleTypeCode;
    [self requestHeaderDataWithCategory];
}
- (void)zx_dismissViewWithTwoLevelMenuListView:(ZXTwoLevelMenuListView *)menuListView
{
    self.navigationItemTitleBtn.selected = !self.navigationItemTitleBtn.selected;
}
*/
