//
//  ZXPHPhotoManager.m
//  FunLive
//
//  Created by simon on 2019/4/24.
//  Copyright © 2019 facebook. All rights reserved.
//

#import "ZXPHPhotoManager.h"

@interface ZXPHPhotoManager ()

@property (nonatomic, assign) CGFloat screenWidth;

@end

@implementation ZXPHPhotoManager

+ (instancetype)shareInstance
{
    static id sharedHelper = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedHelper = [[self alloc] init];
    });
    return sharedHelper;
}

- (CGFloat)screenWidth
{
    return [UIScreen mainScreen].bounds.size.width;
}

// 优化可以改为并发遍历集合数组
- (void)getAlbumCollectionListWithAllowPickingVideo:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickingImage completion:(void (^)(NSArray<ZXAlbumModel *> *))completion
{
    NSMutableArray *albumMArray = [NSMutableArray array];
    
    PHFetchOptions *assetOptions = [[PHFetchOptions alloc]init];
    if (!allowPickingVideo)
    {
         assetOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    }
    if (!allowPickingImage)
    {
        assetOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld",
                            PHAssetMediaTypeVideo];
    }
    assetOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];

    PHFetchResult *topLevelUserCollections = [PHCollection fetchTopLevelUserCollectionsWithOptions:nil];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    
    NSArray *allAlbums = @[smartAlbums,topLevelUserCollections];
    __weak __typeof(self) weakSelf = self;
    [allAlbums enumerateObjectsUsingBlock:^(PHFetchResult *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        [obj enumerateObjectsUsingBlock:^(PHAssetCollection *  _Nonnull collection, NSUInteger idx2, BOOL * _Nonnull stop) {
            
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:assetOptions];
            if ([self.delegate respondsToSelector:@selector(zx_shouldContainAlbumInAlbumCollectionListWithAlbumTitle:fetchResult:)])
            {
                if (![self.delegate zx_shouldContainAlbumInAlbumCollectionListWithAlbumTitle:collection.localizedTitle fetchResult:fetchResult])
                {
                    return ;
                }
            }
            if (fetchResult.count == 0) {
                return;
            }
            if (![weakSelf isAllHiddenSubtype:collection])
            {
                if ([weakSelf isUserLibrarySubtype:collection])
                {
                    ZXAlbumModel *model = [weakSelf modelWithFetchResult:fetchResult title:collection.localizedTitle isCameraRoll:YES];
                    [albumMArray insertObject:model atIndex:0];
                }else{
                   
                    ZXAlbumModel *model = [self modelWithFetchResult:fetchResult title:collection.localizedTitle isCameraRoll:NO];
                    [albumMArray addObject:model];
                }
            }
        }];
    }];
    if (completion && albumMArray.count >0)
    {
        completion(albumMArray);
    }
}






// 是否是“所有照片”,放第一个item；
- (BOOL)isUserLibrarySubtype:(id)metadata
{
    if ([metadata isKindOfClass:[PHAssetCollection class]])
    {
        PHAssetCollection *assetCollection = (PHAssetCollection *)metadata;
        return assetCollection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary;
    }
    return NO;
}

// 是否是“已隐藏”;过滤不显示；
- (BOOL)isAllHiddenSubtype:(PHAssetCollection *)assetCollection
{
    return assetCollection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumAllHidden;
}

#pragma mark - Private Method

- (ZXAlbumModel *)modelWithFetchResult:(id)result title:(NSString *)name isCameraRoll:(BOOL)isCameraRoll {
    ZXAlbumModel *model = [[ZXAlbumModel alloc] init];
    model.result = result;
    model.title = name;
    model.isCameraRoll = isCameraRoll;
    if ([result isKindOfClass:[PHFetchResult class]]) {
        PHFetchResult *fetchResult = (PHFetchResult *)result;
        model.count = fetchResult.count;
    }
    return model;
}


#pragma mark - Get Photo


