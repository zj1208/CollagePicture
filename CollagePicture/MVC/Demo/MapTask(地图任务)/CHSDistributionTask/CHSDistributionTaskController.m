//
//  CHSDistributionTaskController.m
//  MerchantBusinessClient
//
//  Created by simon on 2020/4/23.
//  Copyright © 2020 com.Chs. All rights reserved.
//

#import "CHSDistributionTaskController.h"

#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>

#import "CHSDistributionTastItemView.h"
#import "ZXOpenMapsManager.h"


@interface CHSDistributionTaskController ()<AMapLocationManagerDelegate,MAMapViewDelegate>

@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) UIButton *mapViewBtn;

@property (nonatomic, copy) NSArray *locationArray;
@property (nonatomic, copy) NSMutableArray <MAPointAnnotation *> *annotations;

@property (nonatomic, strong) CHSDistributionTastItemView *itemView;
@property (nonatomic, strong) UIButton *leftItemBtn;
@property (nonatomic, strong) UIButton *rightItemBtn;

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation CHSDistributionTaskController
//最后三位小数点是不断变化的
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"配送任务", nil);
    self.locationArray = @[@{@"lat":@(30.192529),@"log":@(120.189805),@"status":@(1),@"selected":@(1)},
                           @{@"lat":@(30.192529+0.01),@"log":@(120.189805+0.01),@"status":@(1),@"selected":@(0)},
    @{@"lat":@(30.192529+0.02),@"log":@(120.189805+0.02),@"status":@(1),@"selected":@(0)},
    @{@"lat":@(30.192529+0.03),@"log":@(120.189805+0.03),@"status":@(2),@"selected":@(0)},
    @{@"lat":@(30.192529+0.006),@"log":@(120.189805+0.06),@"status":@(2),@"selected":@(0)}];
    [self setUI];
}

- (void)dealloc
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setBarTintColor:[UIColor zx_colorWithHexString:@"#FFFFFF"]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor zx_colorWithHexString:@"#333333"]}];
//    [self.locationManager startUpdatingLocation];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.locationManager stopUpdatingLocation];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)setUI
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self rightBarButton]];

    [self addMapView];

    [self.view addSubview:self.itemView];
    [self.itemView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-[UIApplication sharedApplication].zx_safeAreaBottomHeight-LCDScale_iPhone6(20));
        make.height.mas_equalTo(LCDScale_iPhone6(267));
        make.left.mas_equalTo(self.view.mas_left).offset(LCDScale_iPhone6(63));
    }];

    [self.view addSubview:self.leftItemBtn];
    UIImage *leftImage = [self.leftItemBtn currentImage];
    [self.leftItemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.itemView.mas_centerY);
        make.left.mas_equalTo(self.view.mas_left).offset(LCDScale_iPhone6((63-leftImage.size.width)/2));
    }];

    [self.view addSubview:self.rightItemBtn];
    UIImage *rightImage = [self.rightItemBtn currentImage];
    [self.rightItemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.itemView.mas_centerY);
        make.right.mas_equalTo(self.view.mas_right).offset(-LCDScale_iPhone6((63-rightImage.size.width)/2));
    }];

    [self.view addSubview:self.mapViewBtn];
    UIImage *image = self.mapViewBtn.currentImage;
    [self.mapViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {

        make.height.mas_equalTo(image.size.height);
        make.width.mas_equalTo(image.size.width);
        make.right.mas_equalTo(self.mapView.mas_right).offset(0);
        make.bottom.mas_equalTo(self.mapView.mas_bottom).offset(-LCDScale_iPhone6(267+5));
    }];
}

