//
//  ZXOpenMapsManager.m
//  MerchantBusinessClient
//
//  Created by simon on 2020/4/29.
//  Copyright © 2020 com.Chs. All rights reserved.
//

#import "ZXOpenMapsManager.h"

@interface ZXOpenMapsManager ()

@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *mapItems;

@end


@implementation ZXOpenMapsManager

- (NSMutableArray *)titles
{
    if (!_titles) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}

- (NSMutableArray *)mapItems
{
    if (!_mapItems) {
        _mapItems = [NSMutableArray array];
    }
    return _mapItems;
}


+ (UIAlertController *)zx_showActionSheetInViewController:(UIViewController *)viewController
withLatitude:(double)lat
   longitude:(double)lon
     poiName:(nullable NSString *)poiName
    tapBlock:(nullable void (^)(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex))tapBlock
{
    ZXOpenMapsManager *manager = [[ZXOpenMapsManager alloc] init];
    return [manager showActionSheetInViewController:viewController withLatitude:lat longitude:lon poiName:poiName tapBlock:tapBlock];
}

- (UIAlertController *)showActionSheetInViewController:(UIViewController *)viewController
                               withLatitude:(double)lat
                                  longitude:(double)lon
                                    poiName:(nullable NSString *)poiName
                                 tapBlock:(nullable void (^)(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex))tapBlock
{
    NSArray *items = [self getSupportMapItemSchemes];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSString *cancelButtonTitle = @"取消";
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action){
                                                                if (tapBlock)
                                                                {
                                                                    tapBlock(alertController,action,-1);
                                                                }
                                                         }];
    [alertController addAction:cancelAction];

    if (self.titles.count>0)
    {
        for(NSUInteger i=0; i<self.titles.count;i++)
        {
            NSString *otherButtonTitle = self.titles[i];
            if (otherButtonTitle.length >0) {
                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle
                                                                      style:UIAlertActionStyleDefault
                                                                    handler:^(UIAlertAction *action){
                    
                    NSDictionary *dic = [items objectAtIndex:i];
                    ZXMapType type = [[dic objectForKey:@"mapType"] integerValue];
                    if (type == ZXMapTypeAMap)
                    {
                        [self zx_openSchemeURLToAMapClientForNavigationWithLatitude:lat longitude:lon poiName:poiName openFailure:nil];
                    }
                    else if (type == ZXMapTypeApple)
                    {
                        [self zx_openSchemeURLToAppleMapsForNavigationWithLatitude:lat longitude:lon poiName:poiName];
                    }
                    else if (type == ZXMapTypeBaidu)
                    {
                        [self zx_openSchemeURLToBaiduMapClientForNavigationWithLatitude:lat longitude:lon poiName:poiName openFailure:nil];
                    }
                                                                        if (tapBlock) {
                                                                            tapBlock(alertController, action,i);
                                                                        }
                                                                    }];
                [alertController addAction:otherAction];
            }
        }
    }
    [viewController presentViewController:alertController animated:YES completion:nil];
    return alertController;
}


- (NSArray <NSDictionary*> *)getSupportMapItemSchemes
{
    [self getSupportMapItemSchemesFinishBlock:nil];
    return self.mapItems;
}

- (void)getSupportMapItemSchemesFinishBlock:(nullable void(^)(NSArray <NSDictionary *> *items,NSArray *titles))finish
{
    [self.mapItems removeAllObjects];
    //判断是否安装高德map
    NSURL *amap_scheme = [NSURL URLWithString:@"iosamap://"];
    if ([[UIApplication sharedApplication] canOpenURL:amap_scheme]) {
        NSDictionary *amap_dic = @{@"title":@"高德地图",@"mapType":@(ZXMapTypeAMap)};
        [self.mapItems addObject:amap_dic];
    }
    //判断是否安装baidumap
    NSURL *baidu_scheme = [NSURL URLWithString:@"baidumap://"];
    if ([[UIApplication sharedApplication] canOpenURL:baidu_scheme]) {
        NSDictionary * dic = @{@"title":@"百度地图",@"mapType":@(ZXMapTypeBaidu)};
        [self.mapItems addObject:dic];
    }
    NSDictionary * dic = @{@"title":@"Apple地图",@"mapType":@(ZXMapTypeApple)};
    [self.mapItems addObject:dic];

    [self.titles removeAllObjects];
    __weak __typeof(self)weakSelf = self;
    [self.mapItems enumerateObjectsUsingBlock:^(NSDictionary *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakSelf.titles addObject:[obj objectForKey:@"title"]];
     }];
    if (finish) {
        finish(self.mapItems,self.titles);
    }
}


