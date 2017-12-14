//
//  MBProgressHUD+ZXExtension.h
//  YiShangbao
//
//  Created by simon on 17/6/22.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  2017.12.11

#import <MBProgressHUD/MBProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (ZXExtension)

// 注意：
// 支持window显示和自定义view显示，当view＝nil，显示在window上；
// 在上传，正在干什么这种，要在window上提示；
// 在UITabelViewController，UICollectionViewController，也要在window上提示；

// 正在加载提示
+ (void)zx_showLoadingWithStatus:(nullable NSString *)aText toView:(nullable UIView *)view;



/**
 成功提示；会自动隐藏,默认根据文本内容长度设置时间隐藏；

 @param success 成功提示文本；
 @param view 所加的view层，如果传nil，默认window；
 */
+ (void)zx_showSuccess:(nullable NSString *)success toView:(nullable UIView *)view;

// 同zx_showSuccess:toView:，增加自定义多久隐藏；
+ (void)zx_showSuccess:(nullable NSString *)success toView:(nullable UIView *)view hideAfterDelay:(NSTimeInterval)delay;

/**
 失败提示；会自动隐藏,默认根据文本内容长度设置时间隐藏；
 
 @param error 失败提示文本；
 @param view 所加的view层，如果传nil，默认window；
 */
+ (void)zx_showError:(nullable NSString *)error toView:(nullable UIView *)view;


/**
 成功和失败的基础提示方法；会自动隐藏,默认根据文本内容长度设置时间隐藏，带图片属性；
 
 @param aText 提示文本；
 @param imageName 提示图片；
 @param view 所加的view层，如果传nil，默认window；
 */
+ (MBProgressHUD *)zx_showText:(nullable NSString *)aText customIcon:(nullable NSString *)imageName view:(nullable UIView *)view;

+ (MBProgressHUD *)zx_showText:(nullable NSString *)aText customIcon:(nullable NSString *)imageName view:(nullable UIView *)view hideAfterDelay:(NSTimeInterval)delay;

//gif图提示:@"litteMoney"
+ (void)zx_showGifWithGifName:(NSString *)gifName toView:(nullable UIView *)view;

//自定义加载动画
+ (void)zx_showGifWithGifName:(NSString *)gifName Text:(nullable NSString *)aText toView:(nullable UIView *)view;

//自定义加载动画 显示时间
+ (void)zx_showGifWithGifName:(NSString *)gifName Text:(nullable NSString *)aText time:(CGFloat)time toView:(nullable UIView *)view;

// 隐藏hud
+ (BOOL)zx_hideHUDForView:(nullable UIView *)view;

@end


NS_ASSUME_NONNULL_END
