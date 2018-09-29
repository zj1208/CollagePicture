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
        [self.contentView addSubview:imageView];
        self.imageView = imageView;
        [self addConstraint:imageView toItem:self.contentView];
        
//        self.contentView.backgroundColor = [UIColor orangeColor];
    }
    return self;
}

- (void)addConstraint:(UIView *)item toItem:(UIView *)superView
{
    item.translatesAutoresizingMaskIntoConstraints = NO;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)
    {
        UILayoutGuide *layoutGuide_superView = superView.layoutMarginsGuide;
        //   “thisAnchor = otherAnchor+constant”
        //   （1）view的topAnchor = superView的topAnchor+constant；
        NSLayoutConstraint *constraint_top = [item.topAnchor constraintEqualToAnchor:layoutGuide_superView.topAnchor constant:-8+10];
        //   （2）view的centerYAnchor = superView的CenterYAnchor+constant；
        NSLayoutConstraint *constraint_centerY = [item.centerYAnchor constraintEqualToAnchor:layoutGuide_superView.centerYAnchor constant:5];
        NSLayoutConstraint *constraint_leading = [item.leadingAnchor constraintEqualToAnchor:layoutGuide_superView.leadingAnchor constant:-8];
        NSLayoutConstraint *constraint_trailing = [item.trailingAnchor constraintEqualToAnchor:layoutGuide_superView.trailingAnchor constant:8-10];
        [NSLayoutConstraint activateConstraints:@[constraint_top,constraint_centerY,constraint_leading,constraint_trailing]];
    }
    else
    {
        //top 间距
        NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1 constant:10];
        constraint1.active = YES;
        //Y的center
        NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterY multiplier:1 constant:5];
        constraint2.active = YES;
        //右间距
        NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeRight multiplier:1 constant:-10];
        constraint3.active = YES;
        //x的center
        NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterX multiplier:1 constant:-5];
        constraint4.active = YES;
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
