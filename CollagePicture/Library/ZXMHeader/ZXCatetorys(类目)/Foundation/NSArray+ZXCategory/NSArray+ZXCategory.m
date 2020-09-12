//
//  NSArray+ZXCategory.m
//  MobileCaiLocal
//
//  Created by simon on 2020/6/4.
//  Copyright © 2020 com.Chs. All rights reserved.
//

#import "NSArray+ZXCategory.h"

@implementation NSArray (ZXCategory)


- (NSArray *)zx_where:(BOOL(^)(id obj))testBlock
{
    if (!self) {
        return nil;
    }else if (self && self.count==0)
    {
        return self;
    }
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:self.count];
    for (id obj in self) {
        BOOL flag =  testBlock(obj);
        if (flag) {
            [arr addObject:obj];
        }
    }
    return arr;
}

- (id)zx_map:(id(^)(id obj))fBlock
{
    if (!self) {
        return nil;
    }else if (self && self.count==0)
    {
        return self;
    }
    else if (!fBlock)
    {
       return self;
    }
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:self.count];
    for (id obj in self) {
        id e =  fBlock(obj);
        if (e) {
            [arr addObject:obj];
        }
    }
    return arr;
}


- (BOOL)zx_every:(BOOL(^)(id obj))testBlock
{
    if (!self || self.count == 0) {
        return NO;
    }
    for (id obj in self) {
        if (!testBlock(obj)) return NO;
    }
    return YES;
}



- (BOOL)zx_any:(BOOL(^)(id obj))testBlock
{
    if (!self || self.count == 0) {
        return NO;
    }
    for (id obj in self) {
        BOOL flag =  testBlock(obj);
        if (flag) {
            return YES;
        }
    }
    return NO;
}


- (BOOL)zx_isEmpty
{
    if (self != nil && ![self isKindOfClass:[NSNull class]] && self.count != 0){
        return NO;
    }
    return YES;
}

- (void)zx_forEach:(void(^)(id obj))fBlock
{
    for (id obj in self) {
        fBlock(obj);
    }
}
@end