/*
高德地图导航：输入终点，以用户当前位置为起点开始路线导航，提示用户每段行驶路线以到达目的地。支持版本V5.0.0 起。
url解析：字段-名称-是否必填
navi -服务类型- 是
sourceApplication -第三方调用应用名称,DisplayName -是
poiname -POI名称 -否
poiid -对应sourceApplication的POIID -否
lat -纬度 -是
lon -经度 -是
dev -是否偏移(0:lat和lon是已经加密后的,不需要国测加密;1:需要国测加密) 是 /坐标系：0:GCJ－02，1:WGS－84
 */
- (void)zx_openSchemeURLToAMapClientForNavigationWithLatitude:(double)lat longitude:(double)lon poiName:(nullable NSString *)poiName openFailure:(void(^)(NSString *tostTitle))failure
{
    NSURL *scheme = [NSURL URLWithString:@"iosamap://"];
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:scheme];
    if (!canOpen) {
        if (failure) {
            failure(@"请先安装高德地图App哦～");
        }
        return;
    }
    NSString *bundleName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    NSString *stringURL = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&poiname=&poiid=&lat=%f&lon=%f&dev=0",bundleName,lat,lon];
    if (@available(iOS 9.0,*)) {
        stringURL = [stringURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
    NSURL *url = [NSURL URLWithString:stringURL];
    if (@available(iOS 10.0, *)) {
         [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success){
             if (success) {
                 
             }
         }];
     }else
     {
         [[UIApplication sharedApplication] openURL:url];
     }
}

/// BaiduMap路线规划
/// origin:起点名称或经纬度，或者可同时提供名称和经纬度，此时经纬度优先级高，将作为导航依据，名称只负责展示。必选；
/// destination:终点名称或经纬度，或者可同时提供名称和经纬度，此时经纬度优先级高，将作为导航依据，名称只负责展示。必选；
/// name最后传值，不然地图上目的地只会展示“地图上的点”,也看不到建筑物名字，不友好；只是简单的显示指定的位置，不会去执行位置搜索；
/// mode:导航模式，固定为transit、driving、navigation、walking，riding分别表示公交、驾车、导航、步行和骑行.必选；
/// coord_type:坐标类型，虽然默认是baidu的，但可以设置修改其它类型。必选参数。
/// src:表示来源，用于统计.必选.必选参数，格式为：ios.companyName.appName 不传此参数，不保证服务.
- (void)zx_openSchemeURLToBaiduMapClientForNavigationWithLatitude:(double)lat longitude:(double)lon poiName:(nullable NSString *)poiName openFailure:(nullable void(^)(NSString *tostTitle))failure
{
    NSURL *scheme = [NSURL URLWithString:@"baidumap://"];
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:scheme];
    if (!canOpen) {
        if (failure) {
            failure(@"请先安装百度地图App哦～");
        }
        return;
    }
    NSString *stringURL =[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name:%@&mode=driving&coord_type=gcj02&src=%@",lat,lon,poiName,[[NSBundle mainBundle]bundleIdentifier]];
    if (@available(iOS 9.0,*)) {
        stringURL = [stringURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
    NSURL *url = [NSURL URLWithString:stringURL];
    if (@available(iOS 10.0, *)) {
         [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success){
             if (success) {
                 
             }
         }];
     }else
     {
         [[UIApplication sharedApplication] openURL:url];
     }
}
/// 获取Apple地图路线，导航方向；
/// sadder: 起点，如果你不指定saddrd的值,起点是"here";非必须；
/// dirflg:指定交通类型;非必须；
/// daddr: 终点，目的地址作为目标点方向。如果你没有传终点，则弹出界面让你输入终点，不然无法查询到路线； 必须；
/// address:一个地理位置。只是简单的显示指定的位置，不会去执行位置搜索；
- (void)zx_openSchemeURLToAppleMapsForNavigationWithLatitude:(double)lat longitude:(double)lon poiName:(nullable NSString *)poiName
{
    NSString *stringURL = [NSString stringWithFormat:@"http://maps.apple.com/?daddr=%f,%f&dirflg=r&address=%@",lat,lon,poiName];
    if (@available(iOS 9.0,*)) {
        stringURL = [stringURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
    NSURL *url =[NSURL URLWithString:stringURL];
    if (@available(iOS 10.0,*)) {
        [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:nil];
    }
    else
    {
        [[UIApplication sharedApplication] openURL:url];
    }
}


// 百度地图BD09LL经纬度转换为高德（GCJ02）经纬度
+ (CLLocationCoordinate2D)zx_getGaoDeCoordinateByBaiDuCoordinate:(CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(coordinate.latitude - 0.006, coordinate.longitude - 0.0065);
}

// 高德地图火星坐标系（GCJ02）经纬度转换为百度BD09LL经纬度
+ (CLLocationCoordinate2D)zx_getBD09CoordinateByGaoDeCoordinate:(CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(coordinate.latitude + 0.006, coordinate.longitude + 0.0065);
}
@end
