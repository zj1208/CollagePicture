//
//  ZXCenterTitleHeaderFooterView.m
//  MobileCaiLocal
//
//  Created by 朱新明 on 2020/2/18.
//  Copyright © 2020 com.Chs. All rights reserved.
//

#import "ZXCenterTitleHeaderFooterView.h"

@interface ZXCenterTitleHeaderFooterView ()
///右边线条与中间内容的间距；
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineToCenterBtnSpaceLayout;
///左边线条与中间内容的间距；
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLineToCenterBtnSpaceLayout;

///线条与父视图的间距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineToSuperMarginLayout;

/// 左边线条的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLineHeightLayout;
/// 右边线条的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightLineHeightLayout;
@end

@implementation ZXCenterTitleHeaderFooterView

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
    self.centerBtnGreaterWidthLayout.constant = 10;
    self.leftLine.backgroundColor = [UIColor colorWithRed:204.f/255 green:204.f/255 blue:204.f/255 alpha:1];
    self.rightLine.backgroundColor = self.leftLine.backgroundColor;
    self.lineToCenterBtnSpaceLayout.constant = 15;
//    self.contentView.backgroundColor = [UIColor redColor];
//    self.centerBtn.backgroundColor =  [UIColor redColor];
    self.userInteractionEnabled = NO;
}

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setHideLineView:(BOOL)hideLineView
{
    _hideLineView = hideLineView;
    
    self.leftLine.hidden = hideLineView;
    self.rightLine.hidden = hideLineView;
}

- (void)setLineToCenterBtnSpace:(CGFloat)lineToCenterBtnSpace
{
    _lineToCenterBtnSpace = lineToCenterBtnSpace;
    
    self.lineToCenterBtnSpaceLayout.constant = lineToCenterBtnSpace;
    self.leftLineToCenterBtnSpaceLayout.constant = lineToCenterBtnSpace;
}

- (void)setLineToSuperMargin:(CGFloat)lineToSuperMargin
{
    _lineToSuperMargin= lineToSuperMargin;
    self.lineToSuperMarginLayout.constant = lineToSuperMargin;
}

- (void)setLineHeight:(CGFloat)lineHeight
{
    _lineHeight = lineHeight;
    self.leftLineHeightLayout.constant = lineHeight;
    self.rightLineHeightLayout.constant = self.leftLineHeightLayout.constant;
}


+ (id)viewFromNib
{
    NSArray *arr =[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil];
    return [arr firstObject];
}
@end
