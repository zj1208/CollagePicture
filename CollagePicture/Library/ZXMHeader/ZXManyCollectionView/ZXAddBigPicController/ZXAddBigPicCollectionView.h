//
//  ZXAddBigPicCollectionView.h
//  YiShangbao
//
//  Created by simon on 17/5/19.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXAddProPicCollectionCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZXAddBigPicCollectionViewDataSource <NSObject>

- (nullable NSMutableArray *)ZXAddBigPicCollectionViewSection1Marray;

- (nullable NSMutableArray *)ZXAddBigPicCollectionViewSection2Marray;

@end



@interface ZXAddBigPicCollectionView : UICollectionView<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,AddProductPicViewDelegate>



@property (nullable, nonatomic, copy) void(^uploadPicBtnActionBlock)(NSIndexPath *editPath);

@property (nullable, nonatomic, weak) id<ZXAddBigPicCollectionViewDataSource>zxdataSource;


@end

NS_ASSUME_NONNULL_END
