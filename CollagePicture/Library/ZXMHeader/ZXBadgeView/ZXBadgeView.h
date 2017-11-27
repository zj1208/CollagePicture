//
//  ZXBadgeView.h
//  YiShangbao
//
//  Created by simon on 2017/9/1.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ZXBadgeViewType){
    
    ZXBadgeViewTypeDot = 0,
};

@interface ZXBadgeView : UIView

@property (nonatomic, strong) UIImageView *dotImageView;

@property (nonatomic, assign) ZXBadgeViewType badgeViewType;
@end
