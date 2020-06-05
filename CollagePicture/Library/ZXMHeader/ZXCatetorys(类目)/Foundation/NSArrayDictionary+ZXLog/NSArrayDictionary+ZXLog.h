//
//  NSArrayDictionary+ZXLog.h
//  YiShangbao
//
//  Created by simon on 2016/11/13.
//  Copyright © 2016年 com.Microants. All rights reserved.
//
//  简介：重新解析重组集合对象的数据，如果元素中有unicode-16进制(带转义的特殊字符，比如中文)的符号，会被正常打印；
//
//  2019.4.25 增加description属性重写；
//  2020.06.05 优化


#import <Foundation/Foundation.h>

/*
 如果category中重写覆盖了当前类中的某个方法，那么这个当前类中的原始方法实现，将永远不会被执行；

 调用优先级：分类(category) > 本类 > 父类。即，优先调用cateory中的方法，然后调用本类方法，最后调用父类方法。可以理解为分类重写覆盖本类，本类重写覆盖父类；如果本类中写了super **，则会在调用本类方法中遇到super的地方先调用父类，后再继续执行下一步；

 （1）、如果category中重写当前类中的某个方法，会覆盖原始方法；那么这个当前类中的原始方法实现，将永远不会被执行。(+(void)load方法是一个特例，它会在当前类执行完之后再在category中执行。)category没有办法去代替子类，它不能像子类一样通过super去调用父类的方法实现。

 （2）、同时，一个category也不能可靠的覆盖另一个category中相同的类的相同的方法。例如UIViewController+A与UIViewController+B，都重写了viewDidLoad，其中某个方法永远不会被执行；我们无法控制谁覆盖了谁，所以不知道会先执行哪一个.

 （3）、通过观察头文件我们可以发现，Cocoa框架中的许多类都是通过category来实现功能的，可能不经意间你就覆盖了这些方法中的其一，有时候就会产生一些无法排查的异常原因。

 （4）category的设计是为了让我们更加方便的去拓展一个类，不是让我们去改变一个类。

 结论：
 要重写方法，当然我们首推通过子类重写父类的方法，在一些不方便重写的情况下，我们也可以在category中用runtime进行method swizzling来实现。
 */


@interface NSArray (ZXLog)

///调用对象的description属性会调用这个方法；
- (NSString *)description;


///使用默认NSLog方法%@打印对象不会调用这个方法；用__VA_ARGS__的时候会调用；用这个实例方法的时候会调用；
- (NSString *)descriptionWithLocale:(id)locale;

@end



@interface NSDictionary (ZXLog)

- (NSString *)description;

- (NSString *)descriptionWithLocale:(id)locale;

@end
