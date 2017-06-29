//
//  UIScrollView+AssistiveTouch.h
//  YiShangbao
//
//  Created by simon on 17/4/27.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXAssistiveTouch.h"

@interface UIScrollView (AssistiveTouch)<UIScrollViewDelegate>

@property (nonatomic, strong)ZXAssistiveTouch *assistiveTouch;

- (void)addAssistiveTouchTo:(UIView *)view withTarget:(id)target action:(SEL)action;

//开始触摸时候的偏移量
- (void)asTouchScrollViewWillBeginDragging:(UIScrollView *)scrollView;

//处理在自动滚动／手动拖动时候的业务，及touch的显示隐藏
- (void)asTouchScrollViewDidScroll:(UIScrollView *)scrollView;

//为了获取最后触摸的偏移
- (void)asTouchScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
@end



/*
- (void)viewDidLoad
{
    [self.tableView addAssistiveTouchTo:self.view withTarget:self action:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [scrollView asTouchScrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.dataMArray.count ==0)
    {
        return;
    }
    [scrollView asTouchScrollViewDidScroll:scrollView];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [scrollView asTouchScrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

*/
