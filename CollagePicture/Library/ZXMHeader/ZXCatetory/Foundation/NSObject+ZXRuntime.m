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

//交换二个实例方法的IMP（方法实现）
+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2));
}

//交换二个类方法的IMP（方法实现）
+ (void)exchangeClassMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getClassMethod(self, method1), class_getClassMethod(self, method2));
}

@end

/*
方法交互的初衷目的是替换原生的方法实现；自己添加自己的额外业务逻辑，看MJRefresh例子
 
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
