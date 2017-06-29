//
//  UploadOperationModel.m
//  lovebaby
//
//  Created by simon on 16/6/1.
//  Copyright © 2016年 厦门致上信息科技有限公司. All rights reserved.
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

