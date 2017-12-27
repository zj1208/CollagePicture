//
//  ZXImgIconsCollectionView.h
//  YiShangbao
//
//  Created by simon on 2017/11/28.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//   2017.12.20
//   增加UIImageView+WebCache库

#import <UIKit/UIKit.h>
#import "EqualSpaceFlowLayoutEvolve.h"
#import "ZXImgIcons.h"

@interface ZXImgIconsCollectionView : UIView<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataMArray;

// 设置collectionView的sectionInset;
@property (nonatomic, assign) UIEdgeInsets sectionInset;

// item之间的间距;
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;

// 行间距;
@property (nonatomic, assign) CGFloat minimumLineSpacing;

// 最多可显示的标签数量，到达这个数，就不能再输入了，输入标签也会移除;
@property (nonatomic, assign) NSInteger maxItemCount;

//设置item的width，height，size；
@property (nonatomic, assign) CGFloat iconWidth;
@property (nonatomic, assign) CGFloat iconHeight;

// 设置cell宽度是否随它的内容自适应：default YES;
@property (nonatomic, assign) BOOL apportionsItemWidthsByContent;

// item同样size的值；只有效于apportionsItemWidthsByContent = NO的时候；
@property (nonatomic, assign) CGSize itemSameSize;



- (void)setData:(NSArray *)data;

//设置等间距对齐
//- (void)setCollectionViewLayoutWithEqualSpaceAlign:(AlignType)collectionViewCellAlignType withItemEqualSpace:(CGFloat)equalSpace animated:(BOOL)animated;
/**
 获取整个collectionView需要的大小
 
 @param data 数组
 @return size
 */
- (CGSize)sizeWithContentData:(NSArray *)data;

@end
