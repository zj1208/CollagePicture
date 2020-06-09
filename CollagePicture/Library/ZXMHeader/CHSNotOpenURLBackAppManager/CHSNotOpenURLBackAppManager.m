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
    
//    openURL方式
    Method originalMethod = class_getInstanceMethod(myClass, @selector(application:openURL:options:));
    
    Method swizzledMethod = class_getInstanceMethod([self class], @selector(zx_application:openURL:options:));
    class_addMethod(myClass, method_getName(swizzledMethod), method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    Method swizzledMethod2 = class_getInstanceMethod(myClass, @selector(zx_application:openURL:options:));
    method_exchangeImplementations(originalMethod, swizzledMethod2);
    
//    通用链接方式
//    Method originalMethod_n = class_getInstanceMethod(myClass, @selector(application:continueUserActivity:restorationHandler:));
//    
//    Method swizzledMethod_n = class_getInstanceMethod([self class], @selector(zx_application:continueUserActivity:restorationHandler:));
//    class_addMethod(myClass, method_getName(swizzledMethod_n), method_getImplementation(swizzledMethod_n), method_getTypeEncoding(swizzledMethod_n));
//    
//    Method swizzledMethod2_n = class_getInstanceMethod(myClass, @selector(zx_application:continueUserActivity:restorationHandler:));
//    method_exchangeImplementations(originalMethod_n, swizzledMethod2_n);
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


- (BOOL)zx_application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
//    DLog(@"zxApplication: openURL: options:");
     [CHSNotOpenURLBackAppManager sharedInstance].isOpenURLApplicationBack = YES;
    return [self zx_application:app openURL:url options:options];
}

//- (BOOL)zx_application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler{
//
//    [CHSNotOpenURLBackAppManager sharedInstance].isOpenURLApplicationBack = YES;
//    return [self zx_application:application continueUserActivity:userActivity restorationHandler:restorationHandler];
//}

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
