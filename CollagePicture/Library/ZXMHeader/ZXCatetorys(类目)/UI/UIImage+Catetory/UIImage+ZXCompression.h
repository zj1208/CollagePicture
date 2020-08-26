//
//  UIImage+ZXCompression.h
//  MerchantBusinessClient
//
//  Created by simon on 2020/8/25.
//  Copyright © 2020 com.Chs. All rights reserved.
//
//  简介：压缩图片的质量以及缩小图片尺寸；

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ZXCompression)

///以当前设备分辨率为基准单位；
///1）宽高均大于基准单位值（比如1280），取较大值等于基准单位值，较大值等比例压缩
///2）宽或高一个大于基准单位值，取较大的等于基准单位值，较小的等比压缩
///3）宽高均小于基准单位值，压缩比例不变；
///4）文件大小小于150KB，则不压缩不做任何处理；
/// @param image 要压缩处理的image图片
+ (UIImage *)zx_resizeImage:(UIImage *)image;


@end

NS_ASSUME_NONNULL_END
