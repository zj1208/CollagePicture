//
//  SearchCollectionHistoryCell.h
//  CollagePicture
//
//  Created by 朱新明 on 2019/10/25.
//  Copyright © 2019 simon. All rights reserved.
//

#import "BaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchCollectionHistoryCell : BaseCollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

- (CGSize)sizeForCell;

@end

NS_ASSUME_NONNULL_END
