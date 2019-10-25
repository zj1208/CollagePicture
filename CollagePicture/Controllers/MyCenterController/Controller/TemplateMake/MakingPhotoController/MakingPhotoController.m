//
//  MakingPhotoController.m
//  Baby
//
//  Created by simon on 16/2/24.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "MakingPhotoController.h"
#import "ImageEditView.h"
#import "ZXImagePickerVCManager.h"
//#import "EditorCompleteView.h"

//#import "PayOderViewController.h"
//#import "AppAPIHelper.h"
//#import <QiniuSDK.h>
//#import "UIImage+MultiFormat.h"
//#import "MyAlbumController.h"

#import "OrientationNaController.h"
//#import "AlbumDataManager.h"
#import "SDWebImageDownloader.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"
#define LCDScale_LandX(X)   X*(LCDW-10)/(568-10)
#define LCDScale_LandY(X)  X*(LCDH-40)/(320-40)

// iphoneX系列判断是否有safeAreaInsets的值，其他是0;
// iPhoneX :{44, 0, 34, 0}
#ifndef IS_IPHONE_XX
#define IS_IPHONE_XX ({\
int tmp = 0;\
if (@available(iOS 11.0, *)) { \
UIEdgeInsets areaInset = [UIApplication sharedApplication].delegate.window.safeAreaInsets;\
if(!UIEdgeInsetsEqualToEdgeInsets(areaInset, UIEdgeInsetsZero)){\
tmp = 1;\
}else{\
tmp = 0;\
}\
}\
else{\
tmp = 0;\
}\
tmp;\
})
#endif

// 注意：在旋转的视图中，view需要用magin跟屏幕做约束，这样才能自动以安全区域为准；

// 1.添加主图层和编剧区域数组视图到self.view上；
//（1）.先添加主图层，（2）.再 根据模版索引获取plist文件中设置的编辑区域坐标布局数组，根据坐标布局数组 初始化对应数量的编剧view数组，添加到self.view上；

// 2.设置图层的横屏frame，加载模版数据image，设置图层的content内容显示；
//在旋转后，再设置图层的横屏frame；再在异步全局队列中 加载 指定索引的 图片模版数据，转为image；然后再在主队列中把模版image设置为图层的content内容；

// 3.设置编剧区域数组的每个视图的约束到指定位置上；



@interface MakingPhotoController ()<ImageEditViewPickerDelegate,ZXImagePickerVCManagerDelegate>

/**
 *  多选照片管理器
 */
@property(nonatomic,strong) ZXImagePickerVCManager *imagePickerVCManager;
/**
 *  imageEditView的group的数组；
 */
//@property(nonatomic,copy) NSArray *numGroupArray;
//@property(nonatomic,strong) NSMutableArray *assetsArray;

//@property(nonatomic,strong) NSMutableArray *againMArray;

@property(nonatomic, strong) CALayer *maskLayer;


/**
 *  编辑区域的view，管理内部button，scrollView，imageView等子视图
 */
@property(nonatomic,strong)ImageEditView *tempEditingView;
/**
 *  编辑区域视图数组
 */
@property(nonatomic,strong)NSMutableArray *imageEditViewMArray;
/**
 *  顶部显示数量btn
 */
@property(nonatomic,strong)UIButton *numBtn;
/**
 *  总页数，目前设置为12， 这个参数以后会动态使用
 */
@property(nonatomic,strong)NSNumber *pageCount;
/**
 *  当前页面索引
 */
//@property(nonatomic)NSInteger currentPage;

@property (nonatomic,strong)UIImage *shareImage;
/**
 *  编辑完的照片数组,包括网络加载的image＋本地自己编辑的image
 */
//@property(nonatomic,strong)NSMutableArray *resultImgsMArray;


@end

@implementation MakingPhotoController
@synthesize uploadingIndexPath= _uploadingIndexPath;


