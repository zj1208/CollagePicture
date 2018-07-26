//
//  PageModel.m
//  Baby
//
//  Created by simon on 16/1/19.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "PageModel.h"

@implementation PageModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"currentPage" : @"currentPage",
             @"pageSize" : @"pageSize",
             @"totalPage" : @"totalPage",
             @"totalCount" : @"totalCount"
             };
}


@end
