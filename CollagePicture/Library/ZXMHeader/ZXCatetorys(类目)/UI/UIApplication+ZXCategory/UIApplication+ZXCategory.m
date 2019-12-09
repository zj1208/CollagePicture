//
//  UIApplication+ZXCategory.m
//  MobileCaiLocal
//
//  Created by simon on 2019/11/28.
//  Copyright © 2019 timtian. All rights reserved.
//

#import "UIApplication+ZXCategory.h"


@implementation UIApplication (ZXCategory)


- (CGFloat)zx_safeAreaStatusBarHeight
{
    CGFloat statusBarHeight = 0;
    if (@available(iOS 13.0, *)) {
         statusBarHeight = [[UIApplication sharedApplication] delegate].window.windowScene.statusBarManager.statusBarFrame.size.height;
    } else
    {
        statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    }
    return statusBarHeight;
}

@end
