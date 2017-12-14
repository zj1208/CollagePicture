//
//  ZXAddPicPlaceholderCell.m
//  YiShangbao
//
//  Created by simon on 2017/12/12.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXAddPicPlaceholderCell.h"

#ifndef AppPlaceholderImage
#define AppPlaceholderImage [UIImage imageNamed:@"zxPhoto_addImage"]
#endif


@implementation ZXAddPicPlaceholderCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.contentMode =UIViewContentModeScaleAspectFill;
        [self setView:imageView cornerRadius:5.f borderWidth:0.5f borderColor:UIColorFromRGB_HexValue(0xE8E8E8)];
        imageView.image =  AppPlaceholderImage;
        [self addConstraint:imageView toItem:self.contentView];
        [self.contentView addSubview:imageView];
        self.imageView = imageView;
        
//        self.contentView.backgroundColor = [UIColor orangeColor];
    }
    return self;
}

- (void)addConstraint:(UIView *)item toItem:(UIView *)superView
{
    item.translatesAutoresizingMaskIntoConstraints = NO;
    //top 间距
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1 constant:10];
    [superView addConstraint:constraint1];
    //Y的center
    NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterY multiplier:1 constant:5];
    [superView addConstraint:constraint2];
    
    //右间距
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeRight multiplier:1 constant:-10];
    [superView addConstraint:constraint3];
    
    //x的center
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterX multiplier:1 constant:-5];
    [superView addConstraint:constraint4];
    
}


- (void)setView:(UIView *)view cornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color
{
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = radius;
    view.layer.borderWidth = width;
    
    view.layer.borderColor =color?[color CGColor]:[UIColor clearColor].CGColor;
}

@end
