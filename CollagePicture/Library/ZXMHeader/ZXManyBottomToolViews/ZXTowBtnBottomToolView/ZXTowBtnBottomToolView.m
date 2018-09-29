//
//  ZXTowBtnBottomToolView.m
//  YiShangbao
//
//  Created by simon on 17/4/17.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXTowBtnBottomToolView.h"

@implementation ZXTowBtnBottomToolView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.leftBtn setCornerRadius:(CGRectGetHeight(self.frame)-2*self.allBtnTopLayout.constant)/2 borderWidth:1.f borderColor:nil];
    [self.rightBtn setCornerRadius:(CGRectGetHeight(self.frame)-2*self.allBtnTopLayout.constant)/2 borderWidth:1.f borderColor:nil];
}

@end
