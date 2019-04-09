//
//  ZXGuideViewController.h
//  SiChunTang
//
//  Created by simon on 15/11/18.
//  Copyright © 2015年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//变量或者函数的定义在别的文件中；定义的这个参数变量是不能被改变的；
UIKIT_EXTERN NSString *const kHadLaunchedGuide;


@protocol GuideViewDelegate;

@interface ZXGuideViewController : UICollectionViewController


@property(nullable,nonatomic,weak) id<GuideViewDelegate>delegate;




/**
 *  判断是否已经加载过引导页，即是否是第一次安装；
 *
 *  @return YES/No
 */
+ (BOOL)hadLaunchedGuide;


+ (void)guideFigureWithImages:(NSArray *)images finishWithRootController:(UIViewController *)vc;

/**
 * 用于IM,进入页面必须登录的app.首次安装app加载的根视图设置;
 */
- (void)guideIMAppfirstLaunchWithLoginViewController:(UIViewController *)loginVC
                                      rootController:(UIViewController *)rootVC
                                  isLoginUserDefault:(BOOL)isUD;
/**
 * 用于IM,退出,进入登录界面,为了防止出现之前的重复页面,必须重新初始化,由于有sb或纯代码的可能,所以得先初始化再传入;
 */
- (void)guideIMAppLoginOut:(UIViewController *)loginVC
;

/**
 * 用于IM,登录,进入主rootController;
 */
- (void)guideIMAppLoginIn:(UIViewController *)rootVC;

@end


/**
 * 点击按钮进入主页面的时候的事件;
 */


@protocol GuideViewDelegate <NSObject>

@optional

-(void)guideViewComeToRootViewController;

@end

NS_ASSUME_NONNULL_END


/**
 EventViewController *vc = [[EventViewController alloc] init];
 [ZXGuideViewController guideFigureWithImages:@[@"1",@"2",@"3"] finishWithRootController:vc];

 */
/***
 * 例如:
- (void)initLaunchRootViewController

 {
 self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]] ;
 
 GuideViewController *guide = [GuideViewController sharedGuide];
 [guide setData:@[@"1",@"2",@"3"]];
 guide.delegate =self;
 
 UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
 UIViewController *tb = [sb instantiateViewControllerWithIdentifier:@"tabBarController"];
 
 [guide firstLaunchAppWithRootController:tb];
 }
 在设置tabController的时候
 if (![GuideViewController sharedGuide].launchingGuide)
 {
 [self initTabBar];
 }
 
 */
