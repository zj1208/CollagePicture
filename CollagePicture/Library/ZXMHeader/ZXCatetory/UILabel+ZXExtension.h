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
- (void)zh_digitalIconWithBadgeValue:(NSString *)aDigitalTitle maginY:(CGFloat)aMaginY badgeFont:(nullable UIFont *)font titleColor:(nullable UIColor *)aTitleColor backgroundColor:(nullable UIColor*)aBgColor;

@end


NS_ASSUME_NONNULL_END
