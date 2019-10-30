//
//  ZXSegmentedPageController.h
//  Demo
//
//  Created by simon on 2017/9/6.
//  Copyright © 2017年 simon. All rights reserved.
//
//    NSAssert(self.dataSource.count > 0, @"Must have one childViewCpntroller at least");
//    NSAssert(self.segmentTitles.count == self.dataSource.count, @"The childViewController's count doesn't equal to the count of segmentTitles");

//  注释：包含顶部ZXSegmentedControl 分段选择视图，可以滑动；底部是根据SegmentTitles个数增加的n个子控制器，根据segment选择切换子控制器；
//  2018.3.27 待优化：当控制器往左右方向手动滑动的时候，可以考虑segmentedControl的底部指示条也动画跟着动；

#import <UIKit/UIKit.h>
#import "ZXSegmentedControl.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZXSegmentPageControllerDelegate;

@interface ZXSegmentedPageController : UIViewController


@property (nonatomic, weak) id<ZXSegmentPageControllerDelegate>delegate;

// 选项segment
@property (nonatomic, strong) ZXSegmentedControl *segmentView;

/**
 选项卡标题
 */
@property (nonatomic, strong) NSArray<NSString *> *segmentTitles;



/**
 包含的子控制器
 */
@property (nonatomic, strong) NSArray<UIViewController *> *viewControllers;


//当前页面索引
@property (nonatomic, assign)NSInteger currentIndex;


/**
 标题未选中的颜色
 */
@property (nonatomic, strong) UIColor *segmentTitleNormalColor;

/**
 标题选中的颜色
 */
@property (nonatomic, strong) UIColor *segmentTitleSelectedColor;

/**
 标题字体大小
 */
@property (nonatomic, assign) CGFloat segmentFontSize;

//选中的字体大小
@property (nonatomic, assign) CGFloat segmentSeletedFontSize;



//外观segmentView设置

// segmented的高度,默认40
@property (nonatomic, assign) CGFloat segmentHeight;

//是否隐藏底部分割线
@property (nonatomic, assign) BOOL hideSegmentBottomDivideLine;

// 最小item之间间距；default 20
@property (nonatomic, assign) CGFloat segmentMinimumItemSpacing;

//外边距:Default is UIEdgeInsetsMake(0, 8, 0, 8)
@property (nonatomic, assign) UIEdgeInsets segmentEdgeInset;

//选中样式
@property (nonatomic, assign) ZXSegmentedControlSelectionStyle segmentSelectionStyle;

//设置选中指示条颜色
@property (nonatomic, strong) UIColor *segmentSelectionIndicatorColor UI_APPEARANCE_SELECTOR;

// Default is 3.0
@property (nonatomic, readwrite) CGFloat segmentSelectionIndicatorHeight;


- (void)setSelectedPageIndex:(NSUInteger)index animated:(BOOL)animated;

@end



@protocol ZXSegmentPageControllerDelegate <NSObject>

@optional

