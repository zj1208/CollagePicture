//
//  NSObject+ZXRuntime.h
//  CollagePicture
//
//  Created by 朱新明 on 16/11/17.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>


//交换二个实例方法的IMP（方法实现）
static inline void zxSwizzling_exchangeMethod(Class theClass, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(theClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(theClass, swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

//class_addMethod的实现会覆盖父类的方法实现，但不会取代本类中已存在的实现，如果本类中包含一个同名的实现，则函数会返回NO
static inline BOOL af_addMethod(Class theClass, SEL selector, Method method) {
    return class_addMethod(theClass, selector,  method_getImplementation(method),  method_getTypeEncoding(method));
}


@interface NSObject (ZXRuntime)

+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2;


+ (void)exchangeClassMethod1:(SEL)method1 method2:(SEL)method2;

@end
