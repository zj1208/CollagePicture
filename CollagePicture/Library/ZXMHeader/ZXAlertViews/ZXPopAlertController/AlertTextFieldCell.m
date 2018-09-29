//
//  AlertTextFieldCell.m
//  YiShangbao
//
//  Created by simon on 2017/9/21.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "AlertTextFieldCell.h"

@implementation AlertTextFieldCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.accessoryBtn setImage:[UIImage imageNamed:@"alert_unSelect"] forState:UIControlStateNormal];
    [self.accessoryBtn setImage:[UIImage imageNamed:@"alert_select"] forState:UIControlStateSelected];
    self.textView.text = nil;
    [self.textView setCornerRadius:4.f borderWidth:0.5f borderColor:[UIColor colorWithRed:225.f/255 green:225.f/255 blue:225.f/255 alpha:1]];
//    self.backgroundColor = [UIColor redColor];
    self.textView.placeholder = @"请输入其它原因";
    [self sendSubviewToBack:self.contentView];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.accessoryBtn.selected = selected;
    // Configure the view for the selected state
}

@end
