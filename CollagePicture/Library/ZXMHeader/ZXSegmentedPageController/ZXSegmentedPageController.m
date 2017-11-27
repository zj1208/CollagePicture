//
//  ZXSegmentedPageController.m
//  Demo
//
//  Created by simon on 2017/9/6.
//  Copyright © 2017年 simon. All rights reserved.
//

#import "ZXSegmentedPageController.h"

@interface ZXSegmentedPageController ()<ZXSegmentedControlDelegate,UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSMutableArray *pages;



@end

@implementation ZXSegmentedPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.selectedIndex = 0;
    self.currentIndex = 0;
    self.segmentHeight = 40.f;
    self.segmentView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.segmentHeight);
    self.pageViewController.view.frame = CGRectMake(0, CGRectGetMaxY(self.segmentView.frame), self.view.frame.size.width, self.view.frame.size.height-self.segmentHeight);

    self.segmentView.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 50);
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

}

//viewWillAppear之后确定布局
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
    [self.segmentView.collectionView scrollToItemAtIndexPath:selectIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
//    [self.view bringSubviewToFront:self.segmentView];
}


#pragma mark - data

- (NSMutableArray *)pages {
    if (_pages == nil) {
        _pages = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _pages;
}


#pragma mark - UI

- (ZXSegmentedControl *)segmentView {
    if (_segmentView == nil) {
        _segmentView = [[ZXSegmentedControl alloc]init] ;
        _segmentView.delegate = self;
        _segmentView.fontSize = 15;
        [self.view addSubview:_segmentView];
    }
    
    return _segmentView;
}


- (UIPageViewController *)pageViewController {
    if (_pageViewController == nil) {
        NSDictionary *option = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:10] forKey:UIPageViewControllerOptionInterPageSpacingKey];
        _pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:option];
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
        
        [self addChildViewController:_pageViewController];
        [self.view addSubview:_pageViewController.view];
    }
    
    return _pageViewController;
}

#pragma mark - Setter

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers {
    _viewControllers = viewControllers;
    
    [self.pages addObjectsFromArray:_viewControllers];
    
    //刚开始不能加载，不然如果要先到其它页面，岂不是要加载二次；
//    UIViewController *vc = [self.pages objectAtIndex:self.currentIndex];
//    [self.pageViewController setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
//    if ([self.delegate respondsToSelector:@selector(zx_segmentPageControllerWithSegmentView:didSelectedIndex:)])
//    {
//        [self.delegate zx_segmentPageControllerWithSegmentView:self.segmentView didSelectedIndex:self.currentIndex];
//    }
}


#pragma mark - Setter SegmentView有关

- (void)setSegmentTitles:(NSArray *)segmentTitles {
    
    _segmentTitles = segmentTitles;
    self.segmentView.sectionTitles = segmentTitles;
    [self.segmentView reloadData];
    
    //为了保证不管titles是否赋值，都能更新选中项；
//    [self setSelectedPageIndex:self.currentIndex animated:YES];

}

- (void)setSegmentTitleNormalColor:(UIColor *)segmentTitleNormalColor {
    _segmentTitleNormalColor = segmentTitleNormalColor;
    
    self.segmentView.normalColor = segmentTitleNormalColor;
}

- (void)setSegmentTitleSelectedColor:(UIColor *)segmentTitleSelectedColor
{
    _segmentTitleSelectedColor = segmentTitleSelectedColor;
    self.segmentView.selectedColor = segmentTitleSelectedColor;
}

- (void)setSegmentFontSize:(CGFloat)segmentFontSize {
    _segmentFontSize = segmentFontSize;
    self.segmentView.fontSize = segmentFontSize;
}

- (void)setSegmentSeletedFontSize:(CGFloat)segmentSeletedFontSize
{
    _segmentSeletedFontSize = segmentSeletedFontSize;
    self.segmentView.selectedFontSize = segmentSeletedFontSize;
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
}


//必须要先有segmentView的titles
- (void)setSelectedPageIndex:(NSUInteger)index animated:(BOOL)animated
{
    if (index < [self.pages count])
    {
        self.currentIndex = index;
        [self.segmentView setSelectedIndex:index animation:animated];
//        [self.pageControl setSelectedSegmentIndex:index animated:YES];
        [self.pageViewController setViewControllers:@[self.pages[index]]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:animated
                                         completion:NULL];
    }
}

