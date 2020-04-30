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

+ (NSAttributedString *)zx_strikethroughTypeSingleWithString:(NSString *)str
{
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSAttributedString *attStr = [[NSAttributedString alloc]initWithString:str attributes:attribtDic];
    return attStr;
}

- (NSAttributedString *)zx_addStrikethroughTypeSingleWithRange:(NSRange)range strikethroughColor:(UIColor *)color 
{
    NSMutableAttributedString *attMString = [[NSMutableAttributedString alloc] initWithAttributedString:self];
    
    if(range.location > self.length || range.length > self.length - range.location)
    {
        [NSException raise:NSRangeException format:@"out of range"];
    }
    [attMString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleSingle) range:range];
    if (color)
    {
        [attMString addAttribute:NSStrikethroughColorAttributeName value:color range:range];
    }
    return attMString;
}

+ (NSAttributedString *)zx_underlineStyleWithString:(NSString *)str
{
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSAttributedString *attStr = [[NSAttributedString alloc]initWithString:str attributes:attribtDic];
    return attStr;
}


- (void)zx_enumerateDecimalNumberWithDotSeperateUsingDotPrefixBlock:(void(^)(NSRange dotPrefixRange))prefixBlock dotSuffixBlock:(void(^)(NSRange dotSuffixRange))suffixBlock
{
    if (self.length) {
         
        NSString *dotPrefixString = nil;
        NSString *dotSuffixString = nil;
        if ([self.string containsString:@"."]) {
           
            NSArray <NSString *>*separatedArray = [self.string componentsSeparatedByString:@"."];
            dotPrefixString = [separatedArray firstObject];
            dotSuffixString = [separatedArray lastObject];
            if (suffixBlock) {
                //当999.99，dotSuffixString也能在小数点前面找到的时候,会返回前面的range[0,2]
//                [self.string rangeOfString:dotSuffixString],会造成错误；
               suffixBlock(NSMakeRange(dotPrefixString.length+1, dotSuffixString.length));
            }
        }
        //没有小数点后面的数字时候，后缀block不回调；
        else
        {
            dotPrefixString = self.string;
            dotSuffixString = @"";
        }
        if (prefixBlock) {
            prefixBlock([self.string rangeOfString:dotPrefixString]);
        }
     }
}


@end
