//
//  UIColor+ZXHex.m
//  simon
//
//  Created by simon on 15/1/7.
//  Copyright (c) 2015年 simon. All rights reserved.
//

#import "UIColor+ZXHex.h"

@implementation UIColor (ZXHex)


#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor

/**
 the hex color spec for aquamarine is #7FFFD4, or rgb(127,255,212), so we can use the following code
 
 import AppKit
 
 let redPercentage = CGFloat(0x7F)/255
 let greenPercentage = CGFloat(0xFF)/255
 let bluePercentage = CGFloat(0xD4)/255
 
 let aquamarineColor = NSColor(red: redPercentage, green: greenPercentage, blue: bluePercentage, alpha: 1.0)
 

 @param color color description
 @param alpha 透明度
 @return UIColor对象
 */
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    CGFloat red = (float)r / 255.0f ;
    CGFloat green = (float)g / 255.0f;
    CGFloat blue = (float)b / 255.0f;
    if (@available(iOS 10.0, *))
    {
        return [UIColor colorWithDisplayP3Red:red green:green blue:blue alpha:alpha];
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

//默认alpha值为1
+ (UIColor *)colorWithHexString:(NSString *)color
{
    return [self colorWithHexString:color alpha:1.0f];
}



+ (UIColor *)colorWithRandomColor
{
    CGFloat r = arc4random_uniform(256);
    CGFloat g = arc4random_uniform(256);
    CGFloat b = arc4random_uniform(256);
    
    return [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:1];
}

// 不会有白色，黑色；还没有被使用；待考察；
+ (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}
@end
