//
//  BaseModel.m
//  ICBC
//
//  Created by 朱新明 on 15/3/20.
//  Copyright (c) 2015年 朱新明. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{};
}

+ (NSValueTransformer *)URLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

- (void)setNilValueForKey:(NSString *)key
{
    [self setValue:@0 forKey:key]; // For NSInteger/CGFloat/BOOL
}


@end
