//
//  NSFileManager+ZXExtension.h
//  YiShangbao
//
//  Created by simon on 2018/1/9.
//  Copyright © 2018年 com.Microants. All rights reserved.
//
//  2018.1.9
//  新建

#import <Foundation/Foundation.h>

@interface NSFileManager (ZXExtension)


#pragma mark-计算缓存图片大小-如SDWebImage下的

- (float)zh_getFileSizeForDiskCachePath:(NSString *)diskCachePath;


//生成文件路径下文件集合列表:包括图片，plist文件，bundle文件等所有
- (void)zh_getDefaultManagerResource;
@end
