//
//  NSArray+ZXCategory.m
//  MobileCaiLocal
//
//  Created by simon on 2020/6/4.
//  Copyright © 2020 com.Chs. All rights reserved.
//

#import "NSArray+ZXCategory.h"

@implementation NSArray (ZXCategory)


- (NSArray *)where:(BOOL(^)(id obj))myBlock
{
    if (!self) {
        return nil;
    }else if (self && self.count==0)
    {
        return self;
    }
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:self.count];
    for (id obj in self) {
        BOOL flag =  myBlock(obj);
        if (flag) {
            [arr addObject:obj];
        }
    }
    return arr;
}

- (BOOL)every:(BOOL(^)(id obj))myBlock
{
    if (!self || self.count == 0) {
        return NO;
    }
    for (id obj in self) {
        BOOL flag =  myBlock(obj);
        if (!flag) {
            return NO;
        }
    }
    return YES;
}


- (BOOL)any:(BOOL(^)(id obj))myBlock
{
    if (!self || self.count == 0) {
        return NO;
    }
    for (id obj in self) {
        BOOL flag =  myBlock(obj);
        if (flag) {
            return YES;
        }
    }
    return NO;
}
@end
