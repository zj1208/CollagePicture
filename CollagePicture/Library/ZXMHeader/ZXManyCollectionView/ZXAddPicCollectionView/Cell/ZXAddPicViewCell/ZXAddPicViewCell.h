//
//  ZXAddPicViewCell.h
//  YiShangbao
//
//  Created by simon on 17/3/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  展示图片+delete右上角按钮；可以设置圆角；根据配置的ZXAddPicBaseContentView来显示需要的自定义覆盖View，展示区域等同于imageView的区域；
//  注意：为何自定义cell无法添加手势？

//  5.16 修改自定义contentView覆盖view的frame展示区域；修改视图层级；
//  6.5 修改icon偏移；

#import <UIKit/UIKit.h>
#import "ZXPhoto.h"
#import "ZXAddPicBaseContentView.h"
#import "ZXAddPicViewKit.h"


NS_ASSUME_NONNULL_BEGIN

static NSString *const nib_ZXAddPicViewCell = @"ZXAddPicViewCell";

@class ZXAddPicViewCell;

@protocol ZXAddPicViewCellDelegate <NSObject>

//@optional
//6.20 修改新增
- (void)zxLongPressAction:(UILongPressGestureRecognizer *)longPress;
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

@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;

- (void)setData:(ZXPhoto *)data indexPath:(NSIndexPath *)indexPath isContainVideo:(BOOL)flag;

// 设置手势/6.20 修改新增
- (void)makeGestureRecognizersWithCanMoveItem:(BOOL)flag;
@end

NS_ASSUME_NONNULL_END
