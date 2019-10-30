//
//  ZXModalWeChatDrivenInteractiveTransition.h
//  YiShangbao
//
//  Created by simon on 2018/8/24.
//  Copyright © 2018年 com.Microants. All rights reserved.
//
//  简介：百分比运动交互转场，即手势滑动距离与屏幕距离的百分比来执行交互转场；

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXModalWeChatDrivenInteractiveTransition : UIPercentDrivenInteractiveTransition

- (instancetype)initWithGestureRecognizer:(UIPanGestureRecognizer*)gestureRecognizer;

// 图片的frame
@property (nonatomic, assign) CGRect  transitionBeforeImgFrame;
// 当前图片的frame
@property (nonatomic, assign) CGRect  transitionCurrentImgFrame;
// 当前图片
@property (nonatomic, strong) UIImage *transitionImage;


@end

NS_ASSUME_NONNULL_END
