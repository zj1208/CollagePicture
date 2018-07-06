//
//  ZXImgIcons.h
//  YiShangbao
//
//  Created by simon on 2017/11/28.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  5.09  优化代码

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXImgIcons : NSObject


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
 根据原图快速创建模型
 
 @param originalUrl 原图地址
 @return return value description
 */
+ (instancetype)photoWithOriginalUrl:(nullable NSString *)originalUrl;


+ (instancetype)photoWithImage:(nullable UIImage *)image;


@end

NS_ASSUME_NONNULL_END
