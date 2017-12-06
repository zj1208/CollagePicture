//
//  AlertChoseTableCell.m
//  YiShangbao
//
//  Created by simon on 2017/9/21.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "AlertChoseTableCell.h"

@implementation AlertChoseTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.accessoryBtn setImage:[UIImage imageNamed:@"alert_unSelect"] forState:UIControlStateNormal];
    [self.accessoryBtn setImage:[UIImage imageNamed:@"alert_select"] forState:UIControlStateSelected];
//  self.backgroundColor = [UIColor redColor];
    [self sendSubviewToBack:self.contentView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.accessoryBtn.selected = selected;
      // Configure the view for the selected state
}

@end
