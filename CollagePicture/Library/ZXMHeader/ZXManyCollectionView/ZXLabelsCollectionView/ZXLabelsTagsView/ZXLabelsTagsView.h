//
//  ZXLabelsTagsView.h
//  YiShangbao
//
//  Created by simon on 17/2/21.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//例子 看ZXLabelsInputTagsView的

#import <UIKit/UIKit.h>
#import "LabelCell.h"
#import "EqualSpaceFlowLayoutEvolve.h"

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

// 设置collectionView的sectionInset;
@property (nonatomic, assign) UIEdgeInsets sectionInset;

// item之间的间距;
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;

// 行间距;
@property (nonatomic, assign) CGFloat minimumLineSpacing;

// 最多可显示的标签数量，到达这个数，就不能再输入了，输入标签也会移除;
@property (nonatomic, assign) NSInteger maxItemCount;

// 添加tag标签的额外设置;
@property (nonatomic, strong) UIColor *tagBackgroudColor;

// 设置cell标签宽度是否随它的内容自适应：default NO;
@property (nonatomic, assign) BOOL apportionsItemWidthsByContent;

// item同样size的值；只有效于apportionsItemWidthsByContent = NO的时候；
@property (nonatomic, assign) CGSize itemSameSize;

// 字体大小
@property (nonatomic, assign) CGFloat titleFontSize;

// 设置选中某个item
@property (nonatomic, assign) NSInteger selectedIndex;

// 是否支持选中样式展现
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

@end



//////////////////－－－－－－例如－－－－－－－///////////////
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
    self.labelsTagsView.maxItemCount = 50;
    [super awakeFromNib];
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
        recentlyFindProCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
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
 
