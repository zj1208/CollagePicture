//
//  ZXPhotoBrowser.m
//  YiShangbao
//
//  Created by simon on 2018/8/15.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "ZXPhotoBrowser.h"

#import "ZXWXBigImageTransitionDelegate.h"
#import "ZXOverlay.h"
#import "SDWebImageManager.h"

@interface ZXPhotoBrowser ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ZXOverlayDelegate>

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) ZXWXBigImageTransitionDelegate * wxBigImageTransitionDelegate;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) BOOL showActivityIndicator;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) ZXOverlay *coverView;

////转场过渡的图片
//- (void)setTransitionImage:(UIImage *)transitionImage;
////转场前的图片frame
//- (void)setTransitionBeforeImageFrame:(CGRect)frame;
////转场后的图片frame
//- (void)setTransitionAfterImageFrame:(CGRect)frame;

@end

@implementation ZXPhotoBrowser

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    [self commonInit];
    
}

- (void)commonInit
{
    [self zx_setShowActivityIndicatorView:YES];

    [self.view addSubview:self.imageView];
    [self placeholderImage];
    
    [self.imageView addGestureRecognizer:self.tapGesture];
    
    self.currentImageIndex = 0;
    self.imageCount = 0;
    
    [self setData];
}

- (void)setData
{
    if ([self highQualityImageURLForIndex:0])
    {
        self.imageView.image = [self placeholderImageForIndex:0];
        
        NSURL *imageURL = [self highQualityImageURLForIndex:0];
        if ([self zx_showActivityIndicatorView])
        {
            [self zx_addActivityIndicator];
        }
        WS(weakSelf);
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager loadImageWithURL:imageURL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            
            [weakSelf zx_removeActivityIndicator];
            if (!error)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.imageView.image = image;
                });
            }
        }];
    }
    else
    {
        self.imageView.image = [self placeholderImageForIndex:0];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
}


#pragma mark - getter

- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture)
    {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerAction:)];
        _tapGesture = tap;
    }
    return _tapGesture;
}


- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, LCDW, LCDH)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

- (UIImage *)placeholderImage
{
    if (!_placeholderImage) {
        _placeholderImage = [UIImage zh_imageWithColor:[UIColor grayColor] andSize:CGSizeMake(100, 100)];
    }
    return _placeholderImage;
}

- (ZXWXBigImageTransitionDelegate *)wxBigImageTransitionDelegate
{
    if (!_wxBigImageTransitionDelegate) {
        _wxBigImageTransitionDelegate = [[ZXWXBigImageTransitionDelegate alloc] init];
    }
    return _wxBigImageTransitionDelegate;
}

#pragma mark - UICollectionView

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//        flowLayout.sectionInset = self.sectionInset;
//        self.collectionFlowLayout = flowLayout;
        
        UICollectionView *collection = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
        collection.backgroundColor = [UIColor clearColor];
        collection.delegate = self;
        collection.dataSource = self;
        collection.pagingEnabled = YES;
//        [collection registerNib:[UINib nibWithNibName:NSStringFromClass([ZXBadgeCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:reuseTagsCell];
        collection.showsHorizontalScrollIndicator = NO;
        
        _collectionView = collection;
    }
    return _collectionView;
}


