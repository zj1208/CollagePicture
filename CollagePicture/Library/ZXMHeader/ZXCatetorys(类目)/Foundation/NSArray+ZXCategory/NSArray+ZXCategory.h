//
//  NSArray+ZXCategory.h
//  MobileCaiLocal
//
//  Created by simon on 2020/6/4.
//  Copyright © 2020 com.Chs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (ZXCategory)


/// 循环遍历集合，返回满足函数条件的组成的新集合；返回一个新的惰性 [Iterable]，其中包含所有满足谓词[test]的元素。
/// @param myBlock <#myBlock description#>
- (NSArray *)zx_where:(BOOL(^)(id obj))myBlock;


/*
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
- (BOOL)zx_every:(BOOL(^)(id obj))myBlock;



/*
  检查此可迭代集合的任何一个元素是否满足[test]，只要其中任何一个使[test]返回'true'，则返回'true'，否则返回false。即循环遍历集合，只要集合里面有一个满足条件的就返回true.
 例如：
 ///检查是否any一个有选中的；
 - (BOOL)getIsAnySelectedFromAllGoods
 {
     BOOL flag = [self.shopCartModel.list zx_any:^BOOL(CHSShopCartModel_ListModel *  _Nonnull obj) {
         return obj.isSelected;
     }];
     return flag;
 }
 */
- (BOOL)zx_any:(BOOL(^)(id obj))myBlock;



/// 是否为空
- (BOOL)zx_isEmpty;

@end

NS_ASSUME_NONNULL_END
