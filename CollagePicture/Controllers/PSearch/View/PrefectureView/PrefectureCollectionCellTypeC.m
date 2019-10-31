//
//  PrefectureCollectionCellTypeC.m
//  MobileCaiLocal
//
//  Created by 朱新明 on 2019/10/30.
//  Copyright © 2019 timtian. All rights reserved.
//

#import "PrefectureCollectionCellTypeC.h"

@implementation PrefectureCollectionCellTypeC

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI
{
    self.contentView.layer.cornerRadius = 10;
    self.contentView.backgroundColor = [UIColor whiteColor];

    [self.contentView addSubview:self.view1];
    [self.contentView addSubview:self.view2];

    [self.contentView addSubview:self.view3];

    [self.contentView addSubview:self.view4];

    [self.contentView addSubview:self.line_vertical];
    [self.contentView addSubview:self.line_horizontal];
    [self.contentView addSubview:self.line_vertical2];

    [self.line_vertical mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(@(1));
        make.top.mas_equalTo(self.contentView.mas_top);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);

    }];
    
    [self.line_horizontal mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(self.contentView.mas_right);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);

        make.height.mas_equalTo(@(1));
        make.centerY.mas_equalTo(self.contentView.mas_centerY);

    }];
    
    [self.line_vertical2 mas_makeConstraints:^(MASConstraintMaker *make) {
       
    make.right.mas_equalTo(self.contentView.mas_right).with.offset(LCDScale_iPhone6_Width(-89));
        make.width.mas_equalTo(@(1));
        make.top.mas_equalTo(self.line_horizontal.mas_bottom);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);

    }];
    
 
}


- (UIView *)view1
{
    if (!_view1) {
        _view1 = [[UIView alloc] init];
    }
    return _view1;
}
- (UIView *)view2
{
    if (!_view2) {
        _view2 = [[UIView alloc] init];
    }
    return _view2;
}
- (UIView *)view3
{
    if (!_view3) {
        _view3 = [[UIView alloc] init];
    }
    return _view3;
}

- (UIView *)view4
{
    if (!_view4) {
        _view4 = [[UIView alloc] init];
    }
    return _view4;
}

- (UIView *)line_vertical
{
    if (!_line_vertical) {
        _line_vertical = [[UIView alloc] init];
        _line_vertical.backgroundColor = UIColorFromRGB_HexValue(0xEEEEEE);
    }
    return _line_vertical;
}
- (UIView *)line_vertical2
{
    if (!_line_vertical2) {
        _line_vertical2 = [[UIView alloc] init];
        _line_vertical2.backgroundColor = UIColorFromRGB_HexValue(0xEEEEEE);
    }
    return _line_vertical2;
}
- (UIView *)line_horizontal
{
    if (!_line_horizontal) {
        _line_horizontal = [[UIView alloc] init];
        _line_horizontal.backgroundColor = UIColorFromRGB_HexValue(0xEEEEEE);

    }
    return _line_horizontal;
}
@end
