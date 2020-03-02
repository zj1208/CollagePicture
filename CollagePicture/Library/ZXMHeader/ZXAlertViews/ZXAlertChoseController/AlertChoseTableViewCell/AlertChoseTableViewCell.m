//
//  AlertChoseTableViewCell.m
//  MobileCaiLocal
//
//  Created by 朱新明 on 2020/2/14.
//  Copyright © 2020 com.Chs. All rights reserved.
//

#import "AlertChoseTableViewCell.h"

@implementation AlertChoseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.selectBtn setImage:[UIImage imageNamed:@"alert_unSelect"] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage imageNamed:@"alert_select"] forState:UIControlStateSelected];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.selectBtn.selected = selected;
}

@end
