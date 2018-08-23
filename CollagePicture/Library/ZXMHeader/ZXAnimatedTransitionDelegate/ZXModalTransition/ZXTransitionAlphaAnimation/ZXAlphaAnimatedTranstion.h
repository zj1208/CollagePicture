//
//  ZXAlphaAnimatedTranstion.h
//  lovebaby
//
//  Created by simon on 16/6/28.
//  Copyright © 2016年 . All rights reserved.
//
//  2018.8.07  优化代码；

#import "ZXBaseAnimator.h"

NS_ASSUME_NONNULL_BEGIN

// 添加视图后慢慢放大显示，移除的时候 直接隐藏消失的动画；
@interface ZXAlphaAnimatedTranstion : ZXBaseAnimator

@property (nonatomic, assign) CGSize contentSize;

@end

NS_ASSUME_NONNULL_END
