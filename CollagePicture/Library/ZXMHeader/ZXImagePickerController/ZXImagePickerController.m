//
//  ZXImagePickerController.m
//  FunLive
//
//  Created by simon on 2019/4/23.
//  Copyright © 2019 facebook. All rights reserved.
//

#import "ZXImagePickerController.h"
#import "ZXAlbumPickerController.h"
#import "ZXAuthorizationManager.h"
#import "ZXPhotoPickerController.h"

@interface ZXImagePickerController ()

@property (nonatomic, strong)UILabel *tipLabel;

@property (nonatomic, assign) NSInteger columnNumber;

@property (nonatomic, assign) BOOL pushPhotoPickerViewController;

@end

@implementation ZXImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationBar.barTintColor = [UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:1.0];
    self.barStyle = ZXBarStyleWhite;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [self initWithMaxImagesCount:9 delegate:nil];
    }
    return self;
}
- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount delegate:(nullable id<ZXImagePickerControllerDelegate>)delegate {
    return [self initWithMaxImagesCount:maxImagesCount columnNumber:4 delegate:delegate autoPushPhotoPickerViewController:YES];
}

- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount columnNumber:(NSInteger)columnNumber delegate:(nullable id<ZXImagePickerControllerDelegate>)delegate {
    return [self initWithMaxImagesCount:maxImagesCount columnNumber:columnNumber delegate:delegate autoPushPhotoPickerViewController:YES];
}

- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount columnNumber:(NSInteger)columnNumber delegate:(nullable id<ZXImagePickerControllerDelegate>)delegate autoPushPhotoPickerViewController:(BOOL)pushPhotoPickerVc
{
    ZXAlbumPickerController *albumPickerController = [[ZXAlbumPickerController alloc] init];
    albumPickerController.columnNumber = columnNumber;
    self = [super initWithRootViewController:albumPickerController];
    if (self)
    {
        self.pushPhotoPickerViewController = pushPhotoPickerVc;
        self.maxImagesCount = maxImagesCount > 0 ? maxImagesCount : 9;
        self.pickerDelegate = delegate;
        self.columnNumber = columnNumber;
        
        [self initData];

        __weak __typeof(self) weakSelf = self;
        [ZXAuthorizationManager zx_requestPhotoLibraryAuthorization:^(ZXAuthorizationStatus status) {

            if (status != ZXAuthorizationStatusAuthorized)
            {
                [weakSelf.view addSubview:weakSelf.tipLabel];
            }else{

                [weakSelf pushPhotoPickerVc];
            }
        }];
    }
    return self;
}

- (void)initData{
 
    self.minImagesCount = 0;
    
    self.allowPickingOriginalPhoto = YES;
    
    self.allowPickingVideo = YES;
    self.allowPickingImage = YES;
//    self.allowTakePicture = YES;
    
    
    self.photoWidth = 828.0;
    self.photoPreviewMaxWidth = 600;
    [self configDefaultImageName];
}

- (void)configDefaultImageName {
    self.takePictureImageName = @"takePicture";
    self.photoSelImageName = @"photo_sel_photoPickerVc";
    self.photoDefImageName = @"photo_def_photoPickerVc";
    self.photoNumberIconImageName = @"photo_number_icon";
    self.photoPreviewOriginDefImageName = @"preview_original_def";
    self.photoOriginDefImageName = @"photo_original_def";
    self.photoOriginSelImageName = @"photo_original_sel";
}


- (nullable UIViewController *)childViewControllerForStatusBarStyle
{
    return self.topViewController;
}

- (nullable UIViewController *)childViewControllerForStatusBarHidden
{
    return self.topViewController;
}


- (void)setBarStyle:(ZXBarStyle)barStyle
{
    _barStyle = barStyle;
    if (barStyle == ZXBarStyleBlack)
    {
        self.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationBar.barStyle = UIBarStyleBlack;
        self.stausBarStyle =UIStatusBarStyleLightContent;
    }else{
        self.navigationBar.barStyle = UIBarStyleDefault;
        self.stausBarStyle =UIStatusBarStyleDefault;
    }
}

#pragma mark - bar外观设置

- (void)setBarTintColor:(UIColor *)barTintColor
{
    _barTintColor = barTintColor;
    self.navigationBar.barTintColor = barTintColor;
}
- (void)setBarTitleColor:(UIColor *)barTitleColor
{
    _barTitleColor = barTitleColor;
    [self configNaviTitleAppearance];
}

