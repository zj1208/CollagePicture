//
//  ZXAddPicViewKit.h
//  YiShangbao
//
//  Created by simon on 2018/4/18.
//  Copyright © 2018年 com.Microants. All rights reserved.
//
//  如果要添加自定义遮图；一定要注册自定义重写类；这样ZXAddPicViewCell的contentView才会调用遮图View-自定义类；

#import <Foundation/Foundation.h>
#import "ZXAddPicCellLayoutConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXAddPicViewKit : NSObject

+ (instancetype)sharedKit;

@property (nonatomic, strong) ZXAddPicCellLayoutConfig *cellLayoutConfig;

// 如果需要自定义遮图，则用自己建立的自定义布局+contentView注册展示；
- (void)registerLayoutConfig:(ZXAddPicCellLayoutConfig *)layoutConfigClass;

// 如果不需要自定义遮图，重置，使用默认的展示，不需要自定义外部contentView；
+ (void)resetLayoutConfig;
@end

NS_ASSUME_NONNULL_END

/*
[[ZXAddPicViewKit sharedKit]registerLayoutConfig:[CustomAddPicLayoutConfig new]];
 
 [ZXAddPicViewKit resetLayoutConfig];

*/
