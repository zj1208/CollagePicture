//
//  UIColor+ZXHex.h
//  simon
//
//  Created by simon on 15/1/7.
//  Copyright (c) 2015年 simon. All rights reserved.
//
//  2019.3.28  增加新方法；
//  2019.4.16  增加注释；

#import <UIKit/UIKit.h>

@interface UIColor (ZXHex)


// 16进制颜色转换
+ (UIColor *)colorWithHexString:(NSString *)color;


/**
 从十六进制字符串获取颜色，

 @param color 十六进制颜色字符串，支持@“#FFFFFF”、 @“0XFFFFFF”、 @“FFFFFF”三种格式
 @param alpha 透明度
 @return UIColor对象
 */
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;


// 获取随机颜色
+ (UIColor *)colorWithRandomColor;

@end
