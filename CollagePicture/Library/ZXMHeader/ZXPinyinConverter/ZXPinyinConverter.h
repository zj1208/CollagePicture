//
//  ZXPinyinConverter.h
//  YiShangbao
//
//  Created by simon on 2017/11/7.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXPinyinConverter : NSObject

+ (ZXPinyinConverter *)sharedInstance;

- (NSString *)pinyinFromChiniseString:(NSString *)string;

@end
