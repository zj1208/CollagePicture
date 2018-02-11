//
//  ZXMenuIconCell.m
//  YiShangbao
//
//  Created by simon on 2017/10/23.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXMenuIconCell.h"

#ifndef SCREEN_WIDTH
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#endif

#ifndef SCREEN_MAX_LENGTH
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#endif

//设置iphone6尺寸比例/竖屏,UI所有设备等比例缩放
#ifndef LCDScale_iPhone6_Width
#define LCDScale_iPhone6_Width(X)    ((X)*SCREEN_MIN_LENGTH/375)
#endif


@implementation ZXMenuIconCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    self.backgroundColor = [UIColor greenColor];
    self.titleLab.font = [UIFont systemFontOfSize:LCDScale_iPhone6_Width(14)];
    self.imgViewLayoutWidth.constant = LCDScale_iPhone6_Width(45.f);
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
}

 // Configure the cell
- (void)setData:(id)data placeholderImage:(UIImage *)placeholderImage
{
    ZXMenuIconModel *model = (ZXMenuIconModel *)data;
    self.titleLab.text = model.title ;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:placeholderImage];
    if (model.sideMarkType ==SideMarkType_number)
    {
        self.badgeLab.hidden = NO;
         [self.badgeLab zh_digitalIconWithBadgeValue:[model.sideMarkValue integerValue] maginY:3.5 badgeFont:[UIFont systemFontOfSize:LCDScale_iPhone6_Width(12)] titleColor:[UIColor whiteColor] backgroundColor:[UIColor redColor]];
    }
    else
    {
        self.badgeLab.hidden = YES;
    }
  
}

@end
