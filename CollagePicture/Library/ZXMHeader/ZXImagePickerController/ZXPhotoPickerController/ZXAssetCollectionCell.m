//
//  ZXAssetCollectionCell.m
//  FunLive
//
//  Created by simon on 2019/5/8.
//  Copyright © 2019 facebook. All rights reserved.
//

#import "ZXAssetCollectionCell.h"

@implementation ZXAssetCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUI];
    }
    return self;
}

- (void)setUI
{
    [self.contentView addSubview:self.imageView];
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        _imageView = imageView;
//        [self.contentView bringSubviewToFront:_selectImageView];
//        [self.contentView bringSubviewToFront:_bottomView];
    }
    return _imageView;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.imageView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    
}

@end
