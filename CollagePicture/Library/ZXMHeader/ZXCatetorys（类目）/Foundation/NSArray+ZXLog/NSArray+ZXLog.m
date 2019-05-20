//
//  NSArray+ZXLog.h
//  YiShangbao
//
//  Created by simon on 2016/11/13.
//  Copyright © 2016年 com.Microants. All rights reserved.
//


#import "NSArray+ZXLog.h"

@implementation NSArray (ZXLog)

- (NSString *)description
{
    return [self descriptionWithLocale:nil];
}

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *strM = [NSMutableString stringWithString:@"(\n"];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
   
        [strM appendFormat:@"\t%@,\n", obj];
    }];
    
    [strM appendString:@")"];
    return strM;
}

@end

@implementation NSDictionary (ZXLog)

- (NSString *)description
{
    return [self descriptionWithLocale:nil];
}

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *strM = [NSMutableString stringWithString:@"{\n"];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
            [strM appendFormat:@"\t%@ = %@;\n", key, obj];
    }];
    
    [strM appendString:@"}\n"];
    
    return strM;
}

@end
