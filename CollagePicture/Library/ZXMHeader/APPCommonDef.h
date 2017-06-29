//
//  APPCommonDef.h
//  UI_APPCommonDef
//
//  Created by 朱新明 on 12-10-18.
//  Copyright (c) 2012年 Ibokan. All rights reserved.
//

//宏定义的参数，就是一个字符串替换；所以参数一定要带括号；
#ifndef UI_APPCommonDef_h
#define UI_APPCommonDef_h

#import "QYHelpFunction.h"
#import <objc/runtime.h>

#pragma mark
#pragma mark-system version
/***************************
获取系统版本号等信息
 ****************************/
//获取系统版本
#ifndef                         Device_Version
#define Device_Version          [[UIDevice currentDevice] systemVersion]
#endif

#define Device_Version_Greater_THAN_OR_EQUAL_TO(v) ([Device_Version floatValue] >= v)
#define Device_IOS10_OR_LATER ([Device_Version floatValue] >= 10.0)
#define Device_IOS9_OR_LATER ([Device_Version floatValue] >= 9.0)

/*
//检查系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
*/

//获取系统名
#ifndef                         Device_SystemName
#define Device_SystemName       [[UIDevice currentDevice]systemName]
#endif
//设备名称－用户自己写的名称
#ifndef                         Device_Name
#define Device_Name             [[UIDevice currentDevice]name]
#endif
//用户设备实时类型 @"iPhone", @"iPod touch"
#ifndef                         Device_model
#define Device_model            [[UIDevice currentDevice]model]
#endif

#define Device_UUID             [[[UIDevice currentDevice]identifierForVendor]UUIDString]
#define Device_localizedModel   [[UIDevice currentDevice]localizedModel]


/*********************************************************************************/

#pragma mark
#pragma mark-AppBundle信息
//资源包info.plist文件的所有健值的字典；
#define APPInfoDictionary    [[NSBundle mainBundle]infoDictionary]
#define APP_AllInfoShow      CFShow(APPInfoDictionary)
//应用标识 bundelId
#define APP_bundleIdentifier [[NSBundle mainBundle]bundleIdentifier] 
//包名；根据key值获取本地化资源对象的值
#define APP_BundleName       [APPInfoDictionary objectForKey:@"CFBundleName"]
//显示包别名；根据key值获取本地化资源对象的值
#define APP_DisplayName      [[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleDisplayName"]
#define APP_Name             APP_DisplayName?APP_DisplayName:APP_BundleName
//app版本号version
#define APP_Version          [[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define kAPP_Version    [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"]
//app内部测试版本号Build
#define APP_build            [[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleVersion"]//版本号


//返回AppDelegate指针
#ifndef APP_Delegate
#define APP_Delegate            (AppDelegate*)[[UIApplication sharedApplication]  delegate]
#endif
//应用当前持有的最高级window
#ifndef APP_keyWindow
#define APP_keyWindow            [[UIApplication sharedApplication] keyWindow]
#endif
//应用程序的主window
#ifndef APP_MainWindow
#define APP_MainWindow    [[[UIApplication sharedApplication] delegate] window]
#endif



//iTunesLink 链接－－iTunesLink＋appID，ios6以后有直接跳转appStore的item应用Controller页面
#ifndef ITUNESLINK
#if __IPHONE_7_0
#define ITUNESLINK @"http://itunes.apple.com/cn/app/id"
#else
#define ITUNESLINK @"http://ax.itunes.apple.com/cn/app/id"
#endif
#endif

//检查版本更新请求数据用的
#ifndef kITUNESURL
#define kITUNESURL @"http://itunes.apple.com"
#endif

/*********************************************************************************/
//(375,667) (414,)
#pragma mark
#pragma mark-屏幕尺寸
/***************************
 获取屏幕信息（尺寸，宽，高），bounds 就是屏幕的全部区域：例：0，0，320，568
 ****************************/
#define LCDW ([[UIScreen mainScreen] bounds].size.width)
#define LCDH ([[UIScreen mainScreen] bounds].size.height)

#define LCDNH (self.navigationController.navigationBar.bounds.size.height)

//当用了系统navigationBar的时候。获取可用尺寸高度
#define LCDH_nav  (LCDH-LCDNH-20)
//当用了系统navigationBar和tabBar的时候。获取可用尺寸高度
#define LCDH_navAndTool  (LCDH_nav-self.navigationController.toolbar.bounds.size.height)

#define LCDH_navAndTab (LCDH_nav-self.navigationController.tabBarController.tabBar.bounds.size.height)

//设置iphone6尺寸比例/竖屏,UI所有设备等比例缩放
#define LCDScale_iphone6_Width(X)    ((X)*LCDW/375)

//iphone5,6 一样，6plus放大，用于间距，字体大小，文本控件高度；
//宏定义的变量数字一定要加()才能准;CGFloat right = (LCDScale_5Equal6_To6plus(-93.f))-15.f
#define LCDScale_5Equal6_To6plus(X) (IS_IPHONE_6P ? ((X)*LCDW/375) : (X))


