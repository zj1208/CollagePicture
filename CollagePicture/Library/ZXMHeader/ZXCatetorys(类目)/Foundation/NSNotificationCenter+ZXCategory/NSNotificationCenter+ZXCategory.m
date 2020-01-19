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
    Class myClass = self;
    Method originalMethod = class_getInstanceMethod([self class], @selector(removeObserver:));
    Method swizzledMethod = class_getInstanceMethod([self class], @selector(zx_removeObserver:));
    
    //  运行时动态添加系统方法，如果当前类已经存在了同名字的方法实现，就会添加失败；
    BOOL didAddMethod = class_addMethod(myClass, method_getName(originalMethod), method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    //添加同一个方法，如果成功，说明类中不存在这个方法的实现；
    //将被交换方法的实现替换到这个并不存在的实现；
    if (didAddMethod) {
          class_replaceMethod(myClass, method_getName(swizzledMethod), method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
          method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)zx_removeObserver:(id)observer
{
    [self zx_removeObserver:observer];
}

@end
