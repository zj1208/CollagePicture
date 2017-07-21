//
//  ZXBadgeIconButton.m
//  YiShangbao
//
//  Created by simon on 17/6/19.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXBadgeIconButton.h"

@interface ZXBadgeIconButton ()

@property (nonatomic, strong)UIImageView *imageView;

@property (nonatomic, strong)UILabel *badgeLab;



@property (nonatomic, assign)CGFloat maginY;
@property (nonatomic, strong)UIFont *badgeFont;
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

- (void)setUI
{
    self.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    self.imageView = imageView;
    

    UILabel *label = [[UILabel alloc] init];
    [self addSubview:label];
    
    self.badgeLab = label;
    
    _badgeValue = 0;
}

- (void)maginY:(CGFloat)aMaginY badgeFont:(nullable UIFont *)font badgeTitleColor:(nullable UIColor *)aTitleColor badgeBackgroundColor:(nullable UIColor*)aBgColor
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
    self.badgeLab.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame)-12, CGRectGetMinY(self.imageView.frame), size.width, size.height);
    
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
    
    CGFloat maginY = aMaginY<2.5?2.5:aMaginY;
    CGFloat btnHeight = ceilf(titleFitSize.height)+2*maginY;
    CGFloat btnWidth =0.f;
    //高度 height
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:self.badgeLab attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:btnHeight];
    [self.badgeLab addConstraint:constraint1];
    
    
    if (self.badgeLab.text.length==1)
    {
        btnWidth = btnHeight;
        NSLayoutConstraint *constraintWidth = [NSLayoutConstraint constraintWithItem:self.badgeLab attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:btnHeight];
        [self.badgeLab addConstraint:constraintWidth];
    }
    else if (self.badgeLab.text.length>=2)
    {
        btnWidth = ceilf(titleFitSize.width)+ceilf(btnHeight/2);
        //宽度 width
        NSLayoutConstraint *constraintWidth = [NSLayoutConstraint constraintWithItem:self.badgeLab attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:btnWidth];
        [self.badgeLab addConstraint:constraintWidth];
        
    }
    self.badgeLab.layer.masksToBounds = YES;
    self.badgeLab.layer.cornerRadius = btnHeight/2;
    
    return CGSizeMake(btnWidth, btnHeight);
}


@end
