//
//  PrefectureCollectionCellDelegate.h
//  MobileCaiLocal
//
//  Created by 朱新明 on 2019/11/5.
//  Copyright © 2019 timtian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCollectionViewCell.h"
#import "HomeModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol PrefectureCollectionCellDelegate <NSObject>

- (void)zx_prefectureCollectionCell:(BaseCollectionViewCell *)collectionViewCell didSelectItem:(HomePrefectureModelSubBanner *)bannerModel;

@end

NS_ASSUME_NONNULL_END
