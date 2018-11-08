//
//  NSObject+ZXRuntime.m
//  CollagePicture
//
//  Created by 朱新明 on 16/11/17.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "NSObject+ZXRuntime.h"





@implementation NSObject (ZXRuntime)

#pragma mark -交换二个方法的IMP

/**
 *  交换二个实例方法的IMP（方法实现）
 *
 *  @param selector 指定要添加的方法1名称的选择器(原本的方法)
 *  @param otherSelector 指定要添加的方法2名称的选择器(要替换成的方法)
 */
+ (void)zx_exchangeInstanceMethod1:(SEL)selector method2:(SEL)otherSelector
{
    Class myClass = [self class];
    Method originalMethod = class_getInstanceMethod(myClass, selector);
    Method otherMethod = class_getInstanceMethod(myClass, otherSelector);
    
    BOOL didAddMethod = class_addMethod(myClass, selector, method_getImplementation(otherMethod), method_getTypeEncoding(otherMethod));
    if (didAddMethod)
    {
        class_replaceMethod(myClass, otherSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else
    {
        method_exchangeImplementations(originalMethod, otherMethod);
    }
}

/**
 *  交换二个类方法的IMP（方法实现）
 *
 *  @param selector 指定要添加的方法1名称的选择器
 *  @param otherSelector 指定要添加的方法2名称的选择器
 */
+ (void)zx_exchangeClassMethod1:(SEL)selector method2:(SEL)otherSelector
{
    method_exchangeImplementations(class_getClassMethod([self class], selector), class_getClassMethod([self class], otherSelector));
}

@end

