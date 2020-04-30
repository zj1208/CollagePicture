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
@end
