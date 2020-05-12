//
//  ZXOpenMapsManager.h
//  MerchantBusinessClient
//
//  Created by simon on 2020/4/29.
//  Copyright © 2020 com.Chs. All rights reserved.
//
/// 简介：调用各种地图导航的组件库；支持跳转到高德，百度，苹果地图App进行导航；外部传入的经纬度必须使用火星坐标系（GCJ02）;
/// 配置白名单 由于iOS的限制，iOS系统在9之后的版本中，如果开发者的app希望调起高德/baidu地图，必须在自己app的设置中配置白名单。配置方法： 1、找到您的Info.plist文件 2、在文件中添加key：LSApplicationQueriesSchemes，类型是Array，如果曾经添加过，无需再次添加。 3、Array中依次添加item，类型为String，值为iosamap,baidumap。

//  2020.5.07 修改bug，优化;
// 2020.5.11 增加经纬度转换；

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


//+ (instancetype)sharedInstance;

/// 获取支持的地图列表
- (NSArray <NSDictionary*>*)getSupportMapItemSchemes;


/// 获取支持的地图列表，block返回；
/// @param finish 返回items和titles集合；
- (void)getSupportMapItemSchemesFinishBlock:(nullable void(^)(NSArray <NSDictionary*> *items,NSArray *titles))finish;

/*
    scheme调用打开高德地图App-导航路线，使用火星坐标系（GCJ02）的经纬度；
    url解析：字段-名称-是否必填
    navi 服务类型 是
    sourceApplication 第三方调用应用名称。DisplayName 是
    poiname POI名称 否
    poiid 对应sourceApplication 的POI ID 否
    lat 纬度 是
    lon 经度 是
    dev 是否偏移(0:lat和lon是已经加密后的,不需要国测加密;1:需要国测加密) 是 /坐标系：0:GCJ－02，1:WGS－84
/// @param lat 目的纬度
/// @param lon 目的精度
/// @param failure 没有安装高德app的提示文本回调
 */

- (void)zx_openSchemeURLToAMapClientForNavigationWithLatitude:(double)lat longitude:(double)lon openFailure:( nullable void(^)(NSString *tostTitle))failure;


/// scheme调用打开百度地图App-导航路线，默认使用火星坐标系（GCJ02）的经纬度；
/// @param lat <#lat description#>
/// @param lon <#lon description#>
/// @param failure <#failure description#>
- (void)zx_openSchemeURLToBaiduMapClientForNavigationWithLatitude:(double)lat longitude:(double)lon openFailure:(nullable void(^)(NSString *tostTitle))failure;


/// scheme调用打开苹果系统地图App-导航路线，使用火星坐标系（GCJ02）的经纬度；
/// @param lat 目的纬度
/// @param lon 目的精度
- (void)zx_openSchemeURLToAppleMapsForNavigationWithLatitude:(double)lat longitude:(double)lon;




/// 类方法，调用实例方法；
/// @param viewController viewController description
/// @param lat 使用火星坐标系的经纬度；
/// @param lon 使用火星坐标系的经纬度；
/// @param tapBlock 额外点击回调；
+ (UIAlertController *)zx_showActionSheetInViewController:(UIViewController *)viewController
                                          withLatitude:(double)lat
                                             longitude:(double)lon
                                              tapBlock:(nullable void (^)(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex))tapBlock;


/// 调用当前手机支持的地图列表在ActionSeet展示，自动处理点击不同的地图导航进入不同的app，并支持额外点击回调；
/// @param viewController viewController description
/// @param lat 使用火星坐标系的经纬度；
/// @param lon 使用火星坐标系的经纬度；
/// @param tapBlock 额外点击回调；
- (UIAlertController *)showActionSheetInViewController:(UIViewController *)viewController
                               withLatitude:(double)lat
                                  longitude:(double)lon
                                   tapBlock:(nullable void (^)(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex))tapBlock;

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
