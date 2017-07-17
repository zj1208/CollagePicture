//
//  ZXPhotosView.h
//  CollagePicture
//
//  Created by simon on 17/1/6.
//  Copyright © 2017年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXPhoto.h"
#import "ZXPhotoBrowserConst.h"

NS_ASSUME_NONNULL_BEGIN

// 图片状态
typedef NS_ENUM(NSInteger, ZXPhotosViewState) {
    ZXPhotosViewStateWillCompose = 0,   // 未发布
    ZXPhotosViewStateDidCompose = 1     // 已发布
};

//typedef void (^TextDidChangeBlock)(ZXPlaceholdTextView *textView,NSUInteger remainCount);


@class ZXPhotosView;

@protocol ZXPhotosViewDelegate <NSObject,UIScrollViewDelegate>

@optional
/**
 点击添加图片按钮时调用此方法

 @param photosView photosView description
 @param images 当前已经存在显示的图片（未发布）数组
 */
- (void)photosView:(ZXPhotosView *)photosView didAddImageClickedWithImages:(nullable NSMutableArray *)images;


/**
 点击图片，调用大图显示代理

 @param index 图片索引
 @param photos 所有图片model的数组
 */
- (void)zx_photosView:(ZXPhotosView *)photosView didSelectWithIndex:(NSInteger)index photosArray:( NSArray*)photos;

- (void)zx_photosView:(ZXPhotosView *)photosView didSelectWithIndex:(NSInteger)index photosArray:(NSArray*)photos userInfo:(nullable id)userInfo;
@end



@interface ZXPhotosView : UIScrollView

//代理
@property (nonatomic, weak)id<ZXPhotosViewDelegate>delegate;

/** 所有图片的状态（默认为已发布状态） */
@property (nonatomic, assign) ZXPhotosViewState photosState;

/** 网络图片模型数组 */
@property (nonatomic, copy, nullable) NSArray *photoModelArray;
/** 网络图片地址数组（缩略图） */
@property (nonatomic, copy, nullable) NSArray *thumbnailUrlsArray;
/** 网络图片地址数组（原图） */
@property (nonatomic, copy, nullable) NSArray *originalUrlsArray;

/** 本地相册图片(注意：存的是UIImage)数组(默认最多为九张,当传入图片数组长度超过九张时，取前九张) */
@property (nonatomic, strong, nullable) NSMutableArray *images;
/** 当图片上传前，最多上传的张数，默认为9，用于ZXPhotosViewStateWillCompose*/
@property (nonatomic, assign) NSInteger imagesMaxCountWhenWillCompose;

/**
 控制最多显示几张图片； 用于ZXPhotosViewStateDidCompose
 */
@property (nonatomic, assign) NSInteger photoMaxCount;


/** 图片间距（默认为5） */
@property (nonatomic, assign) CGFloat photoMargin;
/** 图片的宽 (默认为70) */
@property (nonatomic, assign) CGFloat photoWidth;
/** 图片的高 (默认为70) */
@property (nonatomic, assign) CGFloat photoHeight;


/** 当图片为4张是显示为是否两行两列，默认为YES */
@property (nonatomic, assign) BOOL autoLayoutWithWeChatSytle;


/**
  每行最多显示几张图片（默认为3）／在流水布局中最多几列； 当图片布局为线性布局时，此设置失效
 */
@property (nonatomic, assign) NSInteger photosMaxColoum;

//传附加信息用的
@property (nonatomic, strong, nullable) id userInfo;


//注释label
@property (nonatomic, strong) UILabel *promptLab;

//声明一个photoView的block变量-已发布，回调这个itemView，可以设置它
@property (nonatomic, copy, nullable) void(^photoModelItemViewBlock)(UIView* itemView);


/** 快速创建photosView对象 */
+ (instancetype)photosView;

//直接回调设置每张网络图片item
- (void)setItemViewCornerRadius:(void(^)(UIView* itemView))photoItemViewBlock;
/**
 保存网络图片链接的数组

 @param thumbnailUrls 网络图片地址数组（缩略图）
 @param originalUrls 网络图片地址数组（原图）
 @return photosView对象
 */
+ (instancetype)photosViewWithThumbnailPicUrls:(nullable NSArray *)thumbnailUrls  originalPicUrls:(nullable NSArray *)originalUrls;



/**
 获取网络图片模型数组只有1张的时候的size

 @param origSize 原始图片大小
 @return 返回在限制大小，而且正比例缩放的图片的尺寸；
 */
- (CGSize)getSinglePhotoViewLayoutWithOrignialSize:(CGSize)origSize;


/**
 存储本地图片的数组
 
 @param images 本地图片image数组
 @return photosView对象
 */
