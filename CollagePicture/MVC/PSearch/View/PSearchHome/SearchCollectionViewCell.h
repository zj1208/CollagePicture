//
//  SearchCollectionViewCell.h
//  CollagePicture
//
//  Created by 朱新明 on 2019/10/24.
//  Copyright © 2019 simon. All rights reserved.
//

#import "BaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchCollectionViewCell : BaseCollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

- (CGSize)sizeForCell;
@end

NS_ASSUME_NONNULL_END
