//
//  UIViewController+UMThirdLogin.h
//  wqk8
//
//  Created by zhuxinming on 15/11/27.
//  Copyright © 2015年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <UMSocialCore/UMSocialCore.h>

/*
typedef NS_ENUM(NSInteger,ThirdLoginType){
    thirdLoginTypeWeiXin=1,
    thirdLoginTypeQQ=2,
    thirdLoginTypeSina=3
};
*/
@protocol ThirdLoginDelegate <NSObject>

- (void)thirdLoginWithAccessToken:(NSString *)accessToken openId:(NSString *)userId type:(NSInteger)type responseData:(UMSocialUserInfoResponse *)res;


@end


@interface UIViewController (UMThirdLogin)

@property(nonatomic,weak) id<ThirdLoginDelegate>thirdDelegate;

- (void)sinaLogin;

//- (void)weiXinLogin;
//
//- (void)qqLogin;
@end


/**
        <ThirdLoginDelegate>
 *       self.thirdDelegate = self;

*/
