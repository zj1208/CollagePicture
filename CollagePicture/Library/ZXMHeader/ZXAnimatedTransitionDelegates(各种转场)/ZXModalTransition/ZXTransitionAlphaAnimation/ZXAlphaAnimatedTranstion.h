//
//  ZXAlphaAnimatedTranstion.h
//  lovebaby
//
//  Created by simon on 16/6/28.
//  Copyright © 2016年 . All rights reserved.
//

//  待优化处理bug：当设置self.modalPresentationStyle = UIModalPresentationCustom的时候，为什么dismiss的时候，动画块中有些动画过渡效果无效：
//  animateKeyframes动画：这个动画设置self.coverView.alpha = 0.f;无动画过渡效果，其它有；
//  animateWithDuration:动画：这个动画由于设置snapshot.transform = CGAffineTransformMakeScale(0, 0);或 self.coverView.alpha = 0.f;导致全部无动画过渡效果；

//  2018.8.07  优化代码；

#import "ZXBaseAnimator.h"

NS_ASSUME_NONNULL_BEGIN

// 添加视图后慢慢放大显示，移除的时候 直接隐藏消失的动画；
@interface ZXAlphaAnimatedTranstion : ZXBaseAnimator

@property (nonatomic, assign) CGSize contentSize;

@end

NS_ASSUME_NONNULL_END
