//
//  UIDevice+ZXHelper.m
//  YiShangbao
//
//  Created by simon on 2017/11/3.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "UIDevice+ZXHelper.h"

//设备类型
#import "sys/utsname.h"

//mac地址
#import "net/if.h"
#import "sys/sysctl.h"

#include <sys/socket.h> // Per msqr
#include <net/if_dl.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>

//获取cpu
#import <mach/processor_info.h>
#import <mach/mach.h>
#import <mach/mach_host.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
//#define IOS_VPN       @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

#import <AdSupport/AdSupport.h>

@implementation UIDevice (ZXHelper)

#pragma mark - UUID

- (NSString *)zx_getUUID
{
    return  [[NSUUID UUID] UUIDString];
}
//po [[UIDevice currentDevice]getIDFVUUIDString]
- (NSString *)zx_getIDFVUUIDString
{
    NSUUID *uuid = [[UIDevice currentDevice]identifierForVendor];
    NSString *identifier =uuid.UUIDString;
    return identifier;
}

- (NSString *)zx_getIDFAUUIDString
{
//    NSBundle *adSupportBundle = [NSBundle bundleWithPath:@"/System/Library/Frameworks/AdSupport.framework"];
//    if (![adSupportBundle isLoaded])
//    {
//        return @"模拟器";
//    }
#if TARGET_IPHONE_SIMULATOR 
    // iphonex模拟器 66A9243D-A0EF-4BB3-8DBC-2632E09DE21B
    return @"模拟器";
    
#elif TARGET_OS_IPHONE
    
    ASIdentifierManager *manager = [ASIdentifierManager sharedManager];
    if (manager.isAdvertisingTrackingEnabled)
    {
        NSUUID *idfaUUID = manager.advertisingIdentifier;
        return idfaUUID.UUIDString;
    }
#endif
    // 如果开启限制则返回00000000000
    return @"";
}




#pragma mark - Device

- (NSString *)zx_getDeviceVersionInfo
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
    NSString *deviceString = [self zx_getDeviceVersionInfo];
    
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
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    
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
    
    // 2018年 iPhone XS+ iPhone XS Max + iPhone XR ； 操作系统iOS 12.0
    if ([deviceString isEqualToString:@"iPhone11,2"])  return @"iPhone XS";
    if ([deviceString isEqualToString:@"iPhone11,4"])  return @"iPhone_XS_Max";
    if ([deviceString isEqualToString:@"iPhone11,6"])  return @"iPhone_XS_Max";
    if ([deviceString isEqualToString:@"iPhone11,8"])  return @"iPhone XR";
    
    // 2019年 iPhone 11+ iPhone 11 Pro + iPhone 11 Pro Max + iPhone SE 2代； 操作系统iOS 13.0
    if ([deviceString isEqualToString:@"iPhone12,1"])  return @"iPhone 11";
    if ([deviceString isEqualToString:@"iPhone12,3"])  return @"iPhone 11 Pro";
    if ([deviceString isEqualToString:@"iPhone12,5"])  return @"iPhone 11 Pro Max";
    if ([deviceString isEqualToString:@"iPhone12,8"])  return @"iPhone SE 2代";
    
    
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
    
    // 5.iPad Air
    
    if ([deviceString isEqualToString:@"iPad4,1"])     return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,2"])     return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,3"])     return @"iPad Air";
    
    if ([deviceString isEqualToString:@"iPad5,3"])     return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])     return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad11,3"])    return @"iPad Air 3";
    if ([deviceString isEqualToString:@"iPad11,4"])    return @"iPad Air 3";
    
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

#pragma mark - MAC，IP地址


//获取mac地址
+ (nullable NSString *)zx_getMacAddress
{
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    
    //    NSString *outstring = [NSString stringWithFormat:@"xxxxxx", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    //
    
    // MAC地址带冒号
    //    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2),*(ptr+3), *(ptr+4), *(ptr+5)];
    //
    // MAC地址不带冒号
    NSString *outstring = [NSString
                           stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr + 1), *(ptr + 2), *(ptr + 3), *(ptr + 4), *(ptr + 5)];
    free(buf);
    return [outstring uppercaseString];
}

//获取ip地址
//获取设备当前网络IP地址
+ (NSString *)zx_getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ /*IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6,*/ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ /*IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4,*/ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self zx_getIPAddresses];
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

//获取所有相关IP信息
+ (NSDictionary *)zx_getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}



