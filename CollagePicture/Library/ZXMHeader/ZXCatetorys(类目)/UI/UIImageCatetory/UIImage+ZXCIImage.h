//
//  UIImage+ZXCIImage.h
//  MobileCaiLocal
//
//  Created by simon on 2019/12/13.
//  Copyright © 2019 com.Chs. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ZXCIImage)


/// 生成条形码1
/// 默认生成的image是固定高度=32,宽度根据码字符越多越宽；
/// @param inputString 编码到条形码中的消息
+ (UIImage *)zx_generateBarcodeImageWithInputMessage:(NSString *)inputString;


/// 生成条形码2
/// @param inputString 编码到条形码中的消息
/// @param width 指定生成宽度
/// @param height 指定生成高度
+ (UIImage *)zx_generateBarcodeImageWithInputMessage:(NSString *)inputString  width:(CGFloat)width height:(CGFloat)height;


/// 生成二维码
/// @param inputString 编码到二维码中的消息
+ (UIImage *)zx_generateQRCodeImageWithInputMessage:(NSString *)inputString;
@end

NS_ASSUME_NONNULL_END
