//
//  UIColor+Hex.h
//  KoudaiBao
//
//  Created by apple on 15/1/7.
//  Copyright (c) 2015年 jungle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)
//16进制颜色转换
+ (UIColor *)colorWithHexString:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
@end