#pragma mark - 
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage alloc] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage =[UIImage new];
    OrientationNaController *nav = (OrientationNaController *)self.navigationController;
    [nav rotateToDirection:UIInterfaceOrientationLandscapeRight];
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    OrientationNaController *nav = (OrientationNaController *)self.navigationController;
    [nav rotateToDirection:UIInterfaceOrientationPortrait];
}
//没有执行
- (CGSize)sizeForChildContentContainer:(id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize
{
    NSLog(@"parentSize=%@",NSStringFromCGSize(parentSize));
    return CGSizeMake(300, 100);
}

//#pragma mark-UINavigationControllerDelegate 不会调用
//- (UIInterfaceOrientationMask)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController
//{
//    return UIInterfaceOrientationMaskLandscapeRight;
//}
//- (UIInterfaceOrientation)navigationControllerPreferredInterfaceOrientationForPresentation:(UINavigationController *)navigationController
//{
//    NSLog(@"%@",NSStringFromClass([navigationController class]));
//    return UIInterfaceOrientationLandscapeRight;
//}

//2.设置图层的横屏frame，加载模版数据image，设置图层的content内容显示；
//3.设置编剧区域数组的每个视图的约束到指定位置上；
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
     [super viewWillTransitionToSize:size withTransitionCoordinator: coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
        NSLog(@"%@",[NSThread currentThread]);//<NSThread: 0x60000006eb40>{number = 1, name = main}
        //竖屏： iPhoneX :{44, 0, 34, 0}
        //横屏: {0, 44, 21, 44}
        //这里肯定是横屏的
        if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
        {
            UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;
            if (@available(iOS 11.0, *))
            {
                UIEdgeInsets areaInset = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
                if(!UIEdgeInsetsEqualToEdgeInsets(areaInset, UIEdgeInsetsZero)){
                    safeAreaInsets = areaInset;
                }else{
                }
            }
            self.maskLayer.frame = CGRectMake(5+safeAreaInsets.left, 0, size.width-2*5-safeAreaInsets.left-safeAreaInsets.right, size.height-40-safeAreaInsets.bottom);
//            加载模版数据image，设置图层的content内容显示
//            3.设置编剧区域数组的每个视图的约束到指定位置上；
            [self loadTemplateDataWithIndex:self.templateType];
            
            [UIView animateWithDuration:1.f animations:^{
                
                self.view.backgroundColor = [UIColor blackColor];
                
            }];

        }
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
        //旋转完成的时候回调；
        [self.numBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (@available(iOS 11.0, *)) {
                make.top.equalTo(self.view.mas_top).with.offset(5 + [UIApplication sharedApplication].delegate.window.safeAreaInsets.top);
            } else {
                make.top.equalTo(self.view.mas_top).with.offset(5);
            }
            make.centerX.equalTo(self.view.mas_centerX);
            make.width.mas_greaterThanOrEqualTo(60);
            make.height.mas_greaterThanOrEqualTo(26);
        }];
        
    }];
}




- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

#pragma  mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化数据
    [self initData];
    [self setUI];
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
    //初始化添加子试图
    [self resetViewByStyleIndex:[self.templateType integerValue]];
    
    //异步执行初始化相机
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        
        @autoreleasepool {
            [self addMorePickerController];
        }
    });
  
}


//初始化数据
- (void)initData
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.imageEditViewMArray = [NSMutableArray array];
//    self.navigationController.delegate = self;
    //   self.numGroupArray =@[@3,@2,@2,@2,@3,@2,@1,@2,@2,@2,@3,@3];
    //   self.assetsArray = [NSMutableArray array];
    
    self.pageCount = @(1);
    //   self.resultImgsMArray = [NSMutableArray array];
  
}

- (void)setUI
{
    [self.previousPageBtn zx_setBorderWithCornerRadius:5.0f borderWidth:1.0f borderColor:[UIColor grayColor]];
    [self.nextPageBtn zx_setBorderWithCornerRadius:5.0f borderWidth:1.0f borderColor:[UIColor grayColor]];
    [self.againMakingBtn zx_setBorderWithCornerRadius:5.0f borderWidth:1.0f borderColor:[UIColor grayColor]];
    
    //设置左边返回按钮
    [self addLeftBarButtonItem];
    
    //添加主视图
    [self.view.layer addSublayer:self.maskLayer];

    //添加数量按钮;一定要旋转之后设置约束，因为安全区域，哪个为top还没有确定；
    [self.view addSubview:self.numBtn];
}

//设置左边返回按钮
- (void)addLeftBarButtonItem
{
    UIImage *image = [[UIImage imageNamed:@"back"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image landscapeImagePhone:image style:UIBarButtonItemStyleDone target:self action:@selector(customBackAction:)];
}


- (CALayer *)maskLayer
{
    if (!_maskLayer) {
        
        CALayer *maskLayer = [[CALayer alloc] init];
        maskLayer.contentsGravity = kCAGravityResize;
        _maskLayer = maskLayer;
    }
    return _maskLayer;
}

- (UIButton *)numBtn
{
    if (!_numBtn)
    {
        UIButton  *numBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        numBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//        [numBtn setBackgroundImage:[UIImage imageNamed:@"s_titleBg"] forState:UIControlStateNormal];
        numBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        [numBtn setTitle:[NSString stringWithFormat:@"1/%@",self.pageCount] forState:UIControlStateNormal];
        _numBtn = numBtn;
    }
    return _numBtn;
}

#pragma mark - MorePickerController
- (void)addMorePickerController
{
    ZXImagePickerVCManager *manager = [[ZXImagePickerVCManager alloc] init];
    self.imagePickerVCManager = manager;
    self.imagePickerVCManager.morePickerActionDelegate = self;
    self.imagePickerVCManager.displayCutBtn = YES;
    self.imagePickerVCManager.maxNumberOfSelection =12;
    self.imagePickerVCManager.minNumberOfSelection =1;
}

#pragma mark - 加载模版图片数据
/**
 *  加载模版图片数据
 */
- (void)loadTemplateDataWithIndex:(NSNumber *)type
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        @autoreleasepool {
            
            NSString *templateName = [NSString stringWithFormat:@"album_a%@@2x",type];
            UIImage *image = [[UIImage alloc]initWithContentsOfFile:ZX_ContentFile(templateName, @"png")];
            NSLog(@"%@",NSStringFromCGSize(self.maskLayer.frame.size));
            image = [UIImage zx_scaleImage:image toSize:CGSizeMake(self.maskLayer.frame.size.width*1.5, self.maskLayer.frame.size.height*1.5)];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.maskLayer.contents = (__bridge id _Nullable)(image.CGImage);
                [self makeSubviewConstraint:[self.templateType integerValue]];
                
            });
        }
    });
}

