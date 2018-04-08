//
//  ZXSegmentedControl.h
//  Demo
//
//  Created by simon on 2017/9/5.
//  Copyright © 2017年 simon. All rights reserved.
//
//  注释：用UICollectionView自定义一个ZXSegmentControl；底部加选中的红色指示条；
//  2018.3.6,新增选择条样式；新增segment宽度样式；

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN
// 文本延伸宽度
static CGFloat const ZXSegmentedTitleExtendWidth = 10.f;

// 选择条样式
typedef NS_ENUM(NSInteger, ZXSegmentedControlSelectionStyle) {
    
    //  整个cell宽度；
    ZXSegmentedControlSelectionStyleFullWidthStripe =0,
    
    //  选择条是文字对应宽度；
    ZXSegmentedControlSelectionStyleTextWidthStripe =1,
    
    //  title宽度+ZXSegmentedTitleExtendWidth
    ZXSegmentedControlSelectionStyleExtendTextWidthStripe = 2,
//  整个segment覆盖一个层；
//  ZXSegmentedControlSelectionStyleBox,
};

// 设置宽度样式；
typedef NS_ENUM(NSInteger, ZXSegmentedControlSegmentWidthStyle)
{
    //   固定宽带，根据view的宽带得出每个segment的平均宽度；
    ZXSegmentedControlSegmentWidthStyleFixed = 0,   // Segment width is fixed
    ZXSegmentedControlSegmentWidthStyleDynamic = 1, // Segment width will only be as big as the text width (including inset)
};

@protocol ZXSegmentedControlDelegate,ZXSegmentedControlDataSource;
@class ZXSegmentCell;
@interface ZXSegmentedControl : UIView


@property (nonatomic, weak) id<ZXSegmentedControlDelegate>delegate;
@property (nonatomic, weak) id<ZXSegmentedControlDataSource>dataSource;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *sectionTitles;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CGFloat selectedFontSize;

//@property (nonatomic, strong) NSArray *sectionAttributedTitles;

@property (nonatomic, assign) NSInteger selectedIndex;



// 外观collectionView设置

// 是否隐藏底部分割线
@property (nonatomic, assign) BOOL hideBottomDivideLine;

// 最小item之间间距；default 10
@property (nonatomic, assign) CGFloat minimumItemSpacing;

// 外边距:Default is UIEdgeInsetsMake(0, 8, 0, 8)
@property (nonatomic, assign) UIEdgeInsets segmentEdgeInset;

// 选中样式
@property (nonatomic, assign) ZXSegmentedControlSelectionStyle selectionStyle;

// 宽度样式
@property (nonatomic, assign) ZXSegmentedControlSegmentWidthStyle widthStyle;


// 设置选中指示条颜色
@property (nonatomic, strong) UIColor *selectionIndicatorColor UI_APPEARANCE_SELECTOR;

// Default is 3.0
@property (nonatomic, readwrite) CGFloat selectionIndicatorHeight;


+ (instancetype)segmentViewWithSectionTitles:(NSArray<NSString *> *)titles;


- (void)setSelectedIndex:(NSInteger)selectedIndex animation:(BOOL)animation ;

- (void)reloadData;

@end


@protocol ZXSegmentedControlDelegate <NSObject>

// 设置文本显示外观；
- (void)zx_segmentView:(ZXSegmentedControl *)ZXSegmentedControl willDisplayCell:(ZXSegmentCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;

// 选中回调；
- (void)zx_segmentView:(ZXSegmentedControl *)ZXSegmentedControl didSelectedIndex:(NSInteger)index;

@end



@protocol ZXSegmentedControlDataSource <NSObject>

@required

//- (NSAttributedString *)ZXSegmentedControl:(ZXSegmentedControl *)ZXSegmentedControl attributedTitleForSelectItemAtIndexPath:(NSIndexPath *)indexPath;
//
//- (NSAttributedString *)ZXSegmentedControl:(ZXSegmentedControl *)ZXSegmentedControl attributedTitleForUnSelectItemAtIndexPath:(NSInteger)index;

@end

//一定要写在viewWillLayoutSubviews设置frame
/*
 - (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
 
  UIViewController *vc = [self.dataSource objectAtIndex:self.selectedIndex];
  [self.pageViewController setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
  self.segmentView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.segmentHeight);
 
 }
 */




#pragma LDSegmentCell

@interface ZXSegmentCell : UICollectionViewCell

@property (nonatomic ,copy) NSString *title;
@property (nonatomic, copy) NSAttributedString *attributedTitle;

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, assign) CGFloat normalFontSize;
@property (nonatomic, assign) CGFloat selectedFontSize;

@end



@interface ZXSegmentModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSAttributedString *attributedTitle;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) CGFloat fontSize;

@property (nonatomic, assign) CGFloat selectedFontSize;

@end


NS_ASSUME_NONNULL_END
