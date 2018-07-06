//
//  UIDevice+ZXInfo.h
//  YiShangbao
//
//  Created by simon on 2017/11/3.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  2018.04.03  优化注释

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (ZXInfo)

// 每次初始化后生成一个随机的UUID；格式如"E621E1F8-C36C-495A-93FC-0C247A3E6E5F”的字符串；
- (NSString *)getUUID;

// 获取IDFV的UUID；
// 每个APP根据bundleID（供应商）独立一个不同的ADFV，但相同bundleID的app，ADFV是相同的；
// 注意：如果用户将属于此Vender的所有App卸载，则IDFV的值会被重置，即再重装此Vender的App，IDFV的值和之前不同。F47873A0-B382-42CA-B863-F405B87E8682
// 目前解决方法：获取一次后，使用钥匙串保存起来，这样即使你删除了App，再重新安装，只有BundleId不变，那么从钥匙串中获取的UUID不会变的。
- (NSString *)getIDFVUUIDString;

// 获取广告id标识符；
// 广告id，在同一个设备上的所有App都会取到相同的值，是苹果专门给各广告提供商用来追踪用户而设的，Apple默认是允许追踪的，而且一般用户都不知道有这么个设置，所以基本上用来监测推广效果，是戳戳有余了。
// 但IDFA存在重新生成的情况:
// 用户完全重置系统(设置程序 -> 通用 -> 还原 -> 还原位置与隐私)
// 用户明确还原广告(设置程序-> 通用 -> 关于本机 -> 广告 -> 还原广告标示符)
// 注意：由于idfa会出现取不到的情况，故绝不可以作为业务分析的主id，来识别用户。
- (nullable NSString *)getIDFAUUIDString;


// 获取openUDID-第三方
// 根据友盟统计SDK获取UDID，和OpenUDID获取的openUDID一样的；

- (nullable NSString *)getUMOpenUDIDString;



// 获取设备类型名称；
+ (NSString *)getDeviceName;




// 获取mac地址
+ (nullable NSString *)getMacAddress;

// 获取ip地址
// 获取设备当前网络IP地址
+ (NSString *)getIPAddress:(BOOL)preferIPv4;






// CPU总数目
+ (NSUInteger)getCPUCount;
// CPU使用的总比例
+ (CGFloat)getCPUUsage;
// 获取每个cpu的使用比例
+ (nullable NSArray *)getPerCPUUsage;


// 获取磁盘总空间
+ (int64_t)getTotalDiskSpace;
// 获取未使用的磁盘空间
+ (int64_t)getFreeDiskSpace;
// 获取已使用的磁盘空间
+ (int64_t)getUsedDiskSpace;


@end

NS_ASSUME_NONNULL_END

/************************获取设备常见信息***********************/
/*
// 获取设备用户的名称（iphone用户名称,mac用户名称,即自己写的名字）
NSString *iPhoneName = [UIDevice currentDevice].name;
NSLog(@"iPhone名称-->%@", iPhoneName);

// 获取设备的类型 @"iPhone", @"iPod touch"
NSString *model = [UIDevice currentDevice].model;
NSLog(@"设备类型model-->%@", model);

NSString *localizedModel = [UIDevice currentDevice].localizedModel;
NSLog(@"设备本地化模型localizedModel-->%@", localizedModel);

//获取设备的系统名称，iOS，Mac
NSString *systemName = [UIDevice currentDevice].systemName;
NSLog(@"当前系统名称-->%@", systemName);

// 获取设备的系统版本 @"4.0",@"11.0"
NSString *systemVersion = [UIDevice currentDevice].systemVersion;
NSLog(@"当前系统版本号-->%@", systemVersion);

// 获取电量的等级，[0 ,1.0]，-1.0
CGFloat batteryLevel = [[UIDevice currentDevice] batteryLevel];
NSLog(@"电池电量-->%f", batteryLevel);

// 获取设备的电池当前状态：当发生改变时会发送通知
UIDeviceBatteryState batteryState = [[UIDevice currentDevice] batteryState];
NSLog(@"电池当前状态-->%ld", batteryState);



NSString *appVerion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
NSLog(@"app版本号-->%@", appVerion);
*/
