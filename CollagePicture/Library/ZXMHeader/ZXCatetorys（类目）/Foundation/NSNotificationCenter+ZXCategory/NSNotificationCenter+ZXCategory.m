//
//  NSNotificationCenter+ZXCategory.m
//  DS
//
//  Created by simon on 2019/7/10.
//  Copyright © 2019 ds. All rights reserved.
//

#import "NSNotificationCenter+ZXCategory.h"

@implementation NSNotificationCenter (ZXCategory)

+ (void)load
{
    Method originMethod = class_getInstanceMethod([self class], @selector(removeObserver:));
    Method swizzledMethod = class_getInstanceMethod([self class], @selector(zx_removeObserver:));
    method_exchangeImplementations(originMethod, swizzledMethod);
}

- (void)zx_removeObserver:(id)observer
{
    NSLog(@"移除通知 -> observer = %@", observer);
    [self zx_removeObserver:observer];
}

@end
