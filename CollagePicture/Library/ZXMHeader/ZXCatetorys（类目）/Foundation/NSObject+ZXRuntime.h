//
//  NSObject+ZXRuntime.h
//  CollagePicture
//
//  Created by 朱新明 on 16/11/17.
//  Copyright © 2016年 simon. All rights reserved.
//
//  简介：交换二个实例方法的IMP（方法实现）
//  2018.01.10
//  添加注释

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



/*
 方法交互的初衷目的是替换原生的方法实现；自己添加自己的额外业务逻辑，看MJRefresh例子
 调用reloadData的时候，被交换了实现；则调用mj_reloadData；
 再调用mj_reloadData的时候，也被交换了实现；则调用reloadData；
 
 @implementation UITableView (MJRefresh)
 
 + (void)load
 {
    [self exchangeInstanceMethod1:@selector(reloadData) method2:@selector(mj_reloadData)];
 }
 
 - (void)mj_reloadData
 {
    [self mj_reloadData];
 
    [self executeReloadDataBlock];
 }
 @end
 
 */

