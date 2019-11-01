//
//  NSAttributedString+ZXCategory.h
//  YiShangbao
//
//  Created by simon on 2018/6/25.
//  Copyright © 2018年 com.Microants. All rights reserved.
//
//  可以增加很多类目便捷方法；
//  2019.10.28  增加关键字检索高亮
//  2019.11.01  增加删除线方法

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSAttributedString (ZXCategory)



/// 设置行距
/// @param lineSpace 行距大小
- (NSAttributedString *)zx_addLineSpace:(float)lineSpace;


/**
 字符串关键字检索高亮
 @param searchString 搜索关键字
 @param block 回调
*/
/*
 NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
  [attributedText zx_enumerateRangeOfString:self.searchText usingBlock:^(NSRange searchStringRange, NSUInteger idx, BOOL * _Nonnull stop) {
      
      [attributedText addAttributes:@{NSForegroundColorAttributeName:[UIColor zx_colorWithHexString:@"34373A"]} range:searchStringRange];
  }];
  cell.textLabel.attributedText = attributedText;
 */
- (void)zx_enumerateRangeOfString:(NSString *)searchString usingBlock:(void(^)(NSRange searchStringRange,NSUInteger idx, BOOL *stop))block;


/*
在富文本字符串中添加删除线；

*/
+ (NSAttributedString *)zx_addStrikethroughCenterWithString:(NSString *)str;
/*
 在富文本字符串中给指定文本添加删除线，设置删除线颜色；
 
 */
- (NSAttributedString *)zx_addStrikethroughCenterWithCenterlineString:(NSString *)centerlineString centerLineColor:(UIColor *)color;

//- (void)addForegroundColor:(UIColor *)color range:(NSRange)range;
@end
