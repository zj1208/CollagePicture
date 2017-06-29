//
//  UIScrollView+AssistiveTouch.m
//  YiShangbao
//
//  Created by simon on 17/4/27.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "UIScrollView+AssistiveTouch.h"

static char UIScrollViewPullToRefreshView;

@implementation UIScrollView (AssistiveTouch)
- (void)setAssistiveTouch:(ZXAssistiveTouch *)assistiveTouch
{
    [self willChangeValueForKey:@"EGORefreshTableHeaderView"];
    objc_setAssociatedObject(self, &UIScrollViewPullToRefreshView,
                             assistiveTouch,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"EGORefreshTableHeaderView"];
}

- (ZXAssistiveTouch *)assistiveTouch
{
    return objc_getAssociatedObject(self, &UIScrollViewPullToRefreshView);
}


- (void)addAssistiveTouchTo:(UIView *)view withTarget:(id)target action:(SEL)action
{
    NSLog(@"%@",view);
    self.assistiveTouch =[ZXAssistiveTouch showAssistiveTouchAddedTo:view animated:YES];
    self.assistiveTouch.hidden = YES;
    if (!action)
    {
         [self.assistiveTouch.button addTarget:self action:@selector(scrollToTop:) forControlEvents:UIControlEventTouchUpInside]; 
    }
  
    [self.assistiveTouch.button setImage:[UIImage imageNamed:@"pic_dingzhi"] forState:UIControlStateNormal];
}

- (void)scrollToTop:(id)sender
{
    
    if ([self isKindOfClass:[UITableView class]])
    {
        UITableView *tableView = (UITableView *)self;
        if (tableView.indexPathsForVisibleRows.count>0 )
        {
            NSIndexPath *firstIndex = [NSIndexPath indexPathForRow:0 inSection:0];
            [tableView scrollToRowAtIndexPath:firstIndex atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
    if ([self isKindOfClass:[UICollectionView class]])
    {
        UICollectionView *collectionView = (UICollectionView *)self;
        if (collectionView.indexPathsForVisibleItems.count>0 )
        {
            NSIndexPath *firstIndex = [NSIndexPath indexPathForItem:0 inSection:0];
            [collectionView scrollToItemAtIndexPath:firstIndex atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        }
     }

}

- (void)asTouchScrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.assistiveTouch.begainContentOffsetY = scrollView.contentOffset.y;
}


- (void)asTouchScrollViewDidScroll:(UIScrollView *)scrollView
{
      self.assistiveTouch.endContentOffestY = scrollView.contentOffset.y;
    //触摸离开时候的scrollView偏移量比刚触摸的Y值偏移量大，表示向下滚动，向上拖；
    //正在滚的Y偏移量 比触摸离开时候的scrollView偏移量大，表示正在向下滚动；也算dragging中；
    if (self.assistiveTouch.endContentOffestY >self.assistiveTouch.oldContentOffsetY && self.assistiveTouch.oldContentOffsetY >self.assistiveTouch.begainContentOffsetY)
    {
        self.assistiveTouch.hidden = YES;
    }
    //向上拖／向上自动滚动；
    else if (self.assistiveTouch.endContentOffestY <self.assistiveTouch.oldContentOffsetY && self.assistiveTouch.oldContentOffsetY <self.assistiveTouch.begainContentOffsetY)
    {
        [self hideOrNoHideWhenScrollToFirstRowIndexPath:scrollView];
    }
    
    if (scrollView.dragging)
    {
        //向下拖
        if (floor(scrollView.contentOffset.y - self.assistiveTouch.begainContentOffsetY)>5.f)
        {
            self.assistiveTouch.hidden = YES;
        }
        else if (floor(self.assistiveTouch.begainContentOffsetY-scrollView.contentOffset.y)>5.f)
        {
            [self hideOrNoHideWhenScrollToFirstRowIndexPath:scrollView];
        }
    }
}


- (void)asTouchScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.assistiveTouch.oldContentOffsetY = scrollView.contentOffset.y;
}


- (void)hideOrNoHideWhenScrollToFirstRowIndexPath:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]])
    {
        UITableView *tableView = (UITableView *)scrollView;
        NSIndexPath *firstIndex = [NSIndexPath indexPathForRow:0 inSection:0];
        if ([tableView.indexPathsForVisibleRows containsObject:firstIndex])
        {
            self.assistiveTouch.hidden = YES;
        }
        else
        {
            self.assistiveTouch.hidden = NO;
        }
    }
    if ([scrollView isKindOfClass:[UICollectionView class]])
    {
        UICollectionView *collectionView = (UICollectionView *)scrollView;
        NSIndexPath *firstIndex = [NSIndexPath indexPathForItem:0 inSection:0];
        if ([collectionView.indexPathsForVisibleItems containsObject:firstIndex])
        {
            self.assistiveTouch.hidden = YES;
        }
        else
        {
            self.assistiveTouch.hidden = NO;
        }
    }
}


@end
