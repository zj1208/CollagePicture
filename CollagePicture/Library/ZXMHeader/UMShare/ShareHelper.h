//
//  ShareHelper.h
//  douniwan
//
//  Created by IMAC2 on 15/5/25.
//  Copyright (c) 2015年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareInfo.h"


#import <UMSocialCore/UMSocialCore.h>

#pragma mark -UM
// 友盟的key
static NSString *kUMAppKey = @"555daf0767e58e8c7100260f";
// 微信url scheme:appId
static NSString *kWeChat_AppId=@"wx0d4c10b45e46d89c";
static NSString *kWeChat_AppSecret=@"83d977878367c60d240e17e526111ebb";

//新浪微博 url scheme:wb+appkey
static NSString *kSina_AppId = @"3381787410";
static NSString *kSina_AppSecret =@"b496454d3f86f3b7d33b3fb25bcd6fdd";





@interface ShareHelper : NSObject

+ (instancetype)sharedInstance;

- (void)initUmengSocial;

- (void)initUmengSocial6;

//友盟自默认分享
- (void)share:(ShareInfo *)shareInfo SheetView:(UIViewController *)controller;
//友盟自定义分享
- (void)yzxShare:(ShareInfo *)shareInfo SheetView:(UIViewController *)controller andButton:(UIButton *)sender;


@end


/**
 
 [[ShareHelper sharedInstance] initUmengSocial];

 
 ShareInfo *info = [[ShareInfo alloc] init];
 info.content = @"今天看到新闻,我的温州学妹被杀了,惋惜啊";
 info.title = @"标题";//新浪没有标题
 info.url = @"http://baidu.com"; //
 info.ico = @"http://woqin.oss-cn-hangzhou.aliyuncs.com/avtor/3130333033/CA65013B6C3AE8C9C18973CE589D1514.jpg";
 [[ShareHelper sharedInstance]share:info SheetView:self];

*/



/*
#pragma mark -自定义分享

 //初始化分享
 self.share = [[SharePromptView alloc] initWithFrame:self.view.frame];
 self.share.delegate = self;

 
- (void)shareAction:(KxMenuItem *)sender
{
    self.share.hidden = NO;
    [self.view.window addSubview:self.share];
}

//实现分享的事件代理方法
- (void)SharePromptViewWithBtnClick:(UIButton *)sender
{
    
    WS(weakSelf);
    [[[AppAPIHelper shareInstance]getThemeModelAPI]shareThemeDetailWithThemeId:self.themeId type:@(self.themeType) success:^(id data) {
        
        ShareInfo *info = [[ShareInfo alloc] init];
        info.ico = [self.sysDetailModel.examplePic stringByAppendingString:kQINIU_IMAGEPATH_200_200];
        info.url = [NSString stringWithFormat:@"http://%@",[data objectForKey:@"url"]];;
        
        [[ShareHelper sharedInstance]yzxShare:info SheetView:self andButton:sender];
        
    } failure:^(NSError *error) {
        
        [weakSelf zhHUD_showErrorWithStatus:[error localizedDescription]];
        
    }];
}
 */
