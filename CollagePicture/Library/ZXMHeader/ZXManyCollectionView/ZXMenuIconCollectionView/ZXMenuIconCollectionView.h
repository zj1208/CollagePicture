//
//  ZXMenuIconCollectionView.h
//  YiShangbao
//
//  Created by simon on 2017/10/23.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  注释：collectionView菜单列表展示，可以计算出动态数量的item所需要的collectionView总高度；
//  要求：等大小item，上面图标+下面文字；每个图标右上角可以显示badge数字；

//   2018.1.8
//   修改ZXMenuIconCell实例方法
//   2018.1.18
//   优化代码；修改item大小；有bug，计算高度不准；在消息页面，initWithCoder:方法会调用二次
//   2018.1.30 修改计算评价widht的方法；

#import <UIKit/UIKit.h>
#import "ZXMenuIconCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZXMenuIconCollectionViewDelegate,ZXMenuIconCollectionViewDelegateFlowLayout;

@interface ZXMenuIconCollectionView : UIView<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic, weak) id<ZXMenuIconCollectionViewDelegate>delegate;
@property (nonatomic, weak) id<ZXMenuIconCollectionViewDelegateFlowLayout> flowLayoutDelegate;


@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *collectionFlowLayout;

@property (nonatomic, strong) NSMutableArray *dataMArray;

// 设置collectionView的sectionInset;UIEdgeInsetsMake(15, 15, 15, 15)
@property (nonatomic, assign) UIEdgeInsets sectionInset;

// item之间的间距;默认12；
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;

// 行间距;默认12；
@property (nonatomic, assign) CGFloat minimumLineSpacing;

// 设置item中的Icon图标的width，height，size；
//@property (nonatomic, assign) CGSize itemSize;

@property (nonatomic, assign) CGSize iconSize;


@property (nonatomic, strong, nullable) UIImage *placeholderImage;


// 自适应缩放宽度大小：计算出来后用于设置一个总宽度（比如屏幕宽度）下放几个的平均item宽度；
- (CGFloat)getItemAverageWidthInTotalWidth:(CGFloat)totalWidth columnsCount:(NSUInteger)count sectionInset:(UIEdgeInsets)inset minimumInteritemSpacing:(CGFloat)minimumInteritemSpacing;

- (void)setData:(NSArray *)data;

//设置等间距对齐
//- (void)setCollectionViewLayoutWithEqualSpaceAlign:(AlignType)collectionViewCellAlignType withItemEqualSpace:(CGFloat)equalSpace animated:(BOOL)animated;
/**
 获取整个collectionView需要的高度
 
 @param data 数组
 @return 高度
 */
- (CGFloat)getCellHeightWithContentData:(NSArray *)data;
@end


@protocol ZXMenuIconCollectionViewDelegateFlowLayout <UICollectionViewDelegate>
@optional

- (CGSize)zx_menuIconCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol ZXMenuIconCollectionViewDelegate <NSObject>

// 如果不实现这些协议，则会用默认的设置；

@optional
/**
 将要展示数据的时候，自定义设置cell的显示；不影响布局的外观设置
 
 @param cell LabelCell
 @param indexPath collectionView中的对应indexPath
 */
- (void)zx_menuIconView:(ZXMenuIconCollectionView *)menuIconView willDisplayCell:(ZXMenuIconCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;


/**
 自定义 点击添加cell事件回调
 
 @param collectionView collectionView description
 @param indexPath indexPath description
 */
- (void)zx_menuIconView:(ZXMenuIconCollectionView *)labelsTagView collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;


@end

NS_ASSUME_NONNULL_END


//举例1
/*
#import "BaseTableViewCell.h"
#import "ZXMenuIconCollectionView.h"

@interface MessageStackViewCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet ZXMenuIconCollectionView *menuIconCollectionView;

@end

*/

/*
@implementation MessageStackViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.menuIconCollectionView.itemSize = CGSizeMake(LCDScale_iPhone6_Width(80),LCDScale_iPhone6_Width(80));
    self.menuIconCollectionView.placeholderImage = AppPlaceholderImage;
    
}


- (void)setData:(id)data
{
    [self.menuIconCollectionView setData:data];
}

- (CGFloat)getCellHeightWithContentIndexPath:(NSIndexPath *)indexPath data:(id)data
{
    return [self.menuIconCollectionView getCellHeightWithContentData:data];
}
@end
 */


// 例2，如果要做到item的图标大小不受影响，则改变item间距来达到平分；
/*
self.menuIconCollectionView.itemSize = CGSizeMake((LCDW-3*20)/4,(LCDW-3*20)/4);
self.menuIconCollectionView.sectionInset = UIEdgeInsetsZero;
self.menuIconCollectionView.minimumLineSpacing = 0.f;
self.menuIconCollectionView.minimumInteritemSpacing = 20.f;
*/
