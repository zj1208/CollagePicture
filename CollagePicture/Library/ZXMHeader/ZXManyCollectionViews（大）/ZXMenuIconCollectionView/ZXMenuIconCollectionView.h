//
//  ZXMenuIconCollectionView.h
//  YiShangbao
//
//  Created by simon on 2017/10/23.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  注释：collectionView菜单列表横向或纵向展示，每个item展示包含 主图片+图片正下方文字（可选的）+图片右上角的badge数字角标（可选的），可以计算出动态数量的item所需要的collectionView总高度；可以使用自定义Model数据数组+代理方法设置cell的UI数据，也可以使用默认ZXMunuIconModel+默认方法设置；
//  设置图片相同的宽高后,计算得出最小的UI安全显示宽度；如果有右上角的角标，计算宽度的方法会额外增加宽度；
//  self.menuIconCollectionView.itemSize = CGSizeMake(width,width+10);


//  2018.2.11; 优化组件；
//  2018.6.01; 增加裁剪；
//  2018.6.26; 增加设置icon图标大小属性；
//  7.18 增加item最小宽度属性=图标宽度+角标预留的位置，修改最小item间距=0；
//  2019.2.26  大修改；增加修改滚动方向属性，是否可以滚动属性；是否有角标属性；安全显示UI的cell的size；

#import <UIKit/UIKit.h>
#import "ZXMenuIconCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZXMenuIconCollectionViewDelegate,ZXMenuIconCollectionViewDelegateFlowLayout;

@interface ZXMenuIconCollectionView : UIView<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic, weak) id<ZXMenuIconCollectionViewDelegate>delegate;
@property (nonatomic, weak) id<ZXMenuIconCollectionViewDelegateFlowLayout> flowLayoutDelegate;


@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *collectionFlowLayout;


// 设置collectionView的sectionInset;UIEdgeInsetsMake(15, 15, 15, 15)
@property (nonatomic, assign) UIEdgeInsets sectionInset;

// item之间的间距;默认12；// 设置self.minimumInteritemSpacing是给item宽度计算用的，实际cell设置最小依然为0.2

@property (nonatomic, assign) CGFloat minimumInteritemSpacing;

// 行间距;默认12；
@property (nonatomic, assign) CGFloat minimumLineSpacing;

/**
 *  一个屏幕显示多少列；最好小于等于4列；
 */
@property (nonatomic, assign) NSInteger columnsCount;


// 设置item中的Icon图标正方形等边的宽高； 一行4个item时，最大值是默认的 LCDScale_iPhone6_Width(45.f)；
@property (nonatomic, assign) CGFloat iconSquareSideLength;


// 设置item的宽度，高度；
@property (nonatomic, assign) CGSize itemSize;

@property (nonatomic, strong, nullable) UIImage *placeholderImage;

// 设置是否可以滚动
@property(nonatomic,getter=isScrollEnabled) BOOL       scrollEnabled; 

// 设置滚动布局方向
@property (nonatomic) UICollectionViewScrollDirection scrollDirection; // default is UICollectionViewScrollDirectionVertical


// 自适应缩放宽度大小：计算出来后用于设置一个总宽度（比如屏幕宽度）下放几个的平均item宽度；
// 这个宽度是基于item最小宽度的基础上设置的,因为宽度设置小了，角标有可能显示不小；
// flag :设置是否有角标,这个值影响cell的最小安全宽度：safeBadgeMinimumItemWidth；
// iconEqualSideLength:图片的正方形边长
- (CGSize)getItemSafeSizeWithTotalWidth:(CGFloat)totalWidth columnsCount:(NSInteger)count sectionInset:(UIEdgeInsets)inset minimumInteritemSpacing:(CGFloat)minimumInteritemSpacing hasBadge:(BOOL)flag iconSquareSideLength:(CGFloat)iconEqualSideLength;



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


// 代理方法设置cell的数据；
- (void)zx_menuIconView:(ZXMenuIconCollectionView *)menuIconView cell:(ZXMenuIconCell *)cell forItemSetData:(id)data cellForItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 自定义 点击添加cell事件回调
 
 @param collectionView collectionView description
 @param indexPath indexPath description
 */
- (void)zx_menuIconView:(ZXMenuIconCollectionView *)menuIconView collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;


@end

NS_ASSUME_NONNULL_END


