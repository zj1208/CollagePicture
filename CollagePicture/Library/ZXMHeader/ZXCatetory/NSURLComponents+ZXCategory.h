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
 设置某个参数name及value；如果参数name已有，则会覆盖新的value；

 @param value queryItemvalue
 @param name queryItemName
 */
- (void)zhSetQueryItemValue:(nullable NSString *)value forKey:(NSString *)name;

/**
 获取一个参数的value
 
 @param name 参数name
 @return 参数对应的value
 */

- (nullable NSString *)zhObjectForKey:(NSString *)name;
@end



NS_ASSUME_NONNULL_END
