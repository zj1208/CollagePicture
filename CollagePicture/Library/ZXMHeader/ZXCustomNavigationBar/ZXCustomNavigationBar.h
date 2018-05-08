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

//  待优化可以自定义添加左边，右边按钮；

//  4.28  优化功能；


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXCustomNavigationBar : UIView

// 背景图+分割线容器View
@property (weak, nonatomic) IBOutlet UIView *barBackgroundContainerView;
// 导航条背景图
@property (weak, nonatomic) IBOutlet UIImageView *barBackgroundImageView;

// 导航条分割线
@property (weak, nonatomic) IBOutlet UIImageView *barBackgroundShadowImageView;



// 按钮容器视图
@property (weak, nonatomic) IBOutlet UIView *navigationBarContentView;
// 中间titleView
@property (weak, nonatomic) IBOutlet UIView *titleView;

@property (weak, nonatomic) IBOutlet UIView *rightContainerView;

@property (weak, nonatomic) IBOutlet UIView *leftContainerView;

@property (strong, nonatomic) UIBarButtonItem *leftBarButtonItem;

@property (weak, nonatomic) IBOutlet UIButton *leftBarButton;
@property (weak, nonatomic) IBOutlet UIButton *rightBarButton2;
@property (weak, nonatomic) IBOutlet UIButton *rightBarButton1;

// 设置背景图
- (void)zx_setBarBackgroundImage:(nullable UIImage *)backgroundImage;

// 设置背景颜色
- (void)zx_setBarBackgroundColor:(nullable UIColor *)backgroundColor;


// 设置barBackgroundContainerView的alpha
- (void)zx_setBarBackgroundContainerAlpha:(CGFloat)alpha animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END

//  例如：
/*
@property (nonatomic, strong) UIImageView * topImageView;
@property (nonatomic, strong) ZXCustomNavigationBar *customNavigationBar;
*/

/*
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.customNavigationBar.frame = CGRectMake(0, 0, LCDW, HEIGHT_NAVBAR);
}

- (void)addNavigationBarView
{
    ZXCustomNavigationBar *navigationBar = [ZXCustomNavigationBar xm_viewFromNib];
    [self.view addSubview:navigationBar];
    //    navigationBar.hidden = YES;
    [navigationBar zx_setBarBackgroundColor:UIColorFromRGB_HexValue(0xBF352D)];
    self.customNavigationBar = navigationBar;
    
    [self.customNavigationBar.leftBarButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.customNavigationBar.rightBarButton1 addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.customNavigationBar.rightBarButton2 addTarget:self action:@selector(previewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

//前提是collectionView的背景要透明
- (void)createScaleImageView
{
    self.collectionView.backgroundColor = [UIColor clearColor];
    _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, LCDW, LCDW*100.f/375.0)];
    _topImageView.backgroundColor = UIColorFromRGB_HexValue(0xBF352D);
    //    UIImage *image = [UIImage zh_getGradientImageFromTowColorComponentWithSize:CGSizeMake(LCDW, LCDW*100.f/375.0) startColor:UIColorFromRGB(255.f, 180.f, 94.f) endColor:UIColorFromRGB(243.f, 117.f, 80.f)];
    //    _topImageView.image =image;
    [self.view insertSubview:_topImageView belowSubview:self.collectionView];
    _topImageView.hidden = YES;
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
        
        CGRect frame = _topImageView.frame;
        frame.size.height= HEIGHT_NAVBAR+_contentInsetTop-offsetY;
        _topImageView.frame = frame;
        
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
        CGRect frame = _topImageView.frame;
        frame.size.height= HEIGHT_NAVBAR+_contentInsetTop;
        _topImageView.frame = frame;
    }
}
 */

#pragma mark -刚显示时候的细节处理
/*
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.presentedViewController)
    {
        return;
    }
    id<UIViewControllerTransitionCoordinator>tc = self.transitionCoordinator;
    if (tc && [tc initiallyInteractive])
    {
        [self.customNavigationBar zx_setBarBackgroundContainerAlpha:0 animated:animated];
        [self.navigationController setNavigationBarHidden:YES animated:animated];
        
        [tc notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            if ([context isCancelled])
            {
                [self.navigationController setNavigationBarHidden:NO animated:animated];
            }
        }];
    }
    else
    {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
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



