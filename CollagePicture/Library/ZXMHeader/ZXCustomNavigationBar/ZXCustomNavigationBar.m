//
//  ZXCustomNavigationBar.m
//  YiShangbao
//
//  Created by simon on 2017/10/19.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXCustomNavigationBar.h"

@interface ZXCustomNavigationBar()


@end


@implementation ZXCustomNavigationBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.alpha = 1.f; //当前父视图必须是1，不能隐藏，不然导航上的按钮也看不到了;

    self.barBackgroundContainerView.backgroundColor = [UIColor whiteColor];
    [self.rightBarButton1 setTitle:nil forState:UIControlStateNormal];
    [self.rightBarButton2 setTitle:nil forState:UIControlStateNormal];
    [self.leftBarButton setTitle:nil forState:UIControlStateNormal];
    [self.leftBarButton setTitle:nil forState:UIControlStateHighlighted];
    [self zx_setBarBackgroundContainerAlpha:1.f animated:NO];
}


- (void)zx_setBarBackgroundContainerAlpha:(CGFloat)alpha animated:(BOOL)animated
{
    if (!animated)
    {
        _barBackgroundContainerView.alpha = alpha;
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            
            self.barBackgroundContainerView.alpha = alpha;
        }];
    }
}

- (void)zx_setBarBackgroundColor:(nullable UIColor *)backgroundColor
{
    self.barBackgroundImageView.backgroundColor = backgroundColor;
}

- (void)zx_setBarBackgroundImage:(nullable UIImage *)backgroundImage
{
    self.barBackgroundImageView.image = backgroundImage;
}
@end