// 设置文本显示外观；
- (void)zx_segmentPageControllerWithSegmentView:(ZXSegmentedControl *)segmentedControl willDisplayCell:(ZXSegmentCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;

// 选中回调；
- (void)zx_segmentPageControllerWithSegmentView:(ZXSegmentedControl *)segmentedControl didSelectedIndex:(NSInteger)index;

// 手势滑动切换的回调；
- (void)zx_segmentPageControllerWithTransitionToViewControllersIndex:(NSInteger)index transitionCompleted:(BOOL)completed;

@end

NS_ASSUME_NONNULL_END


//举例
/*
- (void)setData
{
    self.segTitles = @[@"全部",@"待确认",@"待支付",@"待发货",@"退款中",@"已发货",@"待评价",@"交易成功",@"交易关闭"];
    
    for (int i = 0; i < self.segTitles.count; i++) {
        
        SellerOrderAllController *vc = (SellerOrderAllController *)[self getControllerWithStoryboardName:sb_SellerOrder controllerWithIdentifier:SBID_SellerOrderAllController];
        vc.nTitle = [NSString stringWithFormat:@"标题%d",i];
        vc.orderListStatus = i;
        [self.dataMArray addObject:vc];
    }
    
    //    self.extendedLayoutIncludesOpaqueBars = YES;
    self.segPageController.segmentTitles = self.segTitles;
    self.segPageController.viewControllers = self.dataMArray;
    CGRect frame = self.view.frame;
    CGFloat Y = IS_IPHONE_XX?88:64;
    frame.origin.y += Y;
    frame.size.height -= Y;
    self.segPageController.view.frame = frame;
    
    
    self.segmentMenuView.itemTitles = self.segTitles;
    
    _orderCountsMArray = [NSMutableArray array];
    
    
    //先加载pageController的某个controller
    [_segPageController setSelectedPageIndex:self.orderListStatus animated:YES];
    SellerOrderAllController *vc = [self.dataMArray objectAtIndex:self.orderListStatus];
    vc.orderListStatus = self.orderListStatus;
    [vc.tableView.mj_header beginRefreshing];
    
    [self requestCleanOrderMark];
}

- (void)requestOrderCount
{
    [[[AppAPIHelper shareInstance]hsOrderManagementApi]getOrderStatusCountWithRoleType:[WYUserDefaultManager getUserTargetRoleType] success:^(id data) {
        
        [_orderCountsMArray removeAllObjects];
        [_orderCountsMArray addObjectsFromArray:data];
        
        NSMutableArray *mArray = [self getNSegmentTitlesWithOrderCountModel:data];
        self.segPageController.segmentTitles = mArray;
        [MBProgressHUD zx_hideHUDForView:self.view];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD zx_hideHUDForView:self.view];
    }];
}


- (ZXSegmentedPageController *)segPageController
{
    if (!_segPageController)
    {
        ZXSegmentedPageController *segVC = [[ZXSegmentedPageController alloc]init];
        segVC.segmentFontSize = 15.f;
        segVC.segmentHeight = 40.f;
        segVC.delegate = self;
        segVC.segmentMinimumItemSpacing = 26.f;
        [self addChildViewController:segVC];
        [self.view addSubview:segVC.view];
        _segPageController = segVC;
    }
    return _segPageController;
}


- (NSMutableArray *)dataMArray
{
    if (!_dataMArray)
    {
        NSMutableArray *mArray = [NSMutableArray array];
        _dataMArray = mArray;
    }
    return _dataMArray;
}

#pragma mark - ZXSegmentPageControllerDelegate


- (void)zx_segmentPageControllerWithSegmentView:(ZXSegmentedControl *)segmentedControl willDisplayCell:(ZXSegmentCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableAttributedString *mAtt1 = [[NSMutableAttributedString alloc] init];
    NSAttributedString *att1 = [[NSAttributedString alloc] initWithString:[self.segTitles objectAtIndex:indexPath.item] attributes:nil];
    [mAtt1 appendAttributedString:att1];
    NSAttributedString *att2 = nil;
    if (indexPath.item >0 && indexPath.item<(self.segTitles.count-2) &&_orderCountsMArray.count>indexPath.item)
    {
        GetOrderStautsCountModel *model = [_orderCountsMArray objectAtIndex:indexPath.item-1];
        NSString *st = [NSString stringWithFormat:@"(%@)",model.orderCount];
        att2= [[NSAttributedString alloc] initWithString:st attributes:nil];
        [mAtt1 appendAttributedString:att2];
    }
    UIColor *selcteColor = [UIColor colorWithRed:255.f/255 green:84.f/255 blue:52.f/255 alpha:1];
    UIColor *normalColor = [UIColor colorWithRed:83./255 green:83.f/255 blue:83.f/255 alpha:1];
    
    if (cell.isSelected)
    {
        [mAtt1 addAttributes:@{NSForegroundColorAttributeName:selcteColor} range:NSMakeRange(0, mAtt1.length)];
        [mAtt1 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(0, mAtt1.length)];
        cell.attributedTitle = mAtt1;
    }
    else
    {
        [mAtt1 addAttributes:@{NSForegroundColorAttributeName:normalColor} range:NSMakeRange(0, att1.length)];
        if (att2.length >0)
        {
            [mAtt1 addAttributes:@{NSForegroundColorAttributeName:selcteColor} range:[mAtt1.string rangeOfString:att2.string]];
        }
        [mAtt1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, mAtt1.length)];
        cell.attributedTitle = mAtt1;
    }
}

- (void)zx_segmentPageControllerWithSegmentView:(ZXSegmentedControl *)segmentedControl didSelectedIndex:(NSInteger)index
{
    [MobClick event:kUM_b_slideabove];
    
    SellerOrderAllController *vc = [self.dataMArray objectAtIndex:index];
    [vc.tableView.mj_header beginRefreshing];
}

//滑动切换的时候；每次请求会刷新； 传的viewControllers数组，controller的status状态属性无效；
- (void)zx_segmentPageControllerWithTransitionToViewControllersIndex:(NSInteger)index transitionCompleted:(BOOL)completed
{
    [MobClick event:kUM_b_slidedown];
    //    NSLog(@"index=%ld",index);
    if (completed)
    {
        //        NSLog(@"%ld",index);
        
        SellerOrderAllController *vc = [self.dataMArray objectAtIndex:index];
        //        vc.orderListStatus = index;
        [vc.tableView.mj_header beginRefreshing];
    }
}
*/
