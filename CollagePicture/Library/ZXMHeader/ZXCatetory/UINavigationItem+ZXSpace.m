//
//  UINavigationItem+ZXSpace.m
//  YiShangbao
//
//  Created by simon on 17/5/16.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "UINavigationItem+ZXSpace.h"
#import "NSObject+ZXRuntime.h"
@implementation UINavigationItem (ZXSpace)
/*
+ (void)load
{
    zxSwizzling_exchangeMethod([self class], @selector(setLeftBarButtonItem:), @selector(changeLeftBarButtonItem:));
//    这个不能写，不然会报错；
//    zxSwizzling_exchangeMethod([self class], @selector(setLeftBarButtonItems:), @selector(changeLeftBarButtonItems:));
    [super load];

}

- (void)changeLeftBarButtonItem:(UIBarButtonItem *)sender
{
    NSMutableArray *mArray = [NSMutableArray arrayWithObject:sender];
    [mArray insertObject:[self negativeSpacer] atIndex:0];
    [self setLeftBarButtonItems:mArray];
}

//- (void)changeLeftBarButtonItems:(NSArray *)sender
//{
//    NSMutableArray *mArray = [NSMutableArray arrayWithArray:sender];
//    [mArray removeObjectAtIndex:0];
//    [mArray insertObject:[self negativeSpacer] atIndex:0];
//    [self setLeftBarButtonItems:mArray];
//}
- (UIBarButtonItem *)negativeSpacer
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    return negativeSpacer;
}
  */
@end
 

