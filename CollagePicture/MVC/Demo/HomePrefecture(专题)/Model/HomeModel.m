//
//  HomeModel.m
//  MobileCaiLocal
//
//  Created by 朱新明 on 2019/10/31.
//  Copyright © 2019 timtian. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel

@end


@implementation HomePrefectureModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"templateTypeCode" : @"templateTypeCode",
             @"specialAreaName" : @"specialAreaName",
             @"banners" :@"banners",
             };

}

+ (NSValueTransformer *)bannersJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[HomePrefectureModelSubBanner class]];
}
@end

@implementation HomePrefectureModelSubBanner

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"bannerId" : @"bannerId",
             @"backgroundPhoto" : @"backgroundPhoto",
             @"name" :@"name",
             @"nameColor" :@"nameColor",
             @"descriptionText" :@"description",
             @"descriptionColor" :@"descriptionColor",

             @"preIcon" :@"preIcon",
             @"suffIcon" :@"suffIcon",
             @"appUrl":@"appUrl",
             @"htmlUrl":@"htmlUrl",
             
             @"displayType":@"displayType",

             };

}

@end

@implementation HomePrefectureModelSubBannerSub

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"photo" : @"photo",
             @"salePrice" : @"salePrice",
             @"referencePrice" :@"referencePrice",
             };

}


@end
