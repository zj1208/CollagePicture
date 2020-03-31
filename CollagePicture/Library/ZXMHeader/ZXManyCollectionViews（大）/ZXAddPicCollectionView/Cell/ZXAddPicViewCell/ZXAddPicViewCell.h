//
//  ZXAddPicViewCell.h
//  YiShangbao
//
//  Created by simon on 17/3/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  简介：展示图片+delete右上角按钮；可以设置圆角；根据配置的ZXAddPicCellBaseCoverView来显示需要的自定义覆盖View，展示区域等同于imageView的区域；
//       iOS12以下会默认每个item添加长按手势并重用；根据是否可以移动属性来设置长按手势是否有效；iOS12以上则不在cell添加手势这个方法；
//  注意：为何自定义cell无法添加手势？

//  5.16 修改自定义contentView覆盖view的frame展示区域；修改视图层级；
//  6.5 修改icon偏移；

#import <UIKit/UIKit.h>
#import "ZXPhoto.h"
#import "ZXAddPicCellBaseCoverView.h"
#import "ZXAddPicViewKit.h"

NS_ASSUME_NONNULL_BEGIN


@class ZXAddPicViewCell;

@protocol ZXAddPicViewCellDelegate <NSObject>

//@optional
//6.20 修改新增
- (void)zxAddPicViewCellDelegateWithLongPressAction:(UILongPressGestureRecognizer *)longPress;
@end


@interface ZXAddPicViewCell : UICollectionViewCell

///右上角删除角标按钮
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

///主图imageView；
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

/// 设置imageView的圆角大小
@property (assign, nonatomic) CGFloat imageViewCornerRadius;


/// 自定义遮图；---已经弃用
@property (weak, nonatomic) IBOutlet UIView *videoCoverView;
/// 自定义遮图；---已经弃用
@property (weak, nonatomic) IBOutlet UIImageView *coverIconImageView;

/// 设置代理
@property (nonatomic, weak) id<ZXAddPicViewCellDelegate>delegate;

/// 设置自定义遮图组件view；
@property (nonatomic, strong) ZXAddPicCellBaseCoverView *customCellCoverView;

/// 获取长按手势；可以通过方法是否有效；
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;


- (void)setData:(id)data indexPath:(NSIndexPath *)indexPath isContainVideo:(BOOL)flag;



/// 设置长按手势是否有效 /6.20 修改新增
- (void)setLongPressGestureRecognizersWithCanMoveItem:(BOOL)flag;
@end

NS_ASSUME_NONNULL_END
