//
//  NSObject+ZXRuntime.m
//  CollagePicture
//
//  Created by simon on 16/11/17.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "NSObject+ZXRuntime.h"

@implementation NSObject (ZXRuntime)

#pragma mark -交换二个方法的IMP

/**
 *  交换二个实例方法的IMP（方法实现）
 *class_addMethod的实现会覆盖父类的方法实现，但不会替换本类中已存在的实现，如果本类中已经有一个同名字的方法实现（本类已经有一个同名字的实例方法实现），则函数会返回NO。如果要更改已存在实现，可以使用method_setImplementation。
 即：动态添加的SEL方法不能在该类中有相同名字的实例方法实现，不然会无法添加成功；不管是自定义方法还是系统方法，只要当前类结构中没有这个名字的方法实现就能添加成功，否则不能；

 *  @param originalSelector 指定要添加的方法1名称的选择器(原本的方法)
 *  @param swizzledSelector 指定要添加的方法2名称的选择器(要替换成的方法)
 */
+ (void)zx_exchangeInstanceMethod1:(SEL)originalSelector method2:(SEL)swizzledSelector
{
    Class myClass = [self class];
    Method originalMethod = class_getInstanceMethod(myClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(myClass, swizzledSelector);
    //向class类动态添加方法及实现,如果当前类本来就存在同名字的imp方法实现,就会返回NO;
    BOOL didAddMethod = class_addMethod(myClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    //添加同一个方法，如果成功，说明类中不存在这个方法的实现；
    //将被交换方法的实现替换到这个并不存在的实现；
    if (didAddMethod)
    {
        class_replaceMethod(myClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else
    {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

/**
 *  交换二个类方法的IMP（方法实现）
 *
 *  @param originalSelector 指定要添加的方法1名称的选择器
 *  @param swizzledSelector 指定要添加的方法2名称的选择器
 */
+ (void)zx_exchangeClassMethod1:(SEL)originalSelector method2:(SEL)swizzledSelector
{
    Method originalMethod = class_getClassMethod(self, originalSelector);
    Method swizzledMethod = class_getClassMethod(self, swizzledSelector);
    method_exchangeImplementations(originalMethod,swizzledMethod);
}

@end

