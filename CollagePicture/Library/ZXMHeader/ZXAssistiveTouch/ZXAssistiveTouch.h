//
//  ZXAssistiveTouch.h
//  YiShangbao
//
//  Created by simon on 17/4/11.
//  Copyright © 2017年 com.Microants. All rights reserved.
//  做这个的主要目的是为了全局页面能用 和苹果系统的touch一样； 缺点，现在不能点击导航条，需要重新调试；

#import <UIKit/UIKit.h>

@class ZXAssistiveTouch;
@protocol ZXAssistiveTouchDelegate <NSObject>

//向下拖动的返回浏览的时候，是否隐藏；
- (BOOL)shouldHideAssistiveTouchDownwardScrolling;

@end


@interface ZXAssistiveTouch : UIView

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, weak) id<ZXAssistiveTouchDelegate>delegate;

@property (nonatomic, assign)CGFloat begainContentOffsetY;
@property (nonatomic, assign)CGFloat oldContentOffsetY;
@property (nonatomic, assign)CGFloat endContentOffestY;

//动画效果还没有实现
+ (instancetype)showAssistiveTouchAddedTo:(UIView *)view animated:(BOOL)animated;

+ (ZXAssistiveTouch *)assistiveTouchForView:(UIView *)view;
- (id)initWithFrame:(CGRect)frame;

@end


//浮按钮，点击按钮返回顶部；出现第一个row隐藏，其它显示；
/*
- (void)scrollToTop:(id)sender
{
    NSIndexPath *firstIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:firstIndex atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSIndexPath *firstIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    if (self.tableView.indexPathsForVisibleRows.count>0 && ![self.tableView.indexPathsForVisibleRows containsObject:firstIndex])
    {
        _assistiveBtn.hidden = NO;
    }
    else
    {
        _assistiveBtn.hidden = YES;
    }
}
*/

//@interface ZXTableView : UITableView
//
//@property (nonatomic,strong)
//
//@end