#ifndef SCREEN_WIDTH

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#endif

#ifndef SCREEN_MAX_LENGTH
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#endif

#ifndef IS_IPHONE_4_OR_LESS
#define IS_IPHONE_4_OR_LESS (SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (SCREEN_MIN_LENGTH == 375.0)
#define IS_IPHONE_6P (SCREEN_MIN_LENGTH == 414.0)
#endif


#pragma mark-设置view某个尺寸改变后的frame
//单独设置view的frame里的高度，其他的值保持不变
#define ZX_FRAME_Y(view,y) CGRectMake(CGRectGetMinX(view.frame),y, CGRectGetWidth(view.frame),CGRectGetHeight(view.frame))
#define ZX_FRAME_H(view,h) CGRectMake(CGRectGetMinX(view.frame),CGRectGetMinY(view.frame), CGRectGetWidth(view.frame),h)
#define ZX_FRAME_W(view,w) CGRectMake(CGRectGetMinX(view.frame),CGRectGetMinY(view.frame), w,CGRectGetHeight(view.frame))

//*********************************************************************************


#pragma mark-secondsTime
//a day/month/year has many secondes;
#define SECONDS_PER_HOUR (60*60)
#define SECONDS_PER_DAY (24*60*60)
#define SECONDS_PER_MONTH (30*24*60*60)
#define SECONDS_PER_YEAR (365*24*60*60)


#pragma mark
//-角度degress转化为radian弧度
#ifndef ZX_DegreesToRadian
#define ZX_DegreesToRadian(x) (M_PI*(x)/180.0)
#endif



//*********************************************************************************

#pragma mark-NSLog utility 打印

////NSLog返回更多信息。
//#ifdef DEBUG
//#define NSLog(format, ...)  do{ printf("\n <%s : %d行> %s \n %s \n",\
//[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __FUNCTION__,[[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]); \
//} while (0)
//#else
//#define NSLog(format, ...)
//#endif

#ifndef __OPTIMIZE__
#define NSLog(format, ...) printf("\n[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);

#endif
//不能用，一旦用了，会无法打包
//#ifndef __OPTIMIZE__
//#define NSLitLog(format, ...) printf(" %s\n", [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
//#endif

//NSLog 根据url和dictionary 参数 打印httpURL请求地址
#ifndef ZX_NSLog_HTTPURL
#define ZX_NSLog_HTTPURL(hostURL,path, parameterDic) \
NSString *string = [NSString stringWithFormat:@"%@%@?", hostURL, path];\
NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:parameterDic];\
NSMutableArray *array = [NSMutableArray array];\
[dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) { \
NSString *para = [NSString stringWithFormat:@"%@=%@",key,[dic objectForKey:key]];\
[array addObject:para];\
}];\
NSString *p = [array componentsJoinedByString:@"&"];\
NSString *urlString = [string stringByAppendingString:p];\
NSLog(@"%@",urlString);
#endif

#pragma mark - 打印一个对象model的所有属性key和他的value

NS_INLINE void ZX_NSLog_ClassAllPropertyAndValue(id model)
{
    u_int count;
    Class cla = object_isClass(model)?model:[model class];
    objc_property_t *properties = class_copyPropertyList(cla, &count);
    for (int i =0; i<count; i++)
    {
        objc_property_t property = properties [i];
        const char *propertyName = property_getName(property);
        NSString *strName = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
        id getIvar = [model valueForKey:strName];
        NSLog(@"key=%@,value=%@",strName,getIvar);
    }
    free(properties);
    NSLog(@"%u",count);
}

#pragma mark - 打印一个class的所有方法列表(包括没有声明的私有方法)

NS_INLINE void ZX_NSLog_ClassMethodListName(id object)
{
    u_int count;
    Class cla = object_isClass(object)?object:object_getClass(object);
    Method *methods = class_copyMethodList(cla, &count);
    for (int i =0; i<count; i++)
    {
        SEL name1 = method_getName(methods[i]);
//        IMP imp = class_getMethodImplementation(cla, name1);
        // 这2句等同于NSStringFromSelector(name1);
        const char *selName= sel_getName(name1);
        NSString *strName = [NSString stringWithCString:selName encoding:NSUTF8StringEncoding];
        NSLog(@"%@",strName);
        
    }
    free(methods);
    NSLog(@"%u",count);//包括很多私有方法;
}

//定义block使用的weak引用
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

//用来读取应用程序的文件，比如图片等
#define ZX_ContentFile(aFileName,aFileType) [[NSBundle mainBundle]pathForResource:aFileName ofType:aFileType]






//#pragma mark-barTintColor
#ifndef ZX_BarTintColor
#define ZX_BarTintColor self.navigationController.navigationBar.barTintColor
#endif




#pragma mark-NSString utility

