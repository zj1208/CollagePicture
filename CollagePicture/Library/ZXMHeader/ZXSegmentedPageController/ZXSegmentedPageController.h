//
//  ZXSegmentedPageController.h
//  Demo
//
//  Created by simon on 2017/9/6.
//  Copyright © 2017年 simon. All rights reserved.
//
//    NSAssert(self.dataSource.count > 0, @"Must have one childViewCpntroller at least");
//    NSAssert(self.segmentTitles.count == self.dataSource.count, @"The childViewController's count doesn't equal to the count of segmentTitles");

#import <UIKit/UIKit.h>
#import "ZXSegmentedControl.h"

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


