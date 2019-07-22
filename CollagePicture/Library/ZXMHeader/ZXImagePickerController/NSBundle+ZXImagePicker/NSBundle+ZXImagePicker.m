//
//  NSBundle+ZXImagePicker.m
//  FunLive
//
//  Created by simon on 2019/5/14.
//  Copyright © 2019 facebook. All rights reserved.
//

#import "NSBundle+ZXImagePicker.h"
#import "ZXImagePickerController.h"

@implementation NSBundle (ZXImagePicker)

+ (NSBundle *)zx_imagePickerBundle
{
    NSBundle *bundle = [NSBundle bundleForClass:[ZXImagePickerController class]];
    NSURL *url = [bundle URLForResource:NSStringFromClass([ZXImagePickerController class]) withExtension:@"bundle"];
    bundle = [NSBundle bundleWithURL:url];
    return bundle;
}

+ (UIImage *)zx_imageNamedFromMyBundle:(NSString *)name
{
    NSBundle *imageBundle = [self zx_imagePickerBundle];
    name = [name stringByAppendingString:@"@2x"];
    NSString *imagePath = [imageBundle pathForResource:name ofType:@"png"];
    UIImage *image = [[UIImage imageWithContentsOfFile:imagePath]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    if (image == nil)
    {
        name = [name stringByReplacingOccurrencesOfString:@"@2x" withString:@""];
        image = [UIImage imageNamed:name];
    }
    return image;
}

//+ (UIImage *)mj_arrowImage
//{
//    static UIImage *arrowImage = nil;
//    if (arrowImage == nil) {
//        arrowImage = [[UIImage imageWithContentsOfFile:[[self mj_refreshBundle] pathForResource:@"arrow@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    }
//    return arrowImage;
//}


@end
