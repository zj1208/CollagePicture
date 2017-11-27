//
//  UIScrollView+ZXMJRefreshing.m
//  YiShangbao
//
//  Created by simon on 17/1/5.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "UIScrollView+ZXMJRefreshing.h"

@implementation UIScrollView (ZXMJRefreshing)

- (BOOL)isRefreshing
{
    if ([self.mj_header isRefreshing]||[self.mj_footer isRefreshing])
    {
        return YES;
    }
    return NO;
}

@end
