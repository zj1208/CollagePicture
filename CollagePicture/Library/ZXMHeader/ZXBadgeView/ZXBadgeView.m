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
    UIImageView *dotView = [[UIImageView alloc] init];
    [self addSubview:dotView];
    self.dotImageView = dotView;
    self.dotImageView.image = [UIImage imageNamed:@"dot_red"];
    self.dotImageView.hidden = YES;
    self.badgeViewType = ZXBadgeViewTypeDot;

}

- (void)addImageView
{
    
}

- (void)setBadgeViewType:(ZXBadgeViewType)badgeViewType
{
    _badgeViewType = badgeViewType;
    if (_badgeViewType == ZXBadgeViewTypeDot)
    {
        self.dotImageView.hidden = NO;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.dotImageView.frame =self.bounds;
}
@end
