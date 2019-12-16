//
//  UISearchBar+ZXCategory.h
//  MobileCaiLocal
//
//  Created by simon on 2019/11/12.
//  Copyright © 2019 com.Chs. All rights reserved.
//
//  iOS13之后UISearchBar增加UISearchTextField属性；
//  2019.11.19 改为只读属性


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UISearchBar (ZXCategory)

/// 获取textField
@property (nullable, nonatomic, readonly, strong) UITextField *zx_searchTextField;


/// 获取取消按钮
@property (nullable, nonatomic, readonly, strong) UIButton *zx_cancleButton;

@end

NS_ASSUME_NONNULL_END
