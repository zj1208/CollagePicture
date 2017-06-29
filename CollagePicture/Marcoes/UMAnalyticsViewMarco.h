//
//  UMAnalyticsViewMarco.h
//  YiShangbao
//
//  Created by simon on 17/3/29.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UMAnalyticsViewMarco : NSObject



@end


#pragma  mark - 接生意
//接生意界面“我要接”点击量
static NSString *kUM_gotoBuild = @"gotoBuild";
//生意详情界面“马上接单”点击量
static NSString *kUM_gotoQuotes =@"gotoQuotes";
//接单界面“发送给采购商”点击量
static NSString *kUM_sendPrice = @"sendPrice";
//生意详情界面“打电话”点击量
static NSString *kUM_callPhone = @"callPhone";
//“已接”点击量
static NSString *kUM_yijie = @"yijie";


#pragma  mark - tabBar

//toolbar“接生意”点击量
static NSString *kUM_Builds  = @"Builds";
//toolbar“商铺”点击量
static NSString *kUM_Shops  = @"Shops";
//toolbar“经侦预警”点击量
static NSString *kUM_Warning = @"Warning";
//toolbar“市场服务”点击量
static NSString *kUM_Service = @"Service";


#pragma mark - 商铺

//商铺“基本资料”点击量
static NSString *kUM_gotoInformation = @"gotoInformation";
//商铺“粉丝”点击量
static NSString *kUM_gotoFans = @"gotoFans";
//商铺“访客”点击量
static NSString *kUM_gotoVisitors = @"gotoVisitors";
//商铺“轮播”点击量
static NSString *kUM_gotoShopsAd = @"gotoShopsAd";
//商铺“上传产品”点击量
static NSString *kUM_gotoAddProduct = @"gotoAddProduct";
//商铺“商铺预览”点击量
static NSString *kUM_Shopreview = @"Shopreview";
//商铺“产品管理”点击量
static NSString *kUM_Productmanage = @"Productmanage";
//商铺“电子名片”点击量
static NSString *kUM_Shopqrcode = @"Shopqrcode";
//商铺“商铺公告”点击量
static NSString *kUM_Shopnotice = @"Shopnotice";
//商铺“商铺实景”点击量
static NSString *kUM_Shopimage = @"Shopimage";
//商铺“常见问题”点击量
static NSString *kUM_commonproblem = @"commonproblem";


#pragma mark - 经侦预警

//经侦预警“搜索”点击量
static NSString *kUM_search = @"search";
//经侦预警“诈骗案例”点击量
static NSString *kUM_fraudcase = @"fraudcase";


#pragma mark - 市场服务

//市场服务“在线报修”点击量
static NSString *kUM_ServiceRepair = @"ServiceRepair";
//市场服务“泊车位办理”点击量
static NSString *kUM_Servicepark = @"Servicepark";
//市场服务“转租转让”点击量
static NSString *kUM_Servicestalls = @"Servicestalls";
//市场服务“服务电话”点击量
static NSString *kUM_ServiceNumber = @"ServiceNumber";


#pragma mark - 其他

//“我的”点击量
static NSString *kUM_mine = @"mine";
//“消息”点击量
static NSString *kUM_message = @"message";

