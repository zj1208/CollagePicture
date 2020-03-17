//
//  AlertChoseTableViewCell.h
//  MobileCaiLocal
//
//  Created by 朱新明 on 2020/2/14.
//  Copyright © 2020 com.Chs. All rights reserved.
//
//  简介：cell:左边一个选中非选中按钮 + 右边文本

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlertChoseTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
