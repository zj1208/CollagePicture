//
//  AppDelegate.m
//  CollagePicture
//
//  Created by simon on 16/9/8.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "AppDelegate.h"
#import <BmobSDK/Bmob.h>
#import "AppMarco.h"
#import "ShareHelper.h"
#import <UMCommon/UMCommon.h>
#import "UncaughtException.h"


//JPush的引入
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import <AMapFoundationKit/AMapFoundationKit.h>


// app从什么激活的
typedef NS_ENUM(NSInteger, AppActiveFromType)
{
    AppActiveFromType_finishLaunch = 1,//app启动激活
    AppActiveFromType_background = 0//从后台激活
};

@interface AppDelegate ()<JPUSHRegisterDelegate>

@property (nonatomic, assign) AppActiveFromType appActiveFromType;


@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(nullable NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions
{
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsUserActivityDictionaryKey])
    {
        self.appActiveFromType =AppActiveFromType_finishLaunch;
    }
     [self setUI];
    
    //设置域名环境
    [self setDomainManager];
    
    //监听事件
    [self commonInitListenEvents];
    
    //初始化全局
    [self setApperanceForAllController];
//    [self registerUserNotification]; //自己测试用的；
    
    //初始化友盟分享
    [[ShareHelper sharedInstance] initUmengSocial6];
    
    /**
     *  增加bmob初始化
     */
    [Bmob registerWithAppKey:kBMOB_APPID];
    //初始化友盟统计
    [self addUMengAnalytics];
    
    //初始化注册通知
    [self addJPushAPNS];
    //处理点击推送通知
    [self takeLaunchRemoteNoti:launchOptions];
    
    [AMapServices sharedServices].apiKey = kAppKey_AMAP;

    //存储异常处理
    InstallUncaughtExceptionHandlers();
    
    //通过该函数可以设置系统唤醒 app 在后台执行Background fetch操作的时间间隔。
    //当系统允许 app 执行 Background fetch 操作时，会在后台唤醒该 app;
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    return YES;
}


#pragma mark-


- (void)setUI
{
    [[UIButton appearance]setExclusiveTouch:YES];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(windowDidBecomeVisibleNotification:) name:UIWindowDidBecomeVisibleNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(windowDidBecomeKeyNotification:) name:UIWindowDidBecomeKeyNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(windowDidBecomeHiddenNotification:) name:UIWindowDidBecomeHiddenNotification object:nil];
}

- (void)windowDidBecomeVisibleNotification:(id)noti
{
    
}

- (void)windowDidBecomeKeyNotification:(id)noti
{
    
}

- (void)windowDidBecomeHiddenNotification:(id)noti
{
    
}

#pragma mark - 设置域名环境
- (void)setDomainManager
{
    [WYUserDefaultManager setOpenChangeDomain:YES];
    
    if (![WYUserDefaultManager getOpenChangeDomain] ||[WYUserDefaultManager getkAPP_BaseURL].length==0)
    {
        [WYUserDefaultManager setkAPP_BaseURL:@"https://api.m.microants.cn"];
        [WYUserDefaultManager setkAPP_H5URL:@"https://wykj.microants.cn"];
        [WYUserDefaultManager setkURL_WXAPPID:@"wxc8edd69b7a7950ee"];
    }
    if (![WYUserDefaultManager getOpenChangeDomain] ||[WYUserDefaultManager getkCookieDomain].length==0)
    {
        [WYUserDefaultManager setkCookieDomain:@".microants.cn"];
    }
}


#pragma mark - 监听事件
- (void)commonInitListenEvents
{
    //token错误
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tokenError:) name:kNotificationUserTokenError object:nil];
    
//    //先去获取一下im信息
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginInRepeatRequest:) name:kNotificationUserLoginIn object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginIn:) name:Noti_tryAgainGetNimAccout object:nil];
//    //监听自动登录
//    [[[NIMSDK sharedSDK]loginManager]addDelegate:self];;
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginOut:) name:kNotificationUserLoginOut object:nil];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeDomain:) name:kNotificationUserChangeDomain object:nil];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(postDataToHost:) name:Noti_PostDataToHost object:nil];
}

