//
//  ZXBadgeCollectionCell.h
//  YiShangbao
//
//  Created by simon on 2018/1/30.
//  Copyright © 2018年 com.Microants. All rights reserved.
//
//  简介：设计依据是 固定中心图标大小；角标（右上角按钮角标，右上角imageView图标角标）相对于中心图标做偏移；
//  可以利用约束imgViewLayoutWidth修改中心图标大小；
//  最好一屏幕最大设置4列，超过4列，角标，图标，字体有可能显示不下；
//  2018.2.7 新增红点的专用imageView；
//  2018.3.22 新增注释；


#import <UIKit/UIKit.h>
#import "BadgeMarkItemModel.h"
#import "UILabel+ZXExtension.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXBadgeCollectionCell : UICollectionViewCell

// 中心图标
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

// 设置中心图标的 大小；默认LCDScale_5Equal6_To6plus(30)；
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewLayoutWidth;

// 标题文本;默认字体大小14，6plus自适应；
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

// 图片 角标
@property (weak, nonatomic) IBOutlet UIImageView *badgeImageView;
// 小红点
@property (weak, nonatomic) IBOutlet UIImageView *badgeDotImageView;

// button按钮角标：可以自定义设置各种背景图+指定数字/文字; 这个暂时不用；
@property (weak, nonatomic) IBOutlet UIButton *badgeOrderBtn;

// 角标数字
@property (weak, nonatomic) IBOutlet UILabel *badgeNumLab;

@property (weak, nonatomic) IBOutlet UIImageView *bottomBadgeImageView;

- (void)setData:(id)data placeholderImage:(UIImage *)placeholderImage;
@end

NS_ASSUME_NONNULL_END
