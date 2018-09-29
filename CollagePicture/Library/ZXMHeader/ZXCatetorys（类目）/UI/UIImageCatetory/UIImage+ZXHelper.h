//
//  UIImage+ZXHelper.h
//  CollagePicture
//
//  Created by simon on 15/6/25.
//  Copyright (c) 2015年 simon. All rights reserved.
//
//  5.4  获取view的快照视图替换方法；
//  2018.5.31 增加获取渐变图方式区分垂直/水平方向 ；

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//渐变image的渐变方向
typedef NS_ENUM(NSInteger, ZXGradientImageDirection) {
    ZXGradientImageDirectionVertical,
    ZXGradientImageDirectionHorizontal
};

@interface UIImage (ZXImageHelper)


/**
  根据一个color颜色创建一个UIImage对象；
  其实调用了zh_imageWithColor: andSize:opaque:;
  opaque＝NO；
 例如：生成全透明图片

 UIImage *backgroundImage = [UIImage zh_imageWithColor:[UIColor clearColor] andSize:CGSizeMake(LCDW, 30.f)];

 @param color color对象
 @param size image的大小尺寸
 @return 返回一个绘制后的图片；
 */
+ (UIImage *)zh_imageWithColor:(UIColor *)color andSize:(CGSize)size;


/**
 根据一个color颜色创建一个UIImage对象；

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
                               locations:(const CGFloat[_Nullable])locations
                              components:(const CGFloat[_Nullable])components
                                   count:(NSInteger)count;

+ (UIImage *)zh_getGradientImageWithSize:(CGSize)size
                               locations:(const CGFloat[_Nullable])locations
                              components:(const CGFloat[_Nullable])components
                                   count:(NSInteger)count
                           directionType:(ZXGradientImageDirection)directon;

/**
 绘制2个位置的水平渐变颜色的image；根据开始颜色和结束颜色，获取一个image渐变图片；
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
+ (UIImage *)zh_getGradientImageFromHorizontalTowColorWithSize:(CGSize)size startColor:(UIColor *)startColor endColor:(UIColor *)endColor;


/**
 返回2个颜色的垂直渐变image图片
 */
+ (UIImage *)zh_getGradientImageFromVerticalTowColorWithSize:(CGSize)size topColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor;

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
 把某个view绘画到上下文中生成一个image图片；
 ios7以后获取快照视图有新方法；
 UIView *clipView = [cell snapshotViewAfterScreenUpdates:NO];
 @param  view 可以是整个屏幕
 @return image
 */
+ (UIImage *)zh_getContextImageFromView:(UIView *)view;



/**
 判断图片是否是有效的位图

 @param imageData 图片数据
 @return 是否是有效的JPG图片
 */
+ (BOOL)zh_checkIsValidJPGImageByImageData:(nullable NSData *)imageData;


- (void)zh_saveImageWithName:(NSString *)imageName;
@end

NS_ASSUME_NONNULL_END
