//
//  ZXCustomNavigationBar.h
//  YiShangbao
//
//  Created by simon on 2017/10/19.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  简介：自定义导航条，根据iOS11系统导航条设计；背景容器view+ 放按钮的容器View；
//  待优化可以自定义添加左边，右边按钮；

#import <UIKit/UIKit.h>

@interface ZXCustomNavigationBar : UIView
// 背景图+分割线容器View
@property (weak, nonatomic) IBOutlet UIView *barBackgroundContainerView;
// 导航条背景图
@property (weak, nonatomic) IBOutlet UIImageView *barBackgroundImageView;

// 导航条分割线
@property (weak, nonatomic) IBOutlet UIImageView *barBackgroundLineImageView;



// 按钮容器视图
@property (weak, nonatomic) IBOutlet UIView *navigationBarContentView;
// 中间titleView
@property (weak, nonatomic) IBOutlet UIView *titleView;

@property (weak, nonatomic) IBOutlet UIView *rightContainerView;

@property (weak, nonatomic) IBOutlet UIView *leftContainerView;

@property (strong, nonatomic) UIBarButtonItem *leftBarButtonItem;

@property (weak, nonatomic) IBOutlet UIButton *leftBarButton;
@property (weak, nonatomic) IBOutlet UIButton *rightBarButton2;
@property (weak, nonatomic) IBOutlet UIButton *rightBarButton1;
@end
