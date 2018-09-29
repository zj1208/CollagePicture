//
//  NSFileManager+ZXExtension.m
//  YiShangbao
//
//  Created by simon on 2018/1/9.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "NSFileManager+ZXExtension.h"

@implementation NSFileManager (ZXExtension)


#pragma mark-计算缓存图片大小-如SDWebImage下的
- (float)zh_getFileSizeForDiskCachePath:(NSString *)diskCachePath
{
    float totalSize = 0;
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:diskCachePath];
    for(NSString *fileName in fileEnumerator)
    {
        NSString *filePath = [diskCachePath stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        signed long long length = [attrs fileSize];
        totalSize +=length/1024.0/1024.0;
    }
    return totalSize;
}


- (void)zh_getDefaultManagerResource
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *defaultPath = [[NSBundle mainBundle] resourcePath];
    NSError *error;
    NSArray *directoryContents = [fileManager contentsOfDirectoryAtPath:defaultPath error:&error];
    NSLog(@"%@",directoryContents);
}


@end