#pragma mark - 返回

- (void)customBackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
//    [self zPostNotification];
    
    [[SDWebImageManager sharedManager] cancelAll];
}




/*
- (void)zSetMaskLayerContentsAndEditView
{
    NSLog(@"self.resultImgsMArray=%@",self.resultImgsMArray);
    dispatch_main_async_safe((^{
        
        SavePhotoModel *model = [self.resultImgsMArray firstObject];
        if ([model.sort integerValue]==1)
        {
            NSString *key = [AlbumDataManager getPhotoImageKey:self.albumId sortId:model.sort];
            UIImage *image = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:key];

            self.maskLayer.contents = (__bridge id _Nullable)(image.CGImage);
        }
        else
        {
            UIImage *image = [[UIImage alloc]initWithContentsOfFile:ZX_ContentFile(@"album_a1@2x", @"png")];
            image = [UIImage zhuScaleToSize:image size:self.maskLayer.frame.size];
            self.maskLayer.contents = (__bridge id _Nullable)(image.CGImage);
            
            [self resetViewByStyleIndex:1];

        }
        
    }));
}
//  比对网络数据和本地数据
 
- (void)comparisionNetDataWithLocalData
{
    AlbumDataManager *manager = [AlbumDataManager getInstance];
    //如果本地有数据
    if ([manager getData:self.albumId])
    {
        NSLog(@"[manager getData:self.albumId]=%@",[manager getData:self.albumId]);

        NSArray *localArray = [manager getData:self.albumId];
        [localArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            __block BOOL containModel;

            //本地的
             SavePhotoModel *model1 = (SavePhotoModel *)obj;
            
            [_resultImgsMArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                //网络的
                SavePhotoModel *model2 = (SavePhotoModel *)obj;
                //如果网络数据 和本地数据 是同一个sort，就比对,没有上传的就加入到显示的地方；
                if ([model1.sort integerValue] ==[model2.sort integerValue])
                {
                    containModel = YES;
                    if (!model1.uploadState)
                    {
                        
                        [_resultImgsMArray replaceObjectAtIndex:idx withObject:[self zxMakeDisplayModel:model1 imgId:model2.imgId]];
                    }
                }
            }];

            //如果网络不包含这个本地数据
            if (!containModel)
            {
                [_resultImgsMArray addObject:[self zxMakeDisplayModel:model1 imgId:model1.imgId]];
                
                if (idx ==localArray.count-1)
                {
                    [self sortDataArray];
                    NSLog(@"如果网络不包含这个本地数据：_resultImgsMArray3=%@",_resultImgsMArray);
                }
            }

        }];
        
        [self zSetMaskLayerContentsAndEditView];
        
    }
     //如果本地没有数据
    else
    {
        [self zSetMaskLayerContentsAndEditView];
    }
    
    NSLog(@"待更新网络上已经上传过的和本地没有上传过的：self.resultImgsMArray2=%@",_resultImgsMArray);

}

*/


//- (void)saveImage:(UIButton *)sender
//{
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    PayOderViewController * payVC = [[PayOderViewController alloc] init];
//    payVC.albumIdStr = [self.albumId stringValue];
//    OrientationNaController *nav = [[OrientationNaController alloc] initWithRootViewController:payVC];
//    [self presentViewController:nav animated:YES completion:nil];
//}



#pragma mark - 根据索引获取plist文件中设置的坐标数组；
/**
 *  根据索引获取plist文件中设置的坐标数组；
 *
 *  @param NSArray NSArray description
 *
 *  @return return value description
 */

- (NSArray *)getSubViewArrayFromBundleResourceWithIndex:(NSInteger)styleIndex
{
    NSString *styleName =[[NSString alloc] initWithFormat:@"albumA_style_%@.plist",@(styleIndex)];
    NSString *path =  [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:styleName];
    NSDictionary *styleDict = [NSDictionary dictionaryWithContentsOfFile:path];
    if (styleDict)
    {
        NSArray *subViewArray = [styleDict objectForKey:@"SubViewArray"];
        return subViewArray;
    }
    return nil;
}

/**
 *  在ViewDidLoad中 先根据模版索引获取plist文件中设置的编辑区域坐标布局数组，同时初始化对应数量的编剧view数组；添加到self.view上
 *
 */
