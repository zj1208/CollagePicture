//
//  ZXCustomCellCollectionView.h
//  YiShangbao
//
//  Created by simon on 2018/1/8.
//  Copyright © 2018年 com.Microants. All rights reserved.
//
// 简介：建立的自定义collectionViewCell需要继承于ZXCustomCollectionVCell
// 2018.1.9
// 新建

#import <UIKit/UIKit.h>
#import "ZXCustomCollectionVCell.h"


NS_ASSUME_NONNULL_BEGIN

@protocol ZXCustomCellCollectionViewDelegate;

@interface ZXCustomCellCollectionView : UIView<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic, weak) id<ZXCustomCellCollectionViewDelegate>delegate;

@property (nonatomic, strong) UICollectionView *collectionView;

// 设置collectionView的sectionInset
@property (nonatomic, assign) UIEdgeInsets sectionInset;

// item之间的间距,忽略删除按钮; 在做一行固定显示几个item的时候，可以用于增大间距来减小item的width；
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;

// 行间距，忽略删除按钮
@property (nonatomic, assign) CGFloat minimumLineSpacing;

// 设置itemSize大小；默认N个item平均高度；
@property (nonatomic, assign) CGSize itemSize;


@property (nonatomic, strong) NSMutableArray *dataMArray;



/**
 注册cell； cell必须是继承于ZXCustomCellCollectionVCell；

 @param collectionViewCell 继承于ZXCustomCellCollectionVCell
 @param identifier 标识
 */
- (void)registerClassWithCollectionViewCell:(ZXCustomCollectionVCell <ZXCustomCollectionVCellProtocol>*)collectionViewCell forCellWithReuseIdentifier:(NSString *)identifier;


/**
 注册nib文件；cell必须是继承于ZXCustomCellCollectionVCell；

 @param nib nib对象
 @param identifier 标识
 */
- (void)registerNib:(nullable UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier;



/**
 设置数组数据；

 @param data 数组；
 */
- (void)setData:(NSArray *)data;


/**
 获取整个collectionView需要的高度
 
 @param data 数组
 @return 高度
 */
- (CGFloat)getCellHeightWithContentData:(NSArray *)data;

@end


@class ZXCustomCellCollectionView;

@protocol ZXCustomCellCollectionViewDelegate <NSObject>


@end


NS_ASSUME_NONNULL_END
