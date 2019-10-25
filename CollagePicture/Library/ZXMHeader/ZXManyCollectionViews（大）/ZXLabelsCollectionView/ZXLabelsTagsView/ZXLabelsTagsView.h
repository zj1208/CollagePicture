//
//  ZXLabelsTagsView.h
//  YiShangbao
//
//  Created by simon on 17/2/21.
//  Copyright © 2017年 com.Microants. All rights reserved.

//  简介：标签展示；利用collectionView展示N个文字标签,支持设置collectionView的基本属性：标签之间的间距，行间距，sectionInset,同时也支持最多展示多少个标签，标签默认背景色，标签宽度是否随文字自适应，设置标签文字字体大小，设置选中索引，设置是否支持选中样式； 动态获取整个collectionView的高度；依赖第三方"EqualSpaceFlowLayoutEvolve"设置左对齐
//  reloadData之前，必须设置collectionView的frame，不然不会回调数据源代理,也无法内部布局；
//  例子 看ZXLabelsInputTagsView的

//  2017.12.26 修改nibName 常量定义 改为NSStringFromClass；
//  2018.6.07  修改高度计算；
//  2018.08.01 优化collectionView添加时机不对造成的高度计算bug；
//  2018.9.11  优化ZXLabelsTagsView作为重用TableFooterView的时候，造成高度获取不准的bug；
//  2019.1.28  增加注释
//  2019.10.26 标签宽度小数点进1，限制标签最大宽度不超过collectionView的宽度-inset的最终宽度；

#import <UIKit/UIKit.h>
#import "LabelCell.h"
#import "EqualSpaceFlowLayoutEvolve.h"

NS_ASSUME_NONNULL_BEGIN

@class ZXLabelsTagsView;

@protocol ZXLabelsTagsViewDelegate <NSObject>

//如果不实现这些协议，则会用默认的设置；

@optional
/**
 将要展示数据的时候，自定义设置cell的显示；不影响布局的外观设置
 
 @param cell LabelCell
 @param indexPath collectionView中的对应indexPath
 */
- (void)zx_labelsTagsView:(ZXLabelsTagsView *)labelsTagView willDisplayCell:(LabelCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;


/**
 自定义 点击添加label事件回调
 
 @param collectionView collectionView description
 @param indexPath indexPath description
 */
- (void)zx_labelsTagsView:(ZXLabelsTagsView *)labelsTagView collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end


// UICollectionViewCell对齐，等间距对齐

typedef NS_ENUM(NSInteger,UICollectionViewFlowLayoutEqualSpaceAlign) {
    
    //不支持固定间距对齐，使用系统的最小间距自动布局；
    UICollectionViewFlowLayoutAlignNoneEqualSpace = 0,
    //等间距左对齐
    UICollectionViewFlowLayoutEqualSpaceAlignLeft = 1,
    //等间距居中对齐
    UICollectionViewFlowLayoutEqualSpaceAlignCenter = 2,
    //等间距右对齐
    UICollectionViewFlowLayoutEqualSpaceAlignRight = 3
};


@interface ZXLabelsTagsView : UIView<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic, weak) id<ZXLabelsTagsViewDelegate>delegate;


@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataMArray;

// 设置collectionView的sectionInset; 默认UIEdgeInsetsMake(15, 15, 15, 15)
@property (nonatomic, assign) UIEdgeInsets sectionInset;

// item之间的间距;默认12.f
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;

// 行间距;默认12.f
@property (nonatomic, assign) CGFloat minimumLineSpacing;

// 最多可显示的标签数量，到达这个数，就不能再输入了，输入标签也会移除; 默认10
@property (nonatomic, assign) NSInteger maxItemCount;

// 设置标签的背景颜色;
@property (nonatomic, strong) UIColor *tagNormarBackgroudColor;

// 设置cell标签宽度是否随它的内容自适应：default NO;
@property (nonatomic, assign) BOOL apportionsItemWidthsByContent;

// item同样size的值；默认CGSizeMake(82.f, 30.f)；只有效于apportionsItemWidthsByContent = NO的时候；
@property (nonatomic, assign) CGSize itemSameSize;

// 字体大小；默认14
@property (nonatomic, assign) CGFloat titleFontSize;

// 设置选中某个item
@property (nonatomic, assign) NSInteger selectedIndex;

// 是否支持选中样式展现；默认NO；
@property (nonatomic, assign) BOOL cellSelectedStyle;


- (void)setData:(NSArray *)data;

//设置等间距对齐
- (void)setCollectionViewLayoutWithEqualSpaceAlign:(AlignType)collectionViewCellAlignType withItemEqualSpace:(CGFloat)equalSpace animated:(BOOL)animated;

/**
 获取整个collectionView需要的高度
 
 @param data 数组
 @return 高度
 */
- (CGFloat)getCellHeightWithContentData:(NSArray *)data;

/**
 2018.9.11新增
 获取整个collectionView需要的高度2;如果当前view是用dispatch_once重用的，则获取高度
 必须用此方法，时刻刷新；
 
 @param data 数组
 @return 高度
 */
