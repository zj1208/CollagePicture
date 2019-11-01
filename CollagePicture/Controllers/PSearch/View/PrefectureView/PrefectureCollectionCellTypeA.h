//
//  PrefectureCollectionCellTypeA.h
//  MobileCaiLocal
//
//  Created by 朱新明 on 2019/10/30.
//  Copyright © 2019 timtian. All rights reserved.
//

#import "BaseCollectionViewCell.h"
#import "PrefectureSubViewB.h"
#import "PrefectureSubViewD.h"
NS_ASSUME_NONNULL_BEGIN

@interface PrefectureCollectionCellTypeA : BaseCollectionViewCell

@property (nonatomic, strong) PrefectureSubViewD *view1;

@property (nonatomic, strong) PrefectureSubViewB *view2;

@property (nonatomic, strong) PrefectureSubViewB *view3;

@property (nonatomic, strong) UIView *line_vertical;

@property (nonatomic, strong) UIView *line_horizontal;

@end

NS_ASSUME_NONNULL_END
