//
//  ZXHorizontalPageCollectionView.h
//  ZXPageDemo
//
//  Created by simon on 2018/1/30.
//  Copyright © 2018年 simon. All rights reserved.
//
// 简介：封装水平滚动的分页collectionView；基于重写UICollectionFlowLayout的ZXHorizontalPageFlowLayout；类似钉钉公司首页，饿了吗首页效果；
// 确保先设定collectionView的高度，这样ZXHorizontalPageFlowLayout才能计算出每个item的高度；
// 注意1：目前无法被重用；如果把这个类放到多个cell的重用中，会造成前后pageControl索引，scrollView偏移距离混乱；
// 注意2：item之间的间距=sectoinInsetLeft *2；这样在一页的时候2边边距看上去才会一样；

// 2018.2.5； 增加pageControl
// 2018.2.8； 优化功能；修改bug；


#import <UIKit/UIKit.h>
#import "ZXBadgeCollectionCell.h"
#import "ZXHorizontalPageFlowLayout.h"

NS_ASSUME_NONNULL_BEGIN



@protocol ZXHorizontalPageCollectionViewDelegate;

@interface ZXHorizontalPageCollectionView : UIView<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>


@property (nonatomic, weak) id<ZXHorizontalPageCollectionViewDelegate>delegate;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIPageControl *pageControl;


@property (nonatomic, strong) NSMutableArray *dataMArray;

// 设置collectionView的sectionInset;
@property (nonatomic, assign) UIEdgeInsets sectionInset;


// item之间的间距;默认12；
@property (nonatomic, assign) CGFloat interitemSpacing;

// 行间距;默认12；
@property (nonatomic, assign) CGFloat lineSpacing;


/**
 *  一个屏幕显示多少列；最好小于等于4列；
 */
@property (nonatomic, assign) NSInteger columnsCount;


/**
 *  最多显示多少行
 */
@property (nonatomic, assign) NSInteger maxRowCount;


@property (nonatomic, assign) CGSize itemSize;

@property (assign, nonatomic)  ZXHorizontalPageFlowLayout *collectionFlowLayout;

@property (nonatomic, strong, nullable) UIImage *placeholderImage;


// 自适应缩放宽度大小：计算出来后用于设置一个总宽度（比如屏幕宽度）下放几个的平均item宽度；
- (CGFloat)getItemAverageWidthInTotalWidth:(CGFloat)totalWidth columnsCount:(NSUInteger)count sectionInset:(UIEdgeInsets)inset minimumInteritemSpacing:(CGFloat)minimumInteritemSpacing
;


- (void)setData:(NSArray *)data;


/**
 获取整个collectionView需要的高度
 
 @param data 数组
 @return 高度
 */
- (CGFloat)getCellHeightWithContentData:(NSArray *)data;


/**
 滚动到第几页；

 @param index 第几页的索引
 @param animated 是否动画效果
 */
- (void)scrollToPageAtIndex:(NSInteger)index animated:(BOOL)animated;
@end



@protocol ZXHorizontalPageCollectionViewDelegate <NSObject>

// 如果不实现这些协议，则会用默认的设置；

@optional
/**
 将要展示数据的时候，自定义设置cell的显示；不影响布局的外观设置

 @param cell LabelCell
 @param indexPath collectionView中的对应indexPath
 */
- (void)zx_horizontalPageCollectionView:(ZXHorizontalPageCollectionView *)pageView willDisplayCell:(ZXBadgeCollectionCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;


/**
 自定义 点击添加cell事件回调
 
 @param collectionView collectionView description
 @param indexPath indexPath description
 */
- (void)zx_horizontalPageCollectionView:(ZXHorizontalPageCollectionView *)pageView collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;


@end


NS_ASSUME_NONNULL_END


//例如：
//controller ，控制器设置代理，回调代理；可设置cell外观；比如我在控制器中使用CollectionView设计页面；
/*
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section ==2)
    {
        PageItemCollectionCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:reuse_pageCell forIndexPath:indexPath];
        if (_shopHomeInfoModel.baseService.count>0)
        {
            cell.itemPageView.delegate = self;
            cell.itemPageView.tag = 200;
            [cell setData:_shopHomeInfoModel.baseService];
        }
        return cell;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==2)
    {
        if (_shopHomeInfoModel.baseService.count ==0)
        {
            return CGSizeMake(LCDW, 0.1);
        }
        PageItemCollectionCell *cell = [[PageItemCollectionCell alloc] init];
        CGFloat height =  [cell getCellHeightWithContentData:_shopHomeInfoModel.baseService];
        
        return CGSizeMake(LCDW, height);
    }
    return CGSizeMake(LCDW, 50);
}

#pragma mark -ZXHorizontalPageCollectionViewDelegate

- (void)zx_horizontalPageCollectionView:(ZXHorizontalPageCollectionView *)pageView willDisplayCell:(ZXBadgeCollectionCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    cell.imgViewLayoutWidth.constant = 30;
}

- (void)zx_horizontalPageCollectionView:(ZXHorizontalPageCollectionView *)pageView collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (pageView.tag ==200)
    {
        BadgeItemCommonModel *model = [_shopHomeInfoModel.baseService objectAtIndex:indexPath.item];
        [MobClick event:model.name];
        [[WYUtility dataUtil]routerWithName:model.url withSoureController:self];
    }
    else if (pageView.tag ==201)
    {
        BadgeItemCommonModel *model = [_shopHomeInfoModel.appendService objectAtIndex:indexPath.item];
        [MobClick event:model.name];
        [[WYUtility dataUtil]routerWithName:model.url withSoureController:self];
    }
}
*/

// 添加组件视图的view
/*
#import "PageItemCollectionCell.h"
#import "BadgeMarkItemModel.h"

@implementation PageItemCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        ZXHorizontalPageCollectionView *page = [[ZXHorizontalPageCollectionView alloc] init];
        page.maxRowCount = 2;
        page.columnsCount = 4;
        page.sectionInset = UIEdgeInsetsMake(0, 2, 12, 2);
        page.lineSpacing = 1.f;
        page.interitemSpacing = 4.f;
 
        CGFloat width = [page getItemAverageWidthInTotalWidth:LCDW columnsCount:page.columnsCount sectionInset:page.sectionInset minimumInteritemSpacing:page.interitemSpacing];
        page.itemSize = CGSizeMake(width, width-LCDScale_iPhone6_Width(12));
        [self.contentView addSubview:page];
        
        [page mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.mas_equalTo(self.contentView);
        }];
        self.itemPageView = page;
    }
    return self;
}


- (void)setData:(id)data
{
    NSArray *dataArray = (NSArray *)data;
    NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:dataArray.count];
    [data enumerateObjectsUsingBlock:^(BadgeItemCommonModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        BadgeMarkItemModel *model = [[BadgeMarkItemModel alloc] init];
        model.icon = obj.icon;
        model.desc = obj.desc;
        model.sideMarkType = obj.sideMarkType;
        model.sideMarkValue = obj.sideMarkValue;
        [mArray addObject:model];
    }];
    [self.itemPageView setData:mArray];
}

- (CGFloat)getCellHeightWithContentData:(id)data
{
    return [self.itemPageView getCellHeightWithContentData:data];
}
@end
*/