#pragma mark -点击事件
- (void)tapGestureRecognizerAction:(id)sender
{
    [self dismiss];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (instancetype)photoBrowserWithCurrentImageIndex:(NSInteger)currentImageIndex imageCount:(NSUInteger)imageCount dataSource:(id<ZXPhotoBrowserDataSource>)dataSource
{
    ZXPhotoBrowser *browser = [[ZXPhotoBrowser alloc] init];
    browser.imageCount = imageCount;
    browser.currentImageIndex = currentImageIndex;
    browser.dataSource = dataSource;
    return browser;
}

+ (void)showPhotoBrowserWithCurrentImageIndex:(NSInteger)currentImageIndex imageCount:(NSUInteger)imageCount dataSource:(id<ZXPhotoBrowserDataSource>)dataSource transitionImage:(UIImage *)sourceImage transitionBeforeImgFrame:(CGRect)beforeImgFrame userInfo:(id)userInfo;
{
    ZXPhotoBrowser *browser = [ZXPhotoBrowser photoBrowserWithCurrentImageIndex:currentImageIndex imageCount:imageCount dataSource:dataSource];
    [browser transitionWithTransitionImage:sourceImage beforeImageFrameInWindow:beforeImgFrame];
    browser.userInfo = userInfo;
    [browser show];
//    return browser;
}


/**
 *  获取指定位置的高清大图URL,和外界的数据源交互
 */
- (NSURL *)highQualityImageURLForIndex:(NSInteger)index
{
    if ([self.dataSource respondsToSelector:@selector(zx_photoBrowser:highQualityImageURLForIndex:)]) {
        NSURL *url = [self.dataSource zx_photoBrowser:self highQualityImageURLForIndex:index];
        if (!url) {
            return nil;
        }
        if ([url isKindOfClass:[NSString class]]) {
            url = [NSURL URLWithString:(NSString *)url];
        }
        if (![url isKindOfClass:[NSURL class]]) {
            
            NSAssert([url isKindOfClass:[NSURL class]], @"高清大图URL数据有问题,不是NSString也不是NSURL");

        }
        return url;
    }
//    else if(self.images.count>index)
//    {
//        if ([self.images[index] isKindOfClass:[NSURL class]]) {
//            return self.images[index];
//        } else if ([self.images[index] isKindOfClass:[NSString class]]) {
//            NSURL *url = [NSURL URLWithString:self.images[index]];
//            return url;
//        } else {
//            return nil;
//        }
//    }
    return nil;
}
/**
 *  获取指定位置的占位图片,和外界的数据源交互
 */
- (UIImage *)placeholderImageForIndex:(NSInteger)index
{
    if ([self.dataSource respondsToSelector:@selector(zx_photoBrowser:placeholderSourceImageForIndex:)])
    {
        return [self.dataSource zx_photoBrowser:self placeholderSourceImageForIndex:index];
    }
    //    else if(self.images.count>index) {
    //        if ([self.images[index] isKindOfClass:[UIImage class]]) {
    //            return self.images[index];
    //        } else {
    //            return self.placeholderImage;
    //        }
    //    }
    return self.placeholderImage;
}

//返回imageView在window上全屏显示时的frame；新的image宽度和高度根据图片比例缩放计算所得，最大为屏幕高度；
- (CGRect)zx_getImageViewRectWithScaleAspectFitImage:(UIImage *)image
{
    CGSize imageSize = image.size;
    CGFloat imageWidthHeightRatio = imageSize.width / imageSize.height;

    CGSize newSize;
    CGFloat width = LCDW;
    CGFloat height = width / imageWidthHeightRatio;
    newSize = CGSizeMake(width, height);
    
    CGFloat imageY = (LCDH - newSize.height) * 0.5;
    if (imageY < 0) {
        imageY = 0;
    }
    CGRect rect =  CGRectMake(0, imageY, newSize.width, newSize.height);
    return rect;
}

#pragma mark - 实例方法

- (void)transitionWithTransitionImage:(UIImage *)transitionImage beforeImageFrameInWindow:(CGRect)frame;
{
    [self.wxBigImageTransitionDelegate setTransitionImage:transitionImage];
    [self.wxBigImageTransitionDelegate setTransitionBeforeImgFrame:frame];
    CGRect afterImageFrame = [self zx_getImageViewRectWithScaleAspectFitImage:transitionImage];
    [self.wxBigImageTransitionDelegate setTransitionAfterImgFrame:afterImageFrame];
    self.transitioningDelegate = self.wxBigImageTransitionDelegate;
    self.placeholderImage = transitionImage;
}

//- (void)setTransitionImage:(UIImage *)transitionImage;
//{
//    [self.wxBigImageTransitionDelegate setTransitionImage:transitionImage];
//}
//
//- (void)setTransitionBeforeImageFrame:(CGRect)frame
//{
//    [self.wxBigImageTransitionDelegate setTransitionBeforeImgFrame:frame];
//}
//
//- (void)setTransitionAfterImageFrame:(CGRect)frame
//{
//    [self.wxBigImageTransitionDelegate setTransitionAfterImgFrame:frame];
//}

- (void)show
{
//    if (self.imageCount <= 0) {
//        return;
//    }
//    if (self.currentImageIndex >= self.imageCount) {
//        self.currentImageIndex = self.imageCount - 1;
//    }
//    if (self.currentImageIndex < 0) {
//        self.currentImageIndex = 0;
//    }
    UIWindow *window = [[[UIApplication sharedApplication]delegate]window];
    UIViewController *vc =window.zx_currentViewController;
    [vc presentViewController:self animated:YES completion:nil];
}

- (void)dismiss
{
    [self zx_removeActivityIndicator];
    if (self.presentingViewController)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark- 在window上添加覆盖图+UIActivityIndicatorView

- (void)zx_setShowActivityIndicatorView:(BOOL)show
{
    self.showActivityIndicator = show;
}

- (BOOL)zx_showActivityIndicatorView
{
    return self.showActivityIndicator;
}

- (void)zx_addActivityIndicator
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];

        self.coverView.frame = window.frame;
        [window addSubview:self.coverView];


        
        [window addSubview:self.activityIndicator];
        NSLayoutConstraint *constaint1 = [NSLayoutConstraint constraintWithItem:self.activityIndicator
                                     attribute:NSLayoutAttributeCenterX
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:window
                                     attribute:NSLayoutAttributeCenterX
                                    multiplier:1.0
                                      constant:0.0];
        constaint1.active = YES;

        NSLayoutConstraint *constaint2 =[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                     attribute:NSLayoutAttributeCenterY
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:window
                                     attribute:NSLayoutAttributeCenterY
                                    multiplier:1.0
                                                                      constant:0.0];
        constaint2.active = YES;
        [self.activityIndicator startAnimating];

    });
}

- (void)zx_removeActivityIndicator {

    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.activityIndicator) {
            
            [UIView animateWithDuration:0.1 animations:^{

                self.coverView.alpha = 0;
                self.activityIndicator.alpha = 0;

            } completion:^(BOOL finished) {

                [self.coverView removeFromSuperview];
                [self.activityIndicator removeFromSuperview];
                self.activityIndicator = nil;
            }];
        }
    });
}

- (UIView *)coverView
{
    if (!_coverView)
    {
        ZXOverlay *overlay = [[ZXOverlay alloc] init];
        overlay.delegate = self;
        _coverView = overlay;
//        _coverView = [[UIView alloc] init];
//        _coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
//        _coverView.backgroundColor = [UIColor orangeColor];

    }
    return _coverView;
}
#pragma mark -zxOverlayDelegate

- (void)zxOverlaydissmissAction
{
    [self dismiss];
}
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [super touchesBegan:touches withEvent:event];
//    UITouch *touch = [touches anyObject];
//    if ([touch.view isEqual:self.coverView])
//    {
//        [self dismiss];
//        CGPoint touchPoint = [touch locationInView:self.coverView];
//        self.view，因为self.coverView是添加在self.view上的，下一级事件传递就是往上；
//        UIView *subview = [self.coverView hitTest:touchPoint withEvent:nil];
//    }
//}
@end
