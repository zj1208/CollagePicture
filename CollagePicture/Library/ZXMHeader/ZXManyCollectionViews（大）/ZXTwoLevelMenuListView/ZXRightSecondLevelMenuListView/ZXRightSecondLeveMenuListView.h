//
//  ZXRightSecondLeveMenuListView.h
//  MobileCaiLocal
//
//  Created by simon on 2019/11/27.
//  Copyright © 2019 timtian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@class ZXRightSecondLeveMenuListView;
@protocol ZXRightSecondLeveMenuListViewDataSource <NSObject>

@required
- (nullable NSString *)zx_rightSecondLeveMenuListView:(ZXRightSecondLeveMenuListView *)leftMenuListView titleForRowAtIndexPath:(nonnull NSIndexPath *)indexPath;

- (NSInteger)zx_rightSecondLeveMenuListView:(ZXRightSecondLeveMenuListView *)leftMenuListView numberOfRowsInSection:(NSInteger)section;

@end

@protocol ZXRightSecondLeveMenuListViewDelegate <NSObject>

@optional

- (BOOL)zx_rightSecondLeveMenuListView:(ZXRightSecondLeveMenuListView *)leftMenuListView isSelectItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)zx_rightSecondLeveMenuListView:(ZXRightSecondLeveMenuListView *)leftMenuListView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ZXRightSecondLeveMenuListView : UIView<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>



@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, weak) id<ZXRightSecondLeveMenuListViewDataSource>dataSource;
@property (nonatomic, weak) id<ZXRightSecondLeveMenuListViewDelegate>delegate;


@property (nonatomic) CGFloat minimumLineSpacing;
@property (nonatomic) CGFloat minimumInteritemSpacing;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) UIEdgeInsets sectionInset;


//@property (nonatomic, strong) NSIndexPath *lastSelectedRightSecondLevelIndexPath;


// 自适应缩放宽度大小：计算出来后用于设置一个总宽度（比如屏幕宽度）下放几个的平均item宽度；
- (CGFloat)getItemAverageWidthInTotalWidth:(CGFloat)totalWidth columnsCount:(NSUInteger)count sectionInset:(UIEdgeInsets)inset minimumInteritemSpacing:(CGFloat)minimumInteritemSpacing;
@end

NS_ASSUME_NONNULL_END
