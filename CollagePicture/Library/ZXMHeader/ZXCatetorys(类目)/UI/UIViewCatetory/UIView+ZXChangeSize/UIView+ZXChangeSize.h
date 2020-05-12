//
//  UIView+ZXChangeSize.h
//  CollagePicture
//
//  Created by simon on 17/1/6.
//  Copyright © 2017年 simon. All rights reserved.
//
// 2020.02.10 safeAreaLayout
// 2020.05.12 注释

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



/**
* @brief 获取view的安全区域的布局Y原点位置。只有当视图在屏幕上可见时，这个guide的layoutFrame才会正常反应；除了用于anchor约束，其它尽量不用。
当视图在屏幕上可见时，该guide反映了视图中navigationBar导航栏、tabBars选项卡栏、toolbars工具栏和其他祖先视图未覆盖的部分。如果当前视图还没有安装在视图层次结构中，或者在屏幕上还不可见，则layoutGuide边缘与视图边缘相等,self.view.frame = self.view.safeAreaLayoutGuide.layoutFrame。
 以iPhone11{{0, 0}, {414, 896}}为例，UIViewController的view在屏幕上可见时：1.导航条半透明，有tab的时候，layoutFrame = {{0, 88}, {414, 725}}; 2.导航条不透明，有tab的时候，layoutFrame = {{0, 0}, {414, 725}}; 3.没导航条，也没有tabController的tab时候，layoutFrame = {{0, 0}, {414, 896}}
*/
@property (nonatomic, readonly) CGFloat zx_safeAreaLayoutGuideY;


/// 获取view的安全区域的布局size区域；
@property (nonatomic, readonly) CGSize zx_safeAreaLayoutGuideSize;


@end



