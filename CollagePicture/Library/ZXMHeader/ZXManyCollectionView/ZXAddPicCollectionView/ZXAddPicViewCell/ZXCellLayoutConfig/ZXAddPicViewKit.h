//
//  ZXAddPicViewKit.h
//  YiShangbao
//
//  Created by simon on 2018/4/18.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXCellLayoutConfig.h"

@interface ZXAddPicViewKit : NSObject

+ (instancetype)sharedKit;

@property (nonatomic, strong) ZXCellLayoutConfig *cellLayoutConfig;

@end
