//
//  PrefectureSubViewA.h
//  MobileCaiLocal
//
//  Created by 朱新明 on 2019/10/31.
//  Copyright © 2019 timtian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetDataProtocol.h"
#import "HomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrefectureSubViewA : UIView<SetDataProtoct>

@property (nonatomic, strong) UILabel *nameLab;

@property (nonatomic, strong) UILabel *descriptionLab;

@property (nonatomic, strong) UIImageView *photoImageView;

@property (nonatomic, strong) UIImageView *bigBgImageView;

@end

NS_ASSUME_NONNULL_END
