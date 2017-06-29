//
//  ZXAddPicViewCell.h
//  YiShangbao
//
//  Created by simon on 17/3/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const nib_ZXAddPicViewCell = @"ZXAddPicViewCell";

@class ZXAddPicViewCell;

@protocol ZXAddPicViewCellDelegate <NSObject>

@optional
- (void)zxDidSingleImageClick:(ZXAddPicViewCell *)photoView; // 单击

@end


@interface ZXAddPicViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, weak) id<ZXAddPicViewCellDelegate>delegate;
@end
