//
//  TMDiskManager.h
//  YiShangbao
//
//  Created by simon on 17/2/16.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  model一定要实现NSCoding协议，不然闪退；

// 6.07 设置本地数据的时候，增加是否发送通知；
// 2019.3.14  swifth调用setValue：forKey：会崩溃；

#import <Foundation/Foundation.h>
#import "TMCache.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const TMDSearchHistoryKey = @"TMDSearchHistoryKey";


@interface TMDiskManager : NSObject

@property (nonatomic, copy) NSString *objectKey;

- (instancetype)initWithObjectKey:(NSString *)objectKey;


/**
 @brief 设置本地数据指定key的value值；swift的model不支持setValue：forKey，不然会崩溃；
 
 */
- (void)setPropertyImplementationValue:(id)value forKey:(NSString *)key;

/**
 @brief 设置本地数据指定key的value值；
 
 @param flag 是否发送通知；
 */
- (void)setPropertyImplementationValue:(id)value forKey:(NSString *)key postNotification:(BOOL)flag;

- (void)setData:(id)object;
- (nullable id)getData;
- (void)removeData;

@end
NS_ASSUME_NONNULL_END

//初始化本地数据model

/*
 @property (nonatomic, strong) TMDiskManager *diskManager;

- (void)initData
{
    AddProductModel *model = [[AddProductModel alloc] init];
    
    if (self.controllerDoingType ==ControllerDoingType_AddProduct)
    {
        model.isMain = YES;
    }
    [self.diskManager setData:model];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(productInfoChange:) name:TMDiskAddProcutKey object:nil];
    
 }

 - (TMDiskManager *)diskManager
 {
     if (!_diskManager) {
         
         _diskManager = [[TMDiskManager alloc] initWithObjectKey:TMDiskAddProcutKey];
     }
     return _diskManager;
 }

 - (void)productInfoChange:(id)notification
 {
    [self.tableView reloadData];
 }
*/

//其它页面获取数据
/*
- (void)setData
{
    NSMutableArray *addArray = [NSMutableArray array];
    self.addedMArray = addArray;
    
    //获取本地数据表管理器
    TMDiskManager *manager = [[TMDiskManager alloc] initWithObjectKey:TMDiskAddProcutKey];
    self.diskManager = manager;
    
    AddProductModel *model = (AddProductModel *)[self.diskManager getData];
    
    if (![NSString zx_isBlankString:model.spec])
    {
        NSArray *labelsArray = [model.spec componentsSeparatedByString:@","];
        if (labelsArray.count>0)
        {
            [self.addedMArray addObjectsFromArray:labelsArray];
        }
    }
}
*/

//改变某个属性数据
/*
- (IBAction)savaBarItemAction:(UIBarButtonItem *)sender {
    
    
    [self.diskManager setPropertyImplementationValue:self.textView.text forKey:@"desc"];
    [self.navigationController popViewControllerAnimated:YES];
    
}
*/
