//
//  NSBundle+ZXImagePicker.h
//  FunLive
//
//  Created by simon on 2019/5/14.
//  Copyright © 2019 facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (ZXImagePicker)

+ (NSBundle *)zx_imagePickerBundle;

+ (UIImage *)zx_imageNamedFromMyBundle:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
