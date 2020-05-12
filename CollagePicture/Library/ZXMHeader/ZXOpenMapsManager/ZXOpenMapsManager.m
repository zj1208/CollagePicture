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

//+ (instancetype)sharedInstance
//{
//    static id instance = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        if (!instance) {
//
//            instance = [self new];
//        }
//    });
//    return instance;
//}

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

- (void)zx_openSchemeURLToAMapClientForNavigationWithLatitude:(double)lat longitude:(double)lon openFailure:(void(^)(NSString *tostTitle))failure
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

- (void)zx_openSchemeURLToBaiduMapClientForNavigationWithLatitude:(double)lat longitude:(double)lon openFailure:(void(^)(NSString *tostTitle))failure
{
    NSURL *scheme = [NSURL URLWithString:@"baidumap://"];
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:scheme];
    if (!canOpen) {
        if (failure) {
            failure(@"请先安装百度地图App哦～");
        }
        return;
    }
    NSString *stringURL =[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=11&mode=driving&coord_type=gcj02",lat,lon];
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

- (void)zx_openSchemeURLToAppleMapsForNavigationWithLatitude:(double)lat longitude:(double)lon
{
    NSString *stringURL = [NSString stringWithFormat:@"http://maps.apple.com/?&daddr=%f,%f",lat,lon];
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

+ (UIAlertController *)zx_showActionSheetInViewController:(UIViewController *)viewController
withLatitude:(double)lat
   longitude:(double)lon
  tapBlock:(nullable void (^)(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex))tapBlock
{
    ZXOpenMapsManager *manager = [[ZXOpenMapsManager alloc] init];
    return [manager showActionSheetInViewController:viewController withLatitude:lat longitude:lon tapBlock:tapBlock];
}

- (UIAlertController *)showActionSheetInViewController:(UIViewController *)viewController
                               withLatitude:(double)lat
                                  longitude:(double)lon
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
                    if (type == ZXMapTypeAMap) {
                        
                        [self zx_openSchemeURLToAMapClientForNavigationWithLatitude:lat longitude:lon openFailure:nil];
                    }
                    else if (type == ZXMapTypeApple)
                    {
                        [self zx_openSchemeURLToAppleMapsForNavigationWithLatitude:lat longitude:lon];
                    }else if (type == ZXMapTypeBaidu)
                    {
                        [self zx_openSchemeURLToBaiduMapClientForNavigationWithLatitude:lat longitude:lon openFailure:nil];
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
