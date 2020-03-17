//
//  UIFont+ZXCategoryFontScale.h
//  CollagePicture
//
//  Created by simon on 2019/4/17.
//  Copyright © 2019 simon. All rights reserved.
//
//  简介：根据不同屏幕大小返回适配字体；只能在写代码的时候换算fontSize,重新赋值；
//  注意：不能用runtime方法全局改字体；由于系统UIAlertController的字体已经经过适配了，再经过这个runtime方法会变大很多；可以看UIFont的图片例子；

//  2019.10.31  增加2个类方法；
//  2020.2.06 针对320屏幕的字体大小做调整，改为原大小的0.93倍，不是0.85倍；

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (ZXCategoryFontScale)


/// 创建返回适配屏幕大小的系统字体Font；
/// @param fontSize iPhone6的字体大小
+ (UIFont *)zx_systemFontOfScaleSize:(CGFloat)fontSize;


/// 根据UIFontWeight（粗细层度）样式创建返回适配屏幕大小的系统字体Font
/// @param fontSize fontSize description
/// @param weight weight description
+ (UIFont *)zx_systemFontOfScaleSize:(CGFloat)fontSize weight:(UIFontWeight)weight API_AVAILABLE(ios(8.2));
/**
 根据原字体大小换算返回适配屏幕大小的新字体UIFont对象；
 字体大小经过transSizeWithFontSize：换算；
 @param fontSize iPhone6的字体大小
 @return 兼容不同屏幕经过计算的字体UIFont对象
 */
- (UIFont *)zx_fontWithScaleSize:(CGFloat)fontSize;

/**
 根据原字体大小 换算返回适配屏幕大小的新字体大小

 @param fontSize iPhone6的字体大小
 @return 兼容不同屏幕经过计算的字体大小
 */
+ (CGFloat)transSizeWithFontSize:(CGFloat)fontSize;

@end

NS_ASSUME_NONNULL_END
