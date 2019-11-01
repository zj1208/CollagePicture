//
//  PrefectureCollectionCellTypeA.m
//  MobileCaiLocal
//
//  Created by 朱新明 on 2019/10/30.
//  Copyright © 2019 timtian. All rights reserved.
//

#import "PrefectureCollectionCellTypeA.h"

@implementation PrefectureCollectionCellTypeA


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

    [self.contentView addSubview:self.line_vertical];

    [self.contentView addSubview:self.line_horizontal];

    [self.line_vertical mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(@(1));
        make.top.mas_equalTo(self.contentView.mas_top);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);

    }];
    
    [self.line_horizontal mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(self.contentView.mas_right);
        make.left.mas_equalTo(self.line_vertical.mas_right);
        
        make.height.mas_equalTo(@(1));
        make.centerY.mas_equalTo(self.contentView.mas_centerY);

    }];
    
    [self.view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
         make.top.left.bottom.mas_equalTo(self.contentView);
         make.right.mas_equalTo(self.line_vertical.mas_left);
    }];
    
    [self.view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
         make.left.mas_equalTo(self.line_vertical.mas_right);
         make.right.mas_equalTo(self.contentView.mas_right);
         make.top.mas_equalTo(self.contentView.mas_top);
         make.bottom.mas_equalTo(self.line_horizontal.mas_top);
    }];
    [self.view3 mas_makeConstraints:^(MASConstraintMaker *make) {
         
          make.left.mas_equalTo(self.line_vertical.mas_right);
          make.right.mas_equalTo(self.contentView.mas_right);
          make.top.mas_equalTo(self.line_horizontal.mas_bottom);
          make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
}

- (UIView *)view1
{
    if (!_view1) {
        _view1 = [[PrefectureSubViewD alloc] init];
    }
    return _view1;
}
- (PrefectureSubViewB *)view2
{
    if (!_view2) {
        _view2 = [[PrefectureSubViewB alloc] init];
    }
    return _view2;
}
- (PrefectureSubViewB *)view3
{
    if (!_view3) {
        _view3 = [[PrefectureSubViewB alloc] init];
    }
    return _view3;
}

- (UIView *)line_vertical
{
    if (!_line_vertical) {
        _line_vertical = [[UIView alloc] init];
        _line_vertical.backgroundColor = UIColorFromRGB_HexValue(0xEEEEEE);
    }
    return _line_vertical;
}
- (UIView *)line_horizontal
{
    if (!_line_horizontal) {
        _line_horizontal = [[UIView alloc] init];
        _line_horizontal.backgroundColor = UIColorFromRGB_HexValue(0xEEEEEE);

    }
    return _line_horizontal;
}


- (void)setData:(id)data
{
    HomePrefectureModelSubBannerSub *good1 = [HomePrefectureModelSubBannerSub new];
    good1.photo = @"https://gw.alicdn.com/bao/upload/TB1jcNmk4z1gK0jSZSgXXavwpXa.jpg_Q75.jpg";
    good1.salePrice = @"10";
    good1.referencePrice = @"12";
    
    HomePrefectureModelSubBannerSub *good2 = [HomePrefectureModelSubBannerSub new];
    good2.photo = @"https://gw.alicdn.com/bao/upload/TB1jcNmk4z1gK0jSZSgXXavwpXa.jpg_Q75.jpg";
    good2.salePrice = @"8.5";
    good2.referencePrice = @"13.2";
    NSArray *arr1 = @[good1,good2];
    
    HomePrefectureModelSubBanner *model = [[HomePrefectureModelSubBanner alloc] init];
    model.displayType = @(1);
    model.backgroundPhoto = @"https://pics0.baidu.com/feed/10dfa9ec8a136327d96a02a65e470ce90afac7eb.jpeg?token=8213d60bb961523646d6005733d7830a&s=B02380BE14631AA42FB27B8B0300E09C";
    model.goodsList = arr1;
    model.suffIcon = @"123";
    model.preIcon = @"";
    
    [self.view1 setData:model];
    [self.view2 setData:model];
    
    HomePrefectureModelSubBanner *model1 = [[HomePrefectureModelSubBanner alloc] init];
    model1.displayType = @(1);
    model1.backgroundPhoto = @"https://pics0.baidu.com/feed/10dfa9ec8a136327d96a02a65e470ce90afac7eb.jpeg?token=8213d60bb961523646d6005733d7830a&s=B02380BE14631AA42FB27B8B0300E09C";
    model1.goodsList = arr1;
    
    [self.view3 setData:model1];
}
@end
