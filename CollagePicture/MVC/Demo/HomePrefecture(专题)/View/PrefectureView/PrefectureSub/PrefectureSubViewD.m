//
//  PrefectureSubViewD.m
//  MobileCaiLocal
//
//  Created by 朱新明 on 2019/11/1.
//  Copyright © 2019 timtian. All rights reserved.
//

#import "PrefectureSubViewD.h"

@implementation PrefectureSubViewD

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

- (UIImageView *)photoImageView1
{
    if (!_photoImageView1) {
        _photoImageView1 = [[UIImageView alloc] init];
        _photoImageView1.contentMode = UIViewContentModeScaleAspectFill;
        _photoImageView1.clipsToBounds = YES;
    }
    return _photoImageView1;
}

- (UIImageView *)photoImageView2
{
    if (!_photoImageView2) {
        _photoImageView2 = [[UIImageView alloc] init];
        _photoImageView2.contentMode = UIViewContentModeScaleAspectFill;
        _photoImageView2.clipsToBounds = YES;
    }
    return _photoImageView2;
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

- (UIImageView *)preSuffIconImageView
{
    if (!_preSuffIconImageView) {
        _preSuffIconImageView = [[UIImageView alloc] init];
        _preSuffIconImageView.contentMode =UIViewContentModeScaleAspectFit;
        _preSuffIconImageView.clipsToBounds = YES;
    }
    return _preSuffIconImageView;
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

- (UILabel *)originalPriceLab2
{
    if (!_originalPriceLab2) {
        _originalPriceLab2 = [[UILabel alloc] init];
        _originalPriceLab2.font = [UIFont zx_systemFontOfScaleSize:10];
        _originalPriceLab2.textColor = UIColorFromRGB_HexValue(0x93989E);
    }
    return _originalPriceLab2;
}

- (UILabel *)salePriceLab2
{
    if (!_salePriceLab2) {
        _salePriceLab2 = [[UILabel alloc] init];
        _salePriceLab2.font = [UIFont zx_systemFontOfScaleSize:12];
        _salePriceLab2.textColor = UIColorFromRGB_HexValue(0xFF1919);
    }
    return _salePriceLab2;
}
- (void)setUI
{
//     self.backgroundColor = [UIColor randomColor];
    [self addSubview:self.bigBgImageView];

    [self addSubview:self.nameLab];
    [self addSubview:self.descriptionLab];
    [self addSubview:self.photoImageView1];
    [self addSubview:self.photoImageView2];

    [self addSubview:self.preSuffIconImageView];
    
    [self addSubview:self.salePriceLab];
    [self addSubview:self.originalPriceLab];

    [self addSubview:self.salePriceLab2];
    [self addSubview:self.originalPriceLab2];
    
    [self.bigBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.edges.mas_equalTo(self);
    }];
    
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {

         make.left.mas_equalTo(self.mas_left).with.offset(10);
         make.top.mas_equalTo(self.mas_top).with.offset(LCDScale_iPhone6(12));
    }];
    [self.descriptionLab mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.mas_equalTo(self.mas_left).with.offset(10);
       make.top.mas_equalTo(self.nameLab.mas_bottom).with.offset(LCDScale_iPhone6(3));
    }];
    
    [self.preSuffIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.nameLab.mas_right).with.offset(5);
        make.centerY.mas_equalTo(self.nameLab.mas_centerY);
        make.height.mas_equalTo(14);
        make.width.mas_lessThanOrEqualTo(40);
    }];
     [self.photoImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
          
         make.top.mas_equalTo(self.descriptionLab.mas_bottom).with.offset(LCDScale_iPhone6(6));
           make.left.mas_equalTo(self.mas_left).with.offset(9);
          make.width.mas_equalTo(LCDScale_iPhone6(70));
           make.height.mas_equalTo(self.photoImageView1.mas_width).multipliedBy(1);
       }];
      
      [self.photoImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
          
           make.centerY.mas_equalTo(self.photoImageView1.mas_centerY);
           make.width.mas_equalTo(self.photoImageView1);
           make.height.mas_equalTo(self.photoImageView1);
           make.right.mas_equalTo(self.mas_right).with.offset(-13);
    
       }];
    
    [self.salePriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.mas_left).with.offset(LCDScale_iPhone6(18));
        make.bottom.mas_equalTo(self.mas_bottom).with.offset(LCDScale_iPhone6(-12));
    }];
    [self.originalPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.salePriceLab.mas_right).with.offset(5);
        make.lastBaseline.mas_equalTo(self.salePriceLab.mas_lastBaseline);
    }];
    [self.salePriceLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.photoImageView2.mas_left).with.offset(LCDScale_iPhone6(8));
        make.bottom.mas_equalTo(self.mas_bottom).with.offset(LCDScale_iPhone6(-12));
    }];
    [self.originalPriceLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.salePriceLab2.mas_right).with.offset(5);
        make.lastBaseline.mas_equalTo(self.salePriceLab2.mas_lastBaseline);
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
    
    [self loadPreSuffIconImageViewWith:model];
    
    HomePrefectureModelSubBannerSub *good = [model.goodsList firstObject];
    [self.photoImageView1 sd_setImageWithURL:[NSURL URLWithString:good.photo] placeholderImage:nil];
    NSString *referencePrice=[NSString stringWithFormat:@"￥%@",good.referencePrice];
    self.originalPriceLab.attributedText = [NSAttributedString zx_strikethroughTypeSingleWithString:referencePrice];
    self.salePriceLab.text =  [NSString stringWithFormat:@"¥%@",good.salePrice];
    
    
    HomePrefectureModelSubBannerSub *good2 = [model.goodsList objectAtIndex:1];
    [self.photoImageView2 sd_setImageWithURL:[NSURL URLWithString:good2.photo] placeholderImage:nil];
    NSString *referencePrice2=[NSString stringWithFormat:@"￥%@",good2.referencePrice];
    self.originalPriceLab2.attributedText = [NSAttributedString zx_strikethroughTypeSingleWithString:referencePrice2];

    self.salePriceLab2.text =  [NSString stringWithFormat:@"¥%@",good2.salePrice];
    
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

