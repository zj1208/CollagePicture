//
//  UILabel+ZXExtension.m
//  YiShangbao
//
//  Created by simon on 17/6/19.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "UILabel+ZXExtension.h"

@implementation UILabel (ZXExtension)

-(void)jl_addMediumLineWithText:(NSString*)text lineColor:(UIColor*)color
{
    NSString* str = [NSString string];
    if (!text) {
        if (self.text) {
            str = [NSString stringWithString:self.text];
        }else{
            return;
        }
    }else{
        str = [NSString stringWithString:text];
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedString setAttributes:@{NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)} range:NSMakeRange(0,str.length)]; //不加这个中文ios10就会出bug出不来中划线
    
    [attributedString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid|NSUnderlineStyleSingle) range:NSMakeRange(0, str.length)];
    [attributedString addAttribute:NSStrikethroughColorAttributeName value:color range:NSMakeRange(0, str.length)];
    
    self.attributedText = attributedString;

}
-(void)jl_setAttributedText:(NSString *)text withMinimumLineHeight:(float)spacing
{
    NSString* str = [NSString string];
    if (!text) {
        if (self.text) {
            str = [NSString stringWithString:self.text];
        }else{
            return;
        }
    }else{
        str = [NSString stringWithString:text];
    }
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setMinimumLineHeight:spacing];
    
    paragraphStyle1.lineBreakMode = self.lineBreakMode;
    paragraphStyle1.alignment = self.textAlignment;

    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [str length])];
    self.attributedText = attributedString;
}
-(void)jl_setAttributedText:(NSString *)text withMinimumLineHeight:(float)spacing lineBreakMode:(NSTextAlignment)alignment
{
    NSString* str = [NSString string];
    if (!text) {
        if (self.text) {
            str = [NSString stringWithString:self.text];
        }else{
            return;
        }
    }else{
        str = [NSString stringWithString:text];
    }
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setMinimumLineHeight:spacing];
    paragraphStyle1.alignment = alignment;
   
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [str length])];
    self.attributedText = attributedString;
}



- (void)zh_digitalIconWithBadgeValue:(NSInteger)aBadgeValue maginY:(CGFloat)aMaginY badgeFont:(nullable UIFont *)font titleColor:(nullable UIColor *)aTitleColor backgroundColor:(nullable UIColor*)aBgColor
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
    self.text = aDigitalTitle;
 
    CGRect titleRect = [aDigitalTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName:self.font} context:nil];
    CGSize titleFitSize = titleRect.size;
    
    CGFloat maginY = aMaginY<2.5?2.5:aMaginY;
    CGFloat height = ceilf(titleFitSize.height)+2*maginY;
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
