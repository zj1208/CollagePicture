//
//  ZXInfiniteCollectionCell.m
//  YiShangbao
//
//  Created by simon on 2017/8/22.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXInfiniteCollectionCell.h"

@implementation ZXInfiniteCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupImageView];
//        [self setupTitleLabel];
    }
    
    return self;
}



- (void)setupImageView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    _imageView = imageView;
    [self.contentView addSubview:imageView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _imageView.frame = self.bounds;

}

@end
