//
//  ZXCenterBottomToolView.m
//  YiShangbao
//
//  Created by simon on 17/2/26.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXCenterBottomToolView.h"

@implementation ZXCenterBottomToolView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews
{
    [self.onlyCenterBtn setCornerRadius:(CGRectGetHeight(self.frame)-2*self.centerBtnTopLayout.constant)/2 borderWidth:1.f borderColor:nil];
    [super layoutSubviews];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
//    [self.onlyCenterBtn setBackgroundColor:WYUISTYLE.colorMred];

//    UIImage *grideImage = [[WYUtility dataUtil]getCommonRedGradientImageWithSize:self.button.frame.size];
//    [self.button setBackgroundImage:grideImage forState:UIControlStateNormal];
    
}
@end
