//
//  UIViewController+NavBarCustom.m
//  ShiChunTang
//
//  Created by zhuxinming on 14/11/1.
//  Copyright (c) 2014年 ZhuXinMing. All rights reserved.
//

#import "UIViewController+NavBarCustom.h"
#import "UIButton+ZXHelper.h"
//#import "APPCommonDef.h"


@implementation UIViewController (NavBarCustom)


#pragma mark-LeftBarBut

-(void)zhNavigationItem_leftBarButtonItem_CustomView_imageName:(nullable NSString*)imageName highImageName:(nullable NSString *)imageName2 title:(nullable NSString *)backTitle action:(nullable SEL)action
{
    UIImage* backItemImage = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImage* backItemHlImage = [[UIImage imageNamed:imageName2] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    UIButton* backButton = [[UIButton alloc] init];
    [backButton setTitle:backTitle forState:UIControlStateNormal];
    [backButton setTitleColor:self.navigationController.navigationBar.tintColor forState:UIControlStateNormal];
    [backButton setTitleColor:[self.navigationController.navigationBar.tintColor colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [backButton setImage:backItemImage forState:UIControlStateNormal];
    [backButton setImage:backItemHlImage forState:UIControlStateHighlighted];
    
    backButton.frame = CGRectMake(0, 0, 50, 44);
    if (imageName && backTitle)
    {
        [backButton zh_centerHorizontalImageAndTitleWithTheirSpace:10.f];
    }
//    [backButton setBackgroundColor:[UIColor redColor]];
    [backButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBar;
}



- (NSArray *)zhNavigationItem_leftOrRightItemReducedSpaceToMaginWithItems:(NSArray *)barButtonItems
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    NSMutableArray *mArray = [NSMutableArray arrayWithArray:barButtonItems];
    [mArray insertObject:negativeSpacer atIndex:0];
    return (NSArray *)mArray;
}

- (NSArray *)zhNavigationItem_leftOrRightItemReducedSpaceToMagin:(CGFloat)magin withItems:(NSArray *)barButtonItems
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = magin;
    NSMutableArray *mArray = [NSMutableArray arrayWithArray:barButtonItems];
    [mArray insertObject:negativeSpacer atIndex:0];
    return (NSArray *)mArray;
}


/**
 *  @brief set all navigationBar 's 返回《指示图标，appearance功能设置系统返回指示图；
 *
 */

- (void)zhNavigationBar_UIBarButtonItem_appearance_systemBack_BackgroundImage:(nullable NSString *)aName highlightImage:(nullable NSString *)highlightName
{
    UIImage *backImage = [UIImage imageNamed:aName];
    backImage= [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    backImage = [backImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, backImage.size.width, 0, 0)];
    
    UIImage *highlightImage = [[UIImage imageNamed:highlightName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    highlightImage =  [highlightImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, highlightImage.size.width, 0, 0)];
    UIBarButtonItem *item =nil;
    //ios9
    if ([UIBarButtonItem instancesRespondToSelector:@selector(appearanceWhenContainedInInstancesOfClasses:)])
    {
        item= [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UINavigationController class]]];
    }
    else
    {
        item = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationController class], nil];
    }
    [item setBackButtonBackgroundImage:backImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //横屏
    [item setBackButtonBackgroundImage:backImage forState:UIControlStateNormal barMetrics:UIBarMetricsCompact];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:highlightImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:highlightImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsCompact];

}


//- (void)zhNavigationBar_UIBarButtonItem_appearance_systemBack_background_Test
//{
//    UIImage *backImage = [UIImage zh_imageWithColor:[UIColor orangeColor] andSize:CGSizeMake(10, 10)];
//    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//}

/**
 *  @brief set all navigationBar 's 系统返回按钮为没有文字； 把文字移至看不到; 注意: storyboard中遇到很长文字的时候，中间标题会受影响，必须改变前面控制器返回按钮的文字为空，才能解决；
 *
 */
+ (void)zhNavigationBar_UIBarButtonItem_appearance_systemBack_noTitle
{
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -100)
                                                         forBarMetrics:UIBarMetricsDefault];
    //横屏
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -100)
                                                         forBarMetrics:UIBarMetricsCompact];
}


/**
 *
 *
 *  @param aName aName description
 */
