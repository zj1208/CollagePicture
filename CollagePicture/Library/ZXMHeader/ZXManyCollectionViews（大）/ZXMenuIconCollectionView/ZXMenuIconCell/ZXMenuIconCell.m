//
//  ZXMenuIconCell.m
//  YiShangbao
//
//  Created by simon on 2017/10/23.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXMenuIconCell.h"

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
    if ([model.sideMarkValue integerValue]>99)
    {
        self.labLayoutLeadingConstraint.constant = -17;
    }
    else
    {
        self.labLayoutLeadingConstraint.constant = -14;
    }
    if (model.sideMarkType ==SideMarkType_number)
    {
        self.badgeLab.hidden = NO;
         [self.badgeLab zh_digitalIconWithBadgeValue:[model.sideMarkValue integerValue] maginY:1.f badgeFont:[UIFont systemFontOfSize:LCDScale_iPhone6_Width(12)] titleColor:[UIColor whiteColor] backgroundColor:[UIColor redColor]];
    }
    else
    {
        self.badgeLab.hidden = YES;
    }
}

@end
