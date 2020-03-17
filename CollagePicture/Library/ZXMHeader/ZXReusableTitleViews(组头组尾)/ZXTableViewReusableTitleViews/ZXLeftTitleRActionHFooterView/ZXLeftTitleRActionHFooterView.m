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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftTitleBtnToSuperLeftLayout;

///设置右边button右间距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightTitleBtnToSuperRightLayout;
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
    self.contentView.backgroundColor = [UIColor whiteColor];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.leftTitleBtn.titleLabel.font = [UIFont systemFontOfSize:14* screenWidth/375];
    self.rightTitleBtn.titleLabel.font = [UIFont systemFontOfSize:14* screenWidth/375];
    UIColor *color = [UIColor colorWithRed:51.f/255 green:51.f/255 blue:51.f/255 alpha:1];
    [self.leftTitleBtn setTitleColor:color forState:UIControlStateNormal];
    [self.rightTitleBtn setTitleColor:color forState:UIControlStateNormal];
}

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setLeftTitleBtnToSuperLeft:(CGFloat)leftTitleBtnToSuperLeft
{
    _leftTitleBtnToSuperLeft= leftTitleBtnToSuperLeft;
    self.leftTitleBtnToSuperLeftLayout.constant = leftTitleBtnToSuperLeft;
}

- (void)setRightTitleBtnToSuperRight:(CGFloat)rightTitleBtnToSuperRight
{
    _rightTitleBtnToSuperRight = rightTitleBtnToSuperRight;
    self.rightTitleBtnToSuperRightLayout.constant = rightTitleBtnToSuperRight;
}
@end
