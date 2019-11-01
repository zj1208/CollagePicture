//
//  UILabel+ZXCategory.m
//  YiShangbao
//
//  Created by simon on 17/6/19.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "UILabel+ZXCategory.h"

@implementation UILabel (ZXCategory)
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

/**
//========WYTextCopy==========
static const char *key_textDidCopyHandler = (void *)@"key_textDidCopyHandler";
static const char *key_isNeedCopy = (void *)@"key_isNeedCopy";
static const char *key_longCopyPressGesture = (void *)@"key_longCopyPressGesture";
@implementation UILabel (WYTextCopy)

+ (void)load
{
    
    Class clLabel = [self class];
    
    SEL originSelector_BFR = @selector(canBecomeFirstResponder);
    SEL swizzleSelector_BFR = @selector(jl_canBecomeFirstResponder);
    // 实例-方法
    Method originMethod_BFR = class_getInstanceMethod(clLabel, originSelector_BFR);
    Method swizzleMethod_BFR = class_getInstanceMethod(clLabel, swizzleSelector_BFR);
    // 动态添加方法 实现是被交换的方法  还回值表示添加成功还是失败
    BOOL addMethod_BFR = class_addMethod(clLabel, originSelector_BFR, method_getImplementation(swizzleMethod_BFR), method_getTypeEncoding(swizzleMethod_BFR));
    
    if (addMethod_BFR) {
        //如果成功 说明类中不存在这个方法的实现
        //将被交换方法的实现替换到这个并不存在的实现
        class_replaceMethod(clLabel, swizzleSelector_BFR, method_getImplementation(originMethod_BFR), method_getTypeEncoding(originMethod_BFR));
    }else {
        //否则交换两个方法的实现
        method_exchangeImplementations(originMethod_BFR, swizzleMethod_BFR);
    }
    
    SEL originSelector_RFR = @selector(resignFirstResponder);
    SEL swizzleSelector_RFR = @selector(jl_resignFirstResponder);
    Method originMethod_RFR = class_getInstanceMethod(clLabel, originSelector_RFR);
    Method swizzleMethod_RFR = class_getInstanceMethod(clLabel, swizzleSelector_RFR);
    BOOL addMethod_RFR  = class_addMethod(clLabel, originSelector_RFR, method_getImplementation(swizzleMethod_RFR), method_getTypeEncoding(swizzleMethod_RFR));
    if (addMethod_RFR) {
        class_replaceMethod(clLabel, swizzleSelector_RFR, method_getImplementation(originMethod_RFR), method_getTypeEncoding(originMethod_RFR));
    }else {
        method_exchangeImplementations(originMethod_RFR, swizzleMethod_RFR);
    }
    
    SEL originSelector_CPF = @selector(canPerformAction:withSender:);
    SEL swizzleSelector_CPF = @selector(jl_canPerformAction:withSender:);
    Method originMethod_CPF  = class_getInstanceMethod(clLabel, originSelector_CPF );
    Method swizzleMethod_CPF  = class_getInstanceMethod(clLabel, swizzleSelector_CPF );
    BOOL addMethod = class_addMethod(clLabel, originSelector_CPF, method_getImplementation(swizzleMethod_CPF), method_getTypeEncoding(swizzleMethod_CPF));
    if (addMethod) {
        class_replaceMethod(clLabel, swizzleSelector_CPF, method_getImplementation(originMethod_CPF), method_getTypeEncoding(originMethod_CPF));
    }else {
        method_exchangeImplementations(originMethod_CPF, swizzleMethod_CPF);
    }
}
-(BOOL)jl_canBecomeFirstResponder
{
    if (self.isNeedCopy) {
        return YES;
    }
    return [self jl_canBecomeFirstResponder];
}
-(BOOL)jl_resignFirstResponder
{
    if (self.isNeedCopy) {
        //重置为系统默认
        [[UIMenuController sharedMenuController] setMenuItems:nil];
    }
    return [self jl_resignFirstResponder];
    
}
-(BOOL)jl_canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(jl_customCopyAction:)) {
        return YES;
    }
    return [self jl_canPerformAction:action withSender:sender];
}
- (void)jl_customCopyAction:(id)sender
{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    if (self.text) {
        [pboard setString:self.text];
        if (self.textDidCopyHandler) {
            self.textDidCopyHandler(self);
        }
    }
}
-(void)setTextDidCopyHandler:(TextDidCopyHandler)textDidCopyHandler
{
    objc_setAssociatedObject(self, key_textDidCopyHandler, textDidCopyHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(TextDidCopyHandler)textDidCopyHandler
{
    return objc_getAssociatedObject(self, key_textDidCopyHandler);
}
- (void)setIsNeedCopy:(BOOL)isNeedCopy
{
    [self needCopyingLongPressGestureRecognizer:isNeedCopy];
    objc_setAssociatedObject(self, key_isNeedCopy, @(isNeedCopy), OBJC_ASSOCIATION_ASSIGN);
}
- (BOOL)isNeedCopy
{
    return [objc_getAssociatedObject(self, key_isNeedCopy) boolValue];
}
-(void)setLongCopyPressGesture:(UILongPressGestureRecognizer *)longCopyPressGesture
{
    objc_setAssociatedObject(self, key_longCopyPressGesture, longCopyPressGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UILongPressGestureRecognizer *)longCopyPressGesture
{
    return (objc_getAssociatedObject(self, key_longCopyPressGesture));
}
-(void)needCopyingLongPressGestureRecognizer:(BOOL)need
{
    if (need) {
        if (!self.longCopyPressGesture) {
            UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
            longPressGr.minimumPressDuration = 0.3;
            [self addGestureRecognizer:longPressGr];
            self.longCopyPressGesture = longPressGr;
        }
        self.userInteractionEnabled = YES;
        [self becomeFirstResponder];//偶现不加的话第一次出现又立即消失
    }else{
        [self removeGestureRecognizer:self.longCopyPressGesture];
        self.longCopyPressGesture = nil;
    }
}
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gesture locationInView:self];
        [self addMenuControllerWithPoint:point];
    }
}
#pragma mark 菜单选项
-(void)addMenuControllerWithPoint:(CGPoint)point
{
    NSLog(@"addMenuControllerWithPoint");
    [self becomeFirstResponder];
    
    UIMenuItem *copyMenuItem = [[UIMenuItem alloc]initWithTitle:NSLocalizedString(@"复制", nil) action:@selector(jl_customCopyAction:)];
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    
    [menuController setMenuItems:[NSArray arrayWithObjects:copyMenuItem,nil]];
    [menuController setTargetRect:CGRectMake(point.x, point.y, 0, 0) inView:self];
    [menuController setMenuVisible:YES animated: YES];
}

@end
 */


