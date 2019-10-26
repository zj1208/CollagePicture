//
//  UploadTable.m
//  Baby
//
//  Created by simon on 16/3/19.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "UploadTable.h"

@implementation UploadTable


+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"uploadId" : @"uploadId",
             @"upload_imagesModels" : @"upload_imagesModels",
             @"upload_progressType" : @"upload_progressType",
             @"upload_showProgress" : @"upload_showProgress",
             @"starting":@"starting"
             };

    }



- (BOOL)isStarting
{
    return _starting;
}
@end
