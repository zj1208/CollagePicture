//
//  BadgeMarkItemModel.m
//  YiShangbao
//
//  Created by simon on 2018/1/31.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "BadgeMarkItemModel.h"

@implementation BadgeMarkItemModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"icon" : @"icon",
             @"desc" :@"desc",

             @"sideMarkType" :@"sideMarkType",
             @"sideMarkValue" :@"sideMarkValue",
             @"vbrands" :@"vbrands"
             };
}


@end
