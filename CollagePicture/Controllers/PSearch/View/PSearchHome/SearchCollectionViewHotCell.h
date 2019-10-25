//
//  SearchCollectionViewHotCell.h
//  CollagePicture
//
//  Created by 朱新明 on 2019/10/24.
//  Copyright © 2019 simon. All rights reserved.
//

#import "BaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchCollectionViewHotCell : BaseCollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *hotIconImageView;

- (CGSize)sizeForCell;
@end

NS_ASSUME_NONNULL_END
