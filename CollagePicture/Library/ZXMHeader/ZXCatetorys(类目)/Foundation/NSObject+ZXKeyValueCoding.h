//
//  NSObject+ZXKeyValueCoding.h
//  MerchantBusinessClient
//
//  Created by simon on 2020/6/15.
//  Copyright © 2020 com.Chs. All rights reserved.
//
//  2020.8.01

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ZXKeyValueCoding)


/// 求和，获取1到n的所有数的和；
/// @param n 指定累加截止数；
- (NSInteger)zx_sumNum:(NSUInteger)n;



/// 判断一个数是否是偶数
/// @param n 指定判断的数
- (BOOL)zx_isEvenNumber:(NSUInteger)n;


//组距分列

//根据数据集合确定组数
- (NSInteger)groupNumberOfRespectively:(NSArray *)list;

//根据 组数 和 原始数据集合 来确定组距；每组的上限和下限之间的距离称为组距。通常用5和10的倍数来作组距。
- (NSInteger)classIntervalOfRespectively:(NSArray *)list;
@end

NS_ASSUME_NONNULL_END
