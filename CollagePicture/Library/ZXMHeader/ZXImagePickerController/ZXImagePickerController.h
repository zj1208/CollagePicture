//
//  ZXImagePickerController.h
//  FunLive
//
//  Created by simon on 2019/4/23.
//  Copyright © 2019 facebook. All rights reserved.
//
//  简介：自己根据Photos.framework框架封装的相册所属照片选择器；主要根据TZImagePickerController间接优化；
//       目前还没有完善，只完成40%的功能及效果；待优化；

#import <UIKit/UIKit.h>
#import "ZXPHPhotoManager.h"
#import "ZXAuthorizationManager.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ZXBarStyle) {
    
    ZXBarStyleBlack = 0, //导航条背景黑色，标题文字白色，barItem文字白色，状态条白色；
    ZXBarStyleWhite = 1, //导航条背景白色，标题文字黑色，barItem文字默认蓝色，状态条黑色；
};


@class ZXImagePickerController;

@protocol ZXImagePickerControllerDelegate <NSObject>

@optional


/**
 取消按钮响应事件回调

 @param picker picker description
 */
- (void)zx_imagePickerControllerDidCancel:(ZXImagePickerController *)picker;



/**
 相册集合列表中是否需要包含指定albumName的相册集合；

 @param albumName 某个相册集合名词
 @param result 某个相册集合的PHAsset检索数组
 */
- (BOOL)zx_shouldContainAlbumInAlbumCollectionListWithAlbumTitle:(NSString *)albumName fetchResult:(PHFetchResult *)result;

@end



@interface ZXImagePickerController : UINavigationController


/**
 初始化方法

 @param maxImagesCount 最大可选数
 @param delegate 容器控制器代理
 @return UINavigationController
 */
- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount delegate:(nullable id<ZXImagePickerControllerDelegate>)delegate;

- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount columnNumber:(NSInteger)columnNumber delegate:(nullable id<ZXImagePickerControllerDelegate>)delegate;

- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount columnNumber:(NSInteger)columnNumber delegate:(nullable id<ZXImagePickerControllerDelegate>)delegate autoPushPhotoPickerViewController:(BOOL)pushPhotoPickerVc;

// Default is 9 / 默认最大可选9张图片
@property (nonatomic, assign) NSInteger maxImagesCount;

// 最小照片必选张数,默认是0
@property (nonatomic, assign) NSInteger minImagesCount;

/// Default is YES, if set NO, the original photo button will hide. user can't picking original photo.
/// 默认为YES，如果设置为NO,原图按钮将隐藏，用户不能选择发送原图
@property (nonatomic, assign) BOOL allowPickingOriginalPhoto;

/// 默认为YES，如果设置为NO,用户将不能选择视频
@property (nonatomic, assign) BOOL allowPickingVideo;
/// Default is NO / 默认为NO，为YES时可以多选视频/gif图片，和照片共享最大可选张数maxImagesCount的限制
@property (nonatomic, assign) BOOL allowPickingMultipleVideo;

/// Default is NO, if set YES, user can picking gif image.
/// 默认为NO，如果设置为YES,用户可以选择gif图片
@property (nonatomic, assign) BOOL allowPickingGif;

/// Default is YES, if set NO, user can't picking image.
/// 默认为YES，如果设置为NO,用户将不能选择发送图片
@property(nonatomic, assign) BOOL allowPickingImage;


/******************导航条外观 ***********////////////////

// 导航条+状态条 总体快捷设置;
@property (nonatomic) ZXBarStyle barStyle;

// 导航条+状态条具体设置；

// 导航条背景，标题文字颜色，标题字体大小
@property (nonatomic, strong) UIColor *barTintColor;
@property (nonatomic, strong) UIColor *barTitleColor;
@property (nonatomic, strong) UIFont *barTitleFont;
// 导航条barItem按钮
@property (nonatomic, strong) UIColor *barItemTextColor;
@property (nonatomic, strong) UIFont *barItemTextFont;
// 状态条样式
@property (nonatomic) UIStatusBarStyle stausBarStyle;


/******************图片名**********////////////////

@property (nonatomic, copy) NSString *takePictureImageName;
@property (nonatomic, copy) NSString *photoSelImageName;
@property (nonatomic, copy) NSString *photoDefImageName;
@property (nonatomic, copy) NSString *photoOriginSelImageName;
@property (nonatomic, copy) NSString *photoOriginDefImageName;
@property (nonatomic, copy) NSString *photoPreviewOriginDefImageName;
//选中图片数量背景icon
@property (nonatomic, copy) NSString *photoNumberIconImageName;



/// The pixel width of output image, Default is 828px / 导出图片的宽度，默认828像素宽
@property (nonatomic, assign) CGFloat photoWidth;

/// Default is 600px / 默认600像素宽
@property (nonatomic, assign) CGFloat photoPreviewMaxWidth;


@property (nonatomic, weak) id<ZXImagePickerControllerDelegate> pickerDelegate;


// 取消按钮事件
- (void)cancelButtonClick;

@end

NS_ASSUME_NONNULL_END
