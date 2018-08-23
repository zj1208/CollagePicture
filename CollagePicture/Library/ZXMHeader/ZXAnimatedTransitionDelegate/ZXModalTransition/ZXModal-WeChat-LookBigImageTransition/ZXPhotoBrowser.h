//
//  ZXPhotoBrowser.h
//  YiShangbao
//
//  Created by simon on 2018/8/15.
//  Copyright © 2018年 com.Microants. All rights reserved.
//
//  简介：类似微信中点击头像查看大图的动画效果；结合ZXWXBigImageTransitionDelegate转场切换；这个控制器页面为最终展示页面；在window上添加覆盖图+UIActivityIndicatorView；
//  目前只支持单张大图预览，主要适用于头像的大图预览；
//  依赖ZXOverlay/SDWebImageManager/ZXWXBigImageTransitionDelegate 3个类；

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXPhotoBrowser;

@protocol ZXPhotoBrowserDataSource <NSObject>

@optional

/**
 *  返回这个位置的原图的占位图片 (如果不实现此方法,会默认使用placeholderImage)
 *
 *  @param browser 浏览器
 *  @param index   位置索引
 *
 *  @return 展示的图片
 */
- (UIImage *)zx_photoBrowser:(ZXPhotoBrowser *)browser placeholderSourceImageForIndex:(NSInteger)index;

/**
 *  返回指定位置的高清图片URL
 *
 *  @param browser 浏览器
 *  @param index   位置索引
 *
 *  @return 返回高清大图索引
 */
- (NSURL *)zx_photoBrowser:(ZXPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;


@end

@interface ZXPhotoBrowser : UIViewController

@property (nonatomic, weak) id<ZXPhotoBrowserDataSource>dataSource;

///**
// *  用户点击的图片视图,用于做图片浏览器弹出的放大动画,不给次属性赋值会通过代理方法photoBrowser: sourceImageViewForIndex:尝试获取,如果还是获取不到则没有弹出放大动画
// */
//@property (nonatomic, strong) UIImageView *sourceImageView;

/**
 *  占位图片,可选(默认是一张灰色的100*100像素图片)
 *  当没有实现数据源中placeholderImageForIndex方法时,默认会使用这个占位图片
 */
@property (nonatomic, strong) UIImage *placeholderImage;

/**
 *  当前显示的图片位置索引 , 默认是0
 */
@property (nonatomic, assign ) NSInteger currentImageIndex;
/**
 *  浏览的图片数量,大于0
 */
@property (nonatomic, assign ) NSInteger imageCount;

// 辅助传递信息
@property (nonatomic, strong)  id userInfo;


/**
 类似微信查看头像的大图转场动画效果，使用默认的AfterImageFrame设置,居中显示；

 @param transitionImage  转场过渡的图片
 @param frame 转场前的图片frame
 */
- (void)transitionWithTransitionImage:(UIImage *)transitionImage beforeImageFrameInWindow:(CGRect)frame;


/**
 *  初始化
 *
 *  @param currentImageIndex 开始展示的图片索引
 *  @param imageCount        图片数量
 *  @param dataSource        数据源
 *
 */
+ (instancetype)photoBrowserWithCurrentImageIndex:(NSInteger)currentImageIndex imageCount:(NSUInteger)imageCount dataSource:(id<ZXPhotoBrowserDataSource>)dataSource;


+ (void)showPhotoBrowserWithCurrentImageIndex:(NSInteger)currentImageIndex imageCount:(NSUInteger)imageCount dataSource:(id<ZXPhotoBrowserDataSource>)dataSource transitionImage:(UIImage *)sourceImage transitionBeforeImgFrame:(CGRect)beforeImgFrame userInfo:(id)userInfo;


// 进入图片浏览器
- (void)show;

// 退出图片浏览器
- (void)dismiss;


#pragma mark - Activity indicator

/**
 *  Show activity UIActivityIndicatorView
 */
- (void)zx_setShowActivityIndicatorView:(BOOL)show;

- (void)zx_setIndicatorStyle:(UIActivityIndicatorViewStyle)style;

- (BOOL)zx_showActivityIndicatorView;
- (void)zx_addActivityIndicator;
- (void)zx_removeActivityIndicator;
@end

NS_ASSUME_NONNULL_END


