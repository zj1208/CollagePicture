//
//  UIDevice+ZXDeviceName.m
//  Runner
//
//  Created by simon on 2020/11/23.
//

#import "UIDevice+ZXDeviceName.h"
//设备类型
#import "sys/utsname.h"

@implementation UIDevice (ZXDeviceName)


#pragma mark - Device

- (NSString *)zx_getDeviceModelInfo
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *device_model = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return device_model;
}

/// 获取设备类型名称；
/// https://www.theiphonewiki.com/wiki/Models
- (NSString *)zx_getDeviceName
{
    NSString *deviceString = [self zx_getDeviceModelInfo];
    
    // 1.模拟器
    if ([deviceString isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([deviceString isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    // 2.iPhone
    // 2011年9月 操作系统iOS 5.0
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    
    // 2012年 操作系统iOS 6.0
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    
    // 2013年 操作系统iOS 7.0
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    
    // 2014年 操作系统iOS 8.0
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    
    // 2015年 iPhone 6s + iPhone 6s Plus + iPhone SE;操作系统iOS 9.0
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE 1代";
    
    // 2016年 iPhone 7 + iPhone 7 Plus；操作系统iOS 10.0
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    
    
    // 2017年 iPhone 8 + iPhone 8 Plus + iPhone X；操作系统iOS 11.0
    if ([deviceString isEqualToString:@"iPhone10,1"])   return @"iPhone 8-国行(A1863)、日行(A1906)、港行";
    if ([deviceString isEqualToString:@"iPhone10,4"])   return @"iPhone 8-美版(全球/A1905)";
    if ([deviceString isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus-国行(A1864)、日行(A1898)、港行";
    if ([deviceString isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus-美版(全球/A1897)";
    if ([deviceString isEqualToString:@"iPhone10,3"])   return @"iPhone X-国行(A1865)、日行(A1902)、港行";
    if ([deviceString isEqualToString:@"iPhone10,6"])   return @"iPhone X-美版(全球/A1901)";
    
    // 2018年 iPhone Xs+ iPhone Xs Max + iPhone Xr ； 操作系统iOS 12.0
    if ([deviceString isEqualToString:@"iPhone11,2"])  return @"iPhone Xs";
    if ([deviceString isEqualToString:@"iPhone11,4"])  return @"iPhone Xs Max";
    if ([deviceString isEqualToString:@"iPhone11,6"])  return @"iPhone Xs Max";
    if ([deviceString isEqualToString:@"iPhone11,8"])  return @"iPhone XR";
    
    // 2019年 iPhone 11+ iPhone 11 Pro + iPhone 11 Pro Max + iPhone SE 2代； 操作系统iOS 13.0
    if ([deviceString isEqualToString:@"iPhone12,1"])  return @"iPhone 11";
    if ([deviceString isEqualToString:@"iPhone12,3"])  return @"iPhone 11 Pro";
    if ([deviceString isEqualToString:@"iPhone12,5"])  return @"iPhone 11 Pro Max";
    if ([deviceString isEqualToString:@"iPhone12,8"])  return @"iPhone SE 2";
    
    // 2020年 iPhone 12 mini+ iPhone 12+ iPhone 12 Pro + iPhone 12 Pro Max； 操作系统iOS 14.0
    if ([deviceString isEqualToString:@"iPhone13,1"])  return @"iPhone 12 mini";
    if ([deviceString isEqualToString:@"iPhone13,2"])  return @"iPhone 12";
    if ([deviceString isEqualToString:@"iPhone13,3"])  return @"iPhone 12 Pro";
    if ([deviceString isEqualToString:@"iPhone13,4"])  return @"iPhone 12 Pro Max";
    
    
    
    // 3.iPod touch-第几代
    
    if ([deviceString isEqualToString:@"iPod1,1"])     return @"iPod Touch 1";
    if ([deviceString isEqualToString:@"iPod2,1"])     return @"iPod Touch 2";
    if ([deviceString isEqualToString:@"iPod3,1"])     return @"iPod Touch 3";
    if ([deviceString isEqualToString:@"iPod4,1"])     return @"iPod Touch 4";
    if ([deviceString isEqualToString:@"iPod5,1"])     return @"iPod Touch 5";
    if ([deviceString isEqualToString:@"iPod7,1"])     return @"iPod Touch 6";
    if ([deviceString isEqualToString:@"iPod9,1"])     return @"iPod Touch 7";
    
    
    
    // 4.iPad
    
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2";

    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3";
    
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    
    if ([deviceString isEqualToString:@"iPad6,11"])    return @"iPad 5";
    if ([deviceString isEqualToString:@"iPad6,12"])    return @"iPad 5";
    
    if ([deviceString isEqualToString:@"iPad7,5"])  return @"iPad 6";
    if ([deviceString isEqualToString:@"iPad7,6"])  return @"iPad 6";
    
    if ([deviceString isEqualToString:@"iPad7,11"])  return @"iPad 7";
    if ([deviceString isEqualToString:@"iPad7,12"])  return @"iPad 7";
    
    // 2020年 操作系统iOS 14.0
    if ([deviceString isEqualToString:@"iPad11,6"])  return @"iPad 8";
    if ([deviceString isEqualToString:@"iPad11,7"])  return @"iPad 8";

    
    
    
    // 5.iPad Air
    
    if ([deviceString isEqualToString:@"iPad4,1"])     return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,2"])     return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,3"])     return @"iPad Air";
    
    if ([deviceString isEqualToString:@"iPad5,3"])     return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])     return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad11,3"])    return @"iPad Air 3";
    if ([deviceString isEqualToString:@"iPad11,4"])    return @"iPad Air 3";
    // 2020年 操作系统iOS 14.0
    if ([deviceString isEqualToString:@"iPad13,2"])    return @"iPad Air 4";

    
    
    // 6.iPad Pro
    
    if ([deviceString isEqualToString:@"iPad6,3"])     return @"iPad Pro (9.7-inch)";
    if ([deviceString isEqualToString:@"iPad6,4"])     return @"iPad Pro (9.7-inch)";
    if ([deviceString isEqualToString:@"iPad6,7"])     return @"iPad Pro (12.9-inch)";
    if ([deviceString isEqualToString:@"iPad6,8"])     return @"iPad Pro (12.9-inch)";
    
    if ([deviceString isEqualToString:@"iPad7,1"])     return @"iPad Pro (12.9-inch) 2";
    if ([deviceString isEqualToString:@"iPad7,2"])     return @"iPad Pro (12.9-inch) 2";
    if ([deviceString isEqualToString:@"iPad7,3"])     return @"iPad Pro (10.5-inch)";
    if ([deviceString isEqualToString:@"iPad7,4"])     return @"iPad Pro (10.5-inch)";
    
    if ([deviceString isEqualToString:@"iPad8,1"])      return @"iPad Pro (11-inch)";
    if ([deviceString isEqualToString:@"iPad8,2"])      return @"iPad Pro (11-inch)";
    if ([deviceString isEqualToString:@"iPad8,3"])      return @"iPad Pro (11-inch)";
    if ([deviceString isEqualToString:@"iPad8,4"])      return @"iPad Pro (11-inch)";
    
    if ([deviceString isEqualToString:@"iPad8,5"])      return @"iPad Pro (12.9-inch) 3";
    if ([deviceString isEqualToString:@"iPad8,6"])      return @"iPad Pro (12.9-inch) 3";
    if ([deviceString isEqualToString:@"iPad8,7"])      return @"iPad Pro (12.9-inch) 3";
    if ([deviceString isEqualToString:@"iPad8,8"])      return @"iPad Pro (12.9-inch) 3";
    
    // 2019
    if ([deviceString isEqualToString:@"iPad8,9"])      return @"iPad Pro (11-inch) 2";
    if ([deviceString isEqualToString:@"iPad8,10"])     return @"iPad Pro (11-inch) 2";
    
    if ([deviceString isEqualToString:@"iPad8,11"])     return @"iPad Pro (12.9-inch) 4";
    if ([deviceString isEqualToString:@"iPad8,12"])     return @"iPad Pro (12.9-inch) 4";
    
    
    
    
    // 7.iPad mini
    
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad Mini 1";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad Mini 1";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad Mini 1";
    if ([deviceString isEqualToString:@"iPad4,4"])      return @"iPad Mini 2";
    if ([deviceString isEqualToString:@"iPad4,5"])      return @"iPad Mini 2";
    if ([deviceString isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"])      return @"iPad Mini 4";
    if ([deviceString isEqualToString:@"iPad5,2"])      return @"iPad Mini 4";
    if ([deviceString isEqualToString:@"iPad11,1"])     return @"iPad mini 5";
    if ([deviceString isEqualToString:@"iPad11,2"])     return @"iPad mini 5";

    
    
    // 8.Apple Watch
    
    if ([deviceString isEqualToString:@"Watch1,1"])      return @"Apple Watch 1";
    if ([deviceString isEqualToString:@"Watch1,2"])      return @"Apple Watch 1";
    
    if ([deviceString isEqualToString:@"Watch2,6"])     return @"Apple Watch Series 1";
    if ([deviceString isEqualToString:@"Watch2,7"])     return @"Apple Watch Series 1";
    
    if ([deviceString isEqualToString:@"Watch2,3"])     return @"Apple Watch Series 2";
    if ([deviceString isEqualToString:@"Watch2,4"])     return @"Apple Watch Series 2";
    
    if ([deviceString isEqualToString:@"Watch3,1"])     return @"Apple Watch Series 3";
    if ([deviceString isEqualToString:@"Watch3,2"])     return @"Apple Watch Series 3";
    if ([deviceString isEqualToString:@"Watch3,3"])     return @"Apple Watch Series 3";
    if ([deviceString isEqualToString:@"Watch3,4"])     return @"Apple Watch Series 3";

    if ([deviceString isEqualToString:@"Watch4,1"])     return @"Apple Watch Series 4";
    if ([deviceString isEqualToString:@"Watch4,2"])     return @"Apple Watch Series 4";
    if ([deviceString isEqualToString:@"Watch4,3"])     return @"Apple Watch Series 4";
    if ([deviceString isEqualToString:@"Watch4,4"])     return @"Apple Watch Series 4";

    if ([deviceString isEqualToString:@"Watch5,1"])     return @"Apple Watch Series 5";
    if ([deviceString isEqualToString:@"Watch5,2"])     return @"Apple Watch Series 5";
    if ([deviceString isEqualToString:@"Watch5,3"])     return @"Apple Watch Series 5";
    if ([deviceString isEqualToString:@"Watch5,4"])     return @"Apple Watch Series 5";

    if ([deviceString isEqualToString:@"Watch5,9"])     return @"Apple Watch SE";
    if ([deviceString isEqualToString:@"Watch5,10"])     return @"Apple Watch SE";
    if ([deviceString isEqualToString:@"Watch5,11"])     return @"Apple Watch SE";
    if ([deviceString isEqualToString:@"Watch5,12"])     return @"Apple Watch SE";

    // 2020年 操作系统iOS 14.0
    if ([deviceString isEqualToString:@"Watch6,1"])     return @"Apple Watch Series 6";
    if ([deviceString isEqualToString:@"Watch6,2"])     return @"Apple Watch Series 6";
    if ([deviceString isEqualToString:@"Watch6,3"])     return @"Apple Watch Series 6";
    if ([deviceString isEqualToString:@"Watch6,4"])     return @"Apple Watch Series 6";

    
    
    // 9.Apple TV
    
    if ([deviceString isEqualToString:@"AppleTV2,1"])    return @"Apple TV 2";
    if ([deviceString isEqualToString:@"AppleTV3,1"])    return @"Apple TV 3";
    if ([deviceString isEqualToString:@"AppleTV3,2"])    return @"Apple TV 3";
    if ([deviceString isEqualToString:@"AppleTV5,3"])    return @"Apple TV 4";
    if ([deviceString isEqualToString:@"AppleTV6,2"])    return @"Apple TV 4K";

    return deviceString;
    
}

- (ZXDeviceModelType)zx_getDeviceModelType
{
    NSString *model = self.model;
    if ([model isEqualToString:@"iPhone"])
    {
        return ZXDeviceModelType_iPhone;
    }
    else if ([model isEqualToString:@"iPad"])
    {
        return ZXDeviceModelType_iPad;
    }
    return ZXDeviceModelType_iPodTouch;
}

@end
