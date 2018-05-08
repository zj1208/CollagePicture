//
//  CustomCoverView.m
//  YiShangbao
//
//  Created by simon on 2018/5/3.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "CustomCoverView.h"

@implementation CustomCoverView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initContentView
{
    self =[super initContentView];
    if (self)
    {
        [self setUpView];
    }
    return self;
}

- (void)setUpView
{
//    self.backgroundColor = [UIColor redColor];
    UIView *alphaBgView = [[UIView alloc] init];
    alphaBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    [self addSubview:alphaBgView];
    self.alphaBgView = alphaBgView;
    self.alphaBgView.clipsToBounds = YES;
    
    [self addSubview:self.markImageView];
}

- (UIImageView *)markImageView
{
    if (!_markImageView)
    {
        _markImageView = [[UIImageView alloc] init];
    }
    return _markImageView;
}


- (void)refresh:(ZXPhoto *)data
{
    if (data.type == ZXAssetModelMediaTypeCustom)
    {
        self.hidden = NO;
        self.markImageView.image = [UIImage imageNamed:@"icon_produce"];
    }
    else if (data.type == ZXAssetModelMediaTypeVideo)
    {
        self.hidden = NO;
        self.markImageView.image = [UIImage imageNamed:@"photo_shexiang"];
    }
    else
    {
        self.markImageView.image = nil;
        self.hidden = YES;
    }
    [self.markImageView sizeToFit];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.alphaBgView.frame  = CGRectMake(0, CGRectGetHeight(self.bounds)-30, CGRectGetWidth(self.bounds), 30);
    
    self.markImageView.frame = CGRectMake(8, CGRectGetHeight(self.bounds)-(30-(30-CGRectGetHeight(self.markImageView.frame))/2), CGRectGetWidth(self.markImageView.frame), CGRectGetHeight(self.markImageView.frame));
}
@end
