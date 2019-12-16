//
//  UIViewController+ZXNavBarCustom.m
//  MusiceFate
//
//  Created by simon on 14/11/1.
//  Copyright (c) 2014年 yinyuetai.com. All rights reserved.
//

#import "UIViewController+ZXNavBarCustom.h"
#import "UIButton+ZXHelper.h"


@implementation UIViewController (ZXNavBarCustom)


#pragma mark-LeftBarBut

-(void)zx_navigationItem_leftBarButtonItem_CustomView_imageName:(nullable NSString*)imageName highImageName:(nullable NSString *)imageName2 title:(nullable NSString *)backTitle action:(nullable SEL)action
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
        backButton.imageEdgeInsets= UIEdgeInsetsMake(0, 0, 0,floorf(10/2));
        backButton.titleEdgeInsets= UIEdgeInsetsMake(0, floorf(10/2), 0, 0);
    }
//    [backButton setBackgroundColor:[UIColor redColor]];
    [backButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBar;
}


//- (NSArray *)zx_navigationItem_leftOrRightItemReducedSpaceToMagin:(CGFloat)magin withItems:(NSArray *)barButtonItems
//{
//    由于iOS11把barButtonItem添加在_UIButtonBarStackView上；
//    if (@available(iOS 11.0, *))
//    {
//        return barButtonItems;
//    }
//    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
//                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
//                                       target:nil action:nil];
//    negativeSpacer.width = magin;
//    NSMutableArray *mArray = [NSMutableArray arrayWithArray:barButtonItems];
//    [mArray insertObject:negativeSpacer atIndex:0];
//    return (NSArray *)mArray;
//}

/**
 * @brief 自定义模态页面barButtonItem按钮，也是为了适应ios6和ios7兼容；默认自动加载了点击事件，加载dismissViewController；
 * @param flag ：YES＝ leftBarItem； NO＝ rightBarItem
 */
- (void)zx_navigationBar_presentedViewController_leftOrRightBarItem:(BOOL)flag   title:(NSString *)aTitle
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





- (void)zx_navigationBar_BackgroundAlpah:(CGFloat)alpha navigationBar:(UINavigationBar *)navigationBar
{
    //默认opaque = NO;
//    NSArray *subViews = navigationBar.subviews;
    // bar的第一子视图；背景view；导航栏背景透明度设置
    UIView *barBackground = [[navigationBar subviews] objectAtIndex:0];// _UIBarBackground
    
    //    //viewWillAppear的时候依然没有改变，viewDidAppear才会改变子视图
    //    id secondView = [[barBackground subviews] objectAtIndex:1];// UIImageView或UIVisualEffectView
    //    NSLog(@"%@",[self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault]);
    //ios11设置不起作用；只能自定义view来当navigationBar了
    if (@available(iOS 11.0, *))
    {
        
    }
    else
    {
        if (navigationBar.isTranslucent)
        {
            //子视图不受影响
            barBackground.alpha = alpha;
            //如果设置了背景图；那么设置子视图的alpha，在translucent的时候，默认imageView子视图alpha为0.93半透明；阴影线索引不同；
            if ([self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault])
            {
                UIImageView *imageView = [barBackground.subviews objectAtIndex:0];
                UIImageView *lineImageView = [barBackground.subviews objectAtIndex:1];
                imageView.alpha = alpha;
                lineImageView.alpha = alpha;
            }
            else
            {
                ////            //阴影线，
                ////            UIImageView *backgroundImageView = [[barBackground subviews] objectAtIndex:0];// UIImageView
                //            UIView *visualEffectView = [[barBackground subviews] objectAtIndex:1];// UIVisualEffectView
                //            if (visualEffectView != nil)
                //            {
                //                visualEffectView.alpha = alpha;
                //            }
            }
        }
        else
        {
            barBackground.alpha = alpha;
        }
    }
}


//iOS11不管用啊
- (void)zx_navigationBar_BackgroundAlpah:(CGFloat)alpha
{
    [self zx_navigationBar_BackgroundAlpah:alpha navigationBar:self.navigationController.navigationBar];

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








- (void)zx_tabBarController_tabBarItem_ImageArray:(nullable NSArray *)aArray selectImages:(nullable NSArray *)selectArray slectedItemTintColor:(nullable UIColor *)aSleColor unselectedItemTintColor:(nullable UIColor *)unSleColor;
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
        if (@available(iOS 10.0, *))
        {
            [tabBar setUnselectedItemTintColor:unSleColor];
        }
        else{
            
        }
    }
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: aColor,NSForegroundColorAttributeName, nil];
//    [[UITabBarItem appearance] setTitleTextAttributes:dic forState:UIControlStateSelected];
    
}




@end
