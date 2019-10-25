//
//  NSAttributedString+ZXCategory.h
//  YiShangbao
//
//  Created by simon on 2018/6/25.
//  Copyright © 2018年 com.Microants. All rights reserved.
//
//  可以增加很多类目便捷方法；

#import <Foundation/Foundation.h>

@interface NSAttributedString (ZXCategory)



- (NSAttributedString *)addLineSpace:(float)lineSpace;


/// 字符串关键字检索高亮
/// @param searchString 搜索关键字
/// @param block 回调
- (void)zx_enumerateRangeOfString:(NSString *)searchString usingBlock:(void(^)(NSRange searchStringRange,NSUInteger idx, BOOL *stop))block;


//- (void)addForegroundColor:(UIColor *)color range:(NSRange)range;
@end
