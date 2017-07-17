//
//  UIViewController+ZXSystemBackButtonAction.h
//  YiShangbao
//
//  Created by simon on 2017/7/13.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZXSystemBackButtonActionDelegate <NSObject>

@optional

- (BOOL)navigationShouldPopOnBackButton;

@end



@interface UIViewController (ZXSystemBackButtonAction)<ZXSystemBackButtonActionDelegate>

@end
