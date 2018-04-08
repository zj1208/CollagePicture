//
//  NSURL+ZXAppLinks.h
//  YiShangbao
//
//  Created by simon on 2018/3/16.
//  Copyright © 2018年 com.Microants. All rights reserved.
//
//  2018/3/16 新增
//  2018/3/26 增加


#import <Foundation/Foundation.h>

@interface NSURL (ZXAppLinks)


/**
 根据AppId去AppStore的指定页面；
 iTunesLink 链接－－iTunesLink＋appID，ios6以后有直接跳转appStore的item应用Controller页面

 @param appId 每个App的唯一id
 @return 路径地址；
 */
+ (NSURL *)appStoreURLForApplicationIdentifier:(NSString *)appId;



/**
 根据appId查找app在AppStore的详细信息；可以用于请求这个地址获取app的线上信息，比如检查版本；

 @param appId 每个App的唯一id
 @return AppInfomation详情信息的URL；
 */
+ (NSURL *)appStoreAppInfomationURLForApplicationIdentifier:(NSString *)appId;
@end