#pragma mark- token错误
- (void)tokenError:(NSNotification *)notification
{
    if ([[notification.userInfo objectForKey:@"api"] isEqualToString:@"第三方API的token失效"])
    {
        return;
    }
    [self.window.rootViewController zx_presentLoginController];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

//设置基本数据

- (void)setApperanceForAllController
{
    [UINavigationController zx_navigationBar_appearance_backgroundImageName:nil ShadowImageName:nil orBackgroundColor:[UIColor whiteColor]];

    [[UIBarButtonItem appearance]setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.f]} forState:UIControlStateNormal];
    [[UIBarButtonItem appearance]setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.f]} forState:UIControlStateHighlighted];
    [UINavigationController zx_navigationBar_UIBarButtonItem_appearance_systemBack_noTitle];
    [[UIButton appearance]setExclusiveTouch:YES];
}

- (void)setApperanceForSigleNavController:(UINavigationController *)navigationController
{
    [navigationController zx_navigationBar_allBackIndicatorImage:@"back_onlyImage" isOriginalImage:YES];
    [navigationController zx_navigationBar_barItemColor:UIColorFromRGB_HexValue(0x222222)];
    [navigationController zx_navigationBar_titleColor:UIColorFromRGB_HexValue(0x222222) titleFont:[UIFont boldSystemFontOfSize:17.f]];
}

#pragma mark-JPush

//初始化APNs代码
- (void)addJPushAPNS
{
    if (@available(iOS 10.0,*))
    {
        JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionSound|UNAuthorizationOptionBadge;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }
    else if(@available(iOS 8.0,*))
    {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
}

- (void)takeLaunchRemoteNoti:(NSDictionary *)launchOptions
{

//    用于标识当前应用所使用的APNs证书环境。0 (默认值)表示采用的是开发证书，1 表示采用生产证书发布应用。
    BOOL isProduction = NO;
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:kJPushAppKey channel:@"App Store" apsForProduction:isProduction advertisingIdentifier:nil];
    
    [JPUSHService setTags:[NSSet setWithObject:@"test"] alias:nil fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags, iAlias);
        
    }];
}
#pragma mark -友盟统计
-(void)addUMengAnalytics
{
    [UMConfigure initWithAppkey:kUMAppKey channel:@"App Store"];
    #ifdef DEBUG
//            [[UMSocialManager defaultManager] openLog:YES];
        [UMConfigure setLogEnabled:YES];
    #else
        [UMConfigure setLogEnabled:NO];
    #endif
}

//自己测试用的；
/*
#pragma mark - 通知
#pragma mark-注册用户通知:
NSString * const kNotificationCategoryIdent  = @"ACTIONABLE";
NSString * const kNotificationActionOneIdent = @"ACTION_ONE";
NSString * const kNotificationActionTwoIdent = @"ACTION_TWO";


- (void)registerUserNotification
{
    //如果已经注册过远程通知，则不必重复注册； 需要测试过，会不会有影响？
    if ([[UIApplication sharedApplication]isRegisteredForRemoteNotifications])
    {
        return;
    }
    
    if (Device_IOS10_OR_LATER)
    {
        //用iOS10框架的新方法注册
//        JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
//        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionSound|UNAuthorizationOptionBadge;
//        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }
    //ios8之后，需要分二步，注册用户通知，再注册远程通知
    else if (Device_Version_Greater_THAN_OR_EQUAL_TO(8.f))
    {
        
        //初始化通知交互事件1
        UIMutableUserNotificationAction *notificationAction1 = [[UIMutableUserNotificationAction alloc] init];
        notificationAction1.activationMode = UIUserNotificationActivationModeBackground;
        notificationAction1.title = @"收藏";
        notificationAction1.identifier = kNotificationActionOneIdent;
        notificationAction1.destructive = YES;
        //是否需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        notificationAction1.authenticationRequired = NO;
        
        //初始化标识为identifier的独特通知类别；
        UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
        category.identifier =kNotificationCategoryIdent;
        [category setActions:@[notificationAction1] forContext:UIUserNotificationActionContextDefault];
        
        NSSet *categories = [NSSet setWithObject:category];
        
        //用户通知类别
        UIUserNotificationType type = UIUserNotificationTypeBadge |UIUserNotificationTypeSound|UIUserNotificationTypeAlert;
        
        //如果没有用用户通知交互，则categories可以设置nil
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:categories];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    else
    {   //iOS7只需要这样就能注册远程通知；
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert |UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
}
*/

#ifdef __IPHONE_8_0
//iOS8之后的方法，在registerUserNotificationSettings:注册用户通知之后， 会回调这个代理方法注册远程通知；
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

#endif

