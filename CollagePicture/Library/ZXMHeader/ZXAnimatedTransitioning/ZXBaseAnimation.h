//
//  ZXBaseAnimation.h
//  ZXControllerTransition
//
//  Created by simon on 15/11/10.
//  Copyright © 2015年 zhuxinming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//创建一个专门用于管理动画的类， 也可以让UIViewController实现UIViewControllerAnimatedTransitioning接口

typedef NS_ENUM(NSInteger,ZXAnimationType)
{
    ZXAnimationTypePresent =1,
    ZXAnimationTypeDismiss =2
};

@interface ZXBaseAnimation : NSObject<UIViewControllerAnimatedTransitioning>

@property(nonatomic,assign) ZXAnimationType type;
@end
