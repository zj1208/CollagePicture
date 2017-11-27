//
//  ZXManyImgIconsView.h
//  YiShangbao
//
//  Created by simon on 17/6/3.
//  Copyright © 2017年 com.Microants. All rights reserved.
//  放动态小图标的；

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXManyImgIconsView : UIView


@property (nonatomic, copy, nullable) NSArray *thumbnailUrlsArray;

/**
 控制最多显示几张图片；
 */
@property (nonatomic, assign) NSInteger imgIconMaxCount;


/** 图片间距（默认为5） */
@property (nonatomic, assign) CGFloat imgIconMargin;
/** 图片的宽 (默认为15) */
@property (nonatomic, assign) CGFloat imgIconWidth;
/** 图片的高 (默认为15) */
@property (nonatomic, assign) CGFloat imgIconHeight;


@property (nonatomic, assign) NSInteger photosMaxColoum;


/**
 保存网络图片链接的数组
 
 @param thumbnailUrls 网络图片地址数组（缩略图）
 @return photosView对象
 */
- (instancetype)zxManyImgIconsViewWithThumbnailPicUrls:(nullable NSArray *)thumbnailUrls;


/**
 根据图片个数和图片状态自动计算出ZXManyImgIconsView的size
 
 @param count 图片个数
 @return IconsView的size
 */
- (CGSize)sizeWithIconsViewCount:(NSInteger)count;

@end

NS_ASSUME_NONNULL_END
/*

- (void)awakeFromNib
{
    ZXManyImgIconsView * iconsView = [[ZXManyImgIconsView alloc] init];
    self.iconsView = iconsView;
    [self.iconsContainerView addSubview:iconsView];
    self.iconsContainerView.backgroundColor = [UIColor clearColor];
    [iconsView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.iconsContainerView).with.insets(UIEdgeInsetsMake(0, 0, 0,0));
        
    }];
    
    [super awakeFromNib];
}


- (void)layoutSubviews
{
     [super layoutSubviews];
    CGSize size  = [self.iconsView sizeWithIconsViewCount:self.iconsView.thumbnailUrlsArray.count];
    [self.iconsContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(size);
    }];

}

- (void)setData:(id)data
{
    ShopMainInfoModel *model = (ShopMainInfoModel *)data;
    self.iconsView.thumbnailUrlsArray = model.serviceIcons;
}
*/


