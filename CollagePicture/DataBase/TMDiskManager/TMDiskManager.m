//
//  TMDiskManager.m
//  YiShangbao
//
//  Created by simon on 17/2/16.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "TMDiskManager.h"

@implementation TMDiskManager


- (instancetype)initWithObjectKey:(NSString *)objectKey
{
    if (self = [super init])
    {
        self.objectKey = objectKey;
    }
    return self;
}


- (void)setPropertyImplementationValue:(id)value forKey:(NSString *)key
{
    if (!key)
    {
        return;
    }
    id object = [self getData]; 
    [object setValue:value forKey:key];
    [self setData:object];
}


- (void)setData:(id)object
{
    if (!object)
    {
        return;
    }
    [[TMDiskCache sharedCache]removeObjectForKey:self.objectKey];
    [[TMDiskCache sharedCache] setObject:object forKey:self.objectKey];
    [[NSNotificationCenter defaultCenter]postNotificationName:self.objectKey object:self];
}

- (id)getData
{
    id object = [[TMDiskCache sharedCache] objectForKey:self.objectKey];
    if (!object)
    {
        NSLog(@"你还没有创建数据");
    }
    return object;
}



- (void)removeData
{
    TMDiskCache *disk = [TMDiskCache sharedCache];
    [disk removeObjectForKey:self.objectKey];
}


@end


