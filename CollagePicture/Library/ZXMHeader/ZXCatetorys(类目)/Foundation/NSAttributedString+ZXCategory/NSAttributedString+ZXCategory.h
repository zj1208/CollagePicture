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
//  2019.12.03 遍历数学数字
//  2020.01.21 优化
//  2020.02.07 优化遍历数字小数的方法；
//  2020.3.23  修改遍历数字小数的方法bug。

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSAttributedString (ZXCategory)



/// 设置行距
/// @param lineSpace 行距大小
- (NSAttributedString *)zx_addLineSpace:(float)lineSpace;


/**
 检索富文本字符串的关键字，并返回字符串中给定searchString字符串每次出现的frange范围。
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
在富文本字符串中添加删除线（）；

*/
+ (NSAttributedString *)zx_addStrikethroughCenterWithString:(NSString *)str;

/*
 在富文本字符串中给指定文本添加删除线，设置删除线颜色；
 
 */
- (NSAttributedString *)zx_addStrikethroughCenterWithCenterlineString:(NSString *)centerlineString centerLineColor:(UIColor *)color;

//- (void)addForegroundColor:(UIColor *)color range:(NSRange)range;



/// 遍历数学数字,以小数点为分割获取小数点前整数的stringRange，小数点后数字的range；例如10.55;如果小数点前置或后置searchString没有找到或为空("”),不返回{NSNotFound, 0}; //2020.3.23 修改bug。
/// @param prefixBlock 小数点前置的字符串Range的block;
/// @param suffixBlock 小数点后置的range；
///  例如：    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:model.todaySalesVolume];
///  [attString zx_enumerateDecimalNumberWithDotSeperateUsingDotPrefixBlock:nil dotSuffixBlock:^(NSRange dotSuffixRange) {
///              [attString addAttributes:@{NSFontAttributeName: [UIFont zx_systemFontOfScaleSize:32 weight:UIFontWeightMedium]} range:NSMakeRange(dotSuffixRange.location-1, dotSuffixRange.length+1)];
///}];
- (void)zx_enumerateDecimalNumberWithDotSeperateUsingDotPrefixBlock:(void(^)(NSRange dotPrefixRange))prefixBlock dotSuffixBlock:(void(^)(NSRange dotSuffixRange))suffixBlock;

@end
