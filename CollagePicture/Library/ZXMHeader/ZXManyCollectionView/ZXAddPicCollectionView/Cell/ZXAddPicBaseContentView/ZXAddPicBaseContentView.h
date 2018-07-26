//
//  ZXAddPicBaseContentView.h
//  YiShangbao
//
//  Created by simon on 2018/4/18.
//  Copyright © 2018年 com.Microants. All rights reserved.
//
//  简介：遮罩图，一般用于标识这个数据的类型；直接覆盖在imageView图片上，添加在cell上；
//       如果要自定义遮罩图上的UI信息，则建立子视图，重写这个类；

#import <UIKit/UIKit.h>
#import "ZXPhoto.h"
#import "ZXAddPicCellLayoutConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXAddPicBaseContentView : UIView


- (instancetype)initContentView;

/**
 *  刷新方法
 *
 *  @param data 刷新数据
 *
 */
- (void)refresh:(ZXPhoto *)data;

- (void)refresh:(ZXPhoto *)data indexPath:(NSIndexPath *)indexPath isContainVideo:(BOOL)flag;

@end

NS_ASSUME_NONNULL_END
