//
//  ZXCustomCellCollectionView.h
//  YiShangbao
//
//  Created by simon on 2018/1/8.
//  Copyright © 2018年 com.Microants. All rights reserved.
//
// 简介：封装一个可以外部自定义cell的collectionView的UIView组件；但是建立的自定义collectionViewCell需要继承于ZXCustomCollectionBaseCell；这样完全开放了cell自定义显示，非常方便； 可以横向或纵向展示，把这个view添加到父视图view上；

// 2018.01.11 修复collectionView的frame大小设置bug；
// 2018.01.19  增加例子注释
// 2019.02.25  修改注释；
// 2019.05.25  增加点击item事件；

#import <UIKit/UIKit.h>
#import "ZXCustomCollectionBaseCell.h"


NS_ASSUME_NONNULL_BEGIN

@protocol ZXCustomCellCollectionViewDelegate;

@interface ZXCustomCellCollectionView : UIView<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic, weak) id<ZXCustomCellCollectionViewDelegate>delegate;

@property (nonatomic, strong) UICollectionView *collectionView;

// 设置collectionView的sectionInset；默认UIEdgeInsetsMake(10, 15, 10, 15)
@property (nonatomic, assign) UIEdgeInsets sectionInset;

// item之间的间距,默认10; 在做一行固定显示几个item的时候，可以用于增大间距来减小item的width；
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;

// 行间距,默认10
@property (nonatomic, assign) CGFloat minimumLineSpacing;

/**
 *  一个屏幕显示多少列；最好小于等于4列；
 */
@property (nonatomic, assign) NSInteger columnsCount;


// 设置itemSize大小；
@property (nonatomic, assign) CGSize itemSize;

@property (nonatomic, strong, nullable) UIImage *placeholderImage;

// 设置是否可以滚动
@property(nonatomic,getter=isScrollEnabled) BOOL       scrollEnabled;

// 设置滚动布局方向
@property (nonatomic) UICollectionViewScrollDirection scrollDirection; // default is UICollectionViewScrollDirectionVertical


/**
 注册cell； cell必须是继承于ZXCustomCellCollectionVCell；

 @param collectionViewCell 继承于ZXCustomCellCollectionVCell
 @param identifier 标识
 */
- (void)registerClassWithCollectionViewCell:(ZXCustomCollectionBaseCell <ZXCustomCollectionBaseCellProtocol>*)collectionViewCell forCellWithReuseIdentifier:(NSString *)identifier;


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
 获取整个collectionView需要的大小
 
 @param data 数组
 @return size
 */
- (CGSize)sizeWithContentData:(nullable NSArray *)data;

@end


@class ZXCustomCellCollectionView;

@protocol ZXCustomCellCollectionViewDelegate <NSObject>


/**
 自定义 点击添加cell事件回调
 
 @param collectionView collectionView description
 @param indexPath indexPath description
 */
- (void)zx_customCellCollectionView:(ZXCustomCellCollectionView *)customCellCollectionView collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;


@end


NS_ASSUME_NONNULL_END


//例如，显示一个由颜色，产品名字，价格属性组合的item的item列表；这个很符合当前组件使用的特征；

//父视图 SaleGoodgraphMainCell 上添加自定义的ZXCustomCellCollectionView；
/*
#import "SaleGoodgraphMainCell.h"

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


// ZXCustomCellCollectionView使用的自定义CollectionViewcell
/*
#import "ZXCustomCollectionBaseCell.h"

@interface SaleGoodsLegendCollectionCell :ZXCustomCollectionBaseCell

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


//例2:横向排列可滚动的数据，根据屏幕适配设置itemSize，根据有几列算出自适应的item间距；
/*
#import "VideoHomeNewCollectionCell.h"

@implementation VideoHomeNewCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.customCellCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([VideoHomeNewLIstCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([VideoHomeNewLIstCollectionCell class])];
    
    self.customCellCollectionView.sectionInset = UIEdgeInsetsMake(0, 15, 10, 15);
    self.customCellCollectionView.itemSize = CGSizeMake(LCDScale_iPhone6_Width(64), LCDScale_iPhone6_Width(92));
    self.customCellCollectionView.minimumLineSpacing = (LCDW - 30 - LCDScale_iPhone6_Width(64)*4)/3;
    self.customCellCollectionView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.customCellCollectionView.scrollEnabled = YES;
}

- (void)setData:(id)data
{
    NSArray *saleGoodgraphs = (NSArray *)data;
    [self.customCellCollectionView setData:saleGoodgraphs];
}
@end

*/
