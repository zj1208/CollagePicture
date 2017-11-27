 //
//  ZXAddProPicView.h
//  YiShangbao
//
//  Created by simon on 17/2/17.
//  Copyright © 2017年 com.Microants. All rights reserved.
//  添加商铺图片的子view

#import <UIKit/UIKit.h>

@protocol AddProductPicViewDelegate <NSObject>

- (void)zxDeleteBtnAction:(UIButton *)sender;

@end


static NSString *AddProductPicViewNib = @"ZXAddProPicView";

@interface ZXAddProPicView : UIView

@property (nonatomic, weak)id<AddProductPicViewDelegate>delegate;

//白色区域的图片按钮
@property (weak, nonatomic) IBOutlet UIButton *picBtn;

//包括文本／图标的小容器view;
@property (weak, nonatomic) IBOutlet UIView *origContainerView;
//文本提示
@property (weak, nonatomic) IBOutlet UILabel *origTitleLab;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;



- (IBAction)deleteBtnAction:(UIButton *)sender;

@end
