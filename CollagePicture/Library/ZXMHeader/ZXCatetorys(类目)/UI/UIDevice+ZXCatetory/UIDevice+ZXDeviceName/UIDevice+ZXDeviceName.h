//
//  UIDevice+ZXDeviceName.h
//  Runner
//
//  Created by simon on 2020/11/23.
//
//  2020.11.21 更新iPhone12 期的各种设备名；

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ZXDeviceModelType) {
    ZXDeviceModelType_iPad,
    ZXDeviceModelType_iPhone,
    ZXDeviceModelType_iPodTouch,
};

@interface UIDevice (ZXDeviceName)


/// 获取设备具体类型名称；
- (NSString *)zx_getDeviceName;


/**
 ! 没有包含全，其它设备类型没有经过测试。
 获取设备大体类型-model：iPad，iPhone，iPod touch
 例如：使用AlertController-actionSheet样式弹出的时候，在iPad上需要不同设置处理；
 @return 设备类型
 */
- (ZXDeviceModelType)zx_getDeviceModelType;


@end

NS_ASSUME_NONNULL_END
