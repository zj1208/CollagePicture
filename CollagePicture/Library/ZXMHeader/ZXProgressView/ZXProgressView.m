//
//  ZXProgressView.m
//  YiShangbao
//
//  Created by simon on 17/1/22.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXProgressView.h"

static CGFloat const ZXProgressHeight = 2;


@implementation ZXProgressView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initData];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initData];
    }
    return self;
}



- (void)initData
{
    self.progressHeight = ZXProgressHeight;
    self.cornerRaidius = NO;
}


- (void)setZxTrackImage:(UIImage *)zxTrackImage
{
    _zxTrackImage = zxTrackImage;
    UIImageView *trackImageView = [self.subviews lastObject];
    trackImageView.image = zxTrackImage;
}

- (void)setProgressHeight:(CGFloat)progressHeight
{
    _progressHeight = progressHeight;
    
    self.transform = CGAffineTransformIdentity;
    self.transform = CGAffineTransformMakeScale(1.f, _progressHeight/2);
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.cornerRaidius)
    {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = self.progressHeight/2;
        self.layer.borderWidth = 1.f;
        self.layer.borderColor =[UIColor clearColor].CGColor;
    }
    
    if (self.zxTrackImage)
    {
        UIImageView *trackImageView = [self.subviews lastObject];
        CGFloat width = CGRectGetWidth(self.frame)*self.progress;
        trackImageView.frame = CGRectMake(0, 0, width, CGRectGetHeight(self.frame));
    }
    if (self.zxProgressImage)
    {
        UIImageView *progressImageView = [self.subviews firstObject];
        progressImageView.frame =self.frame;
    }
}

- (void)setZxProgressImage:(UIImage *)zxProgressImage
{
    _zxProgressImage = zxProgressImage;
    UIImageView *progressImageView = [self.subviews firstObject];
    [progressImageView removeFromSuperview];
}

- (void)setProgress:(float)progress animated:(BOOL)animated
{
    if (self.zxTrackImage)
    {
        self.progress = progress;
        [self setNeedsLayout];
    }
    [super setProgress:progress animated:animated];
}


@end


