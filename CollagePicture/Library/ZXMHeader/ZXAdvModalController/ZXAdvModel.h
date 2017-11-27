//
//  ZXAdvModel.h
//  YiShangbao
//
//  Created by simon on 17/3/26.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXAdvModel : NSObject

@property (nonatomic, copy, nullable) NSString *pic;
@property (nonatomic, copy, nullable) NSString *desc;
@property (nonatomic, copy, nullable) NSString *url;
@property (nonatomic, strong, nullable) NSNumber *advId;

- (instancetype)initWithDesc:(nullable NSString *)desc picString:(nullable NSString *)picString url:(nullable NSString *)url advId:(nullable NSNumber *)aId;
@end

NS_ASSUME_NONNULL_END
