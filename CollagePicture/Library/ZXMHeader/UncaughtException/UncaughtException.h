//
//  UncaughtException.h
//  iflying
//
//  Created by 飞扬旅游集团 on 14-1-7.
//  Copyright (c) 2014年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UncaughtException : NSObject
{
	BOOL dismissed;
}

@end

void InstallUncaughtExceptionHandlers(void);

//appdelegate.m直接调用 InstallUncaughtExceptionHandler();就会全局监听了。