- (void)resetViewByStyleIndex:(NSInteger)styleIndex
{
    if (self.imageEditViewMArray.count>0)
    {
        [self.imageEditViewMArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.imageEditViewMArray removeAllObjects];
    }
    NSArray *subViewArray = [self getSubViewArrayFromBundleResourceWithIndex:styleIndex];
    if (subViewArray.count==0)
    {
        return;
    }
    [subViewArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
//        NSDictionary *subDic = (NSDictionary *)obj;
//        NSArray *layoutArray = [subDic objectForKey:@"layoutArray"];
        
        ImageEditView *editView =[[ImageEditView alloc] init];
        editView.delegate = self;
        [self.view addSubview:editView];
        [self.view sendSubviewToBack:editView];
        
        
        [self.imageEditViewMArray addObject:editView];
        
//        if (layoutArray.count<4)
//        {
//            NSLog(@"缺少点");
//        }
    }];
    NSLog(@"resetViewByStyle=%@",self.imageEditViewMArray);

}

#pragma mark -设置self.imageEditViewMArray编剧区域数组的每个视图的约束到指定位置上

- (void)makeSubviewConstraint:(NSInteger)styleIndex
{
//    根据索引获取plist文件中设置的坐标数组；
    NSArray *subViewArray = [self getSubViewArrayFromBundleResourceWithIndex:styleIndex];

    [self.imageEditViewMArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        ImageEditView *editView =(ImageEditView *)obj;
        NSArray *layoutArray = [[subViewArray objectAtIndex:idx] objectForKey:@"layoutArray"];
       
        [editView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            CGFloat mas_Top;
            CGFloat mas_Left;
            CGFloat mas_Bottom;
            CGFloat mas_Right;
            UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;
            if (@available(iOS 11.0, *)) {
                
                UIEdgeInsets areaInset = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
                if(!UIEdgeInsetsEqualToEdgeInsets(areaInset, UIEdgeInsetsZero)){
                    safeAreaInsets = areaInset;
                }else{
                }
                CGFloat safeAreaWidth = LCDW-safeAreaInsets.left-safeAreaInsets.right;
                CGFloat safeAreaHeight = LCDH-safeAreaInsets.top-safeAreaInsets.bottom;

                mas_Left = ([[layoutArray objectAtIndex:1] integerValue]*(safeAreaWidth-10)/(568-10)) + 5 + safeAreaInsets.left;
                mas_Top = ([[layoutArray objectAtIndex:0] integerValue]*(safeAreaHeight-40)/(320-40))+ safeAreaInsets.top;
                mas_Bottom = ([[layoutArray objectAtIndex:2] integerValue]*(safeAreaHeight-40)/(320-40)) + safeAreaInsets.bottom + 40;
                
                mas_Right = ([[layoutArray objectAtIndex:3] integerValue]*(safeAreaWidth-10)/(568-10)) + 5 + safeAreaInsets.right;
                
            } else {
                mas_Top = LCDScale_LandY([[layoutArray objectAtIndex:0] integerValue]);
                mas_Left = LCDScale_LandX([[layoutArray objectAtIndex:1] integerValue])+5;
                mas_Bottom = LCDScale_LandY([[layoutArray objectAtIndex:2] integerValue])+40;
                mas_Right = LCDScale_LandX([[layoutArray objectAtIndex:3] integerValue])+5;
            }
            UIEdgeInsets inset = UIEdgeInsetsMake(mas_Top,mas_Left, mas_Bottom,mas_Right);
            make.edges.mas_equalTo(self.view).with.insets(inset);
        }];
 
    }];
  
}

- (void)updateNOLandscapeSubviewConstraint:(NSInteger)styleIndex
{
    NSArray *subViewArray = [self getSubViewArrayFromBundleResourceWithIndex:styleIndex];
    
    [self.imageEditViewMArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        ImageEditView *editView =(ImageEditView *)obj;
        NSArray *layoutArray = [[subViewArray objectAtIndex:idx] objectForKey:@"layoutArray"];
        
        [editView mas_updateConstraints:^(MASConstraintMaker *make) {
            
//            CGFloat landTop = LCDScale_LandY([[layoutArray objectAtIndex:0] integerValue]);
//            CGFloat landLeft = LCDScale_LandX([[layoutArray objectAtIndex:1] integerValue])+5;
//            CGFloat landBottom = LCDScale_LandY([[layoutArray objectAtIndex:2] integerValue])+40;
//            CGFloat landRight = LCDScale_LandX([[layoutArray objectAtIndex:3] integerValue])+5;
            UIEdgeInsets inset = UIEdgeInsetsMake(0,0, 0,0);
            //            make.edges.mas_equalTo(inset);
            make.edges.mas_equalTo(self.view).with.insets(inset);
        }];
        
    }];
    
}

#pragma mark -合成图片 及保存 上传；
/**
 *  保存图片－合成后再保存，以及上传图片；
 */