#pragma mark - CPU


// CPU总数目
+ (NSUInteger)zx_getCPUCount
{
    return [NSProcessInfo processInfo].activeProcessorCount;
}


// CPU使用的总比例
+ (CGFloat)zx_getCPUUsage
{
    float cpu = 0;
    NSArray *cpus = [self zx_getPerCPUUsage];
    if (cpus.count == 0) return -1;
    for (NSNumber *n in cpus) {
        cpu += n.floatValue;
    }
    return cpu;
}


// 获取每个cpu的使用比例
+ (nullable NSArray *)zx_getPerCPUUsage
{
    processor_info_array_t _cpuInfo, _prevCPUInfo = nil;
    mach_msg_type_number_t _numCPUInfo, _numPrevCPUInfo = 0;
    unsigned _numCPUs;
    NSLock *_cpuUsageLock;
    
    int _mib[2U] = { CTL_HW, HW_NCPU };
    size_t _sizeOfNumCPUs = sizeof(_numCPUs);
    int _status = sysctl(_mib, 2U, &_numCPUs, &_sizeOfNumCPUs, NULL, 0U);
    if (_status)
        _numCPUs = 1;
    
    _cpuUsageLock = [[NSLock alloc] init];
    
    natural_t _numCPUsU = 0U;
    kern_return_t err = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &_numCPUsU, &_cpuInfo, &_numCPUInfo);
    if (err == KERN_SUCCESS) {
        [_cpuUsageLock lock];
        
        NSMutableArray *cpus = [NSMutableArray new];
        for (unsigned i = 0U; i < _numCPUs; ++i) {
            Float32 _inUse, _total;
            if (_prevCPUInfo) {
                _inUse = (
                          (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER])
                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM])
                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE])
                          );
                _total = _inUse + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE]);
            } else {
                _inUse = _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE];
                _total = _inUse + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE];
            }
            [cpus addObject:@(_inUse / _total)];
        }
        
        [_cpuUsageLock unlock];
        if (_prevCPUInfo) {
            size_t prevCpuInfoSize = sizeof(integer_t) * _numPrevCPUInfo;
            vm_deallocate(mach_task_self(), (vm_address_t)_prevCPUInfo, prevCpuInfoSize);
        }
        return cpus;
    } else {
        return nil;
    }
}

#pragma mark - 磁盘空间

// 获取磁盘总空间
+ (int64_t)zx_getTotalDiskSpace
{
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return -1;
    int64_t space =  [[attrs objectForKey:NSFileSystemSize] longLongValue];
    if (space < 0) space = -1;
    return space;
}

// 获取未使用的磁盘空间
+ (int64_t)zx_getFreeDiskSpace
{
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return -1;
    int64_t space =  [[attrs objectForKey:NSFileSystemFreeSize] longLongValue];
    if (space < 0) space = -1;
    return space;
}

// 获取已使用的磁盘空间
+ (int64_t)zx_getUsedDiskSpace
{
    int64_t totalDisk = [self zx_getTotalDiskSpace];
    int64_t freeDisk = [self zx_getFreeDiskSpace];
    if (totalDisk < 0 || freeDisk < 0) return -1;
    int64_t usedDisk = totalDisk - freeDisk;
    if (usedDisk < 0) usedDisk = -1;
    return usedDisk;
}


#pragma mark - 内存

// 系统总内存空间
- (int64_t)zx_getTotalMemory
{
    int64_t totalMemory = [[NSProcessInfo processInfo] physicalMemory];
    if (totalMemory < -1) totalMemory = -1;
    return totalMemory;
}

// 空闲的内存空间
- (int64_t)zx_getFreeMemory {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.free_count * page_size;
}

// 已使用的内存空间
- (int64_t)zx_getUsedMemory {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return page_size * (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count);
}


// 活跃的内存,正在使用或者很短时间内被使用过
- (int64_t)zx_getActiveMemory
{
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.active_count * page_size;
}

// 最近使用过,但是目前处于不活跃状态的内存
- (int64_t)zx_getInActiveMemory {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.inactive_count * page_size;
}


// 用来存放内核和数据结构的内存,framework、用户级别的应用无法分配
- (int64_t)zx_getWiredMemory {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.wire_count * page_size;
}

// 可释放的内存空间：内存吃紧自动释放，针对大对象存放所需的大块内存空间
- (int64_t)zx_getPurgableMemory {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.purgeable_count * page_size;
}
@end

