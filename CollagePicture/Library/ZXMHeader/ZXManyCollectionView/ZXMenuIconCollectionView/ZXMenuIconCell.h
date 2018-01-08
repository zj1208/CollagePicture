//
//  ZXMenuIconCell.h
//  YiShangbao
//
//  Created by simon on 2017/10/23.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

//   2018.1.8
//   修改ZXMenuIconCell实例方法；倒入MessageModel


@interface ZXMenuIconCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UILabel *badgeLab;

- (void)setData:(id)data placeholderImage:(UIImage *)placeholderImage;
@end