- (void)makeGraphicsImagesContext
{
    if (self.imageEditViewMArray.count==0)
    {
        return;
    }
    dispatch_main_async_safe((^{
        [MBProgressHUD zx_showLoadingWithStatus:NSLocalizedString(@"正在保存...", nil) toView:self.view];
    }));
    
    NSMutableArray *subImageMArray = [NSMutableArray arrayWithCapacity:self.imageEditViewMArray.count];
    [self.imageEditViewMArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ImageEditView *imageEditView = (ImageEditView *)obj;
        CGPoint point = imageEditView.scrollView.contentOffset;

        CGRect rect = CGRectMake(point.x/imageEditView.scrollView.zoomScale, point.y/imageEditView.scrollView.zoomScale, imageEditView.scrollView.frame.size.width/imageEditView.scrollView.zoomScale, imageEditView.scrollView.frame.size.height/imageEditView.scrollView.zoomScale);
        
        
        if (imageEditView.imageView.image)
        {
            CGImageRef imageRef = imageEditView.imageView.image.CGImage;
            CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, rect);
            UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
            CGImageRelease(subImageRef);
            
            UIGraphicsBeginImageContextWithOptions(rect.size, NO, 1);
            [smallImage drawInRect:CGRectMake(0, 0, rect.size.width, rect.size.height) blendMode:kCGBlendModeNormal alpha:1];
            UIImage *editImg = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            [subImageMArray addObject:editImg];
        }
    }];
    
    NSString *path = [[NSString alloc] initWithFormat:@"album_a%@@2x",self.templateType];
    UIImage *bigImage = [[UIImage alloc]initWithContentsOfFile:ZX_ContentFile(path, @"png")];
    
    UIImage *saveImg = [self addImageArray:subImageMArray toImage:bigImage];
    self.shareImage = [UIImage zx_scaleImage:saveImg toSize:self.maskLayer.frame.size];

  
//    [self addOriginalImageModelWith:saveImg displayImage:displayImg];
    [MBProgressHUD zx_showSuccess:NSLocalizedString(@"保存成功", nil) toView:self.view];
    
    UIImageWriteToSavedPhotosAlbum(saveImg, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    [self performSegueWithIdentifier:segue_ShareController sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *vc = segue.destinationViewController;
    if ([segue.identifier isEqualToString:segue_ShareController])
    {
        if ([vc respondsToSelector:@selector(setShareImage:)])
        {
            [vc setValue:self.shareImage forKey:@"shareImage"];
        }
    }
}
/*
- (void)addOriginalImageModelWith:(UIImage *)image1  displayImage:(UIImage *)image2
{
    NSString *key = [AlbumDataManager getPhotoImageKey:self.albumId sortId:@(self.currentPage)];
    
    
    SavePhotoModel *model = [[SavePhotoModel alloc] init];
    model.sort = @(self.currentPage);
    model.imagePath = key;
    model.albumId = self.albumId;
    model.uploadState = NO;

    
    AlbumDataManager *manager = [AlbumDataManager getInstance];
    
    SDImageCache *cache = [SDImageCache sharedImageCache];

  //  判断是否是重新编辑
 
    __block BOOL again = NO;
    if (self.resultImgsMArray.count>0)
    {
        [self.resultImgsMArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            SavePhotoModel *mod = (SavePhotoModel *)obj;
            if ([mod.sort integerValue] ==self.currentPage)
            {
                again = YES;
            }
        }];
    }

    if (!again)
    {
        
        model.imgId = nil;
        [self.resultImgsMArray addObject:model];
        
        cache.shouldCacheImagesInMemory=NO;
        [cache storeImage:image1 forKey:key];
        cache.shouldCacheImagesInMemory=YES;
        [manager insertDataInAlbumWithImage:model withAlbumId:self.albumId];
    }
 
    //如果是重新编辑
 
    else
    {
        [self.resultImgsMArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

            SavePhotoModel *mod = (SavePhotoModel *)obj;
            if ([mod.sort integerValue]==self.currentPage)
            {
                model.imgId =mod.imgId;
                [self.resultImgsMArray replaceObjectAtIndex:idx withObject:model];
                [cache removeImageForKey:key withCompletion:^{
                    
                    cache.shouldCacheImagesInMemory=NO;
                    [cache storeImage:image1 forKey:key];
                    cache.shouldCacheImagesInMemory=YES;

                    [manager insertDataInAlbumWithImage:model withAlbumId:self.albumId];
                }];
            }
        }];
    }
    
}
*/
/**
 *  合成图片：把一系列图片 覆盖合成在image2上，合成为一张图片；
 *
 *  @param imageArray imageArray description
 *  @param image2     image2 description
 *
 *  @return return value description
 */
- (UIImage *)addImageArray:(NSMutableArray*)imageArray toImage:(UIImage *)image2
{
    if (!image2)
    {
        return nil ;
    }
    UIGraphicsBeginImageContextWithOptions(image2.size, YES, 2);
    CGFloat imageWidthScale = image2.size.width/CGRectGetWidth(self.maskLayer.frame);
    CGFloat imageHeightScale = image2.size.height/CGRectGetHeight(self.maskLayer.frame);
    
    
    [imageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGRect editViewRect = [[self.imageEditViewMArray objectAtIndex:idx]frame];
        // Draw image1
        UIImage *img = (UIImage *)obj;

        CGRect rect = CGRectMake((editViewRect.origin.x-5)*imageWidthScale, editViewRect.origin.y*imageHeightScale, editViewRect.size.width*imageWidthScale, editViewRect.size.height*imageHeightScale);
      
        [img drawInRect:rect];
    }];
   
   // Draw image2
    [image2 drawInRect:CGRectMake(0, 0, image2.size.width, image2.size.height)];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}


