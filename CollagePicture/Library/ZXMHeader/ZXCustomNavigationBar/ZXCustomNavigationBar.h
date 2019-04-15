//
//  ZXCustomNavigationBar.h
//  YiShangbao
//
//  Created by simon on 2017/10/19.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  简介：自定义导航条，根据iOS11系统导航条设计；背景容器view+ 放按钮的容器View；
//       放按钮的容器View:navigationBarContentView的高度固定44；
//       背景容器view：barBackgroundContainerView高度自适应；iphoneX 设置64+24，其余设置64
//  如果当前控制器是隐藏导航条的， 二级页面有的是隐藏导航条的，有些是不隐藏导航条的；需要在viewWillDisapear正常转场和滑动中断时期根据下个显示的控制器判断是否显示navigationBar；返回的时候，需要在viewWillAppear滑动中断时期根据之前显示的的页面判断是否显示navigationBar；

//  待优化可以自定义添加左边，右边按钮；

//  5.10  修改注释
//  2019.4.01  修改默认值，添加完整例子；
//  2019.4.15  增加设置title标题属性；


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXCustomNavigationBar : UIView

// 背景图+分割线容器View
@property (weak, nonatomic) IBOutlet UIView *barBackgroundContainerView;
// 导航条背景图
@property (weak, nonatomic) IBOutlet UIImageView *barBackgroundImageView;

// 导航条分割线
@property (weak, nonatomic) IBOutlet UIImageView *barBackgroundShadowImageView;



// 整个按钮区域+titleView 的容器视图
@property (weak, nonatomic) IBOutlet UIView *navigationBarContentView;
// 中间titleView
@property (weak, nonatomic) IBOutlet UIView *titleView;
// 设置标题
@property (nullable,nonatomic,copy) NSString *title;

/**
 左边按钮的容器view
 */
@property (weak, nonatomic) IBOutlet UIView *leftContainerView;

/**
 最左边的按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *leftBarButton;


/**
 右边按钮的容器view
 */
@property (weak, nonatomic) IBOutlet UIView *rightContainerView;
/**
 右边倒数第二的按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *rightBarButton2;


/**
 最右边的按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *rightBarButton1;



// 设置背景图
- (void)zx_setBarBackgroundImage:(nullable UIImage *)backgroundImage;

// 设置背景颜色
- (void)zx_setBarBackgroundColor:(nullable UIColor *)backgroundColor;


// 设置barBackgroundContainerView的alpha
- (void)zx_setBarBackgroundContainerAlpha:(CGFloat)alpha animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END

//  例如： 如果是纯代码添加自定义NavigationBarView，则需要修改tableView的约束值；
/*
@property (nonatomic, strong) UIImageView * topImageView;
@property (nonatomic, strong) ZXCustomNavigationBar *customNavigationBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopLayoutConstraint;
*/

/*
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.customNavigationBar.frame = CGRectMake(0, 0, LCDW, HEIGHT_NAVBAR);
    self.tableViewTopLayoutConstraint.constant = HEIGHT_NAVBAR;
}

- (ZXCustomNavigationBar *)customNavigationBar{
    if(!_customNavigationBar)
    {
        ZXCustomNavigationBar *navigationBar = [ZXCustomNavigationBar zx_viewFromNib];
        [navigationBar zx_setBarBackgroundColor:UIColorFromRGB_HexValue(0xBF352D)];
        navigationBar.hidden = YES;
        _customNavigationBar = navigationBar;
    }
    return _customNavigationBar;
}

- (void)addNavigationBarView
{
    _stausBarStyle =UIStatusBarStyleDefault;
    [self.view addSubview:self.customNavigationBar];
    [self.customNavigationBar.leftBarButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavigationBar.rightBarButton1 addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavigationBar.rightBarButton2 addTarget:self action:@selector(previewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

//前提是collectionView的背景要透明
- (void)createScaleImageView
{
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:self.topImageView belowSubview:self.collectionView];
    self.topImageView.hidden = YES;
    _contentInsetTop = 0;
 //    self.tableView.contentInset = UIEdgeInsetsMake(64-20, 0, 0, 0);
 //    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64-20+ _contentInsetTop, 0, 0, 0);
}
- (UIImageView *)topImageView
{
    if (!_topImageView)
    {
        _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, LCDW, LCDW*100.f/375.0)];
        _topImageView.backgroundColor = UIColorFromRGB_HexValue(0xBF352D);
    }
    return _topImageView;
}
*/

