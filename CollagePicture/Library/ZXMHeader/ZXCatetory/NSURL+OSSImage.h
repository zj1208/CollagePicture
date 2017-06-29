//
//  NSURL+OSSImage.h
//  CollagePicture
//
//  Created by 朱新明 on 16/10/21.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, OSSImageStyle) {
    OSSImageStyle_w600_hX =0,
    
} __TVOS_PROHIBITED;


//SDWebImage本来就会压缩一半，所以要弄实际尺寸的2倍，才会不糊；
typedef NS_ENUM(NSInteger, OSSImageResizeType) {
    
    OSSImageResizeType_w100_hX =0,
    OSSImageResizeType_w200_hX =1,
    OSSImageResizeType_w300_hX =2,
    OSSImageResizeType_w600_hX =3,
    OSSImageResizeType_w700_hX =4,
    OSSImageResizeType_w820_hX =5,
    OSSImageResizeType_w1600_hX = 6,
    
};
//文件链接完整域名：https://${bucket}.${region}.aliyuncs.com/


//2017年最新的方法

@interface NSURL (OSSImage)



/**
 通过样式来处理图片访问规则

 @param style 样式
 @param baseString 图片原图地址
 @return 返回一个图片url地址
 */
//+ (NSURL *)ossImageWithStyleType:(OSSImageStyle)style relativeToImgPath:(NSString *)baseString;


+ (NSURL *)ossImageWithResizeType:(OSSImageResizeType)resizeType relativeToImgPath:(id)baseURL;
@end

NS_ASSUME_NONNULL_END
