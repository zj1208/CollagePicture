//
//  UIColor+ZXHex.h
//  MusiceFate
//
//  Created by simon on 15/1/7.
//  Copyright (c) 2015年 yinyuetai.com. All rights reserved.
//
//  简介：UIColor的分类，根据RGB（sRGB）颜色空间的字符串值转换为RGB（sRGB）颜色空间的color；支持@“#FFFFFF”、 @“0XFFFFFF”、 @“FFFFFF”三种格式的十六进制字符串；

//  2019.3.28  增加新方法；
//  2020.03.03  新增方法
//  2020.06.10  新增方法

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (ZXHex)

/**
 从RGB(sRGB)颜色空间中指定的十六进制字符串获取RGB(sRGB)颜色对象；调用colorWithHexString:alpha:方法；
 */
+ (UIColor *)zx_colorWithHexString:(NSString *)color;


/**
 从RGB(sRGB)颜色空间中指定的十六进制字符串获取RGB(sRGB)颜色对象;返回的是RGB(sRGB)颜色空间的对象；

 @param color RGB颜色空间中指定的十六进制颜色字符串.支持@"#FFFFFF", @"0XFFFFFF", @"FFFFFF"三种格式.
 @param alpha 透明度
 @return RGB(sRGB)的UIColor对象。
 */
+ (UIColor *)zx_colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;



/// 返回P3颜色空间（width color）或RGB颜色空间的Color对象。P3指定的颜色值和sRGB指定的颜色值 所对应的结果是不同的,一套代码在支持P3和不支持P3的设备上同时展示时，如果想要有同样的展现颜色效果，一定要设置2套值。
/// @param color P3颜色空间中指定的十六进制颜色字符串。支持@"#FFFFFF", @"0XFFFFFF", @"FFFFFF"三种格式.
/// @param color2 RGB颜色空间中指定的十六进制颜色字符串。支持@"#FFFFFF", @"0XFFFFFF", @"FFFFFF"三种格式.
/// @param alpha 透明度
+ (UIColor *)zx_colorWithDisplayP3HexString:(NSString *)color RGBHexString:(NSString *)color2 alpha:(CGFloat)alpha;

/// 获取随机颜色
+ (UIColor *)zx_colorWithRandomColor;



/// 从十六进制的字符串颜色转RGB.把＃变为0x，如果没有则加上;
/// @param hex 0X十六进制
/// @param alpha 透明度
+ (UIColor *)zx_colorWithHex:(uint)hex alpha:(CGFloat)alpha;


@end



NS_ASSUME_NONNULL_END