#pragma mark - imageEditView的delegate
/**
 *  imageEditView的delegate
 */
- (void)imageEditViewPickerWithButton:(UIButton *)sender editView:(ImageEditView *)imageEditView
{
    self.tempEditingView = imageEditView;
    if (self.againMakingBtn.selected)
    {
        self.imagePickerVCManager.maxNumberOfSelection = self.imageEditViewMArray.count;
    }
    else
    {
       // self.imagePickerVCManager.maxNumberOfSelection = [self getTotalNumImageEditView];
    }
    [self.imagePickerVCManager zxPresentActionSheetToImagePickerWithSourceController:self];
}


#pragma mark - UIImagePickerControllerDelegate
/**
 *  拍照／原生相册 选择后的delegate
 */
- (void)zxImagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info withEditedImage:(UIImage *)image
{
    [self.tempEditingView removePickerBtn];
    [self.tempEditingView setImageViewData:image];
}

//
//- (void)zxImagePickerController:(ImagePickerViewController *)imagePicker didSelectAssets:(NSArray *)assets isOriginal:(BOOL)original
//{
////    NSLog(@"assets=%@",assets);
//    if (self.againMakingBtn.selected)
//    {
//        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, assets.count)];
////        [self.assetsArray insertObjects:assets atIndexes:indexSet];
//    }
//    else
//    {
////        [self.assetsArray addObjectsFromArray:assets];
//    }
////    NSLog(@"self.assetsArray = %@",self.assetsArray);
////    [self automaticSetImageToImageEditView];
//}


/**
 *  自动赋值给imageEditView
 */
/*
- (void)automaticSetImageToImageEditView
{
//    NSLog(@"%@",self.imageEditViewMArray);
    if (self.imageEditViewMArray.count==0)
    {
        return;
    }
    [self.imageEditViewMArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
        
        ImageEditView *editView = (ImageEditView *)obj;
        if (self.assetsArray.count>0 && !editView.isHadImage)
        {
            ALAsset *asset = [self.assetsArray objectAtIndex:0];
            ALAssetRepresentation *representation = [asset defaultRepresentation];
            UIImage *img = [UIImage imageWithCGImage:representation.fullScreenImage];
            [editView removePickerBtn];
            [editView setImageViewData:img];
            [self.assetsArray removeObject:asset];
        }
    }];

}
 */
///**
// *  计算剩余还需要多少张图片填充满整个相册
// *
// *  @return 待填充满的数量
// */
//- (NSInteger)getTotalNumImageEditView
//{
//    __block NSInteger totalGroupEditViewNum =0;
//    [self.resultImgsMArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//       
//         SavePhotoModel *photoModel = (SavePhotoModel *)obj;
//        totalGroupEditViewNum = totalGroupEditViewNum+[[self.numGroupArray objectAtIndex:([photoModel.sort integerValue]-1)] integerValue];
//    }];
//    
//    //当前editView数组中存在的已经有图片的
//    [self.imageEditViewMArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
//        
//        ImageEditView *editView = (ImageEditView *)obj;
//        if (editView.isHadImage)
//        {
//            totalGroupEditViewNum++;
//        }
//    }];
//
//    return (27-totalGroupEditViewNum);
//}
//


#pragma mark - 重新编辑
/**
 *  重新编辑
 */
- (IBAction)againMakingAction:(UIButton *)sender
{
    if (self.maskLayer.contents==nil)
    {
        return;
    }
    if (self.imageEditViewMArray.count>0)
    {
        [self.imageEditViewMArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.imageEditViewMArray removeAllObjects];
    }
    
    [self loadTemplateDataWithIndex:self.templateType];
    
    [self resetViewByStyleIndex:[self.templateType integerValue]];
    [self makeSubviewConstraint:[self.templateType integerValue]];

    sender.selected = YES;
}

#pragma mark - 上一页
/**
 *  上一张
 */
