//
//  SearchCollectionViewLeftHotCell.m
//  CollagePicture
//
//  Created by 朱新明 on 2019/10/24.
//  Copyright © 2019 simon. All rights reserved.
//

#import "SearchCollectionViewLeftHotCell.h"
#import "SearchTitleModel.h"

@implementation SearchCollectionViewLeftHotCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor zx_colorWithHexString:@"FFF3F3"];

    self.titleLab.textColor = [UIColor zx_colorWithHexString:@"34373A"];
}

- (CGSize)sizeForCell
{
    CGFloat width = [self.titleLab sizeThatFits:CGSizeMake(MAXFLOAT-15*2-12*2-6-10, MAXFLOAT)].width+ 12*2+6+10;
    return CGSizeMake(ceilf(width), 30);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView zx_setBorderWithRoundItem];
}

- (void)setData:(id)data
{
    SearchTitleModelSub *titleModelSub = (SearchTitleModelSub *)data;
    self.titleLab.text = titleModelSub.name;
    self.titleLab.textColor = [NSString zx_isBlankString:titleModelSub.labelColor]? [UIColor zx_colorWithHexString:@"34373A"]: [UIColor zx_colorWithHexString:titleModelSub.labelColor];
    self.contentView.backgroundColor =[NSString zx_isBlankString:titleModelSub.bgColor]? [UIColor zx_colorWithHexString:@"F5F6F7"]: [UIColor zx_colorWithHexString:titleModelSub.bgColor];
//    [self.hotIconImageView sd_setImageWithURL:[NSURL URLWithString:@"https://gss1.bdstatic.com/5bVXsj_p_tVS5dKfpU_Y_D3/urlicon/14.ebdf9a6364e7ac1185ab172f8bbb7c05.png"] placeholderImage:nil];
    [self.hotIconImageView sd_setImageWithURL:[NSURL URLWithString:titleModelSub.preIcon] placeholderImage:nil];

}
@end
