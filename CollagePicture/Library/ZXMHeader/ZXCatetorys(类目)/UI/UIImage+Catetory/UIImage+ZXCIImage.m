//
//  UIImage+ZXCIImage.m
//  MobileCaiLocal
//
//  Created by simon on 2019/12/13.
//  Copyright © 2019 com.Chs. All rights reserved.
//

#import "UIImage+ZXCIImage.h"


@implementation UIImage (ZXCIImage)

#pragma mark - 条形码


+ (UIImage *)zx_generateBarcodeImageWithInputMessage:(NSString *)inputString
{
    NSData *data = [inputString dataUsingEncoding:NSUTF8StringEncoding];

    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    [filter setDefaults];
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@(0) forKey:@"inputQuietSpace"];
    CIImage *outputImage = [filter outputImage];
    UIImage *image = [UIImage imageWithCIImage:outputImage];
    return image;
}

+ (UIImage *)zx_generateBarcodeImageWithInputMessage:(NSString *)inputString  width:(CGFloat)width height:(CGFloat)height
{
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    [filter setDefaults];
    NSData *data = [inputString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@(0) forKey:@"inputQuietSpace"];
    CIImage *outputImage = [filter outputImage];
    CGFloat scaleX = width/outputImage.extent.size.width;
    CGFloat scaleY = height/outputImage.extent.size.height;
    outputImage = [outputImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    UIImage *image = [UIImage imageWithCIImage:outputImage];
    return image;
}


#pragma mark-二维码

+ (UIImage *)zx_generateQRCodeImageWithInputMessage:(NSString *)inputString
{
    NSData *data = [inputString dataUsingEncoding:NSUTF8StringEncoding];

    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    [filter setValue:data forKey:@"inputMessage"];
    CIImage *outputImage = [filter outputImage];
    UIImage *image = [UIImage imageWithCIImage:outputImage];
    return image;
}

+ (UIImage *)zx_generateQRCodeImageWithInputMessage:(NSString *)inputString width:(CGFloat)width height:(CGFloat)height
{
    NSData *data = [inputString dataUsingEncoding:NSUTF8StringEncoding];

    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    [filter setValue:data forKey:@"inputMessage"];
    CIImage *outputImage = [filter outputImage];
    CGFloat scaleX = width/outputImage.extent.size.width;
    CGFloat scaleY = height/outputImage.extent.size.height;
    outputImage = [outputImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    UIImage *image = [UIImage imageWithCIImage:outputImage];
    return image;
}

@end
