//
//  UIScrollView+ZXRefreshHView.m
//  douniwan
//
//  Created by simon on 15/7/2.
//  Copyright (c) 2015年 遥望. All rights reserved.
//

#import "UIScrollView+ZXRefreshHView.h"

static char UIScrollViewPullToRefreshView;
NSString *const refreshFinished = @"refreshFinished";

@implementation UIScrollView (ZXRefreshHView)

@dynamic pullToRefreshView;



- (void)addRefreshHeaderViewWithTarget:(id)target action:(SEL)action
{
    EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] init];
    view.delegate = self;
    self.pullToRefreshView = view;
    [self addSubview:self.pullToRefreshView];
        
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backBlock) name:refreshFinished object:nil];
    IMP imp = class_getMethodImplementation([target class], action);
    Method method = class_getInstanceMethod([target class], action);
    if (class_addMethod(self.class, @selector(addMethodAction), imp, method_getTypeEncoding(method)))
    {
    }
    

}

- (void)addMethodAction
{
        
}
- (void)backBlock
{
    [self addMethodAction];
}

- (void)setPullToRefreshView:(EGORefreshTableHeaderView *)pullToRefreshView {
    [self willChangeValueForKey:@"EGORefreshTableHeaderView"];
    objc_setAssociatedObject(self, &UIScrollViewPullToRefreshView,
                             pullToRefreshView,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"EGORefreshTableHeaderView"];
}

- (EGORefreshTableHeaderView *)pullToRefreshView {
    return objc_getAssociatedObject(self, &UIScrollViewPullToRefreshView);
}




- (void)refreshHeaderViewBeginRefreshing
{
    [self.pullToRefreshView egoRefreshScrollViewDataSourceStartManualLoading:self];
}

//
//如果符合要求，就会调用这个代理。同时会调用动画菊花
-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    [[NSNotificationCenter defaultCenter]postNotificationName:refreshFinished object:nil];
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.pullToRefreshView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.pullToRefreshView egoRefreshScrollViewDidEndDragging:scrollView];
}

@end
