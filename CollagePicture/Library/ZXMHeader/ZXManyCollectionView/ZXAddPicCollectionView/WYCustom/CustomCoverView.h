//
//  CustomCoverView.h
//  YiShangbao
//
//  Created by simon on 2018/5/3.
//  Copyright © 2018年 com.Microants. All rights reserved.
//
//  自定义配置需要展示的view内容，重写方法；

//  5.4 优化重用问题

#import "ZXAddPicBaseContentView.h"

@interface CustomCoverView : ZXAddPicBaseContentView

@property (nonatomic, strong) UIView *alphaBgView;
@property (nonatomic, strong) UIImageView *markImageView;

@end
