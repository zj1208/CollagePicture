//
//  ZXImgIcons.m
//  YiShangbao
//
//  Created by simon on 2017/11/28.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXImgIcons.h"

@implementation ZXImgIcons



/** 根据原图快速创建模型 */
+ (instancetype)photoWithOriginalUrl:(nullable NSString *)originalUrl
{
    return [[ZXImgIcons alloc] initPhotoWithOriginalUrl:originalUrl];
}

+ (instancetype)photoWithImage:(nullable UIImage *)image
{
    return [[ZXImgIcons alloc] initWithImage:image];
}


#pragma  mark - Init

- (instancetype)initPhotoWithOriginalUrl:(nullable NSString *)originalUrl
{
    if (self = [super init])
    {
        self.original_pic = originalUrl;
    }
    return self;
}



- (instancetype)initWithImage:(nullable UIImage *)image {
    if (self = [super init])
    {
        self.image = image;
    }
    return self;
}
@end
