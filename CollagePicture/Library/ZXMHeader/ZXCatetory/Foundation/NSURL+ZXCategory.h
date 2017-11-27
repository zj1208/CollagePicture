//
//  NSURL+ZXCategory.h
//  YiShangbao
//
//  Created by simon on 17/5/25.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (ZXCategory)


/**
 根据urlString初始化一个URL，同时设置某个参数name及value；如果参数name已有，则会覆盖新的value；
 如果urlString错误的（代特殊字符的），则返回nil；

 @param urlString url原始地址
 @param value 参数值
 @param name 参数名
 @return 一个URL；
 */
+ (nullable instancetype)zhURLWithString:(nullable NSString *)urlString queryItemValue:(nullable NSString *)value forKey:(nullable NSString *)name;



/**
 获取一个URL地址的某个参数的value

 @param name 参数name
 @return 参数对应的value
 */
- (nullable id)zhURLQueryItemObjectForKey:(NSString *)name;


/**
 设置一个URL地址的参数

 @param value 参数value
 @param name 参数名
 @return 新的URL
 */
- (nullable instancetype)zhURLQueryItemSetValue:(nullable NSString *)value forKey:(nullable NSString *)name;
@end

NS_ASSUME_NONNULL_END
