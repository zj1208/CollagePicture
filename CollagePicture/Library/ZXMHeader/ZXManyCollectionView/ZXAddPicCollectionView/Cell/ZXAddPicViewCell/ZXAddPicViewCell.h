//
//  ZXAddPicViewCell.h
//  YiShangbao
//
//  Created by simon on 17/3/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  展示图片+delete右上角按钮；可以设置圆角；根据配置的ZXAddPicBaseContentView来显示需要的自定义覆盖View，展示区域是避开delete按钮的区域；

#import <UIKit/UIKit.h>
#import "ZXPhoto.h"
#import "ZXAddPicBaseContentView.h"
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

@property (assign, nonatomic) CGFloat imageViewCornerRadius;


// 自定义遮图；---已经弃用
@property (weak, nonatomic) IBOutlet UIView *videoCoverView;
@property (weak, nonatomic) IBOutlet UIImageView *coverIconImageView;



@property (nonatomic, weak) id<ZXAddPicViewCellDelegate>delegate;

@property (nonatomic, strong) ZXPhoto *model;

@property (nonatomic, strong) ZXAddPicBaseContentView *customContentView;


- (void)setData:(ZXPhoto *)data;

@end

NS_ASSUME_NONNULL_END
