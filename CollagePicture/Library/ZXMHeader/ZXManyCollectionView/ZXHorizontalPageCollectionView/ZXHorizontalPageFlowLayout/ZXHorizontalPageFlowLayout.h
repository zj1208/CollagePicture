//
//  ZXHorizontalPageFlowLayout.h
//  YiShangbao
//
//  Created by simon on 2018/1/30.
//  Copyright © 2018年 com.Microants. All rights reserved.
//
//  简介：重写UICollectionFlowLayout，设计一个屏幕几行，几列展示的collectionView，超过几行*几列 个数，翻页展示；
//  要求edgeInset的左右边界距离 = columnSpacing/2
//  其他人的设计方案：http://blog.csdn.net/u012583107/article/details/76044492

// 2018.2.5； 修改item位置；

#import <UIKit/UIKit.h>

@interface ZXHorizontalPageFlowLayout : UICollectionViewFlowLayout

// 一页每行展示多少个，即每页显示多少列
@property (nonatomic, assign) NSInteger columnsCount;

// 边距
@property (nonatomic, assign) UIEdgeInsets edgeInsets;


/** 列间距 */
@property (nonatomic, assign) CGFloat columnSpacing;

/** 行间距 */
@property (nonatomic, assign) CGFloat rowSpacing;

// 几行
@property (nonatomic, assign) NSInteger rowCount;

/***  存放所有的布局属性LayoutAttributes*/
@property (nonatomic, strong) NSMutableArray *attributesMArray;

@end
