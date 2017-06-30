//
//  ZXAddPicViewCell.m
//  YiShangbao
//
//  Created by simon on 17/3/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXAddPicViewCell.h"

@implementation ZXAddPicViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.deleteBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
//    [self.deleteBtn setBackgroundColor:[UIColor blueColor]];
    
    self.imageView.contentMode =UIViewContentModeScaleAspectFill;
    [self setView:self.imageView cornerRadius:5.f borderWidth:0.5f borderColor:UIColorFromRGB_HexValue(0xE8E8E8)];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDidClicked:)];
    [self.imageView addGestureRecognizer:singleTap];

}


// 单击手势
- (void)imageDidClicked:(UITapGestureRecognizer *)sender
{
    if ([self.delegate respondsToSelector:@selector(zxDidSingleImageClick:)]) { // 自定义 自己管理点击事件
        [self.delegate zxDidSingleImageClick:self];
        return;
    }
}

- (void)setView:(UIView *)view cornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color
{
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = radius;
    view.layer.borderWidth = width;
    
    view.layer.borderColor =color?[color CGColor]:[UIColor clearColor].CGColor;
}

@end
