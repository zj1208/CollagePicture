//
//  ZXMenuIconCell.m
//  YiShangbao
//
//  Created by simon on 2017/10/23.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXMenuIconCell.h"
#import "UILabel+ZXTopBadgeIcon.h"

@implementation ZXMenuIconCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    self.backgroundColor = [UIColor greenColor];
    self.titleLab.font = [UIFont systemFontOfSize:LCDScale_iPhone6(14)];
    self.imgViewLayoutWidth.constant = LCDScale_iPhone6(45.f);
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
}

 // Configure the cell
- (void)setData:(id)data placeholderImage:(UIImage *)placeholderImage
{
    ZXMenuIconModel *model = (ZXMenuIconModel *)data;
    self.titleLab.text = model.title ;
    self.iconImageView.backgroundColor = UIColor.redColor;
//    self.iconImageView.image = placeholderImage;
//    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:placeholderImage];
    if (model.sideMarkType ==SideMarkType_number)
    {
        self.badgeLab.hidden = NO;
         [self.badgeLab zx_topBadgeIconWithBadgeValue:[model.sideMarkValue integerValue] maginY:1.f badgeFont:[UIFont systemFontOfSize:LCDScale_iPhone6(12)] titleColor:[UIColor whiteColor] backgroundColor:[UIColor redColor]];
        
        if ([model.sideMarkValue integerValue]>99)
        {
            self.labLayoutLeadingConstraint.constant = -17;
        }
        else
        {
            self.labLayoutLeadingConstraint.constant = -14;
        }
    }
    else
    {
        self.badgeLab.hidden = YES;
    }
}




@end
