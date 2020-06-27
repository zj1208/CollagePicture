//
//  NSObject+ZXKeyValueCoding.h
//  MerchantBusinessClient
//
//  Created by simon on 2020/6/15.
//  Copyright © 2020 com.Chs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ZXKeyValueCoding)


/// 求和，获取1到n的所有数的和；
/// @param n 指定累加截止数；
- (NSInteger)zx_sumNum:(NSUInteger)n;



/// 判断一个数是否是偶数
/// @param n 指定判断的数
- (BOOL)zx_isEvenNumber:(NSUInteger)n;


@end

NS_ASSUME_NONNULL_END
