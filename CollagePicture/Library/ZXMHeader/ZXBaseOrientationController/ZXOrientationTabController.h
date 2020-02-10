//
//  ZXOrientationTabController.h
//  Baby
//
//  Created by simon on 16/2/24.
//  Copyright © 2016年 simon. All rights reserved.
//
//  简介：功能1:支持屏幕旋转控制；功能2:支持状态条显示控制；
//  功能3:支持控制iPhoneX的Home指示条，一般情况只有视频全屏播放和游戏界面需要设置自动隐藏；隐藏过程是过1.5秒后的alpha动画隐藏；

//  2018.7.25  新增控制iPhoneX的Home指示条；
//  2020.02.05 修改bug,返回topViewController；



#import <UIKit/UIKit.h>

@interface ZXOrientationTabController : UITabBarController

@end
