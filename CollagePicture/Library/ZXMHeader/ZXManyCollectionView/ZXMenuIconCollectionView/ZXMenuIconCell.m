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
    
//    self.backgroundColor = [UIColor orangeColor];
}

- (void)setData:(id)data placeholderImage:(UIImage *)placeholderImage
{
    MessageModelSub *model = (MessageModelSub *)data;
    self.titleLab.text = model.typeName ;    // Configure the cell
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.typeIcon] placeholderImage:placeholderImage];
    [self.badgeLab zh_digitalIconWithBadgeValue:model.num maginY:0 badgeFont:[UIFont systemFontOfSize:12] titleColor:[UIColor whiteColor] backgroundColor:[UIColor redColor]];
    //        cell.backgroundColor = [UIColor redColor];
}

@end
