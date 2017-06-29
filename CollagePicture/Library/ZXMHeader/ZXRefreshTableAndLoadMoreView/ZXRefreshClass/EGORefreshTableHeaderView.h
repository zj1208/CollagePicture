//
//  EGORefreshTableHeaderView.h
//  Demo
//
//自己优化修改版本－2015.4.7
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

typedef enum{
	EGOOPullRefreshPulling = 0,
	EGOOPullRefreshNormal,
	EGOOPullRefreshLoading,	
} EGOPullRefreshState;
typedef void (^SuccessBlock)(id data,NSString * taskNumber) ;


typedef void(^RequestFinishBlock) ();
@protocol EGORefreshTableHeaderDelegate;


@interface EGORefreshTableHeaderView : UIView

@property(nonatomic,weak) id <EGORefreshTableHeaderDelegate> delegate;
@property(nonatomic,getter = isReloading)BOOL reloading;


- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor;



- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;

//请求完后就调用回调方法
- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

//自动刷新加载
- (void)egoRefreshScrollViewDataSourceStartManualLoading:(UIScrollView *)scrollView;

@end




@protocol EGORefreshTableHeaderDelegate <NSObject>

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view;


@optional
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view;

- (NSString*)egoRefreshTableHeaderDataSourceLastUpdatedDateFormatter:(EGORefreshTableHeaderView*)view;
@end




/*
 <EGORefreshTableHeaderDelegate>
 
 @property(nonatomic,strong)EGORefreshTableHeaderView *refreshHeaderView;
 @property(nonatomic)NSInteger pageNo;

 [self addRefreshHeaderView];

 
 - (void)addRefreshHeaderView
 {
    self.refreshHeaderView = [[EGORefreshTableHeaderView alloc] init];
    self.refreshHeaderView.delegate = self;
    [self.tableView addSubview:self.refreshHeaderView];
    [self.refreshHeaderView egoRefreshScrollViewDataSourceStartManualLoading:self.tableView];
 }

 

 -(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
 {
    self.pageNo = 1;
    [self.dataMArray removeAllObjects];
    [self requestData];
 }
 


 //在请求完成的地方调用回调方法；
 [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
 
 
 //#pragma mark-fresh Data
 - (void)scrollViewDidScroll:(UIScrollView *)scrollView
 {
    [self.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
 }
 
 
 -(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
 {
    [self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
 }
*/
