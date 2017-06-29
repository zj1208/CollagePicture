//
//  NSURLComponents+ZXCategory.m
//  YiShangbao
//
//  Created by simon on 17/5/25.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "NSURLComponents+ZXCategory.h"

@implementation NSURLComponents (ZXCategory)


- (void)zhSetQueryItemValue:(nullable NSString *)value forKey:(NSString *)name
{
    NSMutableArray *queryItems = [NSMutableArray arrayWithArray:self.queryItems];
    [queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.name isEqualToString:name])
        {
            [queryItems removeObject:obj];
        }
    }];
    NSURLQueryItem *item = [NSURLQueryItem queryItemWithName:name value:value];
    [queryItems addObject:item];
    self.queryItems = queryItems;
}


- (nullable NSString *)zhObjectForKey:(NSString *)name
{
    __block NSString *value = nil;
    [self.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.name isEqualToString:name])
        {
            value = obj.value;
        }
    }];
    return value;
 
}
@end
