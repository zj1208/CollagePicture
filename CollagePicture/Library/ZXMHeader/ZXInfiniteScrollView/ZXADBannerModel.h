//
//  ZXADBannerModel.h
//  baohuai_iPhone
//
//  Created by 朱新明 on 14/5/2.
//  Copyright (c) 2014年 朱新明. All rights reserved.
//
//  2018.3.21 添加areaId

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface ZXADBannerModel : NSObject


@property (nonatomic, copy, nullable) NSString *pic;
@property (nonatomic, copy, nullable) NSString *desc;
//跳转地址链接-(可以加自己业务，也可以为h5)
@property (nonatomic, copy, nullable) NSString *url;
@property (nonatomic, strong, nullable) NSNumber *advId;

@property (nonatomic, strong, nullable) NSNumber *areaId;


- (instancetype)initWithDesc:(nullable NSString *)desc picString:(nullable NSString *)picString url:(nullable NSString *)url advId:(nullable NSNumber *)aId;

@end

NS_ASSUME_NONNULL_END