- (UIButton *)rightBarButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 101, 32);
    [btn setTitle:@"列表模式" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor zx_colorWithHexString:@"#307DF4"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont zx_systemFontOfScaleSize:16];
    [btn setImage:[UIImage imageNamed:@"map_switch"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(switchViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn zx_setImagePositionWithType:ZXButtonContentTypeImageLeftTitleRight spacing:5];
    btn.backgroundColor = [UIColor zx_colorWithHex:0xF2F2F2 alpha:1];
    return btn;
}

- (CHSDistributionTastItemView *)itemView
{
    if (!_itemView) {
        CHSDistributionTastItemView *view = [[CHSDistributionTastItemView alloc] init];
        [view.callBtn addTarget:self action:@selector(callBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [view.mapBtn addTarget:self action:@selector(mapBtnOpenAction:) forControlEvents:UIControlEventTouchUpInside];
        [view.doBtn addTarget:self action:@selector(doBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [view.tastDetaiBtn addTarget:self action:@selector(tastDetaiBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _itemView = view;
    }
    return _itemView;
}

//+30.19822081,+120.19638961
- (void)addMapView
{
    [AMapServices sharedServices].enableHTTPS = YES;
    [self.view addSubview:self.mapView];
    [self addAnnotation];
    [self.mapView addAnnotations:self.annotations];

    [self.mapView selectAnnotation:[self.annotations firstObject] animated:YES];
    self.currentIndex = 1;
}


//自定义标注,需要实现 <Delegate> 协议中的 mapView:viewForAnnotation:回调函数，设置标注样式。
- (void)addAnnotation
{
    for (NSDictionary *dic in self.locationArray) {
        MAPointAnnotation* annotation = [[MAPointAnnotation alloc]init];
        NSNumber *lat = [dic objectForKey:@"lat"];
        NSNumber *log = [dic objectForKey:@"log"];
        annotation.coordinate = CLLocationCoordinate2DMake(lat.doubleValue, log.doubleValue);
        //设置标注的标题
        annotation.title = nil;
        //副标题
        annotation.subtitle = nil;
        [self.annotations addObject:annotation];
    }
}

- (NSMutableArray *)annotations
{
    if (!_annotations) {
        _annotations = [NSMutableArray array];
    }
    return _annotations;;
}


- (UIButton *)mapViewBtn
{
    if (!_mapViewBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"map_restore"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(mapViewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _mapViewBtn = btn;
    }
    return _mapViewBtn;
}

- (AMapLocationManager *)locationManager
{
    if (!_locationManager) {
        //初始化实例
        AMapLocationManager *manager = [[AMapLocationManager alloc] init];
        manager.delegate = self;
        manager.locatingWithReGeocode = YES;
        manager.pausesLocationUpdatesAutomatically = YES;
        manager.allowsBackgroundLocationUpdates = NO;
//        manager.distanceFilter = 200;
        _locationManager = manager;
    }
    return _locationManager;
}

- (MAMapView *)mapView
{
    if (!_mapView) {
        MAMapView *view = [[MAMapView alloc] initWithFrame:self.view.bounds];
        view.showsUserLocation = YES;
        view.userTrackingMode = MAUserTrackingModeFollow;
        view.delegate = self;
        view.zoomLevel = 13;
        _mapView = view;
    }
    return _mapView;
}


- (UIButton *)leftItemBtn
{
    if (!_leftItemBtn) {
        UIButton *btn  = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"左翻"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(leftItemBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _leftItemBtn = btn;
    }
    return _leftItemBtn;
}

- (UIButton *)rightItemBtn
{
    if (!_rightItemBtn) {
        UIButton *btn  = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"右翻"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(rightItemBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _rightItemBtn = btn;
    }
    return _rightItemBtn;
}


#pragma mark - MAMapViewDelegate
// 实现 <MAMapViewDelegate> 协议中的 mapView:viewForAnnotation:回调函数，设置标注样式。
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
            [annotationView addGestureRecognizer:[self tapGesture]];
        }
        [self setCellDataWithAnnotationView:annotationView viewForAnnotation:annotation];
        return annotationView;
    }
    return nil;
}

- (void)setCellDataWithAnnotationView:(MAPinAnnotationView *)annotationView viewForAnnotation:(id <MAAnnotation>)annotation
{
    //如果是自己加的标注
    if (![self.annotations containsObject:annotation]) {
        return;
    }
    NSInteger index = [self.annotations indexOfObject:annotation];
    NSDictionary *dic = [self.locationArray objectAtIndex:index];
    NSNumber *lat = [dic objectForKey:@"lat"];
    NSNumber *log = [dic objectForKey:@"log"];
    NSNumber *status = [dic objectForKey:@"status"];
    if (annotation.coordinate.latitude == lat.doubleValue && annotation.coordinate.longitude == log.doubleValue)
    {
         if ([status integerValue] == 1) {
             UIImage *image = [UIImage imageNamed:@"map_noFinish"];
             annotationView.image = image;
             annotationView.centerOffset = CGPointMake(0, -image.size.height/2);
         }
         if ([status integerValue] == 2) {
             UIImage *image = [UIImage imageNamed:@"map_finish"];
             annotationView.image = image;
             annotationView.centerOffset = CGPointMake(0, -image.size.height/2);
         }
    }
}


- (UITapGestureRecognizer *)tapGesture
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizerAction:)];
    return tapGesture;
}

- (void)tapRecognizerAction:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        MAPinAnnotationView *view = (MAPinAnnotationView *)sender.view;
        MAPointAnnotation *annotation = view.annotation;
        
        NSInteger index = [self.annotations indexOfObject:annotation];
        self.currentIndex = index;
        [self selectAnnotationAtIndex:index];
    
    }
}

#pragma mark - 选择切换annotation

- (void)selectAnnotationAtIndex:(NSInteger)index
{
    MAPointAnnotation *selectAnnotation = [self.annotations objectAtIndex:index];
    self.mapView.centerCoordinate = selectAnnotation.coordinate;

    [self.annotations enumerateObjectsUsingBlock:^(MAPointAnnotation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MAPinAnnotationView *view = (MAPinAnnotationView *)[self.mapView viewForAnnotation:obj];
        NSDictionary *dic = [self.locationArray objectAtIndex:idx];
        NSNumber *status = [dic objectForKey:@"status"];
        
        if ([selectAnnotation isEqual:obj]) {
            
            UIImage *image = [UIImage imageNamed:@"map_selected"];
            view.image = image;
            view.centerOffset = CGPointMake(0, -image.size.height/2);
         }
        else
        {
            if ([status integerValue] == 1) {
                UIImage *image = [UIImage imageNamed:@"map_noFinish"];
                view.image = image;
                view.centerOffset = CGPointMake(0, -image.size.height/2);
            }
            if ([status integerValue] == 2) {
                UIImage *image = [UIImage imageNamed:@"map_finish"];
                view.image = image;
                view.centerOffset = CGPointMake(0, -image.size.height/2);
            }
        }
    }];
}

//在加载完之后回调；添加手势之后,只有第一次会执行；
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    MAPointAnnotation *annotation = view.annotation;
    NSInteger index = [self.annotations indexOfObject:annotation];
    [self selectAnnotationAtIndex:index];
}


#pragma mark - AMapLocationManagerDelegate

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    if (!location)
    {
        return;
    }
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    if (reGeocode)
    {
        NSLog(@"reGeocode:%@", reGeocode);
    }
}
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    [MBProgressHUD zx_showError:error.localizedDescription toView:self.view];
    NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
}

