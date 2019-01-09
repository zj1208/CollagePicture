//
//  UIControl+ZXFastClick.h
//  YiShangbao
//
//  Created by simon on 17/4/5.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  简介：解决遇到异步请求；连续快速点击二次及以上的事件处理忽略；
//  添加注释
//  2018.01.10 添加注释
//  2019.01.07 添加 NS_ASSUME_NONNULL_BEGIN

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (ZXFastClick)


@property (nonatomic, assign) NSTimeInterval timeInterval;

@end

NS_ASSUME_NONNULL_END
