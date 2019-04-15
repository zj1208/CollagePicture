//
//  ZXBaseAnimator.h
//  ZXControllerTransition
//
//  Created by simon on 15/11/10.
//  Copyright © 2015年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//创建一个专门用于管理动画的类， 也可以让UIViewController实现UIViewControllerAnimatedTransitioning接口

typedef NS_ENUM(NSInteger,ZXAnimationType)
{
    ZXAnimationTypePresent =0,
    ZXAnimationTypeDismiss =1,
    ZXAnimationTypePush =2,
    ZXAnimationTypePop =3,
};

@interface ZXBaseAnimator : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) ZXAnimationType type;

@end

NS_ASSUME_NONNULL_END
