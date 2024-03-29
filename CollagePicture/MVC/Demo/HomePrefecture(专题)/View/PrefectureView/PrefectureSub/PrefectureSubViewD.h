//
//  PrefectureSubViewD.h
//  MobileCaiLocal
//
//  Created by 朱新明 on 2019/11/1.
//  Copyright © 2019 timtian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetDataProtocol.h"
#import "HomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrefectureSubViewD : UIView<SetDataProtoct>

@property (nonatomic, strong) UIImageView *bigBgImageView;

@property (nonatomic, strong) UILabel *nameLab;

@property (nonatomic, strong) UIImageView *preSuffIconImageView;

@property (nonatomic, strong) UILabel *descriptionLab;

@property (nonatomic, strong) UIImageView *photoImageView1;

@property (nonatomic, strong) UIImageView *photoImageView2;

@property (nonatomic, strong) UILabel *originalPriceLab;

@property (nonatomic, strong) UILabel *salePriceLab;

@property (nonatomic, strong) UILabel *originalPriceLab2;

@property (nonatomic, strong) UILabel *salePriceLab2;
@end

NS_ASSUME_NONNULL_END
