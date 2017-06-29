//
//  ZXPhoto.h
//  YiShangbao
//
//  Created by simon on 17/1/12.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXPhoto : NSObject

/**
 图片缩略图地址
 */
@property (nonatomic, copy, nullable) NSString *thumbnail_pic;

/**
 图片原图地址
 */
@property (nonatomic, copy, nullable) NSString *original_pic;


/**
 图片的原图大小
 */
@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat height;


@property (nonatomic, strong) UIImage *image;


/**
 根据原图，缩略图快速创建模型

 @param originalUrl 原图地址-用于上传数据
 @param thumbnailUrl 缩略图地址－用于自己封装显示
 @return photo
 */
+ (instancetype)photoWithOriginalUrl:(nullable NSString *)originalUrl thumbnailUrl:(nullable NSString *)thumbnailUrl;
/**
 根据缩略图快速创建模型

 @param thumbnailUrl 缩略图地址
 @return return value description
 */
+ (instancetype)photoWithThumbnailUrl:(nullable NSString *)thumbnailUrl;

/**
 根据原图快速创建模型

 @param originalUrl 原图地址
 @return return value description
 */
+ (instancetype)photoWithOriginalUrl:(nullable NSString *)originalUrl;


+ (instancetype)photoWithImage:(nullable UIImage *)image;

@end

NS_ASSUME_NONNULL_END
