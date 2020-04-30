//
//  CHSDistributionTastCollectionCell.h
//  MerchantBusinessClient
//
//  Created by simon on 2020/4/27.
//  Copyright © 2020 com.Chs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CHSDistributionTastCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UILabel *shopIdLabel;

@property (nonatomic, strong) UIButton *mapBtn;

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UILabel *timeLab;

@property (nonatomic, strong) UILabel *tastLab;
@property (nonatomic, strong) UIButton *tastDetaiBtn;

@property (nonatomic, strong) UILabel *locationLab;

//确认送达
@property (nonatomic, strong) UIButton *doBtn;
//电话联系
@property (nonatomic, strong) UIButton *callBtn;

- (void)setData:(id)data;
@end

NS_ASSUME_NONNULL_END
