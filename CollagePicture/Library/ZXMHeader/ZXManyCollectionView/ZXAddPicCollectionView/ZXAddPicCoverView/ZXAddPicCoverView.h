//
//  ZXAddPicCoverView.h
//  YiShangbao
//
//  Created by simon on 2017/12/1.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  2018.3.22 修改文字默认颜色

#import <UIKit/UIKit.h>

@interface ZXAddPicCoverView : UIView

@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+ (id)viewFromNib;
@end
