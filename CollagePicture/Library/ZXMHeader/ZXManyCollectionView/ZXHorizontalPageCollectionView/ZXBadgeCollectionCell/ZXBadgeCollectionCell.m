//
//  ZXBadgeCollectionCell.m
//  YiShangbao
//
//  Created by simon on 2018/1/30.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "ZXBadgeCollectionCell.h"
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

@implementation ZXBadgeCollectionCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleLab.font = [UIFont systemFontOfSize:LCDScale_iPhone6_Width(14)];
    UIImage *normal = [UIImage imageNamed:@"badge_dot_red"];
    normal =[normal resizableImageWithCapInsets:UIEdgeInsetsMake(0,normal.size.width/2, 0,normal.size.width/2)];
    [self.badgeOrderBtn setBackgroundImage:normal forState:UIControlStateNormal];
    self.badgeOrderBtn.hidden = YES;
    
    self.imgViewLayoutWidth.constant = LCDScale_5Equal6_To6plus(30.f);
    
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
//    self.backgroundColor = [UIColor whiteColor];
//    self.backgroundColor = [UIColor orangeColor];

//    self.iconImageView.backgroundColor = [UIColor brownColor];
}

- (void)setData:(id)data placeholderImage:(UIImage *)placeholderImage
{
    BadgeMarkItemModel *model = (BadgeMarkItemModel *)data;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:AppPlaceholderImage];
    
    self.titleLab.text = model.desc;
 
    if (model.sideMarkType ==SideMarkType_redDot)
    {
        self.badgeDotImageView.hidden = NO;
        self.badgeImageView.hidden = !self.badgeDotImageView.hidden;
        self.badgeNumLab.hidden = !self.badgeDotImageView.hidden;
    }
    else if (model.sideMarkType==SideMarkType_number)
    {
        self.badgeDotImageView.hidden = YES;
        self.badgeImageView.hidden = YES;
        self.badgeNumLab.hidden = !self.badgeImageView.hidden;
        NSString *badge = [NSString stringWithFormat:@"  %@  ",model.sideMarkValue];
//        NSString *badge = @"8";
        [self.badgeNumLab zh_digitalIconWithBadgeValue:[badge integerValue] maginY:3.5f badgeFont:[UIFont systemFontOfSize:LCDScale_iPhone6_Width(12)] titleColor:[UIColor whiteColor] backgroundColor:[UIColor redColor]];

    }
    else if (model.sideMarkType ==SideMarkType_image)
    {
        self.badgeDotImageView.hidden = YES;
        self.badgeImageView.hidden = NO;
        self.badgeNumLab.hidden = !self.badgeImageView.hidden;
        [self.badgeImageView sd_setImageWithURL:[NSURL URLWithString:model.sideMarkValue]];
    }
    else
    {
        self.badgeImageView.hidden = YES;
        self.badgeNumLab.hidden = YES;
        self.badgeDotImageView.hidden = YES;
    }

    self.bottomBadgeImageView.hidden = !model.vbrands;
    
}
@end

