//
//  ZXAssetCollectionCell.h
//  FunLive
//
//  Created by simon on 2019/5/8.
//  Copyright © 2019 facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXPHPhotoManager.h"

NS_ASSUME_NONNULL_BEGIN

@class ZXAssetModel;
@interface ZXAssetCollectionCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imageView;    


@property (nonatomic, strong) UIButton *selectPhotoButton;
@property (nonatomic, strong) ZXAssetModel *model;

@end

NS_ASSUME_NONNULL_END