- (IBAction)previousPageAction:(UIButton *)sender {
    
    if (self.maskLayer.contents==nil)
    {
        return;
    }
    /*
    if (self.currentPage!=1)
    {
        self.againMakingBtn.selected = NO;
        self.currentPage--;
        [self.numBtn setTitle:[NSString stringWithFormat:@"%@/%@",@(self.currentPage),self.pageCount] forState:UIControlStateNormal];
        if (self.imageEditViewMArray.count>0)
        {
            [self.imageEditViewMArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.imageEditViewMArray removeAllObjects];
        }
        [self.resultImgsMArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            SavePhotoModel *mod = (SavePhotoModel *)obj;
            
            if ([mod.sort integerValue]==self.currentPage)
            {
                NSString *key = [AlbumDataManager getPhotoImageKey:self.albumId sortId:@(self.currentPage)];
                UIImage *image = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:key];
                self.maskLayer.contents = (__bridge id _Nullable)(image.CGImage);
            }
        }];
    }
    else
    {
        [self zhHUD_showErrorWithStatus:@"没有上一页了"];
    }
     */
}


/*
- (void)nextPage
{
    self.currentPage++;
    if (self.imageEditViewMArray.count>0)
    {
        [self.imageEditViewMArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.imageEditViewMArray removeAllObjects];
    }

    if (self.currentPage<=[self.pageCount integerValue])
    {
        [self.numBtn setTitle:[NSString stringWithFormat:@"%@/%@",@(self.currentPage),self.pageCount] forState:UIControlStateNormal];
        
        __block BOOL hasNextPic=NO;
        [self.resultImgsMArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            SavePhotoModel *mod = (SavePhotoModel *)obj;
            
            if ([mod.sort integerValue]==self.currentPage)//下一张图片
            {
                hasNextPic=YES;
                NSString *key = [AlbumDataManager getPhotoImageKey:self.albumId sortId:@(self.currentPage)];
                UIImage *image = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:key];
                
                self.maskLayer.contents = (__bridge id _Nullable)(image.CGImage);
                *stop = YES;
            }  
        }];
        if (!hasNextPic)
        {
            NSString *path = [NSString stringWithFormat:@"album_a%@@2x",@(self.currentPage)];
            UIImage *image = [[UIImage alloc]initWithContentsOfFile:ZX_ContentFile(path, @"png")];
            image = [UIImage zhuScaleToSize:image size:self.maskLayer.frame.size];
            self.maskLayer.contents = (__bridge id _Nullable)(image.CGImage);
            [self resetViewByStyleIndex:self.currentPage];
            [self automaticSetImageToImageEditView];
        }
    }
    else
    {
        [self popMenuView];
        return;
    }
}
*/

/**
 *  制作完弹出Menu视图
 */
/*
- (void)popMenuView
{
    NSLog(@"制作完成");
    EditorCompleteView *editComplete = [[EditorCompleteView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    editComplete.delegate = self;
    
    [editComplete.buyAlbumBtn setTitle:[NSString stringWithFormat:@"¥%.2f\t\t制作实体相册",[self.price floatValue]] forState:UIControlStateNormal];
    [self.view addSubview:editComplete];
}
*/


#pragma mark - 保存／分享
/**
 *  下一页
 *
 */
