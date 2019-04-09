//
//  AppHeader.h
//  
//
//  Created by simon on 15/6/17.
//  Copyright (c) 2015年 simon. All rights reserved.
//

#ifndef douniwan_AppHeader_h
#define douniwan_AppHeader_h
#import "StoryboardHeader.h"
#import "NotificationMarco.h"
#import "UMAnalyticsViewMarco.h"
#import "AppFoundation.h"
//11111111


#pragma mark - 美颜拼图AppleID
#define kAPPID  @"1180821282" //义采宝

#pragma mark - JPush

static NSString *kJPushAppKey = @"87245d848bf02bbd239b59af";
static NSInteger kHTTP_minPageSize = 5;

#pragma mark- 比盟

//思春堂
//static NSString *kBMOB_APPID =  @"85f8f27eba2da26d5076df7114dae422"

//美颜拼图

static NSString *kBMOB_APPID =  @"69c52eeb7424886debae08af8dad3e2f";
#pragma mark - 颜色

////主题色-绿色
//#define AppGlobalTintColor  UIColorFromRGB(12.,212.,186.)
//
////主题色2:灰色
//#define AppSecondGlobalTintColor UIColorFromRGB(128.f,128.f,128.f)
////页面背景色，底色－
//#define AppBgColor  UIColorFromRGB(213.,228.,229.)
////主文字颜色
//#define AppMainTitleColor UIColorFromRGB(50.,50.,50.)
////标识文字颜色
//#define AppMarkTitleColor UIColorFromRGB(128.f,128.f,128.f)
//

#pragma mark - 占位图以及头像头

//义采宝
#define AppPlaceholderImage [UIImage imageNamed:@"默认图正方形"]
//#define AppPlaceholderImage [UIImage zh_imageWithColor:UIColorFromRGB(229., 229., 229.) andSize:CGSizeMake(200, 200)]
//人头像
#define AppPlaceholderImage_Head [UIImage imageNamed:@"ic_empty_person"]
//商铺空头像
#define AppPlaceholderImage_Shop [UIImage imageNamed:@"ic_empty_shop"]





/*
 
#pragma mark -QiniuImageView2

//限定缩略图的长边最多为<750>，进行等比缩放，不裁剪；主要用于宽度等于整个屏幕宽度的图片
static NSString *kQINIU_IMAGEPATH_500_X = @"?imageView2/0/w/750/q/75";

//限定缩略图的宽最少为<200>，高最少为<200>，进行等比缩放，居中裁剪 正方形缩略小图；
static NSString *kQINIU_IMAGEPATH_200_200 = @"?imageView2/1/w/200/h/200";

//限定缩略图的长边最多为<1000>，短边自适应，进行等比缩放，不裁剪。用于显示整个屏幕大小的大图，显示图片原图等；
static NSString *kQINIU_IMAGEPATH_1000_X =@"?imageView2/0/w/1000/q/75";

//限定缩略图的长边最多为<400>，短边最多300，进行等比缩放，不裁剪。用于瀑布流列表显示1/2屏幕宽度的图片；
static NSString *kQINIU_IMAGEPATH_W400_H300 =@"?imageView2/0/w/400/h/300";
*/



#endif
