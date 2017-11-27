//
//  ZXPinyinConverter.m
//  YiShangbao
//
//  Created by simon on 2017/11/7.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXPinyinConverter.h"

@implementation ZXPinyinConverter


+ (ZXPinyinConverter *)sharedInstance
{
    static ZXPinyinConverter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZXPinyinConverter alloc] init];
    });
    return instance;
}

- (NSString *)pinyinFromChiniseString:(NSString *)string
{
   if(!string || ![string length]) return nil;
    NSMutableString *mutableString = [NSMutableString stringWithString:string];
//  zhū xīn míng
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    mutableString = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return [mutableString stringByReplacingOccurrencesOfString:@"'" withString:@""];
}

@end
