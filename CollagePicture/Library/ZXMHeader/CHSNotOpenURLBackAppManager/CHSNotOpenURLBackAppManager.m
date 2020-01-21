//
//  CHSNotOpenURLBackAppManager.m
//  MobileCaiLocal
//
//  Created by simon on 2019/12/30.
//  Copyright © 2019 com.Chs. All rights reserved.
//

#import "CHSNotOpenURLBackAppManager.h"
#import <objc/runtime.h>

NSNotificationName const CHSApplicationNoOpenURLActiveNotification = @"ZXApplicationNoOpenURLActiveNotification";


@implementation CHSNotOpenURLBackAppManager

+ (void)load
{
    Class myClass = NSClassFromString(@"AppDelegate");
    Method originalMethod = class_getInstanceMethod(myClass, @selector(application:openURL:options:));
    
    Method swizzledMethod2 = class_getInstanceMethod([self class], @selector(zxApplication:openURL:options:));
    class_addMethod(myClass, method_getName(swizzledMethod2), method_getImplementation(swizzledMethod2), method_getTypeEncoding(swizzledMethod2));
    
    
    Method swizzledMethod = class_getInstanceMethod(myClass, @selector(zxApplication:openURL:options:));
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

+ (instancetype)sharedInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            
            instance = [self new];
        }
    });
    return instance;
}

- (instancetype)init
{
   [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    return self;
}


- (BOOL)zxApplication:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
//    DLog(@"zxApplication: openURL: options:");
     [CHSNotOpenURLBackAppManager sharedInstance].isOpenURLApplicationBack = YES;
    return [self zxApplication:app openURL:url options:options];
}


- (void)applicationWillEnterForeground:(id)notification
{
    self.isOpenURLApplicationBack = NO;
//    DLog(@"EnterForeground");
    __weak __typeof(&*self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!weakSelf.isOpenURLApplicationBack) {
            [[NSNotificationCenter defaultCenter]postNotificationName:CHSApplicationNoOpenURLActiveNotification object:nil];
        }
    });
}

@end
