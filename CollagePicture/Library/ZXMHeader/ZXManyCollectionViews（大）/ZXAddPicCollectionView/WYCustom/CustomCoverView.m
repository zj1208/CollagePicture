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
//    高度30的半透明遮图
    UIView *alphaBgView = [[UIView alloc] init];
    alphaBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    [self addSubview:alphaBgView];
    self.alphaBgView = alphaBgView;
    self.alphaBgView.clipsToBounds = YES;
    
//    标记
    [self addSubview:self.markImageView];
    
    [self addSubview:self.markMainLab];
    
    [self addSubview:self.alphaCoverView];
}

- (UIView *)alphaCoverView
{
    if (!_alphaCoverView) {
        
        _alphaCoverView = [[UIView alloc] init];
        _alphaCoverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _alphaCoverView.clipsToBounds = YES;

        _alphaCoverView.hidden = YES;
    }
    return _alphaCoverView;
}

- (UIImageView *)markImageView
{
    if (!_markImageView)
    {
        _markImageView = [[UIImageView alloc] init];
    }
    return _markImageView;
}

- (UILabel *)markMainLab
{
    if (!_markMainLab)
    {
        _markMainLab = [[UILabel alloc] init];
        _markMainLab.font = [UIFont systemFontOfSize:13];
        _markMainLab.backgroundColor = [UIColor clearColor];
        _markMainLab.textColor = [UIColor whiteColor];
        _markMainLab.textAlignment = NSTextAlignmentCenter;
        _markMainLab.text = NSLocalizedString(@"主图", nil);
    }
    return _markMainLab;
}

// 因为有些自定义遮罩 要展示，有些

- (void)refresh:(ZXPhoto *)data indexPath:(nonnull NSIndexPath *)indexPath isContainVideo:(BOOL)flag
{
    if (data.type == ZXAssetModelMediaTypeCustom)
    {
        self.hidden = NO;
        self.markImageView.image = [UIImage imageNamed:@"icon_produce"];
        self.markImageView.hidden = NO;
        self.markMainLab.hidden = !self.markImageView.hidden;
    }
    else if (data.type == ZXAssetModelMediaTypeVideo)
    {
        self.hidden = NO;
        self.markImageView.image = [UIImage imageNamed:@"photo_shexiang"];
        self.markImageView.hidden = NO;
        self.markMainLab.hidden = !self.markImageView.hidden;
    }
    else if (data.type == ZXAssetModelMediaTypePhoto)
    {
        if ((flag && indexPath.item ==1) || (!flag && indexPath.item ==0))
        {
            self.hidden = NO;
            self.markImageView.hidden = YES;
            self.markMainLab.hidden = !self.markImageView.hidden;
        }
        else
        {
            self.markImageView.image = nil;
            self.hidden = YES;
        }
    }
 
    [self.markImageView sizeToFit];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.alphaBgView.frame  = CGRectMake(0, CGRectGetHeight(self.bounds)-30, CGRectGetWidth(self.bounds), 30);
    
    self.alphaCoverView.frame  = self.bounds;

    
    self.markMainLab.frame = self.alphaBgView.frame;
    
    self.markImageView.frame = CGRectMake(8, CGRectGetHeight(self.bounds)-(30-(30-CGRectGetHeight(self.markImageView.frame))/2), CGRectGetWidth(self.markImageView.frame), CGRectGetHeight(self.markImageView.frame));
}
@end
