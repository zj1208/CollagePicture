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
 
        _cellLayoutConfig = [[ZXAddPicCellLayoutConfig alloc] init];
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

- (void)registerLayoutConfig:(ZXAddPicCellLayoutConfig *)layoutConfigClass
{
   
    if ([layoutConfigClass isKindOfClass:[ZXAddPicCellLayoutConfig class]])
    {
        self.cellLayoutConfig = layoutConfigClass;
    }
    else
    {
        NSAssert(0, @"class should be subclass of NIMLayoutConfig");
    }
}

+ (void)resetLayoutConfig
{
    [ZXAddPicViewKit sharedKit].cellLayoutConfig = [[ZXAddPicCellLayoutConfig alloc] init];
}

- (id<ZXAddPicCellLayoutConfigSource>)layoutConfig
{
    return _cellLayoutConfig;
}

@end
