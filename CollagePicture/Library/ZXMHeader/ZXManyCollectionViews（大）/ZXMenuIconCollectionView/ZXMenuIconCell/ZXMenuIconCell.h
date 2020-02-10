//
//  ZXMenuIconCell.h
//  YiShangbao
//
//  Created by simon on 2017/10/23.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  注释：icon图标 +底部title； icon与title之间的间距8；  title于底部边距大于等于8；

//  2018.1.8
//  修改ZXMenuIconCell实例方法；倒入MessageModel

//  2018.2.11,新增默认Model模型；ZXMenuIconModel；
//  7.18,改动xib 角标约束；

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

// 中心图标
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

// 设置中心图标的 大小；默认LCDScale_iPhone6(45.f);
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewLayoutWidth;

// 在99+的时候可以调整角标往图片里靠
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labLayoutLeadingConstraint;

// 标题文本;默认字体大小14，6plus自适应；
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

// 角标数字
@property (weak, nonatomic) IBOutlet UILabel *badgeLab;


// 根据默认Model，ZXMenuIconModel设置数据；
- (void)setData:(id)data placeholderImage:(UIImage *)placeholderImage;

@end

NS_ASSUME_NONNULL_END

