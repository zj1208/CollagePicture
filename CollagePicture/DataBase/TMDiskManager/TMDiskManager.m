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
    [self setPropertyImplementationValue:value forKey:key postNotification:YES];
}

- (void)setPropertyImplementationValue:(id)value forKey:(NSString *)key postNotification:(BOOL)flag
{
    if (!key)
    {
        return;
    }
    id object = [self getData];
    if (!object)
    {
        return;
    }
    [object setValue:value forKey:key];
    [[TMDiskCache sharedCache] removeObjectForKey:self.objectKey];
    [[TMDiskCache sharedCache] setObject:object forKey:self.objectKey];
    if (flag)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:self.objectKey object:nil];
    }
}



- (void)setData:(id)object
{
    if (!object)
    {
        return;
    }
    [[TMDiskCache sharedCache]removeObjectForKey:self.objectKey];
    [[TMDiskCache sharedCache] setObject:object forKey:self.objectKey];
//    [[NSNotificationCenter defaultCenter]postNotificationName:self.objectKey object:self];
}

- (nullable id)getData
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


