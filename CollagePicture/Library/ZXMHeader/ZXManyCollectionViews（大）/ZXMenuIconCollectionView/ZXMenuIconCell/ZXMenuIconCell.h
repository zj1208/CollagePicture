//
//  ZXMenuIconCell.h
//  YiShangbao
//
//  Created by simon on 2017/10/23.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  注释：icon图标 +底部title； icon与title之间的间距默认是8；title于底部边距大于等于0；

//  2018.1.8 修改ZXMenuIconCell实例方法；倒入MessageModel
//  2018.2.11,新增默认Model模型；ZXMenuIconModel；
//  7.18,改动xib 角标约束；
//  2020.3.07  方法修改，增加属性：titleLabel与image的间距属性等；XIB约束调整；

#import <UIKit/UIKit.h>
#import "ZXMenuIconModel.h"

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


@interface ZXMenuIconCell : UICollectionViewCell

/// 中心图标
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;


/// 在99+的时候可以调整角标往图片里靠
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labLayoutLeadingConstraint;

/// 标题文本;默认字体大小12，且自适应屏幕；
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

/// 角标数字Label
@property (weak, nonatomic) IBOutlet UILabel *badgeLab;


/// imageView顶部与cell的top顶部的约束间距；默认2
@property (nonatomic, assign) CGFloat imageViewToSupViewTop;
/// imageView正方形长度约束；默认45；
@property (nonatomic, assign) CGFloat imageViewSquareSideLength;
/// titleLab的top与imageView的bottom之间的间距；默认8；
@property (nonatomic, assign) CGFloat titleLabToImageViewSpace;
/// titleLab的底部与cell之间的间距；默认0；
@property (nonatomic, assign) CGFloat titleLabBottomToSupViewSpace;

/// 根据默认Model，ZXMenuIconModel设置数据；
- (void)setData:(id)data placeholderImage:(UIImage *)placeholderImage;

/// 获取titleLab与imageView之间的间距，默认8；只读；
+ (CGFloat)getTitleLabToImageViewDefaultSpace;

/// 获取imageView与cell顶部之间的间距，默认2;只读；
+ (CGFloat)getImageViewToSupViewDefaultTop;

/// 获取titleLabel与cell底部之间的间距，默认0；只读；
+ (CGFloat)getTitleLabToSupViewDefaultBottom;
@end

NS_ASSUME_NONNULL_END

