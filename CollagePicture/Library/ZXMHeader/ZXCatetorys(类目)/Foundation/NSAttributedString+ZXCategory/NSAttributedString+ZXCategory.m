//
//  NSAttributedString+ZXCategory.m
//  YiShangbao
//
//  Created by simon on 2018/6/25.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "NSAttributedString+ZXCategory.h"
#import <UIKit/UIKit.h>

@implementation NSAttributedString (ZXCategory)

- (NSAttributedString *)zx_addLineSpace:(float)lineSpace
{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithAttributedString:self];
    NSMutableParagraphStyle * style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineSpacing = lineSpace;//行距
    [attString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attString.length)];
    return attString;
}

- (void)zx_enumerateRangeOfString:(NSString *)searchString usingBlock:(void(^)(NSRange searchStringRange,NSUInteger idx, BOOL *stop))block
{
    if (self.length && searchString.length) {
        
        NSArray <NSString *>*separatedArray = [self.string componentsSeparatedByString:searchString];
        if (separatedArray.count <2) {
            return;
        }
        NSUInteger count = separatedArray.count -1;
        NSUInteger length = searchString.length;
        __block NSUInteger location = 0;
        [separatedArray enumerateObjectsUsingBlock:^(NSString * _Nonnull componentString, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == count) {
                *stop = YES;
            }else{
                location += componentString.length;//跳过待筛选串前面的串长度
                if (block) {
                    block(NSMakeRange(location, length),idx,stop);
                }
                location += length;//跳过待筛选串的长度
            }
        }];
    }
}

+ (NSAttributedString *)zx_addStrikethroughCenterWithString:(NSString *)str
{
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSAttributedString *attStr = [[NSAttributedString alloc]initWithString:str attributes:attribtDic];
    return attStr;
}

- (NSAttributedString *)zx_addStrikethroughCenterWithCenterlineString:(NSString *)centerlineString centerLineColor:(UIColor *)color
{
    NSMutableAttributedString *attMString = [[NSMutableAttributedString alloc] initWithAttributedString:self];
    if (centerlineString)
    {
         NSRange itemRange = [self.string rangeOfString:centerlineString];
         [attMString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleSingle) range:itemRange];
         if (color)
         {
             [attMString addAttribute:NSStrikethroughColorAttributeName value:color range:itemRange];
         }
     }
    return attMString;
}
//- (NSAttributedString *)addForegroundColor:(UIColor *)color range:(NSRange)range
//{
//    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithAttributedString:self];
//    [attString addAttribute:NSForegroundColorAttributeName value:color range:range];
//    return attString;
//}
@end
