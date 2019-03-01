//
//  ZXCustomCellCollectionView.h
//  YiShangbao
//
//  Created by simon on 2018/1/8.
//  Copyright © 2018年 com.Microants. All rights reserved.
//
// 简介：封装一个可以外部自定义cell的collectionView的UIView组件；但是建立的自定义collectionViewCell需要继承于ZXCustomCollectionVCell；这样完全开放了cell自定义显示，非常方便，但是cell里不能包含事件，因为无法传递； 适合一种独立的显示符合collectionView视图排版的View；

// 2018.01.11 修复collectionView的frame大小设置bug；
// 2018.01.19  增加例子注释
// 2019.02.25  修改注释；

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


//例如，显示一组由颜色，产品名字，价格的多个item；这个很符合当前组件使用的特征；
/*
#import "ZXCustomCellCollectionView.h"
#import "SaleGoodsLegendCollectionCell.h"

@interface SaleGoodgraphMainCell : BaseTableViewCell


@property (nonatomic, strong) PNPieChart *pieChart;
@property (weak, nonatomic) IBOutlet ZXCustomCellCollectionView *customCellCollectionView;

@property (nonatomic, copy) NSArray *colorArray;

@end


@implementation SaleGoodgraphMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    [self.customCellCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SaleGoodsLegendCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([SaleGoodsLegendCollectionCell class])];
    
    self.customCellCollectionView.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
    self.customCellCollectionView.itemSize = CGSizeMake(LCDW/2-2*15, (LCDScale_5Equal6_To6plus(178.f)  -10-10-3*10)/4);
}

- (void)setData:(id)data
{
    NSArray *saleGoodgraphs = (NSArray *)data;
    [self.customCellCollectionView setData:saleGoodgraphs];
}
*/

// 自定义cell
/*
#import "ZXCustomCollectionVCell.h"

@interface SaleGoodsLegendCollectionCell :ZXCustomCollectionVCell

@property (weak, nonatomic) IBOutlet UILabel *colorLab;

@property (weak, nonatomic) IBOutlet UILabel *productName;

@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@end

#import "SaleGoodsLegendCollectionCell.h"

@implementation SaleGoodsLegendCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.productName.font = [UIFont systemFontOfSize:LCDScale_iPhone6_Width(13)];
    self.priceLab.font = [UIFont systemFontOfSize:LCDScale_iPhone6_Width(13)];
}

- (void)setData:(id)data withIndexPath:(NSIndexPath *)indexPath
{
    BillDataSaleGoodgraphModelSub *model = (BillDataSaleGoodgraphModelSub *)data;
    switch (indexPath.item) {
        case 0:
            self.colorLab.backgroundColor = UIColorFromRGB_HexValue(0xFFAB00);
            self.productName.textColor = self.colorLab.backgroundColor;
            self.priceLab.textColor = self.colorLab.backgroundColor;
            break;
        case 1:
            self.colorLab.backgroundColor = UIColorFromRGB_HexValue(0xff5434);
            self.productName.textColor = self.colorLab.backgroundColor;
            self.priceLab.textColor = self.colorLab.backgroundColor;
            break;
        case 2:
            self.colorLab.backgroundColor = UIColorFromRGB_HexValue(0x45A4E8);
            self.productName.textColor = self.colorLab.backgroundColor;
            self.priceLab.textColor = self.colorLab.backgroundColor;
            break;
        case 3:
            self.colorLab.backgroundColor = UIColorFromRGB_HexValue(0xB1B1B1);
            self.productName.textColor = self.colorLab.backgroundColor;
            self.priceLab.textColor = self.colorLab.backgroundColor;
            break;
        default:
            break;
    }
    
    self.productName.text = model.goodName;
    self.priceLab.text = [NSString stringWithFormat:@"¥%@",model.totalFee];
}
@end
*/
