//
//  ZXPhoto.m
//  YiShangbao
//
//  Created by simon on 17/1/12.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXPhoto.h"

@interface ZXPhoto ()


@end

@implementation ZXPhoto

- (instancetype)init
{
    if (self = [super init]) {
           }
    return self;
}


#pragma mark -类方法

+ (instancetype)modelWithAsset:(PHAsset *)asset type:(ZXAssetModelMediaType)type
{
    ZXPhoto *model = [[ZXPhoto alloc] init];
    model.asset = asset;
    model.type = type;
    return model;
}


+ (instancetype)photoWithOriginalUrl:(nullable NSString *)originalUrl thumbnailUrl:(nullable NSString *)thumbnailUrl
{
    ZXPhoto *photo = [[ZXPhoto alloc] init];
    photo.thumbnail_pic = thumbnailUrl;
    photo.original_pic = originalUrl;
    return photo;
}
/** 根据缩略图快速创建模型 */
+ (instancetype)photoWithThumbnailUrl:(nullable NSString *)thumbnailUrl
{
    ZXPhoto *photo = [[ZXPhoto alloc] init];
    photo.thumbnail_pic = thumbnailUrl;
    return photo;
}

/** 根据原图快速创建模型 */
+ (instancetype)photoWithOriginalUrl:(nullable NSString *)originalUrl
{
    return [[ZXPhoto alloc] initPhotoWithOriginalUrl:originalUrl];
}

+ (instancetype)photoWithImage:(nullable UIImage *)image
{
    return [[ZXPhoto alloc] initWithImage:image];
}


#pragma  mark - Init

- (instancetype)initPhotoWithOriginalUrl:(nullable NSString *)originalUrl
{
    self = [super init];
    if (self)
    {
        self.original_pic = originalUrl;
    }
    return self;
}



- (instancetype)initWithImage:(nullable UIImage *)image
{
    self = [super init];
    if (self)
    {
        self.image = image;
    }
    return self;
}

@end
