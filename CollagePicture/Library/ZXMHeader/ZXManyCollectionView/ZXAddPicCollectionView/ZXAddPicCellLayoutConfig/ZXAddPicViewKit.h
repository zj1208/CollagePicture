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

- (void)registerLayoutConfig:(ZXAddPicCellLayoutConfig *)layoutConfigClass;

@end

NS_ASSUME_NONNULL_END

/*
[[ZXAddPicViewKit sharedKit]registerLayoutConfig:[CustomAddPicLayoutConfig new]];
*/
