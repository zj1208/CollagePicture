//
//  ZXAdvModel.m
//  YiShangbao
//
//  Created by simon on 17/3/26.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXAdvModel.h"

@implementation ZXAdvModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"pic" : @"pic",
             @"desc" : @"desc",
             @"url" :@"url",
             @"advId":@"advId"
             };
}

- (instancetype)initWithDesc:(nullable NSString *)desc picString:(nullable NSString *)picString url:(nullable NSString *)url advId:(nullable NSNumber *)aId
{
    self = [super init];
    if (self)
    {
        self.desc = desc;
        self.pic =picString;
        self.url =url;
        self.advId = aId;
    }
    return self;

}
@end
