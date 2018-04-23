//
//  ZXAddPicViewCell.h
//  YiShangbao
//
//  Created by simon on 17/3/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  2017.12.13

#import <UIKit/UIKit.h>
#import "ZXPhoto.h"
#import "ZXAddPicViewContentView.h"
#import "ZXAddPicViewKit.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const nib_ZXAddPicViewCell = @"ZXAddPicViewCell";

@class ZXAddPicViewCell;

@protocol ZXAddPicViewCellDelegate <NSObject>

//@optional
//- (void)zxDidSingleImageClick:(ZXAddPicViewCell *)photoView; // 单击

@end


@interface ZXAddPicViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

// 视频遮图；
@property (weak, nonatomic) IBOutlet UIView *videoCoverView;
@property (weak, nonatomic) IBOutlet UIImageView *coverIconImageView;

@property (nonatomic, weak) id<ZXAddPicViewCellDelegate>delegate;

@property (nonatomic, strong) ZXPhoto *model;

@property (nonatomic, strong) ZXAddPicViewContentView *bubbleView;


- (void)setData:(ZXPhoto *)data;

@end

NS_ASSUME_NONNULL_END
