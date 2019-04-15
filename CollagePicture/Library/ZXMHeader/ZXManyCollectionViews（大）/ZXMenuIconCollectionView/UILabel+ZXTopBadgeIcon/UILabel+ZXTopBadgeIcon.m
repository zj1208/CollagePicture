//
//  UILabel+ZXTopBadgeIcon.m
//  FunLive
//
//  Created by simon on 2019/2/26.
//  Copyright © 2019 qq. All rights reserved.
//

#import "UILabel+ZXTopBadgeIcon.h"

@implementation UILabel (ZXTopBadgeIcon)


- (void)zx_topBadgeIconWithBadgeValue:(NSInteger)aBadgeValue maginY:(CGFloat)aMaginY badgeFont:(nullable UIFont *)font titleColor:(nullable UIColor *)aTitleColor backgroundColor:(nullable UIColor*)aBgColor
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.hidden = aBadgeValue<=0?YES:NO;
    self.textAlignment = NSTextAlignmentCenter;
    self.font =font?font:[UIFont systemFontOfSize:11];
    NSString *aDigitalTitle = [NSString stringWithFormat:@"%ld",(long)aBadgeValue];
    if (aBadgeValue>99)
    {
        aDigitalTitle = @"99+";
    }
    self.text = NSLocalizedString(aDigitalTitle, @"角标数字");
    
    //   注意：不要用NSStringDrawingUsesDeviceMetrics，不然iOS8时候计算的高度就比较大；
    //   从新的SDK之后，计算出来的高度已经包括了一定的上下边距，并不是实际文字的高度；
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = self.lineBreakMode;
    style.alignment = self.textAlignment;
    CGRect titleRect = [self.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 100) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font,NSParagraphStyleAttributeName:style} context:nil];
    CGSize titleFitSize = titleRect.size;
    //    这句代码有问题；
    CGFloat maginY = aMaginY<1.f?1.f:aMaginY;
    
    CGFloat height = (ceilf(titleFitSize.height))+2*maginY;
    [self.constraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.active = NO;
    }];
    NSLog(@"%@",self.constraints);
    //高度 height
    NSLayoutConstraint *constraintHeight = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:height];
    //    [self addConstraint:constraintHeight];
    constraintHeight.active = YES;
    
    if (self.text.length==1)
    {
        NSLayoutConstraint *constraintWidth = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:height];
        constraintWidth.active = YES;
    }
    else if (self.text.length>=2)
    {
        CGFloat width = ceilf(titleFitSize.width)+ceilf(height/2);
        NSLayoutConstraint *constraintWidth = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:width];
        constraintWidth.active = YES;
    }
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = height/2;
    
    UIColor *titleColor = aTitleColor?aTitleColor:[UIColor whiteColor];
    self.textColor = titleColor;
    
    UIColor *bgColor = aBgColor?aBgColor:[UIColor redColor];
    [self setBackgroundColor:bgColor];
}
@end
