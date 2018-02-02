//
//  ZXMenuIconCell.h
//  YiShangbao
//
//  Created by simon on 2017/10/23.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  注释：icon图标 +底部title； icon图左右边距是20，上边距12；下边距8；  title于底部边距大于等于8；

//  2018.1.8
//  修改ZXMenuIconCell实例方法；倒入MessageModel

#import <UIKit/UIKit.h>
//#import "MessageModel.h"




@interface ZXMenuIconCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UILabel *badgeLab;

- (void)setData:(id)data placeholderImage:(UIImage *)placeholderImage;
@end
