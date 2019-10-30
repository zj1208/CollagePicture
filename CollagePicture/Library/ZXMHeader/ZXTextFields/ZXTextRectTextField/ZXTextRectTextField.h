//
//  ZXTextRectTextField.h
//  YiShangbao
//
//  Created by simon on 2018/6/5.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

//  简介：当UITextField设置不是UITextBorderStyleRoundedRect椭圆矩形样式的时候，文字与边框没有边距，需要重写设置；
//  2019.10.29   增加textPositionAdjustment属性，可以移动文本的位置；

#import <UIKit/UIKit.h>

@interface ZXTextRectTextField : UITextField

/*
设置在textField背景中移动文本的位置;默认UIOffsetMake(8, 0);
 */
@property(nonatomic) UIOffset textPositionAdjustment;

@end
