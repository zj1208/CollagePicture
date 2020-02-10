//
//  APPCommonDef.h
//  UI_APPCommonDef
//
//  Created by simon on 12-10-18.
//  Copyright (c) 2012年 Ibokan. All rights reserved.
//
// 2018.3.7 新增宏定义：适配iphoneX
// 2020.1.20 IS_IPHONE_XX老方法用safeAreaInsets判断已不准，在iOS13支持scene新建立工程下；

//宏定义的参数，就是一个字符串替换；所以参数一定要带括号；
#ifndef UI_APPCommonDef_h
#define UI_APPCommonDef_h

#import <objc/runtime.h>

#pragma mark

#pragma mark - system version
/***************************
获取系统版本号等信息
 ****************************/
//获取系统版本
#ifndef kDevice_SYSTEMVERSION
#define kDevice_SYSTEMVERSION    [[UIDevice currentDevice] systemVersion]
#endif

#define kDevice_SYSTEMVERSION_Greater_THAN_OR_EQUAL_TO(v) ([Device_SYSTEMVERSION floatValue] >= v)
#define kDevice_SYSTEMVERSION_IOS10_OR_LATER ([Device_SYSTEMVERSION floatValue] >= 10.0)
#define kDevice_SYSTEMVERSION_IOS9_OR_LATER ([Device_SYSTEMVERSION floatValue] >= 9.0)

/*
//检查系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
*/

#pragma mark - Device设备信息
//获取系统名
#ifndef kDevice_SystemName
#define kDevice_SystemName       [[UIDevice currentDevice]systemName]
#endif
//设备名称－用户自己写的名称
#ifndef kDevice_Name
#define kDevice_Name             [[UIDevice currentDevice]name]
#endif
//用户设备实时类型 @"iPhone", @"iPod touch"
#ifndef kDevice_model
#define kDevice_model            [[UIDevice currentDevice]model]
#endif

#define kDevice_UUID             [[[UIDevice currentDevice]identifierForVendor]UUIDString]
#define kDevice_localizedModel   [[UIDevice currentDevice]localizedModel]
/*********************************************************************************/

#pragma mark - AppBundle信息
//资源包info.plist文件的所有健值的字典；
#define kAPPInfoDictionary    [[NSBundle mainBundle]infoDictionary]
#define kAPP_AllInfoShow      CFShow(APPInfoDictionary)
//应用标识 bundelId
#define kAPP_bundleIdentifier [[NSBundle mainBundle]bundleIdentifier]
//包名；根据key值获取本地化资源对象的值
#define kAPP_BundleName       [kAPPInfoDictionary objectForKey:@"CFBundleName"]
//显示包别名；根据key值获取本地化资源对象的值
#define kAPP_DisplayName      [[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleDisplayName"]
#define kAPP_Name             kAPP_DisplayName?kAPP_DisplayName:kAPP_BundleName
//app版本号version
#define kAPP_Version          [[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define kAPP_Version2    [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"]
//app内部测试版本号Build
#define kAPP_build            [[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleVersion"]//版本号



#pragma mark - -APP的window
//返回AppDelegate指针
#ifndef kAPP_Delegate
#define kAPP_Delegate      (AppDelegate*)[[UIApplication sharedApplication]  delegate]
#endif
//应用当前持有的最高级window
#ifndef kAPP_keyWindow
#define kAPP_keyWindow     [[UIApplication sharedApplication] keyWindow]
#endif
//应用程序的主window
#ifndef kAPP_MainWindow
#define kAPP_MainWindow    [[[UIApplication sharedApplication] delegate] window]
#endif

#pragma mark - Itunes链接

//iTunesLink 链接－－iTunesLink＋appID，ios6以后有直接跳转appStore的item应用Controller页面
#ifndef kITUNESLINK
#define kITUNESLINK @"http://itunes.apple.com/cn/app/id"
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
 获取屏幕信息（尺寸，宽，高），bounds 就是屏幕的全部区域：例：
 iPhone4:{{0, 0},{320，480}}
 iPhone5:{{0, 0},{320，568}}
 iPhone6:{{0, 0},{375,667}}
 plus: {{0, 0}, {414,736}}
iPhoneX:{{0, 0}, {414, 896}}
 ****************************/
#ifndef LCDW
#define LCDW ([[UIScreen mainScreen] bounds].size.width)
#define LCDH ([[UIScreen mainScreen] bounds].size.height)
#endif

#ifndef SCREEN_WIDTH
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#endif

#ifndef SCREEN_MAX_LENGTH
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#endif

//设置iphone6尺寸比例/竖屏,UI所有设备等比例缩放
#ifndef LCDScale_iPhone6
#define LCDScale_iPhone6(X)    ((X)*SCREEN_MIN_LENGTH/375)
#endif

//iphone5,6 一样，6plus放大，用于间距，字体大小，文本控件高度；
//宏定义的变量数字一定要加()才能准;CGFloat right = (LCDScale_5Equal6_To6plus(-93.f))-15.f
#ifndef LCDScale_5Equal6_To6plus
#define LCDScale_5Equal6_To6plus(X) ((IS_IPHONE_6P || IS_IPHONE_XX)? ((X)*SCREEN_MIN_LENGTH/375) : (X))
#endif

#pragma mark - 判断是什么设备

#ifndef IS_IPHONE_4_OR_LESS

