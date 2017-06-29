//
//  ShareHelper.m
//  douniwan
//
//  Created by IMAC2 on 15/5/25.
//  Copyright (c) 2015年 simon. All rights reserved.
//

#import "ShareHelper.h"
#import "UMSocialUIManager.h"


static NSString *appIconUrl = @"http://is3.mzstatic.com/image/thumb/Purple49/" \
"v4/ca/5a/0c/ca5a0c17-42e9-380d-d014-3deec3185fda/source/512x512bb.jpg";

@interface ShareHelper()

@end

@implementation ShareHelper

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id obj = nil;
    dispatch_once(&once, ^{
        obj = [[self alloc]init];
    });
    return obj;
}

#pragma mark
#pragma mark-umeng社会化分享


- (void)initUmengSocial6
{
    //打开调试日志
    [[UMSocialManager defaultManager] openLog:YES];
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:kUMAppKey];
    // 获取友盟social版本号
//    NSLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
    
    //各平台的详细配置
    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kWeChat_AppId appSecret:kWeChat_AppSecret redirectURL:@"http://mobile.umeng.com/social"];
    
    //设置分享到QQ互联的appKey和appSecret
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"100424468"  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    //设置支持没有客户端情况下使用SSO授权
    //设置新浪的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:kSina_AppId  appSecret:kSina_AppSecret redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    // 如果不想显示平台下的某些类型，可用以下接口设置
    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite),@(UMSocialPlatformType_YixinTimeLine),@(UMSocialPlatformType_LaiWangTimeLine),@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_QQ)]];

}

-(void)initUmengSocial
{
    /*
    [UMSocialData setAppKey:kUMAppKey];
    
    [UMSocialWechatHandler setWXAppId:kWeChat_AppId appSecret:kWeChat_AppSecret url:nil];
    
//    [UMSocialQQHandler setQQWithAppId:QQ_APPID appKey:QQ_APPSECRET url:@"http://www.umeng.com/social"];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:kSina_AppId
                                              secret:kSina_AppSecret
                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    //对未安装客户端平台进行隐藏
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToSina,UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
     */
}
/*
//自定义友盟分享
//自定义分享
- (void)yzxShare:(ShareInfo *)shareInfo SheetView:(UIViewController *)controller andButton:(UIButton *)sender
{
    if (!shareInfo)
    {
        return;
    }

    UMSocialData *socialData = [UMSocialData defaultData];
    
    UIImage *image = [UIImage imageNamed:@"logoBig1"];

    //判断图片是否有效，如果无效就用icon图片
    NSURL * imgURL = [NSURL URLWithString:shareInfo.ico];
    NSData * urlData = [NSData dataWithContentsOfURL:imgURL];

    if (!urlData) {
        socialData.shareImage = image;
    }

    //微博
    NSURL * url = [NSURL URLWithString:[shareInfo.url hasPrefix:@"http://"] ? shareInfo.url : [NSString stringWithFormat:@"http://%@",shareInfo.url]];
    
    //微信
    socialData.extConfig.wechatSessionData.title = shareInfo.title;
    socialData.extConfig.wechatSessionData.url = [url description];
    //朋友圈
    socialData.extConfig.wechatTimelineData.title = shareInfo.title;
    socialData.extConfig.wechatTimelineData.url = [url description];
    
    
//    NSString *babyName = [[UserDefaultUtil getBabyObject] @"name"];
    NSString *babyName = nil;
    
    socialData.extConfig.wechatTimelineData.title  = [NSString stringWithFormat:@"拉薇宝贝.%@的照片",babyName];
    
    NSArray * shareArray = nil;
    
    if (sender.tag == 0) {//微博
        
        socialData.shareText = [NSString stringWithFormat:@"#拉薇宝贝.%@的照片#%@（分享至@拉薇宝贝)",babyName,[url description]];
        shareInfo.content  = [NSString stringWithFormat:@"#拉薇宝贝#%@%@（分享至@拉薇宝贝)",shareInfo.content,[url description]];

        shareArray = @[UMShareToSina];
    }
    if (sender.tag == 1) {//朋友圈
        socialData.shareText = [NSString stringWithFormat:@"拉薇宝贝.%@的照片",babyName];
      
        shareArray = @[UMShareToWechatTimeline];
    }
    if (sender.tag == 2) {//微信
        socialData.shareText = [NSString stringWithFormat:@"拉薇宝贝.%@的照片",babyName];
//        shareInfo.content  = [NSString stringWithFormat:@"#拉薇宝贝#%@",shareInfo.content];
        shareArray = @[UMShareToWechatSession];
    }
    
    [socialData.urlResource setResourceType:UMSocialUrlResourceTypeImage url:shareInfo.ico];
    
    [[UMSocialDataService defaultDataService] postSNSWithTypes:shareArray content:shareInfo.content ?  shareInfo.content : socialData.shareText image:socialData.shareImage location:nil urlResource:socialData.urlResource presentedController:controller completion:^(UMSocialResponseEntity *response) {

        
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
}

//友盟系统化分享
- (void)share:(ShareInfo *)shareInfo SheetView:(UIViewController *)controller
{
    if (!shareInfo)
    {
        return;
    }
    UMSocialData *socialData = [UMSocialData defaultData];
    
    UIImage *image = [UIImage imageNamed:@"logo"];
    
    //判断图片是否有效，如果无效就用icon图片
    NSURL * imgURL = [NSURL URLWithString:shareInfo.ico];
    NSData * urlData = [NSData dataWithContentsOfURL:imgURL];
    
    if (!urlData) {
        socialData.shareImage = image;
    }
    //    socialData.extConfig.qqData.title = shareInfo.title;
    //    socialData.extConfig.qqData.url =shareInfo.url;
    //
    //    socialData.extConfig.qzoneData.title = shareInfo.title;
    //    socialData.extConfig.qzoneData.url = shareInfo.url;
    
    
    socialData.extConfig.wechatSessionData.title = shareInfo.title;
    socialData.extConfig.wechatSessionData.url = shareInfo.url;
    
    
    socialData.extConfig.wechatTimelineData.title = shareInfo.title;
    socialData.extConfig.wechatTimelineData.url = shareInfo.url;
    NSLog(@"%@",socialData.identifier);
    [socialData.urlResource setResourceType:UMSocialUrlResourceTypeImage url:shareInfo.ico];
    NSLog(@"%@",shareInfo.debugDescription);
    
    NSArray *snsNames =@[UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline];
    
    
    
    [UMSocialSnsService presentSnsIconSheetView:controller
                                         appKey:nil
                                      shareText:shareInfo.content
                                     shareImage:nil
                                shareToSnsNames:snsNames
                                       delegate:self];
    
    
}


//代理
-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    
    NSString * url =socialData.extConfig.wechatTimelineData.url;

//    NSString *babyName = [[UserDefaultUtil getBabyObject] @"name"];
    NSString *babyName = @"合成模板";
    NSLog(@"%@ %@",platformName, socialData);
    
    if([platformName isEqualToString:@"sina"]){
        
        socialData.shareText = [NSString stringWithFormat:@"#美颜拼图.%@的照片#%@（分享至@美颜拼图)",babyName,url];
        
    }else{
        socialData.shareText = [NSString stringWithFormat:@"美颜拼图.%@的照片",babyName];
    }
    socialData.extConfig.wechatTimelineData.title  = [NSString stringWithFormat:@"美颜拼图.%@的照片",babyName];
    
}
*/

