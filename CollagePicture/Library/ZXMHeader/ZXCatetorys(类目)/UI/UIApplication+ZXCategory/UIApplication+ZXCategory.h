//
//  UIApplication+ZXCategory.h
//  MobileCaiLocal
//
//  Created by simon on 2019/11/28.
//  Copyright © 2019 timtian. All rights reserved.
//



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (ZXCategory)

/// iPhoneX系列 ? (20.f+24.f) : (20.f))
@property (nonatomic, assign, readonly) CGFloat zx_safeAreaStatusBarHeight;

@end

NS_ASSUME_NONNULL_END