#define IS_IPHONE_4_OR_LESS (SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (SCREEN_MIN_LENGTH == 320.0 && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (SCREEN_MIN_LENGTH == 375.0 && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (SCREEN_MIN_LENGTH == 414.0)
#endif

//判断iPhoneX，Xs（iPhoneX，iPhoneXs）
#ifndef IS_IPHONE_X
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size): NO)
#endif

//判断iPhoneXr
#ifndef IS_IPHONE_Xr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size): NO)
#endif
//判断iPhoneXsMax
#ifndef IS_IPHONE_Xs_Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size): NO)
#endif

//判断iPhoneX所有系列
#ifndef IS_IPHONE_XX
#define IS_IPHONE_XX (IS_IPHONE_X || IS_IPHONE_Xr || IS_IPHONE_Xs_Max)
#endif

/*
（1）iOS11之前：没有iPhoneX系列；
（2）iOS11-iOS12之间
iPhoneX :{44, 0, 34, 0};其他手机是UIEdgeInsetsZero;
（2）iOS12 之后
iPhoneX :{44, 0, 34, 0};其它手机是{20, 0, 0, 0}
（3）iOS13引入scene,导致 [UIApplication sharedApplication].delegate.window.safeAreaInsets不准；
iPhoneX : {20, 0, 0, 0}
 */
// iPhoneX系列判断window的safeAreaInsets安全区域底部是否是0;来定义是否是iPhoneX；
//#ifndef IS_IPHONE_XX
//#define IS_IPHONE_XX ({\
//int tmp = 0;\
//if (@available(iOS 11.0, *)) { \
//    UIEdgeInsets areaInset = [UIApplication sharedApplication].delegate.window.safeAreaInsets;\
//    if (areaInset.bottom >0) { \
//        tmp = 1;\
//    }\
//}\
//else{\
//    tmp = 0;\
//}\
//tmp;\
//})
//#endif



#pragma mark - 获取navigationBar，statusBar，tabBar高度

#ifndef  kHEIGHT_SAFEAREA_STATUSBAR
#define  kHEIGHT_SAFEAREA_STATUSBAR   (IS_IPHONE_XX ? (20.f+24.f) : (20.f))
#endif

#ifndef  kHEIGHT_SAFEAREA_NAVBAR
#define  kHEIGHT_SAFEAREA_NAVBAR      (kHEIGHT_SAFEAREA_STATUSBAR+44.f)
#endif

#ifndef  kHEIGHT_SAFEAREA_TABBAR
#define  kHEIGHT_SAFEAREA_TABBAR      (IS_IPHONE_XX ? (34.f+49.f) : 49.f)
#endif

#ifndef  kHEIGHT_SAFEAREA_NormalBottom
#define  kHEIGHT_SAFEAREA_NormalBottom      (IS_IPHONE_XX ? 34.f: 0)
#endif


 

#pragma mark - 设置view某个尺寸改变后的frame
//单独设置view的frame里的高度，其他的值保持不变
#define ZX_FRAME_Y(view,y) CGRectMake(CGRectGetMinX(view.frame),y, CGRectGetWidth(view.frame),CGRectGetHeight(view.frame))
#define ZX_FRAME_H(view,h) CGRectMake(CGRectGetMinX(view.frame),CGRectGetMinY(view.frame), CGRectGetWidth(view.frame),h)
#define ZX_FRAME_W(view,w) CGRectMake(CGRectGetMinX(view.frame),CGRectGetMinY(view.frame), w,CGRectGetHeight(view.frame))

//*********************************************************************************


#pragma mark - secondsTime
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

#pragma mark - NSLog utility 打印

//////NSLog返回更多信息。
//#ifdef DEBUG
//#define NSLog(format, ...)  do{ printf("\n <%s : %d行> %s \n %s \n",\
//[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __FUNCTION__,[[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]); \
//} while (0)
//#else
//#define NSLog(format, ...)
//#endif

//#ifndef __OPTIMIZE__
//#define NSLog(format, ...) printf("\n[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
//
//#endif


// 根据url和dictionary 参数 打印httpURL请求地址
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
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wunused-variable"
        id getIvar = [model valueForKey:strName];
        #pragma clang diagnostic pop
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
#ifndef WS
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#endif

//用来读取应用程序的文件，比如图片等
#define ZX_ContentFile(aFileName,aFileType) [[NSBundle mainBundle]pathForResource:aFileName ofType:aFileType]


#pragma mark - UIColor utility


#ifndef UIColorFromRGB
#define UIColorFromRGB(R,G,B)  [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f]
#endif

#ifndef UIColorFromRGBA
#define UIColorFromRGBA(R,G,B,A)  [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]
#endif
/**
 * @brief 16进制的字符串颜色转RGB.把＃变为0x，如果没有则加上。 eg:#34373A--ZX_RGBHexString(0X34373A)
 */
#ifndef UIColorFromRGB_HexValue
#define UIColorFromRGB_HexValue(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbValue & 0xFF))/255.0f alpha:1.f]
#endif

#ifndef UIColorFromRGBA_HexValue
#define UIColorFromRGBA_HexValue(rgbValue,A) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbValue & 0xFF))/255.0f alpha:A]
#endif










//系统api更新，有一些DEPRECATED了，需要适配
#pragma mark - IOS7，IOS8Compatible

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



#endif


