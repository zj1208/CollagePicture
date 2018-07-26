//
//  NSString+ZXHTMLString.h
//  YiShangbao
//
//  Created by simon on 2018/3/30.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ZXHTMLString)

// 获取<img>标签个数
+ (NSUInteger)zhGetImgSrcCountWithHTMLString:(NSString *)htmlString;

@end
