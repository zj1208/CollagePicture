//
//  ZXLeftTitleRActionHFooterView.m
//  MobileCaiLocal
//
//  Created by 朱新明 on 2020/2/18.
//  Copyright © 2020 com.Chs. All rights reserved.
//

#import "ZXLeftTitleRActionHFooterView.h"

@interface ZXLeftTitleRActionHFooterView ()

///设置左边button左边间距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftTitleBtnMarginLeftLayout;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftTitleBtnMarginTopLayout;

///设置右边button右间距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightTitleBtnMarginRightLayout;


@end

@implementation ZXLeftTitleRActionHFooterView

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
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.leftTitleBtn.titleLabel.font = [UIFont systemFontOfSize:14* screenWidth/375];
    self.rightTitleBtn.titleLabel.font = [UIFont systemFontOfSize:14* screenWidth/375];
    UIColor *color = [UIColor colorWithRed:51.f/255 green:51.f/255 blue:51.f/255 alpha:1];
    [self.leftTitleBtn setTitleColor:color forState:UIControlStateNormal];
    [self.rightTitleBtn setTitleColor:color forState:UIControlStateNormal];
}


- (instancetype)initWithCoder:(NSCoder *)coder{
    
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}




- (void)setLeftTitleBtnMarginLeft:(CGFloat)leftTitleBtnMarginLeft
{
    _leftTitleBtnMarginLeft = leftTitleBtnMarginLeft;
    self.leftTitleBtnMarginLeftLayout.constant = leftTitleBtnMarginLeft;
}


- (void)setLeftTitleBtnMarginTop:(CGFloat)leftTitleBtnMarginTop
{
    _leftTitleBtnMarginTop = leftTitleBtnMarginTop;
    self.leftTitleBtnMarginTopLayout.constant = leftTitleBtnMarginTop;
}


- (void)setRightTitleBtnMarginRight:(CGFloat)rightTitleBtnMarginRight
{
    _rightTitleBtnMarginRight = rightTitleBtnMarginRight;
    self.rightTitleBtnMarginRightLayout.constant = rightTitleBtnMarginRight;
}
@end
