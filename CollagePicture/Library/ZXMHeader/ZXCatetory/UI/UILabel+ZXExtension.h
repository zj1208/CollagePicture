//
//  UILabel+ZXExtension.h
//  YiShangbao
//
//  Created by simon on 17/6/19.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (ZXExtension)

/**
 * @brief  设置一个icon,在数字小于2位数的时候,是圆标记; 如果大于等于2位数,是2边半圆+中间长方形; 可以根据maginY调节文字与垂直边界的距离;
 */
- (void)zh_digitalIconWithBadgeValue:(NSInteger)aBadgeValue maginY:(CGFloat)aMaginY badgeFont:(nullable UIFont *)font titleColor:(nullable UIColor *)aTitleColor backgroundColor:(nullable UIColor*)aBgColor;



/**
 富文本设置最小行高，用于多行显示

 @param text 要显示的字符串，传nil则以self.text显示
 @param spacing 最小行高（eg:一般为UI设计图一半）
 */
-(void)jl_setAttributedText:(nullable NSString *)text withMinimumLineHeight:(float)spacing;




/**
 添加中划线

 @param text 要显示的字符串,传nil则以self.text显示
 @param color 中划线颜色
 */
-(void)jl_addMediumLineWithText:(nullable NSString*)text lineColor:(UIColor*)color;


@end


NS_ASSUME_NONNULL_END