- (void)getPostImageWithAlbumModel:(ZXAlbumModel *)model completion:(void (^)(UIImage * _Nonnull))completion
{
    PHAsset *asset = [model.result lastObject];
    
    [self requestImageForAsset:asset resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
       
        if (completion) {
            completion(result);
        }
    }];
}

#pragma mark - 根据PHAsset获取图片

- (PHImageRequestID)requestImageForAsset:(PHAsset *)asset resultHandler:(void (^)(UIImage *__nullable result, NSDictionary *__nullable info))resultHandler
{
    return [self requestImageForAsset:asset photoWidth:self.screenWidth progressHandler:nil resultHandler:resultHandler];
}

- (PHImageRequestID)requestImageForAsset:(PHAsset *)asset photoWidth:(CGFloat)photoWidth resultHandler:(void (^)(UIImage *__nullable result, NSDictionary *__nullable info))resultHandler
{
    return [self requestImageForAsset:asset photoWidth:photoWidth progressHandler:nil resultHandler:resultHandler];
}

- (PHImageRequestID)requestImageForAsset:(PHAsset *)asset photoWidth:(CGFloat)photoWidth progressHandler:(nullable PHAssetImageProgressHandler)progressHandler  resultHandler:(void (^)(UIImage *__nullable result, NSDictionary *__nullable info))resultHandler
{
    CGFloat aspectRatio = (CGFloat)asset.pixelWidth/asset.pixelHeight;
    CGFloat pixelWidth = photoWidth;
    CGFloat pixelHeight = pixelWidth / aspectRatio;
    CGSize imageSize = CGSizeMake(pixelWidth, pixelHeight);

    return [self requestImageForAsset:asset targetSize:imageSize contentMode:PHImageContentModeAspectFill progressHandler:progressHandler resultHandler:resultHandler];
}


- (PHImageRequestID)requestImageForAsset:(PHAsset *)asset targetSize:(CGSize)targetSize contentMode:(PHImageContentMode)contentMode  progressHandler:(nullable PHAssetImageProgressHandler)progressHandler  resultHandler:(void (^)(UIImage *__nullable result, NSDictionary *__nullable info))resultHandler
{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    //    option.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    
    PHImageManager *imageManager = [PHImageManager defaultManager];
    PHImageRequestID  imageRequestID = [imageManager requestImageForAsset:asset targetSize:targetSize contentMode:contentMode options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        BOOL isCancelled = [[info objectForKey:PHImageCancelledKey] boolValue];
        BOOL isError = [info objectForKey:PHImageErrorKey];
        BOOL downloadFinished =  (!isCancelled && !isError);
        if (downloadFinished && result)
        {
            if (resultHandler)
            {
                resultHandler(result,info);
            }
        }
        // 本地获取不到，必须从iCloud下载图片;当从iCloud下载时候，有progressHandler进度；
        BOOL isInCloud = [[info objectForKey:PHImageResultIsInCloudKey]boolValue];
        if (isInCloud && !result)
        {
            PHImageRequestOptions *options_cloud = [[PHImageRequestOptions alloc] init];
            options_cloud.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
                if (progressHandler)
                {
                    progressHandler(progress,error,stop,info);
                }
            };
            options_cloud.networkAccessAllowed = YES;
            options_cloud.resizeMode = PHImageRequestOptionsResizeModeFast;
            [imageManager requestImageDataForAsset:asset options:options_cloud resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                //如果图片本来就是小图，可能无法完整渲染到targetSize中；所以先放大10倍大小，但是缺点会内存爆增的；待优化；
                UIImage *resultImage = [UIImage imageWithData:imageData scale:0.1];
                resultImage = [self scaleImage:resultImage toSize:targetSize];
                if (resultHandler)
                {
                    resultHandler(result,info);
                }
            }];
        }
    }];
    return imageRequestID;
}



- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size {
    if (image.size.width > size.width) {
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    } else {
        return image;
    }
}
@end
