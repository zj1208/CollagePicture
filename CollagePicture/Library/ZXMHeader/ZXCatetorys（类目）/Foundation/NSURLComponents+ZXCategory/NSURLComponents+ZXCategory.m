//
//  NSURLComponents+ZXCategory.m
//  YiShangbao
//
//  Created by simon on 17/5/25.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "NSURLComponents+ZXCategory.h"

@implementation NSURLComponents (ZXCategory)


- (void)zhSetQueryItemValue:(nullable NSString *)value forKey:(NSString *)key
{
    //如果已经有这个参数，则移除；
    NSMutableArray *queryItems = [NSMutableArray arrayWithArray:self.queryItems];
    [queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.name isEqualToString:key])
        {
            [queryItems removeObject:obj];
        }
    }];
    //新增一个参数Item：根据name，value
    NSURLQueryItem *item = [NSURLQueryItem queryItemWithName:key value:value];
    [queryItems addObject:item];
    self.queryItems = queryItems;
}


- (nullable NSString *)zhObjectForKey:(NSString *)key
{
    __block NSString *value = nil;
    [self.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.name isEqualToString:key])
        {
            value = obj.value;
        }
    }];
    return value;
 
}
@end
