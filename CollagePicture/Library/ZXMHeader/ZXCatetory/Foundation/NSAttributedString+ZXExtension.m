//
//  NSAttributedString+ZXExtension.m
//  YiShangbao
//
//  Created by simon on 2018/6/25.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "NSAttributedString+ZXExtension.h"

@implementation NSAttributedString (ZXExtension)

- (NSAttributedString *)addLineSpace:(float)lineSpace
{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithAttributedString:self];
    NSMutableParagraphStyle * style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineSpacing = lineSpace;//行距
    [attString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attString.length)];
    return attString;
}


//- (NSAttributedString *)addForegroundColor:(UIColor *)color range:(NSRange)range
//{
//    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithAttributedString:self];
//    [attString addAttribute:NSForegroundColorAttributeName value:color range:range];
//    return attString;
//}
@end
