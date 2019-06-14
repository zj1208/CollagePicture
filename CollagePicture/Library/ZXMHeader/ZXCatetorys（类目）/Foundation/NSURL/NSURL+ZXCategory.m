//
//  NSURL+ZXCategory.m
//  YiShangbao
//
//  Created by simon on 17/5/25.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "NSURL+ZXCategory.h"
#import "NSURLComponents+ZXCategory.h"

@implementation NSURL (ZXCategory)

+ (nullable instancetype)zhURLWithString:(NSString *)urlString queryItemValue:(nullable NSString *)value forKey:(nullable NSString *)name;
{
    if (!urlString)
    {
        return nil;
    }
    //有可能url字符串包含特殊字符“[]”，所以必须要转UTF8编码才能初始化URL，NSURLComponents
    if ([urlString canBeConvertedToEncoding:NSUTF8StringEncoding])
    {
       urlString= [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:urlString];
    if (!components)
    {
        return nil;
    }
    if (name)
    {
        [components zhSetQueryItemValue:value forKey:name];
    }

    return components.URL;
}

- (id)zhURLQueryItemObjectForKey:(NSString *)name
{
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:self resolvingAgainstBaseURL:YES];
    if (!components)
    {
        return nil;
    }
    __block id value = nil;
    [components.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.name isEqualToString:name])
        {
            value = obj.value;
        }
    }];
    return value;

}


- (nullable instancetype)zhURLQueryItemSetValue:(nullable NSString *)value forKey:(nullable NSString *)name
{
    NSString *urlString = self.absoluteString;
    if ([urlString canBeConvertedToEncoding:NSUTF8StringEncoding])
    {
        urlString= [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:NO];
    if (!components)
    {
        return nil;
    }
    if (name)
    {
        [components zhSetQueryItemValue:value forKey:name];
    }
    return components.URL;
}

@end
