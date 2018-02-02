//
//  ZXBadgeIconButton.m
//  YiShangbao
//
//  Created by simon on 17/6/19.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXBadgeIconButton.h"

@interface ZXBadgeIconButton ()

@property (nonatomic, strong) UIImageView *imageView;

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
    _autoFit = YES;
}

- (void)setUI
{
    self.backgroundColor = [UIColor clearColor];
    _badgeValue = 0;
    self.badgeLabelContentOffest = CGPointMake(0, 0);
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    self.imageView = imageView;
    
    UILabel *label = [[UILabel alloc] init];
    [self addSubview:label];
    label.translatesAutoresizingMaskIntoConstraints = YES;
    self.badgeLab = label;
    
    [self setBadgeTitleColor:[UIColor whiteColor] badgeBackgroundColor:[UIColor redColor]];
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
    self.imageView.image = image;
    [self.imageView sizeToFit];
    if (image.size.width>40 && image.size.height>40)
    {
        CGRect imageViewRect = self.imageView.frame;
        imageViewRect.size = CGSizeMake(40, 40);
        self.imageView.frame = imageViewRect;
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
    
    self.imageView.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    CGSize size = [self zh_digitalIconWithBadgeValue:self.badgeValue maginY:_maginY badgeFont:self.badgeFont];
    self.badgeLab.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame)-12+self.badgeLabelContentOffest.x, CGRectGetMinY(self.imageView.frame)+self.badgeLabelContentOffest.y, size.width, size.height);
    
    if (_autoFit)
    {
        CGRect rect  = self.frame;
        rect.size.width = CGRectGetWidth(self.badgeLab.frame)+CGRectGetWidth(self.imageView.frame);
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
    
    CGRect titleRect = [aDigitalTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName:self.badgeLab.font} context:nil];
    CGSize titleFitSize = titleRect.size;
    
    CGFloat maginY = aMaginY+2.5;
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
