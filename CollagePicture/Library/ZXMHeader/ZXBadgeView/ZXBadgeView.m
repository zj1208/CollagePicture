//
//  ZXBadgeView.m
//  YiShangbao
//
//  Created by simon on 2017/9/1.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXBadgeView.h"

@implementation ZXBadgeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self  = [super initWithFrame:frame];
    if (self)
    {
        [self setInitUI];
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self setInitUI];
    }
    return self;
}


- (void)setInitUI
{
    self.backgroundColor = [UIColor clearColor];
  
    [self addSubview:self.badgeImageView];
    self.badgeViewType = ZXBadgeViewTypeDot;

}

- (UIImageView *)badgeImageView
{
    if (!_badgeImageView)
    {
        UIImageView *badgeView = [[UIImageView alloc] init];
        badgeView.image = [UIImage imageNamed:@"dot_red"];
        badgeView.hidden = YES;
        _badgeImageView = badgeView;
    }
    return _badgeImageView;
}



- (void)setBadgeViewType:(ZXBadgeViewType)badgeViewType
{
    _badgeViewType = badgeViewType;
    if (_badgeViewType == ZXBadgeViewTypeDot)
    {
        self.badgeImageView.image = [UIImage imageNamed:@"dot_red"];
    }
    else if (_badgeViewType ==ZXBadgeViewTypeCustomDot)
    {
        
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.badgeImageView.frame =self.bounds;
}
@end