#pragma mark -外观Setter

- (void)setHideSegmentBottomDivideLine:(BOOL)hideSegmentBottomDivideLine
{
    _hideSegmentBottomDivideLine = hideSegmentBottomDivideLine;
    self.segmentView.hideBottomDivideLine = hideSegmentBottomDivideLine;
}

- (void)setSegmentMinimumItemSpacing:(CGFloat)segmentMinimumItemSpacing
{
    _segmentMinimumItemSpacing = segmentMinimumItemSpacing;
    self.segmentView.minimumItemSpacing = segmentMinimumItemSpacing;
}

- (void)setSegmentSelectionStyle:(ZXSegmentedControlSelectionStyle)segmentSelectionStyle
{
    _segmentSelectionStyle = segmentSelectionStyle;
    self.segmentView.selectionStyle = segmentSelectionStyle;
}

- (void)setSegmentEdgeInset:(UIEdgeInsets)segmentEdgeInset
{
    _segmentEdgeInset = segmentEdgeInset;
    self.segmentView.segmentEdgeInset = segmentEdgeInset;
}

- (void)setSegmentSelectionIndicatorColor:(UIColor *)segmentSelectionIndicatorColor
{
    _segmentSelectionIndicatorColor = segmentSelectionIndicatorColor;
    self.segmentView.selectionIndicatorColor = segmentSelectionIndicatorColor;
}

- (void)setSegmentSelectionIndicatorHeight:(CGFloat)segmentSelectionIndicatorHeight
{
    _segmentSelectionIndicatorHeight = segmentSelectionIndicatorHeight;
    self.segmentView.selectionIndicatorHeight = segmentSelectionIndicatorHeight;
}

#pragma mark - UIPageViewControllerDataSoure

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index  = [self.pages indexOfObject:viewController];
    if (index ==0 || index == NSNotFound)
    {
        return nil;
    }
    index --;
    return [self.pages objectAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index  = [self.pages indexOfObject:viewController];
    if (index >=self.pages.count-1 || index == NSNotFound)
    {
        return nil;
    }
    index ++;
    NSLog(@"pageViewController,下一页Index=%ld",index);
    return [self.pages objectAtIndex:index];
    
}

#pragma mark - ZXSegmentedControlDelegate

- (void)zx_segmentView:(ZXSegmentedControl *)ZXSegmentedControl didSelectedIndex:(NSInteger)index
{
    if (self.pages.count <= index)
    {
        return;
    }
    UIViewController *vc = [self.pages objectAtIndex:index];
    if (index > self.currentIndex)
    {
        [self.pageViewController setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        [self.pageViewController setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
            
        }];
    }
    self.currentIndex = index;
    
    if ([self.delegate respondsToSelector:@selector(zx_segmentPageControllerWithSegmentView:didSelectedIndex:)])
    {
        [self.delegate zx_segmentPageControllerWithSegmentView:ZXSegmentedControl didSelectedIndex:index];
    }
}

- (void)zx_segmentView:(ZXSegmentedControl *)ZXSegmentedControl willDisplayCell:(ZXSegmentCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(zx_segmentPageControllerWithSegmentView:willDisplayCell:forItemAtIndexPath:)])
    {
        [self.delegate zx_segmentPageControllerWithSegmentView:ZXSegmentedControl willDisplayCell:cell forItemAtIndexPath:indexPath];
    }
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    
    UIViewController *nextVC = [pendingViewControllers firstObject];
    NSInteger index = [self.pages indexOfObject:nextVC];
    self.currentIndex = index;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    if ([self.delegate respondsToSelector:@selector(zx_segmentPageControllerWithTransitionToViewControllersIndex:transitionCompleted:)])
    {
        [self.delegate zx_segmentPageControllerWithTransitionToViewControllersIndex:self.currentIndex transitionCompleted:completed];
    }
    if (completed) {
        
        self.segmentView.selectedIndex =self.currentIndex ;
    }
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
