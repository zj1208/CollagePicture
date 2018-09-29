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


//如果是用SDWebImage下载的，它会压缩一半，所以要弄实际尺寸的2倍，才会不糊；
typedef NS_ENUM(NSInteger, OSSImageResizeType) {
    
    OSSImageResizeType_w100_hX =0,
    OSSImageResizeType_w200_hX =1,
    OSSImageResizeType_w300_hX =2,
    OSSImageResizeType_w600_hX =3,
    OSSImageResizeType_w700_hX =4,
    
    OSSImageResizeType_w414_hX =5, //屏幕宽度；6plus414
    OSSImageResizeType_w828_hX =6, //双倍屏幕宽度；6plus414
    
    OSSImageResizeType_w667_hX =7, //横屏宽度；
    
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


/**
 通过样式来处理图片访问规则

 @param resizeType OSSImageResizeType
 @param baseURL 可以传URL对象，也可以传NSString对象；
 @return 返回URL
 */
+ (NSURL *)ossImageWithResizeType:(OSSImageResizeType)resizeType relativeToImgPath:(id)baseURL;
@end

NS_ASSUME_NONNULL_END
