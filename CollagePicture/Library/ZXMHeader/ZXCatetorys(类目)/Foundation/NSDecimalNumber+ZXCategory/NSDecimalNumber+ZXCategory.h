//
//  NSDecimalNumber+ZXCategory.h
//  MobileCaiLocal
//
//  Created by simon on 2019/12/3.
//  Copyright © 2019 timtian. All rights reserved.
//
//  2020.2.19 增加除法方法；



#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDecimalNumber (ZXCategory)



/// 返回的对象=number/100,且会忽略小数点后末尾的所有0;
/// @param scale 小数点保留几位
/// @param number 整型数字字符串，一般价格数字以分为单位，如500分；
+ (NSDecimalNumber *)zx_dividing100WithScale:(short)scale withIntegerNumberString:(NSString *)number;


/// 返回的对象=number/numberValue,且会忽略小数点后末尾的所有0;
/// @param number 数字字符串；
/// @param numberValue 除数分母
/// @param scale 小数点保留几位
///    [self decimalNumberByDividingWithNumberString:model.consumeCondition withDividingString:@"1" withScale:2];
+ (NSDecimalNumber *)zx_decimalNumberByDividingWithNumberString:(NSString *)number withDividingString:(nullable NSString *)numberValue withScale:(short)scale;

@end

NS_ASSUME_NONNULL_END
