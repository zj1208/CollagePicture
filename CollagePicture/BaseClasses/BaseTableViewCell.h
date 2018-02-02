//
//  BaseTableViewCell.h
//  Baby
//
//  Created by simon on 16/1/22.
//  Copyright © 2016年 simon. All rights reserved.
//
// 2018.01.09
// 新增协议方法

#import <UIKit/UIKit.h>
#import "SetDataProtocol.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
@interface BaseTableViewCell : UITableViewCell<SetDataProtoct>

@end
