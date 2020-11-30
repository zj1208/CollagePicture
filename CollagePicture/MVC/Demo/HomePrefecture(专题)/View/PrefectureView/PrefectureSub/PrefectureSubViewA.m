//
//  PrefectureSubViewA.m
//  MobileCaiLocal
//
//  Created by 朱新明 on 2019/10/31.
//  Copyright © 2019 timtian. All rights reserved.
//

#import "PrefectureSubViewA.h"

@implementation PrefectureSubViewA
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (UILabel *)nameLab
{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        _nameLab.textColor = UIColorFromRGB_HexValue(0x34373A);
    }
    return _nameLab;
}

- (UILabel *)descriptionLab
{
    if (!_descriptionLab) {
        _descriptionLab = [[UILabel alloc] init];
        _descriptionLab.font = [UIFont systemFontOfSize:12];
        _descriptionLab.textColor = UIColorFromRGB_HexValue(0x93989E);
    }
    return _descriptionLab;
}

- (UIImageView *)photoImageView
{
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc] init];
        _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _photoImageView.clipsToBounds = YES;
    }
    return _photoImageView;
}

- (UIImageView *)bigBgImageView
{
    if (!_bigBgImageView) {
        _bigBgImageView = [[UIImageView alloc] init];
        _bigBgImageView.contentMode =UIViewContentModeScaleAspectFill;
        _bigBgImageView.clipsToBounds = YES;
    }
    return _bigBgImageView;
}

- (void)setUI
{
//    self.backgroundColor = [UIColor randomColor];
    [self addSubview:self.bigBgImageView];

    [self addSubview:self.nameLab];
    [self addSubview:self.descriptionLab];
    [self addSubview:self.photoImageView];
    
    [self.bigBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
     }];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.mas_left).with.offset(9);
        make.top.mas_equalTo(self.mas_top).with.offset(11);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    [self.descriptionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.mas_left).with.offset(9);
        make.right.mas_equalTo(self.mas_right).with.offset(-6);
        make.top.mas_equalTo(self.nameLab.mas_bottom).with.offset(LCDScale_iPhone6(3));
    }];
     
     [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
         
          make.left.mas_equalTo(self.mas_left).with.offset(9);
          make.right.mas_equalTo(self.mas_right).with.offset(-8);
          make.bottom.mas_equalTo(self.mas_bottom).with.offset(-12);
          make.height.mas_equalTo(self.photoImageView.mas_width).multipliedBy(1);
      }];
}

- (void)setData:(id)data
{
    HomePrefectureModelSubBanner *model = (HomePrefectureModelSubBanner *)data;
    self.nameLab.text = @"产地直达";
    self.nameLab.textColor = [NSString zx_isBlankString:model.nameColor]?UIColorFromRGB_HexValue(0x34373A):[UIColor zx_colorWithHexString:model.nameColor];
    self.descriptionLab.text = @"人气好货推荐";
    self.descriptionLab.textColor = [NSString zx_isBlankString:model.descriptionColor]?UIColorFromRGB_HexValue(0x93989E):[UIColor zx_colorWithHexString:model.descriptionColor];
    
    [self.bigBgImageView sd_setImageWithURL:[NSURL URLWithString:model.backgroundPhoto] placeholderImage:nil];

    HomePrefectureModelSubBannerSub *good = [model.goodsList firstObject];
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:good.photo] placeholderImage:nil];
    
    NSNumber *dispalyType = model.displayType;
    if ([dispalyType isEqualToNumber:@(1)]) {
        [self dispalyTypeA];
    }
    else if ([dispalyType isEqualToNumber:@(2)])
    {
        [self dispalyTypeB];
    }else
    {
        [self dispalyTypeC];
    }
}

- (void)dispalyTypeA
{
    self.nameLab.hidden = NO;
    self.descriptionLab.hidden = self.nameLab.hidden;
    
    self.photoImageView.hidden = NO;
    
    self.bigBgImageView.hidden = YES;
}

- (void)dispalyTypeB
{
    self.nameLab.hidden = YES;
    self.descriptionLab.hidden = self.nameLab.hidden;

    self.photoImageView.hidden = YES;
    
    self.bigBgImageView.hidden = NO;
    
}

- (void)dispalyTypeC
{
    self.nameLab.hidden = YES;
    self.descriptionLab.hidden = self.nameLab.hidden;

    self.photoImageView.hidden = NO;
    
    self.bigBgImageView.hidden = NO;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
