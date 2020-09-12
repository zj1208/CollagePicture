//
//  NSArray+ZXCategory.h
//  MobileCaiLocal
//
//  Created by simon on 2020/6/4.
//  Copyright © 2020 com.Chs. All rights reserved.
//
//  2020.07.04 增加map方法，forEach方法；
//  2020.9.2 注释，满足条件的系统方法；以后多用；

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (ZXCategory)


/**
循环遍历集合，返回满足函数条件的组成的新集合；返回一个新的惰性 [Iterable]，其中包含所有满足谓词[test]的元素。
@param testBlock myBlock description
系统方法：返回数组中满足给定block函数的对象的索引集合；
block函数满足条件返回YES的对象，会被加入索引集合最后返回；
 - (NSIndexSet *)indexesOfObjectsPassingTest:(BOOL (NS_NOESCAPE ^)(ObjectType obj, NSUInteger idx, BOOL *stop))predicate;
 */
- (NSArray *)zx_where:(BOOL(^)(id obj))testBlock;


/// 返回一个新的集合，其中的元素是通过按迭代顺序在这个集合的每个元素上调用' fBlock '函数创建的。
/// 一般用于创建返回新的对象类型集合，或者每个对象修改后的集合；
/// @param fBlock 让每个元素调用函数方法并修改return返回；
- (id)zx_map:(id(^)(id obj))fBlock;




/**
检查此集合的每个元素（全部）是否满足条件[test]；
循环遍历检查集合顺序中的每个元素，如果其中任何一个使[test]返回'false'，则返回'false'，否则返回'true'。
例如：
//检查是否每个item被选中，即是否被全部选中
- (BOOL)getIsSelectedAllGoods
{
    BOOL flag = [self.shopCartModel.list zx_every:^BOOL(CHSShopCartModel_ListModel *  _Nonnull obj) {
        return obj.isSelected;
    }];
    return flag;
}
 */
- (BOOL)zx_every:(BOOL(^)(id obj))testBlock;



/**
  检查此可迭代集合的任何一个元素是否满足[test]，只要其中任何一个使[test]返回'true'，则停止遍历，返回'true'，否则返回false。即循环遍历集合，只要集合里面有一个满足条件的就停止遍历，返回true.
 例如：
 ///检查是否any一个有选中的；
 - (BOOL)getIsAnySelectedFromAllGoods
 {
     BOOL flag = [self.shopCartModel.list zx_any:^BOOL(CHSShopCartModel_ListModel *  _Nonnull obj) {
         return obj.isSelected;
     }];
     return flag;
 }
 系统方法：返回数组中满足给定block函数的第一个对象的索引。检查数组中任何一个对象是否满足block函数，只要其中任何一个使block返回YES，则返回YES-返回满足的第一个索引；如果没有满足条件的则返回NO，索引返回NSNotFound。
 - (NSUInteger)indexOfObjectPassingTest:(BOOL (NS_NOESCAPE ^)(ObjectType obj, NSUInteger idx, BOOL *stop))predicate;
 */
- (BOOL)zx_any:(BOOL(^)(id obj))testBlock;


/// 将函数fBlock按迭代顺序应用于此集合的每个元素。就是for...in语句；
/// 例如：全选(遍历每个item，并选中),全不选；
/// @param fBlock 一个block
- (void)zx_forEach:(void(^)(id obj))fBlock;

/// 是否为空
- (BOOL)zx_isEmpty;

@end

NS_ASSUME_NONNULL_END
