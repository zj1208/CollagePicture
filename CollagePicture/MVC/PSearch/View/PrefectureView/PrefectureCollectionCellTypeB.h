//
//  PrefectureCollectionCellTypeB.h
//  MobileCaiLocal
//
//  Created by 朱新明 on 2019/10/30.
//  Copyright © 2019 timtian. All rights reserved.
//

#import "BaseCollectionViewCell.h"
#import "PrefectureSubViewC.h"
#import "PrefectureCollectionCellDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrefectureCollectionCellTypeB : BaseCollectionViewCell

@property (nonatomic, strong) PrefectureSubViewC *view1;

@property (nonatomic, strong) PrefectureSubViewC *view2;

@property (nonatomic, strong) PrefectureSubViewC *view3;

@property (nonatomic, strong) PrefectureSubViewC *view4;

@property (nonatomic, strong) UIView *line_vertical;

@property (nonatomic, strong) UIView *line_horizontal;

@property (nonatomic, weak)id<PrefectureCollectionCellDelegate>delegate;
@property (nonatomic, strong) HomePrefectureModel *homeModel;
@end

NS_ASSUME_NONNULL_END
