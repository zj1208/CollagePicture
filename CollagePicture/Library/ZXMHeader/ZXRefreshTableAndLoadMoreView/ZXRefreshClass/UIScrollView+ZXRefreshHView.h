//
//  UIScrollView+ZXRefreshHView.h
//  douniwan
//
//  Created by simon on 15/7/2.
//  Copyright (c) 2015年 遥望. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"



@interface UIScrollView (ZXRefreshHView)<EGORefreshTableHeaderDelegate,UIScrollViewDelegate>

@property(nonatomic,strong)EGORefreshTableHeaderView *pullToRefreshView;

- (void)addRefreshHeaderViewWithTarget:(id)target action:(SEL)action;

- (void)refreshHeaderViewBeginRefreshing;

@end
