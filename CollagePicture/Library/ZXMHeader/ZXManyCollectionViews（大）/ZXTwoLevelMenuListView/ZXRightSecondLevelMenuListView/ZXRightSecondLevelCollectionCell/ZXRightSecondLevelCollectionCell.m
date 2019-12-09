//
//  ZXRightSecondLevelCollectionCell.m
//  MobileCaiLocal
//
//  Created by simon on 2019/11/27.
//  Copyright © 2019 timtian. All rights reserved.
//

#import "ZXRightSecondLevelCollectionCell.h"
#import "UIColor+ZXHex.h"

@implementation ZXRightSecondLevelCollectionCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.titleLabel.layer.masksToBounds = YES;
    self.titleLabel.layer.cornerRadius = (5*[[UIScreen mainScreen] bounds].size.width)/375;
    [self.contentView addSubview:self.titleLabel];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = self.contentView.bounds;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    CGFloat fontSize = (12*[[UIScreen mainScreen] bounds].size.width)/375 ;
    if (selected) {
        self.titleLabel.textColor = [UIColor zx_colorWithHexString:@"#36B44D"];
        self.titleLabel.font = [UIFont systemFontOfSize:fontSize weight:UIFontWeightSemibold];
        self.titleLabel.backgroundColor = [UIColor colorWithRed:219/255.0 green:241/255.0 blue:223/255.0 alpha:1.0];
    }
    else
    {
        self.titleLabel.textColor = [UIColor zx_colorWithHexString:@"#34373A"];
        self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        self.titleLabel.backgroundColor = [UIColor colorWithRed:245/255.0 green:246/255.0 blue:247/255.0 alpha:1.0];
    }
}

@end
