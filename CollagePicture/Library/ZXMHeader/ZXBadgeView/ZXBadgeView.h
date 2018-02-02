//
//  ZXBadgeView.h
//  YiShangbao
//
//  Created by simon on 2017/9/1.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  注释：感觉没什么用，除了可以设置红点外面再弄白色边缘有用；
//  2018.1.30 修改

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ZXBadgeViewType){
    // 根据默认图标大小
    ZXBadgeViewTypeDot = 0,
    ZXBadgeViewTypeCustomDot =1,
};

@interface ZXBadgeView : UIView

@property (nonatomic, strong) UIImageView *badgeImageView;

@property (nonatomic, assign) ZXBadgeViewType badgeViewType;
@end
