//
//  UIImage+ZXGIF.h
//  CollagePicture
//
//  Created by simon on 17/6/16.
//  Copyright © 2017年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ZXGIF)

+ (UIImage *)zx_animatedGIFNamed:(NSString *)name;

+ (UIImage *)zx_animatedGIFWithData:(NSData *)data;

- (UIImage *)zx_animatedImageByScalingAndCroppingToSize:(CGSize)size;


@end


NS_ASSUME_NONNULL_END
