//
//  ZXOpenMapsManager.h
//  MerchantBusinessClient
//
//  Created by simon on 2020/4/29.
//  Copyright © 2020 com.Chs. All rights reserved.
//
/// 简介：调用各种地图导航的组件库；支持跳转到高德，百度，苹果地图App进行导航；外部传入的经纬度必须使用火星坐标系（GCJ02）;支持指定目的地名称展示;高德是导航，百度，Apple是路线规划；
/// 配置白名单 由于iOS的限制，iOS系统在9之后的版本中，如果开发者的app希望调起高德/baidu地图，必须在自己app的设置中配置白名单。配置方法： 1、找到您的Info.plist文件 2、在文件中添加key：LSApplicationQueriesSchemes，类型是Array，如果曾经添加过，无需再次添加。 3、Array中依次添加item，类型为String，值为iosamap,baidumap。

//  2020.5.07 修改bug，优化;
//  2020.5.13 增加经纬度转换；优化地图导航展示名称；

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN



typedef NS_ENUM(NSUInteger, ZXMapType) {
    ZXMapTypeAMap = 0, //高德，坐标系类型是AMap
    ZXMapTypeBaidu = 1,//百度，坐标系类型是baidu的；
    ZXMapTypeApple = 2,//苹果，坐标系类型是AMap
};

@interface ZXOpenMapsManager : NSObject


/// 类方法，调用实例方法；
/// @param viewController viewController description
/// @param lat 使用火星坐标系的经纬度；
/// @param lon 使用火星坐标系的经纬度；
/// @param poiName poi名称，位置名称，可选参数；同一个经纬度下可能有很多poi名称，指定poi后高德导航目的地更精准；百度和apple只是简单的显示指定的位置，不会去执行位置搜索；
/// @param tapBlock 额外点击回调；
+ (UIAlertController *)zx_showActionSheetInViewController:(UIViewController *)viewController
                                             withLatitude:(double)lat
                                                longitude:(double)lon
                                                  poiName:(nullable NSString *)poiName
                                                 tapBlock:(nullable void (^)(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex))tapBlock;

/// 调用当前手机支持的地图列表在ActionSeet展示，自动处理点击不同的地图导航进入不同的app，并支持额外点击回调；
/// @param viewController viewController description
/// @param lat 使用火星坐标系的经纬度；
/// @param lon 使用火星坐标系的经纬度；
/// @param poiName poi名称，位置名称，可选参数；同一个经纬度下可能有很多poi名称，指定poi后高德导航目的地更精准；百度和apple只是简单的显示指定的位置，不会去执行位置搜索；
/// @param tapBlock 额外点击回调；
- (UIAlertController *)showActionSheetInViewController:(UIViewController *)viewController
                               withLatitude:(double)lat
                                  longitude:(double)lon
                                    poiName:(nullable NSString *)poiName
                                   tapBlock:(nullable void (^)(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex))tapBlock;


/// 获取支持的地图列表
- (NSArray <NSDictionary*>*)getSupportMapItemSchemes;


/// 获取支持的地图列表，block返回；
/// @param finish 返回items和titles集合；
- (void)getSupportMapItemSchemesFinishBlock:(nullable void(^)(NSArray <NSDictionary*> *items,NSArray *titles))finish;


/// scheme调用打开高德地图App-直接导航，使用火星坐标系（GCJ02）的经纬度；
/// @param lat 目的纬度
/// @param lon 目的精度
/// @param poiName poi名称，位置名称；可选参数；
/// @param failure 没有安装高德app的提示文本回调
- (void)zx_openSchemeURLToAMapClientForNavigationWithLatitude:(double)lat longitude:(double)lon poiName:(nullable NSString *)poiName openFailure:( nullable void(^)(NSString *tostTitle))failure;


/// scheme调用打开百度地图App-导航路线，默认使用火星坐标系（GCJ02）的经纬度；
/// @param lat 目的纬度
/// @param lon 目的精度
/// @param poiName poi名称，位置名称，只是简单的显示指定的位置，不会去执行位置搜索；可选参数
/// @param failure 没有安装app的提示文本回调
- (void)zx_openSchemeURLToBaiduMapClientForNavigationWithLatitude:(double)lat longitude:(double)lon poiName:(nullable NSString *)poiName openFailure:(nullable void(^)(NSString *tostTitle))failure;


/// scheme调用打开苹果系统地图App-导航路线，使用火星坐标系（GCJ02）的经纬度；
/// @param lat 目的纬度
/// @param lon 目的精度
/// @param poiName 只是简单的显示指定的位置，不会去执行位置搜索；可选；
- (void)zx_openSchemeURLToAppleMapsForNavigationWithLatitude:(double)lat longitude:(double)lon poiName:(nullable NSString *)poiName;



/// 百度地图BD09LL经纬度转换为高德（GCJ02）经纬度
+ (CLLocationCoordinate2D)zx_getGaoDeCoordinateByBaiDuCoordinate:(CLLocationCoordinate2D)coordinate;

/// 高德地图火星坐标系（GCJ02）经纬度转换为百度BD09LL经纬度
+ (CLLocationCoordinate2D)zx_getBD09CoordinateByGaoDeCoordinate:(CLLocationCoordinate2D)coordinate;

@end

NS_ASSUME_NONNULL_END


//例如：
/*
#import <AMapFoundationKit/AMapFoundationKit.h>

- (void)mapBtnOpenAction:(UIButton *)sender
{
    if (self.dataMArray.count <= self.currentIndex) {
        return;
    }
    CHSTastListModel *model = [self.dataMArray objectAtIndex:self.currentIndex];
    
    if (!model.amap_latitude && !model.amap_longitude) {
        
        NSNumber *lat = model.latitude;
        NSNumber *lon = model.longitude;
        CLLocationCoordinate2D bd09Coordinate =  CLLocationCoordinate2DMake(lat.doubleValue, lon.doubleValue);
        CLLocationCoordinate2D cj02Coordinate = AMapCoordinateConvert(bd09Coordinate, AMapCoordinateTypeBaidu);
        [ZXOpenMapsManager zx_showActionSheetInViewController:self withLatitude:cj02Coordinate.latitude longitude:cj02Coordinate.longitude tapBlock:nil];
    }else
    {
        NSNumber *lat = model.amap_latitude;
        NSNumber *lon = model.amap_longitude;
        [ZXOpenMapsManager zx_showActionSheetInViewController:self withLatitude:lat.doubleValue longitude:lon.doubleValue tapBlock:nil];
    }
}
*/