//举例1
/*
#import "BaseTableViewCell.h"
#import "ZXMenuIconCollectionView.h"

@interface MessageStackViewCell : BaseTableViewCell

@property (strong, nonatomic) ZXMenuIconCollectionView *menuIconCollectionView;

@end

*/

// 如果是sb注册的cell，则在awakeFromNib添加
/*
@implementation MessageStackViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.contentView addSubview:self.menuIconCollectionView];
}

- (ZXMenuIconCollectionView *)menuIconCollectionView
{
    if (!_menuIconCollectionView)
    {
        ZXMenuIconCollectionView *menuIconCollectionView = [[ZXMenuIconCollectionView alloc]init];
        menuIconCollectionView.columnsCount = 3;
        menuIconCollectionView.minimumInteritemSpacing = 5;
        
        CGFloat width = [menuIconCollectionView getItemAverageWidthInTotalWidth:LCDW columnsCount:menuIconCollectionView.columnsCount sectionInset:menuIconCollectionView.sectionInset minimumInteritemSpacing:menuIconCollectionView.minimumInteritemSpacing];
        menuIconCollectionView.itemSize = CGSizeMake(width,width-LCDScale_iPhone6_Width(20));
        
        menuIconCollectionView.placeholderImage = AppPlaceholderImage;
        _menuIconCollectionView = menuIconCollectionView;
    }
    return _menuIconCollectionView;
}


 - (void)setData:(id)data
 {
     NSArray *dataArray = (NSArray *)data;
     NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:dataArray.count];
     [data enumerateObjectsUsingBlock:^(MessageModelSub *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
     
     ZXMenuIconModel *model = [[ZXMenuIconModel alloc] init];
     model.icon = obj.typeIcon;
     model.title = obj.typeName;
     if (obj.num>0) {
     model.sideMarkType = SideMarkType_number;
     }else{
     model.sideMarkType = SideMarkType_none;
     }
     model.sideMarkValue = [NSString stringWithFormat:@"%@",@(obj.num)];
     [mArray addObject:model];
     }];
     [self.menuIconCollectionView setData:mArray];
 }

- (CGFloat)getCellHeightWithContentIndexPath:(NSIndexPath *)indexPath data:(id)data
{
    return [self.menuIconCollectionView getCellHeightWithContentData:data];
}
@end
 */

//例2:横向滚动例子
/*
class DiscoverHomeGameCell: UICollectionViewCell {
    
    lazy var menuIconCollectionView:ZXMenuIconCollectionView = {
        
        let menuIconCollectionView = ZXMenuIconCollectionView();
        menuIconCollectionView.columnsCount = 4;
        menuIconCollectionView.minimumInteritemSpacing = 20 * kScreenWidth/375;
        menuIconCollectionView.minimumLineSpacing = 20 * kScreenWidth/375;
        menuIconCollectionView.iconSquareSideLength = 64 * kScreenWidth/375;
        menuIconCollectionView.sectionInset = UIEdgeInsets(top: 0, left: 30 * kScreenWidth/375, bottom: 20, right: 30 * kScreenWidth/375);
        let size = menuIconCollectionView.getItemSafeSize(withTotalWidth: kScreenWidth, columnsCount: menuIconCollectionView.columnsCount, sectionInset: menuIconCollectionView.sectionInset, minimumInteritemSpacing: menuIconCollectionView.minimumInteritemSpacing,hasBadge:false,iconSquareSideLength: menuIconCollectionView.iconSquareSideLength);
        menuIconCollectionView.itemSize = CGSize(width: size.width, height: size.height);
        menuIconCollectionView.placeholderImage = AppPlaceholderImage;
        menuIconCollectionView.isScrollEnabled = true;
        menuIconCollectionView.scrollDirection = UICollectionView.ScrollDirection.horizontal;
        return menuIconCollectionView;
    }();
    
    override func awakeFromNib() {
        super.awakeFromNib();
        
        self.contentView.addSubview(self.menuIconCollectionView);
        self.menuIconCollectionView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
*/
//控制器
/*
extension DiscoverViewController :ZXMenuIconCollectionViewDelegate
{
    func zx_menuIconView(_ menuIconView: ZXMenuIconCollectionView, willDisplay cell: ZXMenuIconCell, forItemAt indexPath: IndexPath) {
        
        cell.titleLab?.font = UIFont.systemFont(ofSize: 12 * kScreenWidth/375);
        cell.iconImageView?.zx_setCornerRadius(8, borderWidth: 1, borderColor: nil);
    }
}
*/
