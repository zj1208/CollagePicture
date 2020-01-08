//
//  UncaughtException.h
//  iflying
//
//  Created by simon on 14-1-7.
//  Copyright (c) 2014年 yinyuetai.com. All rights reserved.
//
//  2020.1.08 改为只兼容iOS9以上；

#import <Foundation/Foundation.h>

@interface UncaughtException : NSObject

@property (nonatomic, assign) BOOL dismissed;

@end

void InstallUncaughtExceptionHandlers(void);

//appdelegate.m直接调用 InstallUncaughtExceptionHandler();就会全局监听了。