- (IBAction)nextPageAction:(UIButton *)sender {
    
  
    if (self.imageEditViewMArray.count>0 && ![self finishedAllEditView])
    {
        [MBProgressHUD zx_showError:NSLocalizedString(@"您还没有编辑完当前相片", nil) toView:self.view];
    }
    else
    {
        [self makeGraphicsImagesContext];
//        self.againMakingBtn.selected = NO;
    }
/*
    if (self.againMakingBtn.selected)
    {
        if (self.imageEditViewMArray.count>0 && ![self finishedAllEditView])
        {
            [self zhHUD_showErrorWithStatus:@"您还没有编辑完当前相片"];
        }
        else
        {
            [self makeGraphicsImagesContext];
            self.againMakingBtn.selected = NO;
        }
        return;
    }

    if (self.currentPage<=[self.pageCount integerValue])
    {
        if (self.currentPage <=self.resultImgsMArray.count)
        {
            if (self.currentPage==self.resultImgsMArray.count)//当前 ＝＝总量
            {
                if (self.currentPage==[self.pageCount integerValue])
                {
                    [self popMenuView];
                    return;
                }
                
                __block BOOL hasCurrentPic=NO;
                __block BOOL hasNextPic = NO;
                [self.resultImgsMArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    SavePhotoModel *mod = (SavePhotoModel *)obj;
                    
                    if ([mod.sort integerValue]==self.currentPage)
                    {
                        hasCurrentPic=YES;
                        *stop = YES;
                    }
                }];
                if (!hasCurrentPic)
                {
                    if (self.imageEditViewMArray.count>0 && ![self finishedAllEditView])
                    {
                        [self zhHUD_showErrorWithStatus:@"您还没有编辑完当前相片"];
                    }
                    else
                    {
                        [self makeGraphicsImagesContext];
                    }
                    return;
                }
                
                [self.resultImgsMArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    SavePhotoModel *mod = (SavePhotoModel *)obj;
                    
                    if ([mod.sort integerValue]==self.currentPage+1)//下一张图片
                    {
                        hasNextPic=YES;
                        NSString *key = [AlbumDataManager getPhotoImageKey:self.albumId sortId:@(self.currentPage+1)];
                        UIImage *image = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:key];
                        self.maskLayer.contents = (__bridge id _Nullable)(image.CGImage);
                        *stop = YES;
                    }
                }];

                if (!hasNextPic)
                {
                    self.currentPage++;
                    NSString *path = [NSString stringWithFormat:@"album_a%@@2x",@(self.currentPage)];
                    UIImage *image = [[UIImage alloc]initWithContentsOfFile:ZX_ContentFile(path, @"png")];
                    image = [UIImage zhuScaleToSize:image size:self.maskLayer.frame.size];
                    self.maskLayer.contents = (__bridge id _Nullable)(image.CGImage);
                    [self resetViewByStyleIndex:self.currentPage];
                }
            }
            //如果当前照片小于总量
            else
            {
                __block BOOL hasCurrentPic=NO;
                __block BOOL hasNextPic = NO;
                [self.resultImgsMArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    SavePhotoModel *mod = (SavePhotoModel *)obj;
                    
                    if ([mod.sort integerValue]==self.currentPage)
                    {
                        hasCurrentPic=YES;
                        *stop = YES;
                    }
                    
                }];
                if (!hasCurrentPic)
                {
                    if (self.imageEditViewMArray.count>0 && ![self finishedAllEditView])
                    {
                        [self zhHUD_showErrorWithStatus:@"您还没有编辑完当前相片"];
                    }
                    else
                    {
                        [self makeGraphicsImagesContext];
                    }
                    return;
                }
                
                
                self.currentPage++;
                [self.resultImgsMArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    SavePhotoModel *mod = (SavePhotoModel *)obj;
                    
                    if ([mod.sort integerValue]==self.currentPage)//下一张图片
                    {
                        hasNextPic=YES;
                        NSString *key = [AlbumDataManager getPhotoImageKey:self.albumId sortId:mod.sort];
                        UIImage *image = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:key];
                        self.maskLayer.contents = (__bridge id _Nullable)(image.CGImage);
                        *stop = YES;
                    }
                    
                }];
                
                if (!hasNextPic)
                {
                    NSString *path = [NSString stringWithFormat:@"album_a%@@2x",@(self.currentPage)];
                    UIImage *image = [[UIImage alloc]initWithContentsOfFile:ZX_ContentFile(path, @"png")];
                    image = [UIImage zhuScaleToSize:image size:self.maskLayer.frame.size];
                    self.maskLayer.contents = (__bridge id _Nullable)(image.CGImage);
                    [self resetViewByStyleIndex:self.currentPage];
                }
            }
            [self.numBtn setTitle:[NSString stringWithFormat:@"%@/%@",@(self.currentPage),self.pageCount] forState:UIControlStateNormal];
        }
        else//if (self.currentPage >self.resultImgsMArray.count) 是制作照片
        {
            if (self.imageEditViewMArray.count>0 && ![self finishedAllEditView])
            {
                [self zhHUD_showErrorWithStatus:@"您还没有编辑完当前相片"];
            }
            else
            {
                [self makeGraphicsImagesContext];
            }
        }
    }
     */
}



- (BOOL)finishedAllEditView
{
    __block bool finished;
    [self.imageEditViewMArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        finished = YES;
        ImageEditView *imageEditView = (ImageEditView *)obj;
        if ([imageEditView.selectBtn isDescendantOfView:imageEditView])
        {
            finished = NO;
            *stop = YES;
        }
    }];
    return finished;
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(id)info
{
    NSLog(@"D＝%@,%@",[NSThread currentThread], [NSThread currentThread].name);
    if(error)
    {
        NSLog(@"savefailed:%@",error.localizedDescription);
    }
    else
    {
        NSLog(@"savesuccess");
    }
    
}


/*
- (void)yzMakePhotoAlbum
{
    //跳转
    PayOderViewController * payVC = [[PayOderViewController alloc] init];
    //id
    payVC.albumIdStr = [self.albumId stringValue];
    [self.navigationController pushViewController:payVC animated:YES];
}


- (void)yzSaveAlbumPhotos
{
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[MyAlbumController class]])
        {
            [self.navigationController popToViewController:obj animated:YES];
            [self zPostNotification];
        }
    }];

}

- (void)zPostNotification
{
    if ([self.albumMakedType integerValue]==AlbumMakedType_Old)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:kNOTIFICATION_UPLOAD_ALBUM object:nil userInfo:@{@"albumId":self.albumId,@"uploadingIndexPath":self.uploadingIndexPath,@"albumMakedType":self.albumMakedType}];
    }
    else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:kNOTIFICATION_UPLOAD_ALBUM object:nil userInfo:@{@"albumId":self.albumId,@"albumMakedType":self.albumMakedType}];
    }
}

*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

