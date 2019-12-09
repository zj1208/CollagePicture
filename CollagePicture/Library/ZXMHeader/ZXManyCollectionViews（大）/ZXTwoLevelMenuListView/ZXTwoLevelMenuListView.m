//
//  ZXTwoLevelMenuListView.m
//  MobileCaiLocal
//
//  Created by simon on 2019/11/27.
//  Copyright © 2019 timtian. All rights reserved.
//

#import "ZXTwoLevelMenuListView.h"

#ifndef IS_IPHONE_XX
#define IS_IPHONE_XX ({\
int tmp = 0;\
if (@available(iOS 11.0, *)) { \
    UIEdgeInsets areaInset = [UIApplication sharedApplication].delegate.window.safeAreaInsets;\
    if (areaInset.bottom >0) { \
        tmp = 1;\
    }\
}\
else{\
    tmp = 0;\
}\
tmp;\
})
#endif



#pragma mark - 获取navigationBar，statusBar，tabBar高度

#ifndef  kHEIGHT_SAFEAREA_STATUSBAR
#define  kHEIGHT_SAFEAREA_STATUSBAR   (IS_IPHONE_XX ? (20.f+24.f) : (20.f))
#endif

#ifndef  kHEIGHT_SAFEAREA_NAVBAR
#define  kHEIGHT_SAFEAREA_NAVBAR      (kHEIGHT_SAFEAREA_STATUSBAR+44.f)
#endif

@interface ZXTwoLevelMenuListView ()<ZXLeftFirstLevelMenuListViewDataSource,ZXLeftFirstLevelMenuListViewDelegate,ZXRightSecondLeveMenuListViewDataSource,ZXRightSecondLeveMenuListViewDelegate>

//记录一级列表上次选中的有效indexPath
@property (nonatomic, strong) NSIndexPath *lastSelectedLeftFirstLevelIndexPath;
//记录二级列表上次选中的有效indexPath
@property (nonatomic, strong) NSIndexPath *lastSelectedRightSecondLevelIndexPath;

@end


@implementation ZXTwoLevelMenuListView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initUIAndData];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initUIAndData];
    }
    return self;
}


- (void)initUIAndData
{
    self.backgroundColor = [UIColor whiteColor];
    if (CGRectEqualToRect(self.frame, CGRectZero))
    {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, LCDScale_iPhone6_Width(250.f));
    }
    [self addSubview:self.leftFirstLevelMenuView];
    [self addSubview:self.rightSecondLevelMenuView];
    
    self.leftFirstLevelMenuViewWidth = 80;
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    self.leftFirstLevelMenuView.frame = CGRectMake(0, 0, self.leftFirstLevelMenuViewWidth, CGRectGetHeight(self.bounds));
    self.rightSecondLevelMenuView.frame = CGRectMake(self.leftFirstLevelMenuViewWidth, 0, CGRectGetWidth(self.bounds)-self.leftFirstLevelMenuViewWidth, CGRectGetHeight(self.bounds));
    CGFloat width = [self.rightSecondLevelMenuView getItemAverageWidthInTotalWidth:CGRectGetWidth(self.bounds)-self.leftFirstLevelMenuViewWidth columnsCount:3 sectionInset:self.rightSecondLevelMenuView.sectionInset minimumInteritemSpacing:self.rightSecondLevelMenuView.minimumInteritemSpacing];
    self.rightSecondLevelMenuView.itemSize = CGSizeMake(width, width *30/85);
}

- (ZXLeftFirstLevelMenuListView *)leftFirstLevelMenuView
{
    if (!_leftFirstLevelMenuView) {
        
        _leftFirstLevelMenuView = [[ZXLeftFirstLevelMenuListView alloc] init];
        _leftFirstLevelMenuView.dataSource = self;
        _leftFirstLevelMenuView.delegate = self;
    }
    return _leftFirstLevelMenuView;
}

- (ZXRightSecondLeveMenuListView *)rightSecondLevelMenuView
{
    if (!_rightSecondLevelMenuView) {
        
        _rightSecondLevelMenuView = [[ZXRightSecondLeveMenuListView alloc] init];
        _rightSecondLevelMenuView.dataSource = self;
        _rightSecondLevelMenuView.delegate = self;
    }
    return _rightSecondLevelMenuView;
}


#pragma mark - 一级二级列表的DataSource，Delegate

- (NSString *)zx_leftFirstLevelMenuListView:(ZXLeftFirstLevelMenuListView *)leftMenuListView titleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataSource respondsToSelector:@selector(zx_twoLevelMenuListView:titleForLeftFirstLevelRowAtIndexPath:)]) {
        
        return [self.dataSource zx_twoLevelMenuListView:self titleForLeftFirstLevelRowAtIndexPath:indexPath];
    }
    return nil;
}

- (NSInteger)zx_leftFirstLevelMenuListView:(ZXLeftFirstLevelMenuListView *)leftMenuListView numberOfRowsInSection:(NSInteger)section
{
    if ([self.dataSource respondsToSelector:@selector(zx_twoLevelMenuListView:numberOfRowsInLeftFirstLevelSection:)]) {
        return [self.dataSource zx_twoLevelMenuListView:self numberOfRowsInLeftFirstLevelSection:section];
    }
    return 0;
}

