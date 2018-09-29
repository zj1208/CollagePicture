//
//  ZXNavKuGouDrivenInteractiveTransition.h
//  YiShangbao
//
//  Created by simon on 2018/8/22.
//  Copyright © 2018年 com.Microants. All rights reserved.
//
//  简介：百分比运动交互转场，即手势滑动距离与屏幕距离的百分比来执行交互转场；

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXNavKuGouDrivenInteractiveTransition : UIPercentDrivenInteractiveTransition

- (instancetype)initWithGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer;

@end

NS_ASSUME_NONNULL_END
