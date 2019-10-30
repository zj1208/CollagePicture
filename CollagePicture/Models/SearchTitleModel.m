//
//  SearchTitleModel.m
//  CollagePicture
//
//  Created by 朱新明 on 2019/10/24.
//  Copyright © 2019 simon. All rights reserved.
//

#import "SearchTitleModel.h"

@implementation SearchTitleModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"groupCode" : @"groupCode",
             @"groupName" : @"groupName",
             @"ifPaging" :@"ifPaging",
             @"worlds":@"worlds",
             };

}

+ (NSValueTransformer *)worldsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SearchTitleModelSub class]];
}
@end

@implementation SearchTitleModelSub

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"code" : @"code",
             @"name" : @"name",
             @"preIcon" :@"preIcon",
             @"suffIcon" :@"suffIcon",
             @"bgColor":@"bgColor",
             @"labelColor":@"labelColor",
             @"appUrl":@"appUrl",
             @"htmlUrl":@"htmlUrl",
             };

}
@end
