//
//  ZXSegmentMenuView.h
//
//
//  Created by simon on 2017/9/7.
//  Copyright © 2017年 simon. All rights reserved.
//
//  注释：弹出下拉视图；顶部一个“选择订单状态”Label + “箭头”按钮button，下面是展开的collectionView，其中有n个cell；

//  2018.3.27   增加注释；

#import <UIKit/UIKit.h>
#import "ZXLabelsTagsView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZXSegmentMenuViewDelegate;

@interface ZXSegmentMenuView : UIView

@property (nonatomic, weak) id<ZXSegmentMenuViewDelegate>delegate;

// segmented的高度,默认40
@property (nonatomic, assign) CGFloat menuHeaderViewHeight;

@property (nonatomic, copy) NSArray *itemTitles;

/**
 选中的索引
 */
@property (nonatomic, assign) NSInteger selectedIndex;

- (void)showInView:(UIView *)view;
@end




@protocol ZXSegmentMenuViewDelegate <NSObject>

- (void)zx_segmentMenuView:(ZXSegmentMenuView *)menuView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;


@optional
/**
 将要展示数据的时候，自定义设置cell的显示；不影响布局的外观设置
 
 @param cell LabelCell
 @param indexPath collectionView中的对应indexPath
 */
- (void)zx_segmentMenuView:(ZXSegmentMenuView *)menuView labelTagsView:(ZXLabelsTagsView *)tagsView willDisplayCell:(LabelCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END

//例如：
/*
@property (nonatomic, strong) ZXSegmentMenuView *segmentMenuView;

- (void)setData
{
    self.segTitles = @[@"全部",@"待确认",@"待支付",@"待发货",@"退款中",@"已发货",@"待评价",@"交易成功",@"交易关闭"];
    self.segmentMenuView.itemTitles = self.segTitles;
}

- (ZXSegmentMenuView *)segmentMenuView
{
    if (!_segmentMenuView)
    {
        ZXSegmentMenuView *menuView = [[ZXSegmentMenuView alloc] init];
        menuView.delegate = self;
        menuView.frame =  self.view.frame;
        menuView.selectedIndex = 0;
        _segmentMenuView = menuView;
    }
    return _segmentMenuView;
    
}

- (UIButton *)choseBtn
{
    if (!_choseBtn)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setImage:[UIImage imageNamed:@"ic_zhankai"] forState:UIControlStateNormal];
        btn.adjustsImageWhenHighlighted = NO;
        [btn addTarget:self action:@selector(popMenuView:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.segPageController.view addSubview:btn];
        _choseBtn = btn;
    }
    return _choseBtn;
}

- (void)popMenuView:(UIButton *)sender
{
    [MobClick event:kUM_b_listopen];
    
    self.segmentMenuView.selectedIndex = self.segPageController.currentIndex;
    [self.segmentMenuView showInView:self.segPageController.view];
}

 
#pragma mark - ZXSegmentMenuViewDelegate

- (void)zx_segmentMenuView:(ZXSegmentMenuView *)menuView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.segPageController setSelectedPageIndex:indexPath.item animated:YES];
    SellerOrderAllController *vc = [self.dataMArray objectAtIndex:indexPath.item];
    //    vc.orderListStatus = indexPath.item;
    [vc.tableView.mj_header beginRefreshing];
}
*/
