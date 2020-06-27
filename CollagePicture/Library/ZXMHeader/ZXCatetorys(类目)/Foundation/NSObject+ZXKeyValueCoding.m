//
//  NSObject+ZXKeyValueCoding.m
//  MerchantBusinessClient
//
//  Created by simon on 2020/6/15.
//  Copyright © 2020 com.Chs. All rights reserved.
//

#import "NSObject+ZXKeyValueCoding.h"

@implementation NSObject (ZXKeyValueCoding)


- (NSInteger)zx_sumNum:(NSUInteger)n
{
    NSUInteger sum = 0;
    for (int i = 0; i <= n; i++) {
        sum += i;
    }
    return sum;
}

- (BOOL)zx_isEvenNumber:(NSUInteger)n
{
    if (n%2 == 0) {
        return true;
    }
    return false;
}
@end
