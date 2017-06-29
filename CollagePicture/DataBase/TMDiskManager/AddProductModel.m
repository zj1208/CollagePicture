//
//  AddProductModel.m
//  YiShangbao
//
//  Created by simon on 17/2/16.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "AddProductModel.h"

@implementation AddProductModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"pics" : @"pics",
             @"name" :@"name",
             @"labels":@"labels",
             @"sysCateId":@"sysCateId",
             @"sysCateName" :@"sysCateName",
             @"productId" :@"id",
             @"model":@"model",
             @"spec":@"spec",
             @"desc":@"desc",
             @"isMain":@"isMain",
             @"sourceType" :@"sourceType",
             @"minQuantity" :@"minQuantity",
             @"price" :@"price",
             @"priceUnit":@"priceUnit",
             @"volumn":@"volumn",
             @"weight" :@"weight",
             @"number":@"number",
             @"unitInBox" :@"unitInBox",
             @"isOnshelve":@"isOnshelve",
             @"status" :@"status"
                 
             };
}

+ (NSValueTransformer *)picsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[AliOSSPicUploadModel class]];
}
@end



@implementation AliOSSPicUploadModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"h" : @"h",
             @"p" : @"p",
             @"w" : @"w",
             };
}
@end

