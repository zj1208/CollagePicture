//
//  BaseCollectionViewCell.h
//  Baby
//
//  Created by simon on 16/1/18.
//  Copyright © 2016年 simon. All rights reserved.
//
// 2018.01.09 新增协议方法
// 2019.06.11 新增重写方法

#import <UIKit/UIKit.h>
#import "SetDataProtocol.h"
#import "UIImageView+WebCache.h"

@interface BaseCollectionViewCell : UICollectionViewCell<SetDataProtoct>

@end
