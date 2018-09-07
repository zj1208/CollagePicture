//
//  ZXWXBigImageTransitionDelegate.h
//  YiShangbao
//
//  Created by simon on 2018/8/15.
//  Copyright © 2018年 com.Microants. All rights reserved.
//
//  简介：查看大图，雷同微信点击头像查看大图效果；
//  注意：查看大图不要使用系统UINavigationControllerDelegate的转场，如果使用那么导航条必然存在，所以遇到要展现没有导航条的toViewController的view，则不能使用；因为使用 [self.navigationController setNavigationBarHidden:YES animated:animated];会有过渡效果问题，且移除大图重新展示导航条的时候，会让底下的下拉刷新UI展示出来，效果非常不好，千万不要用pushViewController切换；

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXWXBigImageTransitionDelegate : NSObject<UIViewControllerTransitioningDelegate>

// 非交互式
/** 转场过渡的图片 */
- (void)setTransitionImage:(UIImage *)transitionImage;
/** 转场前的图片frame */
- (void)setTransitionBeforeImgFrame:(CGRect)frame;
/** 转场后的图片frame */
- (void)setTransitionAfterImgFrame:(CGRect)frame;

// 交互式
@property (nonatomic, strong, nullable) UIPanGestureRecognizer *customInteractivePopGestureRecognizer;

// 图片的frame
@property (nonatomic, assign) CGRect  interactiveBeforeImageViewFrame;
// 当前图片的frame
@property (nonatomic, assign) CGRect  interactiveCurrentImageViewFrame;
// 当前图片
@property (nonatomic, strong) UIImage *interactiveCurrentImage;

@end

NS_ASSUME_NONNULL_END
