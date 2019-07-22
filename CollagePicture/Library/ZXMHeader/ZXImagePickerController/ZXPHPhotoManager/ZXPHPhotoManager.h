//
//  ZXPHPhotoManager.h
//  FunLive
//
//  Created by simon on 2019/4/24.
//  Copyright © 2019 facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "ZXAssetModel.h"
#import "ZXImagePickerController.h"


NS_ASSUME_NONNULL_BEGIN


@class ZXPHPhotoManager;

@protocol ZXPHPhotoManagerDelegate <NSObject>

@optional

- (BOOL)zx_shouldContainAlbumInAlbumCollectionListWithAlbumTitle:(NSString *)albumName fetchResult:(PHFetchResult *)result;



@end

@interface ZXPHPhotoManager : NSObject


+ (instancetype)shareInstance;

@property (assign, nonatomic) id<ZXPHPhotoManagerDelegate> delegate;

/// Default is 600px / 默认600像素宽
@property (nonatomic, assign) CGFloat photoPreviewMaxWidth;
/// The pixel width of output image, Default is 828px / 导出图片的宽度，默认828像素宽
@property (nonatomic, assign) CGFloat photoWidth;

/**
 获取相册集合列表【智能相册+本地自己创建的相册】

 @param allowPickingVideo 是否允许选择视频
 @param allowPickingImage 是否允许选择图片
 @param completion 获取完成回调数组；
 */
- (void)getAlbumCollectionListWithAllowPickingVideo:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickingImage completion:(void (^)(NSArray<ZXAlbumModel *> *))completion;


//typedef void (^ completion)(UIImage *);
/**
 获取某个相册集合（PHFetchResult<PHAsset>数组）的封面图

 @param model 相册model
 @param completion 获取完成回调image
 */
- (void)getPostImageWithAlbumModel:(ZXAlbumModel *)model completion:(void (^)(UIImage *))completion;




/**
 根据PHAsset获取图片1;

 @param asset 资源PHAsset对象
 @param resultHandler 请求结果
 @return 此图片结果的请求的请求ID
 */
- (PHImageRequestID)requestImageForAsset:(PHAsset *)asset resultHandler:(void (^)(UIImage *__nullable result, NSDictionary *__nullable info))resultHandler;

/**
 根据PHAsset获取图片2;
 
 @param asset 资源PHAsset对象
 @param photoWidth 根据photoWidth正比例缩放得到targetSize
 @param resultHandler 请求结果
 @return 此图片结果的请求的请求ID
 */
- (PHImageRequestID)requestImageForAsset:(PHAsset *)asset photoWidth:(CGFloat)photoWidth resultHandler:(void (^)(UIImage *__nullable result, NSDictionary *__nullable info))resultHandler;

/**
 根据PHAsset获取图片3；photoWidth正比例缩放得到targetSize;

 @param asset 资源PHAsset对象
 @param photoWidth 根据photoWidth正比例缩放得到targetSize
 @param progressHandler 如果是iCould网络图片，则有进度返回；如果是本地d图片，则无返回；
 @param resultHandler 请求结果
 @return 此图片结果的请求的请求ID
 */
- (PHImageRequestID)requestImageForAsset:(PHAsset *)asset photoWidth:(CGFloat)photoWidth progressHandler:(nullable PHAssetImageProgressHandler)progressHandler  resultHandler:(void (^)(UIImage *__nullable result, NSDictionary *__nullable info))resultHandler;


/**
 根据PHAsset获取图片4；

 @param asset 资源PHAsset对象
 @param targetSize 获取图片返回来的目标大小；
 @param contentMode 显示模式；是否变形；
 @param progressHandler 如果是iCould网络图片，则有进度返回；如果是本地d图片，则无返回；
 @param resultHandler 请求结果
 @return  此图片结果的请求的请求ID
 */
- (PHImageRequestID)requestImageForAsset:(PHAsset *)asset targetSize:(CGSize)targetSize contentMode:(PHImageContentMode)contentMode  progressHandler:(nullable PHAssetImageProgressHandler)progressHandler  resultHandler:(void (^)(UIImage *__nullable result, NSDictionary *__nullable info))resultHandler;

@end

NS_ASSUME_NONNULL_END
