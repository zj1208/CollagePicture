//
//  ZXCellLayoutConfigSource.h
//  YiShangbao
//
//  Created by simon on 2018/4/18.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ZXCellLayoutConfigSource <NSObject>

/**
 * @return 返回内容大小
 */
- (CGSize)contentSize:(id)model cellWidth:(CGFloat)width;


/**
 *  需要构造的cellContent类名
 */
- (NSString *)cellContent:(id)model;


@end