#pragma mark - Action


- (void)switchViewAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)mapViewBtnAction:(UIButton *)sender
{
    if (self.annotations.count == 0) {
        return;
    }
    self.mapView.centerCoordinate = [self.annotations objectAtIndex:self.currentIndex].coordinate;
    self.mapView.zoomLevel = 13;
}


#pragma mark- cellAction

- (void)callBtnAction:(UIButton *)sender
{
    [[UIApplication sharedApplication]zx_openURLToCallIphoneWithTel:@"18268681208"];
}

- (void)mapBtnOpenAction:(UIButton *)sender
{
    NSDictionary *dic = [self.locationArray objectAtIndex:self.currentIndex];
    NSNumber *lat = [dic objectForKey:@"lat"];
    NSNumber *lon = [dic objectForKey:@"log"];
    
    ZXOpenMapsManager *manager = [ZXOpenMapsManager sharedInstance];
    [manager showActionSheetInViewController:self withLatitude:lat.doubleValue longitude:lon.doubleValue tapBlock:nil];
}

- (void)doBtnAction:(UIButton *)sender
{
    
}

- (void)tastDetaiBtnAction:(UIButton *)sender
{
    
}


#pragma mark - 左右按钮

- (void)leftItemBtnAction:(UIButton *)sender
{
    // 更新item数据
    // 切换地图
    if (self.annotations.count <= 1) {
        return;
    }
    if (self.currentIndex == 0) {
        self.currentIndex = self.annotations.count-1;
    }else
    {
        self.currentIndex --;
    }
    [self selectAnnotationAtIndex:self.currentIndex];
}

- (void)rightItemBtnAction:(UIButton *)sender
{
    if (self.annotations.count <= 1) {
        return;
    }
    if (self.currentIndex == self.annotations.count-1)
    {
        self.currentIndex = 0;
    }else{
        self.currentIndex ++;
    }
    [self selectAnnotationAtIndex:self.currentIndex];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