//去除2端空格；
#ifndef ZX_StringRemoveSpace
#define ZX_StringRemoveSpace(string)     [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
#endif




#pragma mark-UIColor utility

#define UIColorFromRGB(R,G,B)  [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f]
#define UIColorFromRGBA(R,G,B,A)  [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]

/**
 * @brief 16进制的字符串颜色转RGB.把＃变为0x，如果没有则加上。 eg:#333333--ZX_RGBHexString(0X333333)
 */
#define UIColorFromRGB_HexValue(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbValue & 0xFF))/255.0f alpha:1.f]

#define UIColorFromRGBA_HexValue(rgbValue,A) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbValue & 0xFF))/255.0f alpha:A]















//系统api更新，有一些DEPRECATED了，需要适配
#pragma mark  IOS7，IOS8Compatible

#pragma mark-NSString(UIStringDrawing)

/*
 Single line, no wrapping. Truncation based on the NSLineBreakMode.
 //根据字体大小获取CGSize,只针对一行,没有折行；用参数NSLineBreakMode来截断；
 */

//无限长宽度；
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define ZX_TEXTSIZE(text, font) [text length] > 0 ? [text sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero;
#else
#define ZX_TEXTSIZE(text, font) [text length] > 0 ? [text sizeWithFont:font] : CGSizeZero;
#endif




//根据文字，一个最大Size尺寸，字体大小，换行模式 来获取最适合的CGSize
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define ZX_TEXTSIZE_MULTILINE(text, font, maxSize, mode) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
#else
#define ZX_TEXTSIZE_MULTILINE(text, font, maxSize, mode) [text length] > 0 ? [text \
sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero;
#endif





//状态栏样式
#if __IPHONE_7_0
#define ZX_UIStatusBarStyleLightContent UIStatusBarStyleLightContent

#else
#define ZX_UIStatusBarStyleLightContent UIStatusBarStyleBlackOpaque\

#endif


//tabBar的背景颜色
#if __IPHONE_7_0
#define ZX_UITabBar_BarTintColor(tabBar) tabBar.barTintColor

#else
#define ZX_UITabBar_BarTintColor(tabBar) tabBar.tintColor

#endif






//tabBarItme按钮的颜色。selectedImageTintColor在ios8.0已经废弃；在ios7和之前， seletedImageTintColor 用UITabBar的tintColor属性获取
#if __IPHONE_8_0
#define ZX_UITabBar_TintColor(tabBar) tabBar.tintColor
#else
#define ZX_UITabBar_TintColor(tabBar) tabBar.selectedImageTintColor
#endif





#endif




////以下开始是宏定义
////rac_valuesForKeyPath:observer:是方法名
//#define RACObserve(TARGET, KEYPATH) \
//[(id)(TARGET) rac_valuesForKeyPath:@keypath(TARGET, KEYPATH) observer:self]
//
//#define keypath(...) \
//metamacro_if_eq(1, metamacro_argcount(__VA_ARGS__))(keypath1(__VA_ARGS__))(keypath2(__VA_ARGS__))
//
////这个宏在取得keypath的同时在编译期间判断keypath是否存在，避免误写
////您可以先不用介意这里面的巫术..
//#define keypath1(PATH) \
//(((void)(NO && ((void)PATH, NO)), strchr(# PATH, '.') + 1))
//
//#define keypath2(OBJ, PATH) \
//(((void)(NO && ((void)OBJ.PATH, NO)), # PATH))
//
////A和B是否相等，若相等则展开为后面的第一项，否则展开为后面的第二项
////eg. metamacro_if_eq(0, 0)(true)(false) => true
////    metamacro_if_eq(0, 1)(true)(false) => false
//#define metamacro_if_eq(A, B) \
//metamacro_concat(metamacro_if_eq, A)(B)
//
//#define metamacro_if_eq1(VALUE) metamacro_if_eq0(metamacro_dec(VALUE))
//
//#define metamacro_if_eq0(VALUE) \
//metamacro_concat(metamacro_if_eq0_, VALUE)
//
//#define metamacro_if_eq0_1(...) metamacro_expand_
//
//#define metamacro_expand_(...) __VA_ARGS__
//
//#define metamacro_argcount(...) \
//metamacro_at(20, __VA_ARGS__, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1)
//
//#define metamacro_at(N, ...) \
//metamacro_concat(metamacro_at, N)(__VA_ARGS__)
//
//#define metamacro_concat(A, B) \
//metamacro_concat_(A, B)
//
//#define metamacro_concat_(A, B) A ## B
//
//#define metamacro_at2(_0, _1, ...) metamacro_head(__VA_ARGS__)
//
//#define metamacro_at20(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, ...) metamacro_head(__VA_ARGS__)
//
//#define metamacro_head(...) \
//metamacro_head_(__VA_ARGS__, 0)
//
//#define metamacro_head_(FIRST, ...) FIRST
//
//#define metamacro_dec(VAL) \
//metamacro_at(VAL, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19)




