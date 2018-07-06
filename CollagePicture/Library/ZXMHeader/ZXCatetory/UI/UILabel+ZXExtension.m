//
//  UILabel+ZXExtension.m
//  YiShangbao
//
//  Created by simon on 17/6/19.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "UILabel+ZXExtension.h"

@implementation UILabel (ZXExtension)
-(void)jl_changeStringOfNumberStyle:(NSString *)text numberColor:(UIColor *)numColr numberFont:(UIFont *)font
{
    NSString* str = nil;
    if (!text) {
        if (self.text) {
            str = [NSString stringWithString:self.text];
        }else{
            return;
        }
    }else{
        str = [NSString stringWithString:text];
    }
    NSScanner *scanner = [NSScanner scannerWithString:str];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
    int number;
    [scanner scanInt:&number];
    NSInteger local = 0;
    NSString* strnum = [NSString stringWithFormat:@"%d",number];
    NSRange range_num = [str rangeOfString:strnum];
    
    NSMutableString* strCopy = [NSMutableString stringWithString:str];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    while (range_num.location != NSNotFound) {
        NSRange range = NSMakeRange(range_num.location+local, range_num.length);
        [attributedString addAttribute:NSForegroundColorAttributeName value:numColr range:range];
        [attributedString addAttribute:NSFontAttributeName value:font range:range];
        
        local = range_num.length;
        [strCopy deleteCharactersInRange:range_num];
        
        NSScanner *scanner = [NSScanner scannerWithString:strCopy];
        [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
        int number;
        [scanner scanInt:&number];
        
        NSString* strnum = [NSString stringWithFormat:@"%d",number];
        range_num = [strCopy rangeOfString:strnum];
    }
    self.attributedText = attributedString;
}
-(void)jl_addMediumLineWithText:(NSString*)text lineColor:(UIColor*)color
{
    NSString* str = nil;
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
    NSString* str = nil;
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
-(void)jl_setAttributedText:(NSString *)text withLineSpacing:(float)spacing
{
    NSString* str = nil;
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
    [paragraphStyle1 setLineSpacing:spacing];
    
    paragraphStyle1.lineBreakMode = self.lineBreakMode;
    paragraphStyle1.alignment = self.textAlignment;
    
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
