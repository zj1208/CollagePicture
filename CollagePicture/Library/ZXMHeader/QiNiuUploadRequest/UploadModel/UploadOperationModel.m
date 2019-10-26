//
//  UploadOperationModel.m
//  lovebaby
//
//  Created by simon on 16/6/1.
//  Copyright © 2016年 . All rights reserved.
//

#import "UploadOperationModel.h"

@implementation UploadOperationModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"operationId": @"id",
             @"subjectId": @"subjectId",
             @"type":@"type"
             };
}

@end

@implementation GrowthSavePhotoModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             
            };
}

@end

