//
//  NSDecimalNumber+ZXCategory.m
//  MobileCaiLocal
//
//  Created by simon on 2019/12/3.
//  Copyright © 2019 timtian. All rights reserved.
//

#import "NSDecimalNumber+ZXCategory.h"


@implementation NSDecimalNumber (ZXCategory)


+ (NSDecimalNumber *)zx_dividing100WithScale:(short)scale withIntegerNumberString:(NSString *)number
{
    NSDecimalNumber*decimal_A = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%lld",[number longLongValue]]locale:[NSLocale currentLocale]];
    NSDecimalNumber*dividing_100 = [NSDecimalNumber decimalNumberWithString:@"100"];
    NSDecimalNumberHandler *RoundDown  = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:scale raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    NSDecimalNumber *finally_A = [decimal_A decimalNumberByDividingBy:dividing_100 withBehavior:RoundDown];
    return finally_A;
}

+ (NSDecimalNumber *)zx_decimalNumberByDividingWithNumberString:(NSString *)number withDividingString:(nullable NSString *)numberValue withScale:(short)scale
{
    NSString *str = [NSString stringWithFormat:@"%lld",[number longLongValue]];
    NSDecimalNumber*decimal_A = [NSDecimalNumber decimalNumberWithString:str locale:[NSLocale currentLocale]];
    NSDecimalNumber*dividing_num = [NSDecimalNumber decimalNumberWithString:numberValue];
    NSDecimalNumberHandler *RoundDown  = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:scale raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    NSDecimalNumber *finally_A = [decimal_A decimalNumberByDividingBy:dividing_num withBehavior:RoundDown];
    return finally_A;
}
@end
