//
//  PrefectureSubViewB.m
//  MobileCaiLocal
//
//  Created by 朱新明 on 2019/10/31.
//  Copyright © 2019 timtian. All rights reserved.
//

#import "PrefectureSubViewB.h"

@implementation PrefectureSubViewB

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
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
        _nameLab.font = [UIFont zx_systemFontOfScaleSize:15 weight:UIFontWeightMedium];
        _nameLab.textColor = UIColorFromRGB_HexValue(0x34373A);
    }
    return _nameLab;
}

- (UILabel *)descriptionLab
{
    if (!_descriptionLab) {
        _descriptionLab = [[UILabel alloc] init];
        _descriptionLab.font = [UIFont zx_systemFontOfScaleSize:12];
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

- (UILabel *)originalPriceLab
{
    if (!_originalPriceLab) {
        _originalPriceLab = [[UILabel alloc] init];
        _originalPriceLab.font = [UIFont zx_systemFontOfScaleSize:10];
        _originalPriceLab.textColor = UIColorFromRGB_HexValue(0x93989E);
    }
    return _originalPriceLab;
}

- (UILabel *)salePriceLab
{
    if (!_salePriceLab) {
        _salePriceLab = [[UILabel alloc] init];
        _salePriceLab.font = [UIFont zx_systemFontOfScaleSize:12];
        _salePriceLab.textColor = UIColorFromRGB_HexValue(0xFF1919);
    }
    return _salePriceLab;
}

- (void)setUI
{
//     self.backgroundColor = [UIColor randomColor];
    [self addSubview:self.bigBgImageView];

    [self addSubview:self.nameLab];
    [self addSubview:self.descriptionLab];
    [self addSubview:self.photoImageView];
    
    [self addSubview:self.salePriceLab];
    [self addSubview:self.originalPriceLab];

    [self.bigBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.edges.mas_equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).with.offset(4);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(self.mas_right).with.offset(-10);
    make.width.mas_equalTo(self.photoImageView.mas_height).multipliedBy(1);
     }];

    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
         make.left.mas_equalTo(self.mas_left).with.offset(10);
         make.top.mas_equalTo(self.mas_top).with.offset(LCDScale_iPhone6(9));
    }];
    [self.descriptionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.mas_left).with.offset(10);
        make.centerY.mas_equalTo(self.photoImageView.mas_centerY);
        make.right.mas_greaterThanOrEqualTo(self.photoImageView.mas_left).with.offset(LCDScale_iPhone6(-6));

    }];
    
    [self.salePriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.mas_left).with.offset(10);
        make.bottom.mas_equalTo(self.mas_bottom).with.offset(LCDScale_iPhone6(-9));

    }];
    [self.originalPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.salePriceLab.mas_right).with.offset(5);
        make.lastBaseline.mas_equalTo(self.salePriceLab.mas_lastBaseline);
    }];
}

- (void)setData:(id)data
{
    HomePrefectureModelSubBanner *model = (HomePrefectureModelSubBanner *)data;
    self.nameLab.text = @"产地直达";
    self.nameLab.textColor = [NSString zhIsBlankString:model.nameColor]?UIColorFromRGB_HexValue(0x34373A):[UIColor zx_colorWithHexString:model.nameColor];
    self.descriptionLab.text = @"人气好货推荐";
    self.descriptionLab.textColor = [NSString zhIsBlankString:model.descriptionColor]?UIColorFromRGB_HexValue(0x93989E):[UIColor zx_colorWithHexString:model.descriptionColor];
    
    [self.bigBgImageView sd_setImageWithURL:[NSURL URLWithString:model.backgroundPhoto] placeholderImage:nil];

    HomePrefectureModelSubBannerSub *good = [model.goodsList firstObject];
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:good.photo] placeholderImage:nil];
    NSString *referencePrice=[NSString stringWithFormat:@"￥%@",good.referencePrice];
    self.originalPriceLab.attributedText = [NSAttributedString zx_addStrikethroughCenterWithString:referencePrice];
    self.salePriceLab.text =  [NSString stringWithFormat:@"¥%@",good.salePrice];
    
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
    self.originalPriceLab.hidden = self.photoImageView.hidden;
    self.salePriceLab.hidden = self.photoImageView.hidden;
    
    self.bigBgImageView.hidden = YES;
}

- (void)dispalyTypeB
{
    self.nameLab.hidden = YES;
    self.descriptionLab.hidden = self.nameLab.hidden;
    
    self.photoImageView.hidden = YES;
    self.originalPriceLab.hidden = self.photoImageView.hidden;
    self.salePriceLab.hidden = self.photoImageView.hidden;
    
    self.bigBgImageView.hidden = NO;
    
}

- (void)dispalyTypeC
{
    self.nameLab.hidden = YES;
    self.descriptionLab.hidden = self.nameLab.hidden;

    self.photoImageView.hidden = NO;
    self.originalPriceLab.hidden = self.photoImageView.hidden;
    self.salePriceLab.hidden = self.photoImageView.hidden;
    
    self.bigBgImageView.hidden = NO;
}
@end