- (void)loadPreSuffIconImageViewWith:(HomePrefectureModelSubBanner *)model
{
    if (![NSString zhIsBlankString:model.suffIcon]) {

        [self.nameLab mas_remakeConstraints:^(MASConstraintMaker *make) {

             make.left.mas_equalTo(self.mas_left).with.offset(10);
             make.top.mas_equalTo(self.mas_top).with.offset(LCDScale_iPhone6(12));
        }];
        [self.preSuffIconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {

            make.left.mas_equalTo(self.nameLab.mas_right).with.offset(5);
            make.centerY.mas_equalTo(self.nameLab.mas_centerY);
            make.height.mas_equalTo(14);
            make.width.mas_lessThanOrEqualTo(40);
        }];
        self.preSuffIconImageView.image = [UIImage imageNamed:@"icon_hot"];
    }
    else if (![NSString zhIsBlankString:model.preIcon])
    {
        [self.preSuffIconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(self.mas_left).with.offset(10);
            make.top.mas_equalTo(self.mas_top).with.offset(LCDScale_iPhone6(16));
            make.height.mas_equalTo(14);
            make.width.mas_lessThanOrEqualTo(40);
        }];
        [self.nameLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.preSuffIconImageView.mas_right).with.offset(5);
            make.centerY.mas_equalTo(self.preSuffIconImageView.mas_centerY);
        }];
        self.preSuffIconImageView.image = [UIImage imageNamed:@"icon_hot"];

    }else
    {
        [self.nameLab mas_remakeConstraints:^(MASConstraintMaker *make) {

             make.left.mas_equalTo(self.mas_left).with.offset(10);
             make.top.mas_equalTo(self.mas_top).with.offset(LCDScale_iPhone6(12));
        }];
        self.preSuffIconImageView.image = nil;
    }
}

- (void)dispalyTypeA
{
    self.nameLab.hidden = NO;
    self.descriptionLab.hidden = self.nameLab.hidden;
    self.preSuffIconImageView.hidden = self.nameLab.hidden;
    
    self.photoImageView1.hidden = NO;
    self.photoImageView2.hidden = self.photoImageView1.hidden;
    self.salePriceLab.hidden = self.photoImageView1.hidden;
    self.salePriceLab2.hidden = self.photoImageView1.hidden;
    self.originalPriceLab.hidden = self.photoImageView1.hidden;
    self.originalPriceLab2.hidden = self.photoImageView1.hidden;
    
    self.bigBgImageView.hidden = YES;
}

- (void)dispalyTypeB
{
    self.nameLab.hidden = YES;
    self.descriptionLab.hidden = self.nameLab.hidden;
    self.preSuffIconImageView.hidden = self.nameLab.hidden;

    self.photoImageView1.hidden = YES;
    self.photoImageView2.hidden = self.photoImageView1.hidden;
    self.salePriceLab.hidden = self.photoImageView1.hidden;
    self.salePriceLab2.hidden = self.photoImageView1.hidden;
    self.originalPriceLab.hidden = self.photoImageView1.hidden;
    self.originalPriceLab2.hidden = self.photoImageView1.hidden;
    
    self.bigBgImageView.hidden = NO;
    
}

- (void)dispalyTypeC
{
    self.nameLab.hidden = YES;
    self.descriptionLab.hidden = self.nameLab.hidden;
    self.preSuffIconImageView.hidden = self.nameLab.hidden;

    self.photoImageView1.hidden = NO;
    self.photoImageView2.hidden = self.photoImageView1.hidden;
    self.salePriceLab.hidden = self.photoImageView1.hidden;
    self.salePriceLab2.hidden = self.photoImageView1.hidden;
    self.originalPriceLab.hidden = self.photoImageView1.hidden;
    self.originalPriceLab2.hidden = self.photoImageView1.hidden;
    
    self.bigBgImageView.hidden = NO;
}
@end
