//
//  UIViewController+UMThirdLogin.m
//  wqk8
//
//  Created by zhuxinming on 15/11/27.
//  Copyright © 2015年 simon. All rights reserved.
//

#import "UIViewController+UMThirdLogin.h"
//#import "UMSocial.h"

static char thirdLoginKey;

@implementation UIViewController (UMThirdLogin)

@dynamic thirdDelegate;



- (void)sinaLogin
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Sina currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            // 授权信息
            NSLog(@"Sina uid: %@", resp.uid);
            NSLog(@"Sina accessToken: %@", resp.accessToken);
            NSLog(@"Sina refreshToken: %@", resp.refreshToken);
            NSLog(@"Sina expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"Sina name: %@", resp.name);
            NSLog(@"Sina iconurl: %@", resp.iconurl);
            NSLog(@"Sina gender: %@", resp.gender);
            
            // 第三方平台SDK源数据
            NSLog(@"Sina originalResponse: %@", resp.originalResponse);
            
            if ([self.thirdDelegate respondsToSelector:@selector(thirdLoginWithAccessToken:openId:type:responseData:)])
            {
                [self.thirdDelegate thirdLoginWithAccessToken:resp.accessToken openId:resp.uid type: UMSocialPlatformType_Sina responseData:result];
                
            }

        }
    }];

}

/*
- (void)sinaLogin
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            
            if ([self.thirdDelegate respondsToSelector:@selector(thirdLoginWithAccessToken:openId:type:)])
            {
                [self.thirdDelegate thirdLoginWithAccessToken:snsAccount.accessToken openId:snsAccount.usid type: thirdLoginTypeSina];
                
            }
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
        }});
    
}

- (void)weiXinLogin
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            if ([self.thirdDelegate respondsToSelector:@selector(thirdLoginWithAccessToken:openId:type:)])
            {
                [self.thirdDelegate thirdLoginWithAccessToken:snsAccount.accessToken openId:snsAccount.usid type: thirdLoginTypeWeiXin];
                
            }
            
        }
        
    });
    
}

- (void)qqLogin
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];

    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //点击第三方的登陆后,才会回调这个block
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess)
        {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
            if ([self.thirdDelegate respondsToSelector:@selector(thirdLoginWithAccessToken:openId:type:)])
            {
                NSLog(@"提示:正在登陆");
                [self.thirdDelegate thirdLoginWithAccessToken:snsAccount.accessToken openId:snsAccount.usid type: thirdLoginTypeQQ];
                
            }
            
        }
        
    });
    
}

 */


- (id<ThirdLoginDelegate>)thirdDelegate
{
    return objc_getAssociatedObject(self, &thirdLoginKey);
}


- (void)setThirdDelegate:(id<ThirdLoginDelegate>)thirdDelegate
{
    [self willChangeValueForKey:@"ThirdLoginController"];
    objc_setAssociatedObject(self, &thirdLoginKey, thirdDelegate, OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"ThirdLoginController"];
}

@end