// 显示背景/ 隐藏背景的 动态转变
/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //注意,默认偏移为-20
    CGFloat offsetY = scrollView.contentOffset.y + scrollView.contentInset.top;
    //    NSLog(@"%f,%f,%f",scrollView.contentOffset.y,scrollView.contentInset.top,offsetY);
    if (offsetY <= 0) {
        
        CGRect frame = self.topImageView.frame;
        frame.size.height= HEIGHT_NAVBAR+_contentInsetTop+ABS(offsetY);
        self.topImageView.frame = frame;
        
        [self.customNavigationBar zx_setBarBackgroundContainerAlpha:0 animated:YES];
    }
    else
    {
        CGFloat alpha = (offsetY>0 && offsetY<=20)?offsetY/20:1.f;
        [self.customNavigationBar zx_setBarBackgroundContainerAlpha:alpha animated:YES];
        
        if (alpha >0.5)
        {
            //            _stausBarStyle = UIStatusBarStyleDefault;
            //            [self setNeedsStatusBarAppearanceUpdate];
        }
        else
        {
            //            _stausBarStyle = UIStatusBarStyleLightContent;
            //            [self setNeedsStatusBarAppearanceUpdate];
        }
        CGRect frame = self.topImageView.frame;
        frame.size.height= HEIGHT_NAVBAR+_contentInsetTop;
        self.topImageView.frame = frame;
    }
}
 */

#pragma mark -刚显示时候的细节处理
/*
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];

    if (self.presentedViewController)
    {
        return;
    }
 
    id<UIViewControllerTransitionCoordinator>tc = self.transitionCoordinator;
    if (tc && [tc initiallyInteractive])
    {
        [self.customNavigationBar zx_setBarBackgroundContainerAlpha:0 animated:animated];
        // 如果上级页面本来就是需要隐藏导航条的控制器，则不复原；
        if (@available(iOS 10.0, *))
        {
            [tc notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                if ([context isCancelled])
                {
                    UIViewController *fromViewController = [context viewControllerForKey: UITransitionContextFromViewControllerKey];
                    if (![fromViewController isKindOfClass:NSClassFromString(@"MyLevelViewController")])
                    {
                        [self.navigationController setNavigationBarHidden:NO animated:animated];
                    }
                }
            }];
        }
        else
        {
            [tc notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                if ([context isCancelled])
                {
                    UIViewController *fromViewController = [context viewControllerForKey: UITransitionContextFromViewControllerKey];
                    if (![fromViewController isKindOfClass:NSClassFromString(@"MyLevelViewController")])
                    {
                        [self.navigationController setNavigationBarHidden:NO animated:animated];
                    }
                }
            }];
        }

    }
    else
    {
        CGFloat offsetY = self.collectionView.contentOffset.y + self.collectionView.contentInset.top;
        if (offsetY<=0)
        {
            [self.customNavigationBar zx_setBarBackgroundContainerAlpha:0 animated:YES];
        }
        else
        {
            CGFloat alpha = (offsetY>0 && offsetY<=_contentInsetTop)?offsetY/_contentInsetTop:1.f;
            [self.customNavigationBar zx_setBarBackgroundContainerAlpha:alpha animated:YES];
        }
    }
}
*/

// 要显示的页面本来就是需要隐藏导航条的控制器，则不复原；
/*
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.presentedViewController)
    {
        return;
    }
    if (self.transitionCoordinator != nil)
    {
        //非交互式回调,完成转场了再设置navigationBar是否隐藏已经无意义了,所以completion的block不用
        BOOL flag  = [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            UIViewController *toViewController = [context viewControllerForKey: UITransitionContextToViewKey];
            if (![toViewController isKindOfClass:NSClassFromString(@"MyLevelViewController")])
            {
                [self.navigationController setNavigationBarHidden:NO animated:animated];
            }
        } completion:nil];
        //交互式中断
        if (!flag)
        {
            UIViewController *toViewController = self.navigationController.topViewController;
            if (![toViewController isKindOfClass:NSClassFromString(@"MyLevelViewController")])
            {
                [self.navigationController setNavigationBarHidden:NO animated:animated];
            }
        }
    }
}
*/


// 如果二级页面也是隐藏系统导航条，使用自定义view的，则在viewWillDisappear需要判断下个显示的控制器是否需要展示navigationBar；
// 如果返回页面本来就是需要隐藏导航条的控制器，则不复原；

/*
override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true);
    if (self.transitionCoordinator != nil)
    {
        self.transitionCoordinator?.animate(alongsideTransition: { (context:UIViewControllerTransitionCoordinatorContext) in
            
            let toViewController = context.viewController(forKey: UITransitionContextViewControllerKey.to);
            if (!(toViewController is MineViewController))
            {
                self.navigationController?.setNavigationBarHidden(false, animated: animated);
            }
        }, completion:nil);
    }
}

override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated);
    self.navigationController?.setNavigationBarHidden(true, animated: animated);
    if (self.navigationController?.viewControllers.count)! > 1
    {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate;
    }
}
override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews();
    self.barHeightConstraint.constant = kNavigationBarHeight;
}
*/
