//
//  CustomCoverView.h
//  YiShangbao
//
//  Created by simon on 2018/5/3.
//  Copyright © 2018年 com.Microants. All rights reserved.
//
//  自定义配置需要展示的view内容，重写方法；

//  5.4 优化重用问题

#import "ZXAddPicCellBaseCoverView.h"

@interface CustomCoverView : ZXAddPicCellBaseCoverView

// 底部半透明视图
@property (nonatomic, strong) UIView *alphaBgView;
// 图标
@property (nonatomic, strong) UIImageView *markImageView;
// 主图
@property (nonatomic, strong) UILabel *markMainLab;

// 最上面一层遮图
@property (nonatomic, strong) UIView *alphaCoverView;

@end