- (void)zhNavigationBar_Single_BackIndicatorImage:(nullable NSString *)aName isOriginalImage:(BOOL)originalImage
{
    UIImage *backImage = [UIImage imageNamed:aName];
    if (originalImage)
    {
        backImage= [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    UINavigationController *navigationController= nil;
    if ([self isKindOfClass:[UINavigationController class]])
    {
        navigationController = (UINavigationController *)self;
    }
    else
    {
        navigationController = self.navigationController;
    }
    [navigationController.navigationBar setBackIndicatorImage:backImage];
    [navigationController.navigationBar setBackIndicatorTransitionMaskImage:backImage];
}


- (void)zhNavigationBar_tintColor:(UIColor *)tintColor
{
    if (!tintColor) {
        return;
    }
    self.navigationController.navigationBar.tintColor = tintColor;
}

/**
 *  @brief 自定义系统的返回按钮文字title,如果aTitle==nil,only arrow;当文字太长的时候,可以用这个设置系统返回;
 *  navigationItem的backBarButtonItem的action是不会执行的.无论怎么改，除了popViewController什么都不执行。
 *
 */
- (void)zhNavigationItem_backBarButtonItem_title:(nullable NSString *)aTitle font:(NSInteger)aFont
{
    NSString *string = aTitle ? aTitle : @"";
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:string style:UIBarButtonItemStylePlain target:self action:nil];
    if (aTitle)
    {
        NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:aFont] forKey:NSFontAttributeName];
        [cancelButton setTitleTextAttributes:dic forState:UIControlStateNormal];

    }
    
    self.navigationItem.backBarButtonItem = cancelButton;    
}


- (void)zhNavigationItem_titleCenter
{
    UIViewController *previousVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    previousVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                   initWithTitle:@""
                                                   style:UIBarButtonItemStylePlain
                                                   target:self
                                                   action:nil];
}


/**
 * @brief 自定义模态页面barButtonItem按钮，也是为了适应ios6和ios7兼容；默认自动加载了点击事件，加载dismissViewController；
 * @param flag ：YES＝ leftBarItem； NO＝ rightBarItem
 */
- (void)zhNavigationBar_presentedViewController_leftOrRightBarItem:(BOOL)flag   title:(NSString *)aTitle
{
    UIBarButtonItem *barBtn = nil;
    if (__IPHONE_7_0)
    {
        barBtn = [[UIBarButtonItem alloc] initWithTitle:aTitle style:UIBarButtonItemStylePlain target:self action:@selector(modelLeftButtonClickHandler)];
    }
    else
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:aTitle forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0.0, 40.0, 44.0);
        [btn addTarget:self action:@selector(modelLeftButtonClickHandler)forControlEvents:UIControlEventTouchUpInside];
        barBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    }
    if (flag)
    {
        self.navigationItem.leftBarButtonItem = barBtn;
        return;
    }
    self.navigationItem.rightBarButtonItem = barBtn;

}

- (void)modelLeftButtonClickHandler
{
    for(id view in self.view.subviews)
    {
        if ([view isKindOfClass:[UITextField class]])
        {
            UITextField *textField = view;
            if ([view isFirstResponder])
            {
                [textField resignFirstResponder];
            }
        }
    }
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        }];
}






#pragma mark-设定所有导航条背景
+ (void)zhNavigationBar_appearance_backgroundImageName:(nullable NSString *)bagImgName
                                       ShadowImageName:(nullable NSString *)aShadowName
                                     orBackgroundColor:(nullable UIColor *)backgoundColor
                                            titleColor:(nullable UIColor *)aColor
                                             titleFont:(UIFont *)aFont


{
    //tintColor不支持UIAppearance;你可以在Interface Builder中全局设置tint color-global Tint;navigationBar的tintColor－文字和按钮
    
    UIFont *tiFont = aFont ?aFont:[UIFont systemFontOfSize:17];
    
    UIColor *color = aColor?aColor:[UIColor whiteColor];
    //设置中间title标题文本;
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:color,NSFontAttributeName:tiFont}];
    
    if (bagImgName)//背景图片如果有透明效果，那么显示导航的时候也会有透明效果的；默认是毛玻璃效果
    {
        UIImage *navBgImg  =[UIImage imageNamed:bagImgName];
        if ([UINavigationBar  instancesRespondToSelector:@selector(setBackgroundImage:forBarPosition:barMetrics:)])
        {
            [[UINavigationBar appearance] setBackgroundImage:navBgImg forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
        }
        else
        {
            [[UINavigationBar appearance]setBackgroundImage:navBgImg forBarMetrics:UIBarMetricsDefault];
        }
    }
    if (!bagImgName &&backgoundColor)
    {
        if (__IPHONE_7_0)
        {
            [[UINavigationBar appearance]setBarTintColor:backgoundColor];
        }
        else
        {
            //ios6,是导航栏的颜色
        }
    }
    if (aShadowName)
    {
        UIImage *navLineImg = [UIImage imageNamed:aShadowName];
        [[UINavigationBar appearance]setShadowImage:navLineImg];
    }
}


