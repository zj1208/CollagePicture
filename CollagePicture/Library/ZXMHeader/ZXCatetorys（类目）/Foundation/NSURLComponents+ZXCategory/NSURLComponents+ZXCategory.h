//
//  NSURLComponents+ZXCategory.h
//  YiShangbao
//
//  Created by simon on 17/5/25.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURLComponents (ZXCategory)

/**
 设置某个参数key及value；如果参数key已有，则会覆盖新的value；

 @param value NSURLQueryItem.Value
 @param key   NSURLQueryItem.Name
 */
- (void)zhSetQueryItemValue:(nullable NSString *)value forKey:(NSString *)key;

/**
 获取一个参数的value
 
 @param key NSURLQueryItem的name
 @return    参数对应的value
 */

- (nullable NSString *)zhObjectForKey:(NSString *)key;


- (void)jlRemoveObjectForKey:(NSString *)key;

@end



NS_ASSUME_NONNULL_END
