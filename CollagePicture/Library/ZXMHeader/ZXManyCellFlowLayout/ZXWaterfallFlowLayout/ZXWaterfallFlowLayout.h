//
//  ZXWaterfallFlowLayout.h
//  lovebaby
//
//  Created by simon on 16/5/6.
//  Copyright © 2016年 simon. All rights reserved.
//
// 2017.12.27
// 注释添加

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXWaterfallFlowLayout;

@protocol ZXWaterfallFlowLayoutDelegate <NSObject>


// 根据item宽度 获取比例高度
- (CGFloat)waterflowLayout:(ZXWaterfallFlowLayout *)waterflowLayout referenceHeightForItemOfWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath;

@optional
/**
 *  瀑布流获取header的size
 *
 *  @param waterflowLayout waterflowLayout description
 *  @param section         section description
 *
 *  @return return value description
 */
- (CGSize)waterflowLayout:(ZXWaterfallFlowLayout *)waterflowLayout referenceSizeForHeaderInSection:(NSInteger)section;

/** 
 *  是否限制indexPath的高度
 *
 *  @param waterflowLayout waterflowLayout description
 *  @param indexPath       indexPath description
 *
 *  @return return value description
 */
- (BOOL)waterflowLayout:(ZXWaterfallFlowLayout *)waterflowLayout limitItemHeightAtIndexPath:(NSIndexPath *)indexPath;

@end



@interface ZXWaterfallFlowLayout : UICollectionViewFlowLayout


/**
 *  显示多少列
 */
@property (nonatomic, assign) NSInteger columnsCount;

/**
 *  边距
 */
//@property (nonatomic,assign) UIEdgeInsets sectionInset;

/**
 *  每一行之间的间距
 */
@property (nonatomic, assign) CGFloat rowMargin;

/**
 *  每一列之间的间距
 */
@property (nonatomic, assign) CGFloat columnMargin;


@property (nonatomic, weak) id<ZXWaterfallFlowLayoutDelegate>delegate;

@property (nonatomic) BOOL limitItemHeight;

@end

NS_ASSUME_NONNULL_END

/**
 - (void)addCollectionView
 {
 self.layout.columnMargin = 2;
 self.layout.columnsCount = 2;
 self.layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
 self.layout.rowMargin = 2;
 self.layout.delegate = self;
 }
 
 - (CGFloat)waterflowLayout:(ZXWaterfallFlowLayout *)waterflowLayout referenceHeightForItemOfWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath
 {
    ThemeListModel *model = [self.dataMArray objectAtIndex:indexPath.item];
    //    NSLog(@"width =%f",width);
    return model.height * width/ model.width ;
 }

 - (CGFloat)waterflowLayout:(ZXWaterfallFlowLayout *)waterflowLayout referenceHeightForItemOfWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath
 {
    if (indexPath.item ==0)
    {
        return (79*width)/159;
    }
    YZModel *model = [self.dataMArray objectAtIndex:(indexPath.item-1)];
    //    NSLog(@"width =%f",width);
    return model.h * width/ model.w ;
 }
 - (CGSize)waterflowLayout:(ZXWaterfallFlowLayout *)waterflowLayout referenceSizeForHeaderInSection:(NSInteger)section
 {
 return CGSizeMake(LCDW, 100);
 }

 */