- (void)share:(ShareInfo *)shareInfo SheetView:(UIViewController *)controller
{
    WS(weakSelf);
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMShareMenuSelectionView *shareSelectionView, UMSocialPlatformType platformType) {
        
        [shareSelectionView hiddenShareMenuView];

        if (platformType ==UMSocialPlatformType_Sina)
        {
            //设置图文 
//            NSString *text = [NSString stringWithFormat:@"#%@.我刚拼的照片#%@（分享至@%@)",APP_Name,shareInfo.url,APP_Name];
             NSString *text = [NSString stringWithFormat:@"#%@#（分享至@%@)",APP_Name,APP_Name];
            [weakSelf shareImageAndTextToPlatformType:platformType share:shareInfo text:text];
           
        }
        //微信朋友圈-shareWebPage替换以前的图文形式
        else if (platformType ==UMSocialPlatformType_WechatTimeLine||platformType ==UMSocialPlatformType_WechatSession)
        {
            [weakSelf shareImageAndTextToPlatformType:platformType share:shareInfo text:nil];

//            [weakSelf shareWebPageToPlatformType:platformType share:shareInfo];

        }
            
    }];
    
    
}
//分享纯文本，基本不用
- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType text:(NSString *)text
{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    messageObject.text = text;
    //调用分享接口，openURL:(NSURL *)url options:一定要实现
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];

}
//分享图文（新浪支持，微信/QQ仅支持图或文本分享）
- (void)shareImageAndTextToPlatformType:(UMSocialPlatformType)platformType share:(ShareInfo *)shareInfo text:(NSString *)text
{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    messageObject.text = text;//唯一设置文本的属性；
    
    //如果使用图文UMShareImageObject初始化，就必须有shareImage内容；类方法中的标题描述 缩略图没有用
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //唯一设置图片的属性
    //判断图片是否有效，如果有效才设置
    if ([shareInfo.ico isKindOfClass:[NSString  class]])
    {
        NSURL * imgURL = [NSURL URLWithString:shareInfo.ico];
        NSData * urlData = [NSData dataWithContentsOfURL:imgURL];
        if (urlData)
        {
            shareObject.shareImage = shareInfo.ico;
        }
        else
        {
            shareObject.shareImage= [UIImage imageNamed:@"icon"];
        }

    }
    else if ([shareInfo.ico isKindOfClass:[UIImage class]])
    {
        shareObject.shareImage= shareInfo.ico;
    }
    messageObject.shareObject = shareObject;
    
    //调用分享接口，openURL:(NSURL *)url options:一定要实现
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];

}

//网页分享：微信聊天 和朋友圈主要这种方式；微信朋友圈只有标题，没有描述
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType share:(ShareInfo *)shareInfo
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:shareInfo.title  descr:nil thumImage:[UIImage imageNamed:@"icon"]];
    
    //微信聊天，多添加一个描述
    if (platformType ==UMSocialPlatformType_WechatSession)
    {
        shareObject.descr = shareInfo.content;
    }
    if ([shareInfo.ico isKindOfClass:[NSString  class]])
    {
        //判断图片是否有效，如果有效才设置
        NSURL * imgURL = [NSURL URLWithString:shareInfo.ico];
        NSData * urlData = [NSData dataWithContentsOfURL:imgURL];
        if (urlData)
        {
            shareObject.thumbImage = shareInfo.ico;
        }
        
    }
    else if ([shareInfo.ico isKindOfClass:[UIImage class]])
    {
         shareObject.thumbImage = shareInfo.ico;
    }

   
    //设置网页地址
    shareObject.webpageUrl =shareInfo.url;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}
@end
