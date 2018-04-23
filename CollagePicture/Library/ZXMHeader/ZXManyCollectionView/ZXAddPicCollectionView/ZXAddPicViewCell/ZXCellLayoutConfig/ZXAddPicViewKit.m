//
//  ZXAddPicViewKit.m
//  YiShangbao
//
//  Created by simon on 2018/4/18.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "ZXAddPicViewKit.h"


@implementation ZXAddPicViewKit

- (instancetype)init
{
    if (self = [super init]) {
 
        _cellLayoutConfig = [[ZXCellLayoutConfig alloc] init];
    }
    return self;
}


+ (instancetype)sharedKit
{
    static ZXAddPicViewKit *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZXAddPicViewKit alloc] init];
    });
    return instance;
}

- (void)registerLayoutConfig:(ZXCellLayoutConfig *)layoutConfigClass
{
    if ([layoutConfigClass isKindOfClass:[ZXCellLayoutConfig class]])
    {
        self.cellLayoutConfig = layoutConfigClass;
    }
    else
    {
        NSAssert(0, @"class should be subclass of NIMLayoutConfig");
    }
}


- (id<ZXCellLayoutConfigSource>)layoutConfig
{
    return _cellLayoutConfig;
}

@end