- (void)zhNavigationBar_barItemColor:(nullable UIColor *)tintColor
{
    if ([self isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *nav = (UINavigationController *)self;
        nav.navigationBar.tintColor = tintColor;
    }
    else if ([self isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tabControler = (UITabBarController *)self;
        [tabControler.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj isKindOfClass:[UINavigationController class]])
            {
                UINavigationController *nav = (UINavigationController *)obj;
                nav.navigationBar.tintColor = tintColor;
            }
        }];
    }
    else
    {
        self.navigationController.navigationBar.tintColor =tintColor;
    }
    
}



- (void)zhNavigationBar_BackgroundAlpah:(CGFloat)alpha
{
    // 导航栏背景透明度设置
    UIView *barBackgroundView = [[self.navigationController.navigationBar subviews] objectAtIndex:0];// _UIBarBackground
    UIImageView *backgroundImageView = [[barBackgroundView subviews] objectAtIndex:0];// UIImageView
    if (self.navigationController.navigationBar.isTranslucent)
    {
        if (backgroundImageView != nil && backgroundImageView.image != nil)
        {
            barBackgroundView.alpha = alpha;
        }
        else {
            UIView *backgroundEffectView = [[barBackgroundView subviews] objectAtIndex:1];// UIVisualEffectView
            if (backgroundEffectView != nil)
            {
                backgroundEffectView.alpha = alpha;
            }
        }
    } else {
        barBackgroundView.alpha = alpha;
    }
    self.navigationController.navigationBar.clipsToBounds = alpha == 0.0;
}







// lingh add
- (void)linNavigationBar_Right_Button:(NSString *)title action:(SEL)action
{
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(10.0, 100.0, 62.0, 29.0)];
    [btnRight setBackgroundColor:[UIColor whiteColor]];
    UIColor *color = [UIColor colorWithRed:254.0 / 255 green:144.0 / 255 blue:0.0 alpha:1.0];
    [btnRight setTitleColor:color  forState:UIControlStateNormal];
    [btnRight setTitle:title forState:UIControlStateNormal];
    btnRight.layer.masksToBounds = YES;
    btnRight.layer.cornerRadius = 6;
    [btnRight addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem = barItem;
}



/*----------------------------------------------------*/
//给navigationBar上添加 logo-titleView的imageView／title
- (void)zhNavigationBar_titleView_Logo_imageName:(nullable NSString*)imageName
{
    UIImage *img = [UIImage imageNamed:imageName];
    if (!img)
    {
        return;
    }
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    self.navigationItem.titleView = imgView;
}


- (void)zhNavigationBar_titleView_Logo_Label_title:(nullable NSString*)aTitle font:(NSInteger)aFont titleColor:(UIColor*)aColor
{
    UILabel *navLab = [[UILabel alloc] initWithFrame:CGRectZero];
    navLab.text = aTitle;
    navLab.textColor = aColor?aColor:[UIColor whiteColor];
    navLab.font = [UIFont boldSystemFontOfSize:aFont];
    [navLab sizeToFit];
    self.navigationItem.titleView = navLab;
    
}




- (void)zhTabBarController_tabBarItem_ImageArray:(nullable NSArray *)aArray selectImages:(nullable NSArray *)selectArray slectedItemTintColor:(nullable UIColor *)aSleColor unselectedItemTintColor:(nullable UIColor *)unSleColor;
{
    NSMutableArray *imgArray = [NSMutableArray arrayWithCapacity:4];
    for(int i =0;i<aArray.count;i++)
    {
        UIImage *firstImgs = [UIImage imageNamed:[aArray objectAtIndex:i]];
        [imgArray addObject:firstImgs];
        
    }
    
    NSMutableArray *selectImgsArray = [NSMutableArray arrayWithCapacity:4];
    for(int i =0;i<selectArray.count;i++)
    {
        UIImage *firstImgs = [UIImage imageNamed:[selectArray objectAtIndex:i]];
        [selectImgsArray addObject:firstImgs];
    }

    
    UITabBarController *tabBarController =(UITabBarController *)self;
    NSArray *array = tabBarController.viewControllers;
    for (int i =0; i<array.count; i++)
    {
        UIViewController *vc = (UIViewController *)[array objectAtIndex:i];
        vc.tabBarItem.selectedImage = [selectImgsArray[i] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.tabBarItem.image =[imgArray[i] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    UITabBar *tabBar = tabBarController.tabBar;
    tabBar.tintColor = aSleColor;
    if ([tabBar respondsToSelector:@selector(setUnselectedItemTintColor:)])
    {
        [tabBar setUnselectedItemTintColor:unSleColor];
    }
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: aColor,NSForegroundColorAttributeName, nil];
//    [[UITabBarItem appearance] setTitleTextAttributes:dic forState:UIControlStateSelected];
    
}




@end
