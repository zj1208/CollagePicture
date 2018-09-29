//
//  UINavigationController+ZXKuGouInteractivePopGestureRecognizer.h
//  YiShangbao
//
//  Created by simon on 2018/8/23.
//  Copyright © 2018年 com.Microants. All rights reserved.
//
//  简介：给导航栏添加自定义push/pop切换转场-酷狗音乐效果，自定义交互式转场手势返回效果；只要用这个UINavigationController类目就行；

#import <UIKit/UIKit.h>
#import "ZXNavKuGouTransitionDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (ZXKuGouInteractivePopGestureRecognizer)

@property (nonatomic, strong) ZXNavKuGouTransitionDelegate * kuGouTransitionDelegate;

// 是否开启自定义push/pop切换转场,是否开启自定义交互式转场手势返回
- (void)zx_setNavigatonKuGouTransitionWithAnimationTransition:(BOOL)flag interactivePopGestureTransition:(BOOL)interactiveFlag;

@end

NS_ASSUME_NONNULL_END

//例如：在UINavigationController子类上设置；
/*
#import "UINavigationController+ZXKuGouInteractivePopGestureRecognizer.h"

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self zx_setNavigatonKuGouTransitionWithAnimationTransition:YES interactivePopGestureTransition:YES];
}
*/
// 也可以直接在UINavigationController的rootViewController上设置,   [self.navigationController zx_setNavigatonKuGouTransitionWithAnimationTransition:YES interactivePopGestureTransition:YES];


