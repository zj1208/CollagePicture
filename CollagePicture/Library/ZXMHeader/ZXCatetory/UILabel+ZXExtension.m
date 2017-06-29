//
//  UILabel+ZXExtension.m
//  YiShangbao
//
//  Created by simon on 17/6/19.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "UILabel+ZXExtension.h"

@implementation UILabel (ZXExtension)


- (void)zh_digitalIconWithBadgeValue:(NSString *)aDigitalTitle maginY:(CGFloat)aMaginY badgeFont:(UIFont *)font titleColor:(nullable UIColor *)aTitleColor backgroundColor:(nullable UIColor*)aBgColor
{
    self.textAlignment = NSTextAlignmentCenter;
    self.font = font;
    if ([aDigitalTitle integerValue]>99)
    {
        aDigitalTitle = @"99+";
    }
    self.text = aDigitalTitle;
    
    CGRect titleRect = [aDigitalTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName:self.font} context:nil];
    CGSize titleFitSize = titleRect.size;
    
    CGFloat maginY = aMaginY<4?4:aMaginY;
    CGFloat btnHeight = ceilf(titleFitSize.height)+2*maginY;
    
    //高度 height
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:btnHeight];
    [self addConstraint:constraint1];
    
    
    if (self.text.length==1)
    {
        NSLayoutConstraint *constraintWidth = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:btnHeight];
        [self addConstraint:constraintWidth];
    }
    else if (self.text.length>=2)
    {
        CGFloat btnWidth = ceilf(titleFitSize.width)+ceilf(btnHeight/2);
        //宽度 width
        NSLayoutConstraint *constraintWidth = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:btnWidth];
        [self addConstraint:constraintWidth];
        
    }
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = btnHeight/2;
    
    UIColor *titleColor = aTitleColor?aTitleColor:[UIColor whiteColor];
    self.textColor = titleColor;
    
    UIColor *bgColor = aBgColor?aBgColor:[UIColor redColor];
    [self setBackgroundColor:bgColor];
}


@end
