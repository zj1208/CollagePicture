//
//  NSString+ZXHTMLString.m
//  YiShangbao
//
//  Created by simon on 2018/3/30.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "NSString+ZXHTMLString.h"

@implementation NSString (ZXHTMLString)

+ (NSUInteger)zhGetImgSrcCountWithHTMLString:(NSString *)htmlString
{
    NSArray *arr =  [htmlString componentsSeparatedByString:@"<img src"];
    return arr.count-1;
}
@end
