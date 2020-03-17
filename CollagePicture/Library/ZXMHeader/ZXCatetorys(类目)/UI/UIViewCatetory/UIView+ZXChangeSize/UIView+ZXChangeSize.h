//
//  UIView+ZXChangeSize.h
//  CollagePicture
//
//  Created by simon on 17/1/6.
//  Copyright © 2017年 simon. All rights reserved.
//
// 2020.02.10 safeAreaLayout

#import <UIKit/UIKit.h>


#pragma mark-设置view某个尺寸改变后的frame
//单独设置view的frame里的高度，其他的值保持不变
#define ZX_FRAME_Y(view,y) CGRectMake(CGRectGetMinX(view.frame),y, CGRectGetWidth(view.frame),CGRectGetHeight(view.frame))
#define ZX_FRAME_H(view,h) CGRectMake(CGRectGetMinX(view.frame),CGRectGetMinY(view.frame), CGRectGetWidth(view.frame),h)
#define ZX_FRAME_W(view,w) CGRectMake(CGRectGetMinX(view.frame),CGRectGetMinY(view.frame), w,CGRectGetHeight(view.frame))



@interface UIView (ZXChangeSize)

@property (nonatomic, assign) CGFloat zx_x;
@property (nonatomic, assign) CGFloat zx_y;
@property (nonatomic, assign) CGFloat zx_centerX;
@property (nonatomic, assign) CGFloat zx_centerY;
@property (nonatomic, assign) CGFloat zx_width;
@property (nonatomic, assign) CGFloat zx_height;
@property (nonatomic, assign) CGSize  zx_size;
@property (nonatomic, assign) CGPoint zx_origin;


/// 获取view的安全区域的布局Y原点位置；
/// 导航条透明，有tab的时候，layoutFrame = {{0, 88}, {414, 725}}
/// 导航条不透明，有tab的时候，layoutFrame = {{0, 0}, {414, 725}}
/// 没导航条，也没有tabController的tab时候，layoutFrame = {{0, 0}, {414, 896}}
@property (nonatomic, readonly) CGFloat zx_safeAreaLayoutGuideY;

/// 获取view的安全区域的布局size区域；
@property (nonatomic, readonly) CGSize zx_safeAreaLayoutGuideSize;

@end
