//
//  ZXBadgeIconButton.m
//  YiShangbao
//
//  Created by simon on 17/6/19.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXBadgeIconButton.h"

@interface ZXBadgeIconButton ()

@property (nonatomic, strong) UIImageView *iconImageView;
// 角标label对象
@property (nonatomic, strong) UILabel *badgeLab;

@property (nonatomic, assign) BOOL autoFit;

@property (nonatomic, assign) CGFloat maginY;
@property (nonatomic, strong) UIFont *badgeFont;

/**
 设置角标的外观静态设置
 
 @param aMaginY 数字的上下边距
 @param font 角标字体大小
 @param aTitleColor 角标的数字颜色
 @param aBgColor 角标的背景颜色
 */
- (void)setBadgeContentInsetY:(CGFloat)aMaginY badgeFont:(nullable UIFont *)font badgeTitleColor:(nullable UIColor *)aTitleColor badgeBackgroundColor:(nullable UIColor*)aBgColor;

@end

@implementation ZXBadgeIconButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setUI];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUI];
    }
    return self;
}

- (void)sizeToFit
{
    [super sizeToFit];
    self.autoFit = YES;
}

- (void)setUI
{
    self.backgroundColor = [UIColor clearColor];
    self.badgeValue = 0;
    self.badgeLabelContentOffest = CGPointMake(0, 0);
    
    [self addSubview:self.iconImageView];
    
    [self addSubview:self.badgeLab];
}

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        _iconImageView = imageView;
    }
    return _iconImageView;
}

- (UILabel *)badgeLab
{
    if (!_badgeLab) {
        UILabel *lab = [[UILabel alloc] init];
        lab.translatesAutoresizingMaskIntoConstraints = YES;
        lab.textColor = [UIColor whiteColor];
        lab.backgroundColor = [UIColor redColor];
        _badgeLab = lab;
    }
    return _badgeLab;
}

- (void)setBadgeTitleColor:(nullable UIColor *)aTitleColor badgeBackgroundColor:(nullable UIColor*)aBgColor
{
    UIColor *titleColor = aTitleColor?aTitleColor:[UIColor whiteColor];
    self.badgeLab.textColor = titleColor;
    
    UIColor *bgColor = aBgColor?aBgColor:[UIColor redColor];
    [self.badgeLab setBackgroundColor:bgColor];
}


- (void)setBadgeContentInsetY:(CGFloat)aMaginY badgeFont:(nullable UIFont *)font
{
    self.maginY = aMaginY;
    self.badgeFont = font?font:[UIFont systemFontOfSize:11];

    [self layoutIfNeeded];
}


- (void)setBadgeContentInsetY:(CGFloat)aMaginY badgeFont:(nullable UIFont *)font badgeTitleColor:(nullable UIColor *)aTitleColor badgeBackgroundColor:(nullable UIColor*)aBgColor
{
    self.maginY = aMaginY;
    self.badgeFont = font?font:[UIFont systemFontOfSize:11];
    UIColor *titleColor = aTitleColor?aTitleColor:[UIColor whiteColor];
    self.badgeLab.textColor = titleColor;
    
    UIColor *bgColor = aBgColor?aBgColor:[UIColor redColor];
    [self.badgeLab setBackgroundColor:bgColor];
    
    [self layoutIfNeeded];
}


- (void)setImage:(UIImage *)image
{
    self.iconImageView.image = image;
    [self.iconImageView sizeToFit];
    if (image.size.width>40 && image.size.height>40)
    {
        CGRect imageViewRect = self.iconImageView.frame;
        imageViewRect.size = CGSizeMake(40, 40);
        self.iconImageView.frame = imageViewRect;
    }
    [self layoutIfNeeded];

}

- (void)setBadgeValue:(NSInteger)badgeValue
{
    _badgeValue = badgeValue;
    
    [self layoutSubviews];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.iconImageView.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    CGSize size = [self zh_digitalIconWithBadgeValue:self.badgeValue maginY:self.maginY badgeFont:self.badgeFont];
    self.badgeLab.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame)-12+self.badgeLabelContentOffest.x, CGRectGetMinY(self.iconImageView.frame)+self.badgeLabelContentOffest.y, size.width, size.height);
    
    if (self.autoFit)
    {
        CGRect rect  = self.frame;
        rect.size.width = CGRectGetWidth(self.badgeLab.frame)+CGRectGetWidth(self.iconImageView.frame);
        self.frame = rect;
    }
}



- (CGSize)zh_digitalIconWithBadgeValue:(NSInteger)aBadgeValue maginY:(CGFloat)aMaginY badgeFont:(UIFont *)font{
    
    if (aBadgeValue ==0)
    {
        return CGSizeZero;
    }
    self.badgeLab.textAlignment = NSTextAlignmentCenter;
    self.badgeLab.font = font;
    NSString *aDigitalTitle = [NSString stringWithFormat:@"%ld",(long)aBadgeValue];
    if (aBadgeValue>99)
    {
        aDigitalTitle = @"99+";
    }
    self.badgeLab.text = aDigitalTitle;
    
    //  注意：不要用NSStringDrawingUsesDeviceMetrics，不然iOS8时候计算的高度就比较大；
    //   从新的SDK之后，计算出来的高度已经包括了一定的上下边距，并不是实际文字的高度；
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = self.badgeLab.lineBreakMode;
    style.alignment = self.badgeLab.textAlignment;
    CGRect titleRect = [aDigitalTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.badgeLab.font,NSParagraphStyleAttributeName:style} context:nil];
    CGSize titleFitSize = titleRect.size;
    
    CGFloat maginY = aMaginY;
    CGFloat btnHeight = ceilf(titleFitSize.height)+2*maginY;
    CGFloat btnWidth =0.f;
//    高度 height
    if (self.badgeLab.text.length==1)
    {
        btnWidth = btnHeight;
    }
    else if (self.badgeLab.text.length>=2)
    {
        btnWidth = ceilf(titleFitSize.width)+ceilf(btnHeight/2);
    }
    self.badgeLab.layer.masksToBounds = YES;
    self.badgeLab.layer.cornerRadius = btnHeight/2;
    
    return CGSizeMake(btnWidth, btnHeight);
}


@end
