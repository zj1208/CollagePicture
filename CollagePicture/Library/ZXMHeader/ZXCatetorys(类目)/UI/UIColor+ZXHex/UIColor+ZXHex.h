//
//  UIColor+ZXHex.h
//  MusiceFate
//
//  Created by simon on 15/1/7.
//  Copyright (c) 2015年 yinyuetai.com. All rights reserved.
//
//  简介：UIColor的分类，支持@“#FFFFFF”、 @“0XFFFFFF”、 @“FFFFFF”三种格式的十六进制字符串；利用RGB来创建UIColor，在iOS10及以上支持sRGB宽域颜色方法；

//  2019.3.28  增加新方法；
//  2019.4.16  增加注释，增加支持iOS10的sRGB方法
//  2020.03.03  新增方法

#import <UIKit/UIKit.h>

@interface UIColor (ZXHex)


/**
 从十六进制字符串获取颜色；调用colorWithHexString:alpha:方法；
 */
+ (UIColor *)zx_colorWithHexString:(NSString *)color;


/**
 从十六进制字符串获取颜色;iOS10后使用sRGB，iOS10以前用RGB获取UIColor；

 @param color 十六进制颜色字符串，支持@“#FFFFFF”、 @“0XFFFFFF”、 @“FFFFFF”三种格式
 @param alpha 透明度
 @return UIColor对象
 */
+ (UIColor *)zx_colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;


/// 获取随机颜色
+ (UIColor *)zx_colorWithRandomColor;



/// 从十六进制的字符串颜色转RGB.把＃变为0x，如果没有则加上;
/// @param hex 0X十六进制
/// @param alpha 透明度
+ (UIColor *)zx_colorWithHex:(uint)hex alpha:(CGFloat)alpha;
@end