#pragma mark-注册远程通知后的回调
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"deviceToken=%@",[deviceToken description]);
//    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"<>"];
//    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:set];
//    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    //业务处理，传给第三方服务器；比如容云，个推，极光等；
   // [GeTuiSdk registerDeviceToken:token];
    // [[RCIMClient sharedRCIMClient] setDeviceToken:token];//向容云服务器注册设备token
    
    [JPUSHService registerDeviceToken:deviceToken];
}

#pragma mark -注册远程通知失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);

}

#pragma mark - 4个方法接收远程通知

//iOS远程通知接收总结：
//（1）iOS7以前用didReceiveRemoteNotification：方法接收（iOS7以前不支持后台）；
//（2）iOS7及以上app，没有启动或在后台的时候点击通知栏进入前台，或本来就在前台 都用iOS7支持后台的新方法接收（点击通知条进入app前台的时候会先唤醒调用）；
//（3）但在后台的时候如果点击了通知条上的交互事件则用iOS8/iOS9新方法（点击通知条上的交互事件进入app前台的时候调用）；
// (4)接收远程通知的数据格式是固定的，在未启动的时候，系统会自动解析aps字典，使得你app的角标对应显示badge，而不会造成永远是1的问题；

//已经废弃不用了
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS7及以下系统，收到通知:%@", [self logDic:userInfo]);

}

/*
 *ios7开始支持后台远程推送技术：但不支持用户通知交互；
 *iOS7及以上都用iOS7的新方法接收，不管前台后台还是未启动（点击通知条进入app前台的时候会先唤醒调用）；
 *接收到推送通知后，需要判断当前程序所处的状态，并根据公司业务做出不同处理;
 *在处理完成后，需要调用completionHandler block回调
 *
 *一般在UIApplicationStateActive前台运行时，不做处理；
 *如果要求在前台运行时对收到的通知做处理，我们可以用提示框显示，或者改变某个ui展示如红点，同时修改badge值。如果角标用特别ui提示，那么就要计算角标数字了；主要用于im项目；
 */

//iOS7-iOS10之间收到推送通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [JPUSHService handleRemoteNotification:userInfo];
    //告诉服务器，现在badge已经变为0了；那么下次推送过来的badge值就会变1，不然会不断的累积啊；
    [JPUSHService setBadge:0];
    
    NSDictionary *apsDic = [userInfo objectForKey:@"aps"];
    NSString *alert = [apsDic objectForKey:@"alert"];
   
   
    NSLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
   
    //后台状态／非活跃状态：手机锁屏，双击home键，没有启动状态
    if (application.applicationState == UIApplicationStateInactive||application.applicationState == UIApplicationStateBackground)
    {
        //直接处理业务跳转；
    }
    
    //活跃状态：前台运行； 一般不写业务，如果需要就添加提示框；
    else if (application.applicationState == UIApplicationStateActive)
    {
        [UIAlertController zx_presentGeneralAlertInViewController:self.window.rootViewController withTitle:nil message:alert cancelButtonTitle:@"取消" cancleHandler:nil doButtonTitle:nil doHandler:nil];
    }

    completionHandler(UIBackgroundFetchResultNewData);
}

//在后台的时候如果点击了通知条上的交互事件则用iOS8/iOS9新方法（点击通知条上的交互事件进入app前台的时候调用）；
//如果不支持iOS8的用户通知交互，则只需简单写回调，或不实现iOS8/ios9方法；
//iOS8和iOS9开始支持用户通知交互：用户从你的推送通知中选择一个交互动作后，该方法将会在后台被调用。

- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)(void))completionHandler
{
    [JPUSHService setBadge:0];
    //自定义用户通知交互事件
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"iOS9-didReceiveRemoteNotification" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 =[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action1];
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}




#pragma mark - 3个方法接收本地通知

//iOS8以前的接收本地通知：不支持用户通知交互，如果在前台也是这个收
//- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
//{
//    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
//}

///2个方法新方法只适用于后台模式的推送通知，而且必须要点击交互事件按钮才会调用；
//如果不支持iOS8的用户通知交互，则可以不实现iOS8/ios9方法；
//如果在后台，iOS8和iOS9支持用户通知交互：用户从你的本地推送通知中选择一个交互动作后，该方法将会在后台被调用。
- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forLocalNotification:(UILocalNotification *)notification withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)(void))completionHandler
{
    //调用自定义的本地通知处理
    [self  handleActionWithIdentifier:identifier forLocalNotification:notification withResponseInfo:responseInfo completionHandler:completionHandler];
    
}

