//
//  UIImage+ZXCompression.m
//  MerchantBusinessClient
//
//  Created by simon on 2020/8/25.
//  Copyright © 2020 com.Chs. All rights reserved.
//

#import "UIImage+ZXCompression.h"

#ifndef DLog
#ifdef DEBUG
    #define DLog(format, ...)  do {                                                                          \
                             fprintf(stderr, "\n====================\n<%s : %d> %s\n\n",                                           \
                             [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
                             __LINE__, __func__);                                                        \
                             (NSLog)((format), ##__VA_ARGS__);                                           \
                             fprintf(stderr, "-------\n");                                               \
                           } while (0)
 #else
    #define DLog(...)
#endif
#endif

@implementation UIImage (ZXCompression)

/*
+ (NSData *)zx_luBanCompressImage:(UIImage *)image{
    
    double size;
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    
    int fixelW = (int)image.size.width;
    int fixelH = (int)image.size.height;
    
    double scale = (double)fixelW/fixelH;
    
    NSData *jpegData = UIImageJPEGRepresentation(image, 1);
    NSData *pngData = UIImagePNGRepresentation(image);
    NSLog(@"iOS image data size before compressed:jpeg == %f MB,png == %f MB, image == %@ ,imageOrientation=%@,size:w=%d,h=%d",jpegData.length/1024.0/1024.0,pngData.length/1024.0/1024.0, image,@(image.imageOrientation),fixelW,fixelH);
    
    double scaleA = 9.0/16.0;//0.5625
    double scaleB = 1.0/2.0; //0.5
    
    if (scale <= 1 && scale > scaleA) {
        
        if (fixelH < 1664) {
            if (imageData.length/1024.0 < 150) {
                return imageData;
            }
            size = (fixelW * fixelH) / pow(1664, 2) *150;
            size = size <60 ?60 :size;
        }
        else if (fixelH >= 1664 && fixelH <4990){
            
        }
    }
    
}
*/
//压缩图片的质量以及缩小图片尺寸 方案一:

+ (UIImage *)zx_resizeImage:(UIImage *)image
{
    //pixel像素宽度/高度
    float width = image.size.width;
    float height = image.size.height;
    
    float maxHeight = UIScreen.mainScreen.currentMode.size.height;
    float maxWidth = [UIScreen mainScreen].currentMode.size.width;
//    DLog(@"size = %@",NSStringFromCGSize([UIScreen mainScreen].currentMode.size));
    
    NSData *sourceImageData = UIImageJPEGRepresentation(image, 1);
    float compressionQuality = 0.5;
//    NSData *pngData = UIImagePNGRepresentation(image);
//    DLog(@"iOS image data size before compressed:jpeg == %f MB,png == %f MB, image == %@ ,imageOrientation=%@,size:w=%f,h=%f",sourceImageData.length/1024.0/1024.0,pngData.length/1024.0/1024.0, image,@(image.imageOrientation),width,height);
//
    //如果小于150KB，就不要压缩；
    if (sourceImageData.length/1024.0 < 150) {
        return [UIImage imageWithData:sourceImageData];
    }
    
    if (height > maxHeight && width > maxWidth) {
        
        if (width > height)
        {
            CGFloat scale = height/width;
            width = maxWidth;
            height = width * scale;
        }
        else{
               
            CGFloat scale = width/height;
            height = maxHeight;
            width = height * scale;
        }
    }
    else if (width > maxWidth || height < maxHeight){
        CGFloat scale = height/width;
        width = maxWidth;
        height = width*scale;
    }
    else if(width < maxWidth || height > maxHeight){
        CGFloat scale = width/height;
        height = maxHeight;
        width = height*scale;
    }
    
    
    CGRect rect = CGRectMake(0.0, 0.0, width, height);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();

    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);

    UIGraphicsEndImageContext();

    DLog(@"iOS image data size after compressed:jpeg == %f KB, image == %@ ,imageOrientation=%@,size:w=%f,h=%f",imageData.length/1024.0, image,@(image.imageOrientation),img.size.width,img.size.height);
    
    return [UIImage imageWithData:imageData];
}



@end

//
//拍照存储的照片：
//jpeg == 5.948195 MB,png == 20.700935 MB, image == <UIImage:0x282c63b10 anonymous {3024, 4032}> ,imageOrientation=3
//横向：jpeg == 4.671441 MB,png == 12.607887 MB, image == <UIImage:0x282c6cea0 anonymous {4032, 3024}> ,imageOrientation=0

//网络图片：
//jpeg == 2.469869 MB,png == 11.081782 MB, image == <UIImage:0x282c60990 anonymous {2600, 3900}> ,imageOrientation=0

//截屏照片：
//jpeg == 0.407666 MB,png == 0.493250 MB, image == <UIImage:0x282c7d050 anonymous {750, 1334}> ,imageOrientation=0

//拍照：
//jpeg == 4.699715 MB,png == 16.767288 MB, image == <UIImage:0x282c786c0 anonymous {3024, 4032}> ,imageOrientation=3

//实现后：
// iOS image data size before/after compressed:

//截屏：jpeg == 0.231116 MB,png == 0.214774 MB, image == <UIImage:0x283768630 anonymous {750, 1334}> ,imageOrientation=0,size:w=750.000000,h=1334.000000
//截屏压缩：jpeg == 70.703125 KB, image == <UIImage:0x283768630 anonymous {750, 1334}> ,imageOrientation=0,size:w=750.000000,h=1334.000000

//拍照：jpeg == 6.098376 MB,png == 16.246523 MB, image == <UIImage:0x2832a0c60 anonymous {3024, 4032}> ,imageOrientation=0,size:w=3024.000000,h=4032.000000
//拍照压缩：jpeg == 125.211914 KB, image == <UIImage:0x2832a0c60 anonymous {3024, 4032}> ,imageOrientation=0,size:w=1001.000000,h=1334.000000
