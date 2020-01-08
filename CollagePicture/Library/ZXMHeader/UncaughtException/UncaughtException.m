//
//  UncaughtException.m
//  iflying
//
//  Created by simon on 14-1-7.
//  Copyright (c) 2014年 yinyuetai.com. All rights reserved.
//

#import "UncaughtException.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";

volatile int32_t UncaughtExceptionCount = 0;
const int32_t UncaughtExceptionMaximum = 10;

const NSInteger UncaughtExceptionHandlerSkipAddressCount = 4;
const NSInteger UncaughtExceptionHandlerReportAddressCount = 5;
@implementation UncaughtException


+ (NSArray *)backtrace
{
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (
         i = UncaughtExceptionHandlerSkipAddressCount;
         i < UncaughtExceptionHandlerSkipAddressCount +
         UncaughtExceptionHandlerReportAddressCount;
         i++)
    {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    
    return backtrace;
}


- (void)validateAndSaveCriticalApplicationData
{
    
}

- (void)handleException:(NSException *)exception
{
    [self validateAndSaveCriticalApplicationData];
    
    NSString *message = [NSString stringWithFormat:NSLocalizedString(
                                                                     @"如果点击继续，程序有可能会出现其他的问题，建议您还是点击退出按钮并重新打开\n\n"
                                                                     @"异常原因如下:\n%@\n%@", nil),
                         [exception reason],
                         [[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey]];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"抱歉，程序出现了异常", nil) message:message preferredStyle:UIAlertControllerStyleAlert];
    __weak __typeof (&*self)weakSelf = self;
    UIAlertAction *action1 =[UIAlertAction actionWithTitle:NSLocalizedString(@"退出", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        weakSelf.dismissed = YES;
    }];
    UIAlertAction *action2 =[UIAlertAction actionWithTitle:NSLocalizedString(@"继续", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"ssssssss");
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    UIViewController *vc = window.rootViewController;
    [vc presentViewController:alert animated:YES completion:nil];
    
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
    
    while (!self.dismissed)
    {
        for (NSString *mode in (__bridge NSArray *)allModes)
        {
            CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
        }
    }
    
    CFRelease(allModes);
    
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    
    if ([[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName])
    {
        kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]);
    }
    else
    {
        [exception raise];
    }
}

@end

void HandleException(NSException *exception)
{
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum)
    {
        return;
    }
    
    NSArray *callStack = [UncaughtException backtrace];
    NSMutableDictionary *userInfo =
    [NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
    [userInfo
     setObject:callStack
     forKey:UncaughtExceptionHandlerAddressesKey];
    
    [[[UncaughtException alloc] init]
     performSelectorOnMainThread:@selector(handleException:)
     withObject:
     [NSException
      exceptionWithName:[exception name]
      reason:[exception reason]
      userInfo:userInfo]
     waitUntilDone:YES];
}

void SignalHandler(int signal)
{
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum)
    {
        return;
    }
    
    NSMutableDictionary *userInfo =[NSMutableDictionary dictionaryWithObject:@(signal)
     forKey:UncaughtExceptionHandlerSignalKey];
    
    NSArray *callStack = [UncaughtException backtrace];
    [userInfo setObject:callStack forKey:UncaughtExceptionHandlerAddressesKey];
    
    NSString *reason = [NSString stringWithFormat:NSLocalizedString(@"Signal %d was raised.", nil),signal];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:@(signal) forKey:UncaughtExceptionHandlerSignalKey];
    UncaughtException *unException = [[UncaughtException alloc] init];
    
    NSException *exception = [NSException exceptionWithName:UncaughtExceptionHandlerSignalExceptionName reason:reason userInfo:dic];

    [unException performSelectorOnMainThread:@selector(handleException:) withObject:exception waitUntilDone:YES];
}

void InstallUncaughtExceptionHandlers(void)
{
    //如果有异常崩溃就会调用 方法UncaughtExceptionHandler
    NSSetUncaughtExceptionHandler(&HandleException);
    //如果有signal-SIGABRT崩溃就会调用这个
    signal(SIGABRT, SignalHandler);
    signal(SIGILL, SignalHandler);
    signal(SIGSEGV, SignalHandler);
    signal(SIGFPE, SignalHandler);
    signal(SIGBUS, SignalHandler);
    signal(SIGPIPE, SignalHandler);
}
