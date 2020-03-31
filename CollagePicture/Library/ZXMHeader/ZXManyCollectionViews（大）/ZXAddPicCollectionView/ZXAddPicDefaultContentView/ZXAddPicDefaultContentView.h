//
//  ZXAddPicDefaultContentView.h
//  YiShangbao
//
//  Created by simon on 2017/12/1.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  简介：上传图片UI组件的默认显示View；添加图片Button+提示文本titleLabel，可以调节间距；
//  2018.3.22 修改文字默认颜色
//  2018.4.26 修改titleLab边距
//  2020.03.17  增加动态设置属性。

#import <UIKit/UIKit.h>

@interface ZXAddPicDefaultContentView : UIView

@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/// addButton与父视图右间距
@property (nonatomic, assign) CGFloat addButtonToSupTopSpace;
/// addButton与父视图左间距
@property (nonatomic, assign) CGFloat addButtonToSupLeftSpace;

/// titleLab的左边间距约束设置
@property (nonatomic, assign) CGFloat titleLabToAddButtonLeading;

+ (id)viewFromNib;
@end
