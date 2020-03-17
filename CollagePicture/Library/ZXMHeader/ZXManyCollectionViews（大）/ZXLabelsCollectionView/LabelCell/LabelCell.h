//
//  LabelCell.h
//  YiShangbao
//
//  Created by simon on 17/2/19.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  2018.2.11，修改cell高度；增加字体大小适配；
//  2019.10.26 标签宽度小数点进1，限制标签最大宽度不超过collectionView的宽度-inset的最终宽度；[UIView sizeThatFits:]方法中size参数只是一个期望大小，在实际计算中可以忽略，返回的依然是实际计算的大小；

#import <UIKit/UIKit.h>
#import "ZXLabelsTitleColorModel.h"

#ifndef SCREEN_WIDTH
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#endif

#ifndef SCREEN_MAX_LENGTH
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#endif

//设置iphone6尺寸比例/竖屏,UI所有设备等比例缩放
#ifndef LCDScale_iPhone6
#define LCDScale_iPhone6(X)    ((X)*SCREEN_MIN_LENGTH/375)
#endif

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,ZXLabelsViewBorderStyle) {
    
    // 半圆边框,width默认会增加一个高度的大小；
    ZXLabelsViewBorderStyle_Semicircle = 0,
    // 矩形小圆角边框
    ZXLabelsViewBorderStyle_Rectangle = 1,

};

@interface LabelCell : UICollectionViewCell

@property (nonatomic, copy) NSString *title;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (nonatomic, assign) CGFloat height;

/// 设置标签的背景颜色;
@property (nonatomic, strong) UIColor *labelBackgroudColor;

/// 标签cell边框样式
@property (nonatomic, assign) ZXLabelsViewBorderStyle labelsViewBorderStyle;
/// 在apportionsItemWidthsByContent=YES，自适应宽度的时候，调节内容contentInset；
@property (nonatomic, assign) UIEdgeInsets itemContentInset;

/// 是否支持选中样式展现；默认NO；
@property (nonatomic, assign) BOOL cellSelectedStyle;

/// 设置选中标签的背景颜色;
@property (nonatomic, strong) UIColor *selectedLabelBackgroudColor;

/// 如果是自适应宽度，获取size尺寸；
- (CGSize)sizeForCellThatWidthFits:(CGFloat)maxWidth;

- (void)setData:(id)data;

///  ZXLabelsTagsView:willDispaly设置外观
- (void)labelsTagsViewWillDisplayCellWithData:(id)data;
@end


NS_ASSUME_NONNULL_END
