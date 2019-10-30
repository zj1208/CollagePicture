//
//  ZXLocation.h
//  areapicker
//
//  Created by simon on 14-9-9.
//  Copyright (c) 2014年 simon.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXLocation : NSObject

@property (copy, nonatomic) NSString *country; //国家
@property (copy, nonatomic) NSString *state;//省份
@property (copy, nonatomic) NSString *city; //城市
@property (copy, nonatomic) NSString *district;//区
@property (copy, nonatomic) NSString *street;//街道
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

@end