- (void)setBarTitleFont:(UIFont *)barTitleFont {
    _barTitleFont = barTitleFont;
    [self configNaviTitleAppearance];
}

- (void)configNaviTitleAppearance {
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    if (self.barTitleColor) {
        textAttrs[NSForegroundColorAttributeName] = self.barTitleColor;
    }
    if (self.barTitleFont) {
        textAttrs[NSFontAttributeName] = self.barTitleFont;
    }
    self.navigationBar.titleTextAttributes = textAttrs;
}

- (void)setBarItemTextFont:(UIFont *)barItemTextFont {
    _barItemTextFont = barItemTextFont;
    [self configBarButtonItemAppearance];
}

- (void)setBarItemTextColor:(UIColor *)barItemTextColor {
    _barItemTextColor = barItemTextColor;
    [self configBarButtonItemAppearance];
}

- (void)configBarButtonItemAppearance {
    UIBarButtonItem *barItem;
    if (@available(iOS 9.0, *))
    {
         barItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[ZXImagePickerController class]]];
    }else{
//        barItem = [UIBarButtonItem appearanceWhenContainedIn:[ZXImagePickerController class], nil];
    }
//    if ([UIBarButtonItem respondsToSelector:@selector(appearanceWhenContainedInInstancesOfClasses:)]) {
//        barItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[ZXImagePickerController class]]];
//    } else {
//        barItem = [UIBarButtonItem appearanceWhenContainedIn:[ZXImagePickerController class], nil];
//    }
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = self.barItemTextColor;
    textAttrs[NSFontAttributeName] = self.barItemTextFont;
    [barItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
}


- (UILabel *)tipLabel
{
    if (!_tipLabel)
    {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.numberOfLines = 0;
        _tipLabel.font = [UIFont systemFontOfSize:16];
        _tipLabel.textColor = [UIColor blackColor];
        NSDictionary *infoDict = [NSBundle mainBundle].localizedInfoDictionary;
        if (!infoDict) {
            infoDict = [NSBundle mainBundle].infoDictionary;
        }
        NSString *appName = [infoDict valueForKey:@"CFBundleDisplayName"];
        if (!appName) appName = [infoDict valueForKey:@"CFBundleName"];
        NSString *title =[NSString stringWithFormat:@"请在iPhone的\"设置-隐私-照片\"选项中，\r允许%@访问你的手机照片",appName];
        _tipLabel.text = title;
    }
    return _tipLabel;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *))
    {
        UIEdgeInsets areaInset = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
        if(!UIEdgeInsetsEqualToEdgeInsets(areaInset, UIEdgeInsetsZero)){
            safeAreaInsets = areaInset;
        }else{
        }
    }
    self.tipLabel.frame = CGRectMake(8, 120+safeAreaInsets.top, [UIScreen mainScreen].bounds.size.width - 16, 60);
}

#pragma mark - 取消

- (void)cancelButtonClick
{
    [self dismissViewControllerAnimated:YES completion:^{
        
        if ([self.pickerDelegate respondsToSelector:@selector(zx_imagePickerControllerDidCancel:)])
        {
            [self.pickerDelegate zx_imagePickerControllerDidCancel:self];
        }
        
        
    }];
}


- (void)setPickerDelegate:(id<ZXImagePickerControllerDelegate>)pickerDelegate
{
    _pickerDelegate = pickerDelegate;
    ZXAlbumPickerController *albumPickerVc = [self.childViewControllers firstObject];
    albumPickerVc.pickerDelegate = pickerDelegate;
}


- (void)pushPhotoPickerVc {
    // 1.6.8 判断是否需要push到照片选择页，如果_pushPhotoPickerVc为NO,则不push
    if (self.pushPhotoPickerViewController) {
        ZXPhotoPickerController *photoPickerVc = [[ZXPhotoPickerController alloc] init];
//        photoPickerVc.isFirstAppear = YES;
//        photoPickerVc.columnNumber = self.columnNumber;
//        [[TZImageManager manager] getCameraRollAlbum:self.allowPickingVideo allowPickingImage:self.allowPickingImage completion:^(TZAlbumModel *model) {
//            photoPickerVc.model = model;
//            [self pushViewController:photoPickerVc animated:YES];
//            _didPushPhotoPickerVc = YES;
//        }];
        [self pushViewController:photoPickerVc animated:YES];
    }
    
//    TZAlbumPickerController *albumPickerVc = (TZAlbumPickerController *)self.visibleViewController;
//    if ([albumPickerVc isKindOfClass:[TZAlbumPickerController class]]) {
//        [albumPickerVc configTableView];
//    }
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
