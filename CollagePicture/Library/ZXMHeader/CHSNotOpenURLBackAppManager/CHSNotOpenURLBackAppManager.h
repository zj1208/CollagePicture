//
//  CHSNotOpenURLBackAppManager.h
//  MobileCaiLocal
//
//  Created by simon on 2019/12/30.
//  Copyright © 2019 com.Chs. All rights reserved.
//
//  简介：监听在已经didFinishLanuch启动显示的app，非openURL，非通用链接方式返回显示app前台的时候发送一个通知；使用通用链接切换返回App的时候也属于正常返回，比如微信正常切换返回。

// 2020.06.09  增加通用链接返回的代理方法 作为正常app切换返回的交换；

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//非正常返回当前应用：（1）从后台->前台；（2）openURL到第三方app后，再从第三方app的左上角快捷返回到前台显示；
FOUNDATION_EXPORT NSNotificationName const CHSApplicationNoOpenURLActiveNotification;

@interface CHSNotOpenURLBackAppManager : NSObject

/*
 除了启动应用程序，还有其它方式重新打开应用程序；
 在openURL返回激活的application生命周期：从后台->先进入前台->openURL回调->激活；
 非openURL进入前台的application生命周期：从后台->进入前台->激活；
*/
@property (nonatomic) BOOL isOpenURLApplicationBack;//是否app由第三方openURL方式进入前台返回

// 初始化开启通知监听；必须调用才能用
+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END

/*
- (void)addNotificationObserver
{
    [CHSNotOpenURLBackAppManager sharedInstance];
 
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationNoOpenURLActive:) name:CHSApplicationNoOpenURLActiveNotification object:nil];

}
- (void)applicationNoOpenURLActive:(id)notification
{
    if (![self.navigationController.topViewController isEqual:self]) {
        return;
    }
    if (self.isAuthRequesting) {

        [MBProgressHUD zx_hideHUDForView:self.view];
        DLog(@"付款码-isAuthRequesting返回");
        [self.view.window makeToast:@"授权取消"];
        [self goBackController];
    }
}
*/

