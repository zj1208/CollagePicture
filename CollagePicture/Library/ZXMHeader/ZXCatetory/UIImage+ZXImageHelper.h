//
//  UIImage+ZXImageHelper.h
//  CollagePicture
//
//  Created by simon on 15/6/25.
//  Copyright (c) 2015年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ZXImageHelper)


/**
 @brief  用color 和 size 创建 image；
 生成全透明的图片：
 UIImage *backgroundImage = [UIImage zh_imageWithColor:[UIColor clearColor] andSize:CGSizeMake(LCDW, 30.f)];
 
 */
+ (UIImage *)zh_imageWithColor:(UIColor *)color andSize:(CGSize)size;


/**


 @param color 颜色
 @param size size尺寸
 @param opaque 是否半透明
 @return image
 */
+ (UIImage *)zh_imageWithColor:(UIColor *)color andSize:(CGSize)size opaque:(BOOL)opaque;


/**
 绘制多个位置的渐变颜色的image:几个位置就几种颜色，系统方法就会根据这几种颜色之间的差距过渡渐变过来；
 const CGFloat location[] ={0,1};
 const CGFloat components[] ={
 255.f/255,67.f/255,82.f/255,1,
 243.f/255,19.f/255,37.f/255,1
 };
 UIImage *backgroundImage = [UIImage zh_getGradientImageWithSize:CGSizeMake(200, 36) locations:location components:components count:2];
 
 @param size 上下文size
 @param locations 颜色所在位置（范围0~1）
 @param components 颜色数组
 @param count 渐变个数，等于locations的个数
 @return return value description
 */
+ (UIImage *)zh_getGradientImageWithSize:(CGSize)size
                               locations:(const CGFloat[])locations
                              components:(const CGFloat[])components
                                   count:(NSInteger)count;



/**
 绘制2个位置的渐变颜色的image；根据开始颜色和结束颜色，获取一个image渐变图片；
 利用
 zh_getGradientImageWithSize:(CGSize)size
 locations:(const CGFloat[])locations
 components:(const CGFloat[])components
 count:(NSInteger)count;方法；
 @param size 上下文绘画的size空间
 @param startColor 开始颜色
 @param endColor 结束颜色
 @return 背景图片
 */
+ (UIImage *)zh_getGradientImageFromTowColorComponentWithSize:(CGSize)size startColor:(UIColor *)startColor endColor:(UIColor *)endColor;


/**
 把原图image重新绘画到指定size的上下文中；
 利用Image的drawInRect绘画方法写入上下文中
 @param image 原图
 @param size 指定size大小的上下文
 @return image
 */
+ (UIImage *)zh_scaleImage:(UIImage *)image toSize:(CGSize)size;


/**
 把原图image重新绘画到scaleSize 倍率的上下文中；
 利用Image的drawInRect绘画方法写入上下文中
 @param image 原图
 @param scaleSize 缩放比例
 @return image
 */
+ (UIImage *)zh_scaleImage:(UIImage *)image toScale:(float)scaleSize;

/**
 把某个view绘画到image上下文中；

 @param view 如果要整个屏幕,用self.view.window；
 @return image
 */
+ (UIImage *)zh_getContextImageFromView: (UIView *)view;

- (void)zh_saveImageWithName:(NSString *)imageName;
@end
