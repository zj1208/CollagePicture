//
//  ZXAddPicCellLayoutConfigSource.h
//  YiShangbao
//
//  Created by simon on 2018/4/18.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXPhoto.h"

@protocol ZXAddPicCellLayoutConfigSource <NSObject>

/**
 * @return 返回内容大小
 */
- (CGSize)contentSize:(ZXPhoto *)model cellWidth:(CGFloat)width;


/**
 *  需要构造的cellContent类名
 */
- (NSString *)cellContent:(ZXPhoto *)model;


@end