- (void)zx_leftFirstLevelMenuListView:(ZXLeftFirstLevelMenuListView *)leftMenuListView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.rightSecondLevelMenuView.collectionView reloadData];
}


- (NSString *)zx_rightSecondLeveMenuListView:(ZXRightSecondLeveMenuListView *)leftMenuListView titleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataSource respondsToSelector:@selector(zx_twoLevelMenuListView:titleForRightSecondLevelRowAtIndexPath:)]) {
        
        return [self.dataSource zx_twoLevelMenuListView:self titleForRightSecondLevelRowAtIndexPath:indexPath];
    }
    return nil;
}

- (NSInteger)zx_rightSecondLeveMenuListView:(ZXRightSecondLeveMenuListView *)leftMenuListView numberOfRowsInSection:(NSInteger)section
{
    if ([self.dataSource respondsToSelector:@selector(zx_twoLevelMenuListView:numberOfRowsInRightSecondLevelSection:)]) {
        return [self.dataSource zx_twoLevelMenuListView:self numberOfRowsInRightSecondLevelSection:section];
    }
    return 0;
}

- (BOOL)zx_rightSecondLeveMenuListView:(ZXRightSecondLeveMenuListView *)leftMenuListView isSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.lastSelectedLeftFirstLevelIndexPath &&[self.lastSelectedLeftFirstLevelIndexPath isEqual:[self indexPathForFirstLevelTableViewSelectedRow]]) {
        
        if (self.lastSelectedRightSecondLevelIndexPath == indexPath) {
            return YES;
        }
    }
    return NO;
}

- (void)zx_rightSecondLeveMenuListView:(ZXRightSecondLeveMenuListView *)leftMenuListView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.lastSelectedLeftFirstLevelIndexPath = [self indexPathForFirstLevelTableViewSelectedRow];
    self.lastSelectedRightSecondLevelIndexPath = indexPath;
//    self.rightSecondLevelMenuView.lastSelectedRightSecondLevelIndexPath = self.lastSelectedRightSecondLevelIndexPath;
    __weak __typeof(&*self)weakSelf = self;
    [self dismissViewWithCompletion:^(BOOL finished) {
        
        if ([weakSelf.delegate respondsToSelector:@selector(zx_twoLevelMenuListView:didSelectRightSecondLevelItemAtIndexPath:)]) {
            [weakSelf.delegate zx_twoLevelMenuListView:weakSelf didSelectRightSecondLevelItemAtIndexPath:indexPath];
        }
    }];

}

#pragma mark - 获取第一级列表选中的row
- (NSIndexPath *)indexPathForFirstLevelTableViewSelectedRow
{
    NSIndexPath *groupIndexPath = [self.leftFirstLevelMenuView.tableView indexPathForSelectedRow];
    return groupIndexPath;
}

#pragma mark - 选中上次选择的item

- (void)selectLastIndexPath
{
    if (!self.lastSelectedLeftFirstLevelIndexPath) {
        [self.leftFirstLevelMenuView.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }else{
     
        [self.leftFirstLevelMenuView.tableView selectRowAtIndexPath:self.lastSelectedLeftFirstLevelIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self zx_leftFirstLevelMenuListView:self.leftFirstLevelMenuView didSelectItemAtIndexPath:self.lastSelectedLeftFirstLevelIndexPath];
    }
}

#pragma mark - 弹出，关闭

- (void)showInView:(UIView *)view
{
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    if ([view isKindOfClass:[UITableView class]] ||[view isKindOfClass:[UICollectionView class]])
    {
        view = window;
    }
    ZXOverlay *overlay = [[ZXOverlay alloc] init];
    overlay.delegate = self;
    [overlay addSubview:self];
    [view addSubview:overlay];
    
    overlay.frame = view.bounds;

    self.frame = CGRectMake(0, -CGRectGetHeight(self.frame), CGRectGetWidth(view.frame), CGRectGetHeight(self.frame));
    [UIView animateWithDuration:0.3 animations:^{
        
            self.frame = CGRectMake(0, kHEIGHT_SAFEAREA_NAVBAR, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissViewWithCompletion:(void (^ __nullable)(BOOL finished))completion
{
    [UIView animateWithDuration:0.3
                     animations:^{

                         self.frame = CGRectMake(0,-CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));

                     }
                     completion:^(BOOL finished){
                         
                         
                         [UIView animateWithDuration:0.05 animations:^{
                             
                             self.superview.alpha = 0;
                             
                         } completion:^(BOOL finished) {
                             
                             if ([self.superview isKindOfClass:[ZXOverlay class]])
                                 [self.superview removeFromSuperview];
                             [self removeFromSuperview];
                             if (completion) {
                                 completion(finished);
                             }
                         }];
                     }];
}

- (void)zxOverlaydissmissAction
{
    __weak __typeof(&*self)weakSelf = self;
    [self dismissViewWithCompletion:^(BOOL finished) {
        
        if ([weakSelf.delegate respondsToSelector:@selector(zx_dismissViewWithTwoLevelMenuListView:)]) {
            [weakSelf.delegate zx_dismissViewWithTwoLevelMenuListView:weakSelf];
        }
    }];
}

- (void)reloadData
{
    [self.leftFirstLevelMenuView.tableView reloadData];
}
@end