+ (instancetype)photosViewWithImages:(nullable NSMutableArray *)images;

/**
 * 刷新图片(未发布)
 * images : 新的图片数组
 */
- (void)reloadDataWithImages:(nullable NSMutableArray *)images;


/**
 根据图片个数和图片状态自动计算出ZXPhontosView的size
 
 @param count 图片个数
 @return ZXPhontosView的size
 */
- (CGSize)sizeWithPhotoCount:(NSInteger)count  photosState:(ZXPhotosViewState)state;

@end


NS_ASSUME_NONNULL_END

/*
- (void)awakeFromNib
{
    [super awakeFromNib];
    
 
    //   self.photoContainerView.backgroundColor = [UIColor redColor];
    // 创建一个流水布局photosView(默认为流水布局)
    ZXPhotosView *photoView   = [ZXPhotosView photosView];
    photoView.autoLayoutWithWeChatSytle = YES;
    photoView.photoMargin = PhotoMargin;
    photoView.photoWidth = (LCDW-72-PhotoMargin*2)/3;
    photoView.photoHeight = photoView.photoWidth;
    photoView.photoModelItemViewBlock = ^(UIView *itemView)
    {
        [itemView setCornerRadius:2.f borderWidth:0.5f borderColor:UIColorFromRGB_HexValue(0xE8E8E8)];
    };
    self.photosView = photoView;
    [self.photoContainerView addSubview:self.photosView];
    
    [photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.photoContainerView).with.insets(UIEdgeInsetsMake(0, 0, 0,0));
        
    }];
 
 //打印nib中约束的frame，永远是布局上已有的frame大小，所以在自动布局中，你不能用frame来给动态的值；
 NSLog(@"self.photoContainerView.frame=%@",NSStringFromCGRect(self.photoContainerView.frame));

}


- (void)setData:(id)data
{
    
    NSMutableArray *picMArray = [NSMutableArray array];
    [model.photosArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        AliOSSPicModel *picModel = (AliOSSPicModel *)obj;
        ZXPhoto *photo = [ZXPhoto photoWithOriginalUrl:picModel.picURL];
        photo.thumbnail_pic = picModel.picURL;
        photo.width = picModel.width;
        photo.height = picModel.height;
        [picMArray addObject:photo];
        
    }];
    self.photosView.photoModelArray = picMArray;
    if (model.photosArray.count==1)
    {
        ZXPhoto *photo = [picMArray firstObject];
        NSLog(@"%@",photo);
        
        CGSize photoSize =  [self.photosView getSinglePhotoViewLayoutWithOrignialSize:CGSizeMake(photo.width, photo.height)];
        self.photosView.photoWidth = photoSize.width;
        self.photosView.photoHeight = photoSize.height;
    }
    else
    {
        self.photosView.photoWidth =(LCDW-72-PhotoMargin*2)/3;
        self.photosView.photoHeight = self.photosView.photoWidth;
    }
    
}

//父视图约束一定要降低优先级，否则无法更新约束
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size  = [self.photosView sizeWithPhotoCount:self.photosView.photoModelArray.count];
    [self.photoContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(size);
    }];
}

 //计算动态布局的高度，一定要约束到contentView的上下左右，尤其是下边距；label一定要标明numberOfLines
- (CGFloat)getCellHeightWithContentData:(id)data
{
    [self.contentLab setPreferredMaxLayoutWidth:LCDW-72];
    [self.contentLab layoutIfNeeded];
    self.contentLab.text = [data content];
    [self.contentView layoutIfNeeded];
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    NSMutableArray *picMArray = [NSMutableArray array];
    [[data photosArray] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        AliOSSPicModel *picModel = (AliOSSPicModel *)obj;
        ZXPhoto *photo = [ZXPhoto photoWithOriginalUrl:picModel.picURL];
        photo.thumbnail_pic = picModel.picURL;
        photo.width = picModel.width;
        photo.height = picModel.height;
        [picMArray addObject:photo];
        
    }];
    if (picMArray.count==1)
    {
        ZXPhoto *photo = [picMArray firstObject];
        CGSize photoSize =  [self.photosView getSinglePhotoViewLayoutWithOrignialSize:CGSizeMake(photo.width, photo.height)];
        self.photosView.photoWidth = photoSize.width;
        self.photosView.photoHeight = photoSize.height;
    }
    else
    {
        self.photosView.photoWidth =(LCDW-72-PhotoMargin*2)/3;
        self.photosView.photoHeight = self.photosView.photoWidth;
        
    }
    CGSize photosViewSize  = [self.photosView sizeWithPhotoCount:picMArray.count];
    
    return size.height+1.0f-90+photosViewSize.height;
}

 */