- (CGFloat)getDispatchOnceCellHeightWithContentData:(NSArray *)data;
@end

NS_ASSUME_NONNULL_END


//////////////////－－－－－－例1－－－－－－－///////////////
#pragma mark - 例如 显示纯展示的推荐标签数组

/*

#import "BaseTableViewCell.h"
#import "ZXLabelsTagsView.h"

@interface AddProRecdLabelCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet ZXLabelsTagsView *labelsTagsView;
@end

 */


/*
#import "AddProRecdLabelCell.h"

@implementation AddProRecdLabelCell


- (void)awakeFromNib
{
    [super awakeFromNib];
    self.labelsTagsView.maxItemCount = 50;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setData:(id)data
{
    [self.labelsTagsView setData:data];
}

- (CGFloat)getCellHeightWithContentIndexPath:(NSIndexPath *)indexPath data:(id)data
{
    return [self.labelsTagsView getCellHeightWithContentData:data];
}
@end

*/

#pragma mark- tableViewController
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    if (indexPath.section ==3)
    {
        RecentlyFindLabCell *recentlyFindProCell = [tableView dequeueReusableCellWithIdentifier:reuse_recentlyFindCell forIndexPath:indexPath];
 
        if (self.purchaserModel.lastProducts.count>0)
        {
            [recentlyFindProCell setData:self.purchaserModel.lastProducts];
        }
        return recentlyFindProCell;
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==3)
    {
        static RecentlyFindLabCell *cell =  nil;
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            
            cell = [tableView dequeueReusableCellWithIdentifier:reuse_recentlyFindCell];
        });
        return [cell getCellHeightWithContentIndexPath:indexPath data:self.purchaserModel.lastProducts];
    }
    return UITableViewAutomaticDimension;
}
*/


//////////////////－－－－－－例2－－－－－－－///////////////
// tableFooterView,有订单的各种操作按钮，计算出需要的labelsTagsView的高度再调整整个高度；
// 其实按钮高度固定，操作栏高度固定，可以自己设置sectionInset来达到居中目的；

// 控制器
/*
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    static OrderCellFooterView *cell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        cell = (OrderCellFooterView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:reuse_FooterView];
    });
    CGFloat height = [cell getCellHeightWithContentData:[self.dataMArray objectAtIndex:section]];
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    OrderCellFooterView * footView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuse_FooterView];
    [footView setData:[self.dataMArray objectAtIndex:section]];
    [footView.moreBtn addTarget:self action:@selector(moreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    footView.moreBtn.tag = 200+section;
    footView.labelsTagsView.delegate = self;
    footView.labelsTagsView.tag = section;
    return footView;
}
*/
 
// tableFooterView:
/*
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.contentView.backgroundColor = WYUISTYLE.colorBGgrey;
    self.transFeeLab.adjustsFontSizeToFitWidth = YES;
    [self.moreBtn zh_centerHorizontalImageAndTitleWithTheirSpace:10.f];
    
    self.labelsTagsView.maxItemCount = 3;
    self.labelsTagsView.apportionsItemWidthsByContent = NO;
    self.labelsTagsView.sectionInset = UIEdgeInsetsMake(7.5, 15, 7.5, 15);
    [self.labelsTagsView setCollectionViewLayoutWithEqualSpaceAlign:AlignTypeRight withItemEqualSpace:10.f animated:NO];
}
- (void)setData:(id)data
{
    GetOrderManagerModel *model = (GetOrderManagerModel *)data;;
    self.numProDesLab.text = [NSString stringWithFormat:@"共计%@件产品 合计:",model.prodCount];
    
    self.finalPriceLab.text = model.finalPrice;
    self.transFeeLab.text = [NSString stringWithFormat:@"(含运费%@)",model.transFee];
    
    
    CGFloat moreViewHeight = model.showMore?45.f:0.f;
    [self.moreContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(moreViewHeight);
    }];
    self.moreContainerView.hidden = !model.showMore;
    
    NSMutableArray *titleArray = [NSMutableArray array];
    [model.buttons enumerateObjectsUsingBlock:^(OrderButtonModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [titleArray addObject:obj.name];
    }];
    CGFloat labelTagsHeiht = [self.labelsTagsView getCellHeightWithContentData:titleArray];
    [self.labelTagsContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(labelTagsHeiht);
        
    }];
    
    [self.labelsTagsView setData:titleArray];
}


//获取tableFooterView的高度
- (CGFloat)getCellHeightWithContentData:(id)data
{
    GetOrderManagerModel *model = (GetOrderManagerModel *)data;
    NSMutableArray *titleArray = [NSMutableArray array];
    [model.buttons enumerateObjectsUsingBlock:^(OrderButtonModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [titleArray addObject:obj.name];
    }];
    CGFloat labelTagsHeiht = [self.labelsTagsView getDispatchOnceCellHeightWithContentData:titleArray];
    
    if (!model.showMore)
    {
        return 45*2+10+labelTagsHeiht-45;
    }
    return 45*2+10+labelTagsHeiht;
}
*/


