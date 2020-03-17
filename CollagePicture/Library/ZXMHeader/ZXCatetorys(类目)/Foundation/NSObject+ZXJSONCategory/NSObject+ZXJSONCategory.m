//
//  NSObject+ZXJSONCategory.m
//  MerchantBusinessClient
//
//  Created by 朱新明 on 2020/2/2.
//  Copyright © 2020 com.Chs. All rights reserved.
//

#import "NSObject+ZXJSONCategory.h"


@implementation NSObject (ZXJSONCategory)


+ (nullable id)zx_getJSONSerializationObjectWithJSONData:(nullable NSData *)data
{
    NSError *error=nil;
    id dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    if (!error && data)
    {
        return dic;
    }
    return nil;
}

+ (nullable id)zx_getJSONSerializationObjectFromString:(nullable NSString *)string
{
    if ([NSString zhIsBlankString:string])
    {
        return nil;
    }
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [NSString zx_getJSONSerializationObjectWithJSONData:data];
}

+ (nullable id)zx_getJSONSerializationObjectFromJSON:(id)json
{
    NSData *jsonData = nil;
    if (!json || json == (id)kCFNull) return nil;
    if ([json isKindOfClass:[NSDictionary class]] || [json isKindOfClass:[NSArray class]]) {
        return json;
    }
    else if ([json isKindOfClass:[NSString class]])
    {
        jsonData = [(NSString *)json dataUsingEncoding : NSUTF8StringEncoding];
    }
    else if ([json isKindOfClass:[NSData class]]) {
        jsonData = json;
    }
    NSError *error=nil;
    id dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    if (!error && jsonData)
    {
        return dic;
    }
    return nil;
}

+ (nullable id)zx_getJSONSerializationObjectFromContentsOfFile:(NSString *)path
{
//    NSString *path = [[NSBundle mainBundle]pathForResource:@"ZXPrivacyPolicy" ofType:@"json"];
//    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error = nil;
    id dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    if (error==nil && data!=nil)
    {
        return dic;
    }
    return nil;

}

+ (NSString *)zx_getJSONSerializationStringFromJSONObject:(nullable id)responseObject
{
    if ([NSJSONSerialization isValidJSONObject:responseObject])
    {
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&error];
        if (!error && data!=nil)
        {
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSString *escapeString = [NSString zx_filterEscapeCharacterWithJsonString:str];
            return escapeString;
        }
    }
    return nil;
}

//过滤转义字符
+ (NSString *)zx_filterEscapeCharacterWithJsonString:(NSString *)str
{
    NSMutableString *responseString = [NSMutableString stringWithString:str];
    NSString *character = nil;
    for (int i = 0; i < responseString.length; i ++) {
        character = [responseString substringWithRange:NSMakeRange(i, 1)];
        if ([character isEqualToString:@"\\"])
            [responseString deleteCharactersInRange:NSMakeRange(i, 1)];
    }
    return responseString;
}







@end
