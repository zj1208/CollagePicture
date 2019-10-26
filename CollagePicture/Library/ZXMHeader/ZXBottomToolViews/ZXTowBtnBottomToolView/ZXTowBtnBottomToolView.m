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
    [self c_setBorderWithCornerRadius:(CGRectGetHeight(self.frame)-2*self.allBtnTopLayout.constant)/2 borderWidth:1.f borderColor:nil view:self.leftBtn];
    
    [self c_setBorderWithCornerRadius:(CGRectGetHeight(self.frame)-2*self.allBtnTopLayout.constant)/2 borderWidth:1.f borderColor:nil view:self.rightBtn];
}

- (void)c_setBorderWithCornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(nullable UIColor *)borderColor view:(UIView *)view
{
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = radius;
    view.layer.borderWidth = borderWidth;
    view.layer.borderColor =borderColor?[borderColor CGColor]:[UIColor clearColor].CGColor;
}
@end