//自己抽离：为了兼容ios8以前的不支持通知事件交互，iOS8和iOS9支持的通知交互代理处理；
- (void)handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)(void))completionHandler
{
    /*
    if ([identifier isEqualToString:kNotificationActionOneIdent])
    {
        NSLog(@"You chose action 1.");
    }
    else if ([identifier isEqualToString:kNotificationActionTwoIdent]) {
        
        NSLog(@"You chose action 2.");
    }
     */
    if (completionHandler) {
        
        completionHandler();
    }

}

//ios10之后的推送；可以处理自定义事件，前台激活模式／非激活模式
#ifdef NSFoundationVersionNumber_iOS_9_x_Max

#pragma mark- JPUSHRegisterDelegate
//这2个方法是极光推送的改版代理方法； 和原生方法类同；

//iOS10 前台收到远程通知／本地通知处理；

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler
{
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);

    NSDictionary * userInfo = notification.request.content.userInfo;
    // 收到推送的请求
    UNNotificationRequest *request = notification.request;
    // 收到推送的消息内容
    UNNotificationContent *content = request.content;
    // 推送消息的角标
    NSNumber *badge = content.badge;
    // 推送消息体
    NSString *body = content.body;
    // 推送消息的声音
    UNNotificationSound *sound = content.sound;
     // 推送消息的副标题
    NSString *subtitle = content.subtitle;
    // 推送消息的标题
    NSString *title = content.title;
    
    //如果是远程通知
    if([request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
    {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
      //  [rootViewController addNotificationCount];
    }
    else
    {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
}

//iOS10 在非激活模式，用户响应推送通知栏的 打开应用，关闭通知，响应用户通知事件，都会回调这个代理方法；这个代理方法必须在applicationDidFinishLaunching:启动完成之前设置好；
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    completionHandler();  // 系统要求执行这个方法

    NSDictionary * userInfo = response.notification.request.content.userInfo;
    // 收到推送的请求
    UNNotificationRequest *request = response.notification.request;
    // 收到推送的消息内容
    UNNotificationContent *content = request.content;
    // 推送消息的角标
    NSNumber *badge = content.badge;
    // 推送消息体
    NSString *body = content.body;
    // 推送消息的声音
    UNNotificationSound *sound = content.sound;
    // 推送消息的副标题
    NSString *subtitle = content.subtitle;
    // 推送消息的标题
    NSString *title = content.title;
    
    if([request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
      //  [rootViewController addNotificationCount];
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
}
#endif



#pragma mark -
/**
 *   Window级别的控制,该方法默认值为Info.plist中配置的 Supported interface orientations 项的值。
 iOS中通常只有一个window，所以此处的控制也可以视为全局控制。
 *
 *  @param application application description
 *  @param window      window description
 *
 *  @return return value description
 */
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskLandscapeRight;
}

#pragma mark - 第三方应用回调

//一般这个方法早已弃用，可以不写
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [self customAppByCallbackHandleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation
{
    return  [self customAppByCallbackHandleOpenURL:url];
}

#ifdef __IPHONE_9_0
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    return  [self customAppByCallbackHandleOpenURL:url];
 
}

#endif
//第三方app回调本app
- (BOOL)customAppByCallbackHandleOpenURL:(NSURL *)url
{
    if ([[url host] isEqualToString:@"pay"])
    {
        //        return  [WXApi handleOpenURL:url delegate:self];
    }
    else if ([url.host isEqualToString:@"safepay"])
    {
        //处理钱包或者独立快捷app支付跳回商户app携带的支付结果Url
        //        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic)
        //         {
        //             NSLog(@"result = %@",resultDic);
        //         }];
        return YES;
    }
    return [[UMSocialManager defaultManager] handleOpenURL:url];
}

#pragma mark - 后台任务

//获取数据、管理数据以及更新 UI 等。
//在该方法中处理 Background fetch 的具体任务:获取数据、管理数据以及更新 UI 等。
//当系统允许 app 执行 Background fetch 操作时，会在后台唤醒该 app;
//作为善后工作，我们必须调用系统提供的completion handler;
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

}

- (void)applicationWillEnterForeground:(UIApplication *)application {


}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // 最简单的管理iconBadgeNumber就是直接设置为0，不精准计算
    [application setApplicationIconBadgeNumber:0];
    //如果你实现了默认badge会自动累加；那么设置这个能告诉服务器，现在badge已经变为0了；那么下次推送过来的badge值就会变1，不然会不断的累积啊；
    [JPUSHService setBadge:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}



#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.xinMing.CollagePicture" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CollagePicture" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CollagePicture.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

@end
