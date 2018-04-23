//
//  ZXPhoto.h
//  YiShangbao
//
//  Created by simon on 17/1/12.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  简介：照片的通用Model数据
//  4.18 增加媒体类型，增加视频URL地址属性；

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//AssetModelMediaTypeLivePhoto
typedef  NS_ENUM(NSInteger,ZXAssetModelMediaType){
    //默认photo
    ZXAssetModelMediaTypePhoto = 0,
    ZXAssetModelMediaTypePhotoGif = 1,
    ZXAssetModelMediaTypeVideo =2,
    ZXAssetModelMediaTypeAudio = 3,
    ZXAssetModelMediaTypeCustom = 100,
};

@class PHAsset;
@interface ZXPhoto : NSObject

@property (nonatomic, strong) PHAsset *asset;

@property (nonatomic, assign) ZXAssetModelMediaType type;
/**
 图片缩略图地址
 */
@property (nonatomic, copy, nullable) NSString *thumbnail_pic;

/**
 图片原图地址
 */
@property (nonatomic, copy, nullable) NSString *original_pic;

// 视频地址
@property (nonatomic, copy, nullable) NSString *videoURLString;


/**
 图片的原图大小
 */
@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat height;


@property (nonatomic, strong) UIImage *image;


+ (instancetype)modelWithAsset:(PHAsset *)asset type:(ZXAssetModelMediaType)type;


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
