//
//  ZXImgIconsCollectionView.h
//  YiShangbao
//
//  Created by simon on 2017/11/28.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  注释： 专门用于显示动态小图标集合view，能计算出动态数量所需要的collectionView整个内容需要的宽度，高度；支持动态内容图标自适应大小的时候的计算；裁剪掉collectonView越界父视图显示区域；

//  可以设置图标间距，设置图标大小；可以根据ZXImgIconsModel的width，height来设置cell宽度是否随它的内容自适应

//   2017.12.20 增加UIImageView+WebCache库
//   2018.1.18 增加注释
//   2018.6.01 修改动态内容大小时候，获取整个内容需要的宽度，高度的做法；

#import <UIKit/UIKit.h>
#import "EqualSpaceFlowLayoutEvolve.h"
#import "ZXImgIcons.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXImgIconsCollectionView : UIView<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataMArray;

// 设置collectionView的sectionInset;
@property (nonatomic, assign) UIEdgeInsets sectionInset;

// item之间的间距;
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;

// 行间距;
@property (nonatomic, assign) CGFloat minimumLineSpacing;

// 最多可显示的图标数量
@property (nonatomic, assign) NSInteger maxItemCount;

//设置item的width，height，size；
@property (nonatomic, assign) CGFloat iconWidth;
@property (nonatomic, assign) CGFloat iconHeight;

// 设置cell宽度是否随它的内容自适应：default YES;
@property (nonatomic, assign) BOOL apportionsItemWidthsByContent;

// item同样size的值；只有效于apportionsItemWidthsByContent = NO的时候；
@property (nonatomic, assign) CGSize itemSameSize;



- (void)setData:(nullable NSArray *)data;

//设置等间距对齐
//- (void)setCollectionViewLayoutWithEqualSpaceAlign:(AlignType)collectionViewCellAlignType withItemEqualSpace:(CGFloat)equalSpace animated:(BOOL)animated;
/**
 获取整个collectionView需要的大小
 
 @param data 数组
 @return size
 */
- (CGSize)sizeWithContentData:(nullable NSArray *)data;

@end

NS_ASSUME_NONNULL_END

/*
- (void)awakeFromNib
{
    [super awakeFromNib];
    ZXImgIconsCollectionView *iconsView = [[ZXImgIconsCollectionView alloc] init];
    self.iconsView = iconsView;
    iconsView.minimumInteritemSpacing = 2.f;
    [self.iconsContainerView addSubview:iconsView];
    self.iconsContainerView.backgroundColor = [UIColor clearColor];
    [iconsView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.iconsContainerView).with.insets(UIEdgeInsetsMake(0, 0, 0,0));
        
    }];
}
 
- (void)setData:(id)data
{
    CGSize size  = [self.iconsView sizeWithContentData:self.iconsView.dataMArray];
    [self.iconsContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(size.width);
        
    }];
}
*/
