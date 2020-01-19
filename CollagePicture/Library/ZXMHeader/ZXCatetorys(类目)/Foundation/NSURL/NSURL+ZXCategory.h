//
//  NSURL+ZXCategory.h
//  YiShangbao
//
//  Created by simon on 17/5/25.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
// 2019.12.18 优化

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
+ (nullable instancetype)zx_URLWithString:(nullable NSString *)urlString queryItemValue:(nullable NSString *)value forKey:(nullable NSString *)name;



/**
 获取一个URL地址的某个参数的value；

 在遇到key-value形式&拼接的字符串，比如阿里Inside返回的字段，可以自己先创建虚拟URL，然后再获取value；
 例如：
 NSString *boby =@"success=true&auth_code=21d0bf2ffdc64f9b860151b2984dQF42&result_code=200&alipay_open_id=2019070365769458&user_id=2088002688409423";
 NSURL *url =  [NSURL URLWithString:[NSString stringWithFormat:@"chs://paymentCode?%@",boby]];
 NSString *auth_code = [url zx_URLQueryItemObjectForKey:@"auth_code"];
 
 @param name 参数name
 @return 参数对应的value
 */
- (nullable id)zx_URLQueryItemObjectForKey:(NSString *)name;


/**
 设置一个URL地址的参数

 @param value 参数value
 @param name 参数名
 @return 新的URL
 */
- (nullable instancetype)zx_URLQueryItemSetValue:(nullable NSString *)value forKey:(nullable NSString *)name;
@end

NS_ASSUME_NONNULL_END
