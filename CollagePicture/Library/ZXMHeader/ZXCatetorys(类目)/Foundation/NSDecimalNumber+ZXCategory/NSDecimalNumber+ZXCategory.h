//
//  NSDecimalNumber+ZXCategory.h
//  MobileCaiLocal
//
//  Created by simon on 2019/12/3.
//  Copyright © 2019 timtian. All rights reserved.
//



#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDecimalNumber (ZXCategory)



/// 返回的对象=number/100,且会忽略小数点后末尾的所有0;
/// @param scale 小数点保留几位
/// @param number 整型数字字符串，一般价格数字以分为单位，如500分；
+ (NSDecimalNumber *)zx_dividing100WithScale:(short)scale withIntegerNumberString:(NSString *)number;



@end

NS_ASSUME_NONNULL_END
