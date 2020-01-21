//
//  SearchCollectionViewCell.m
//  CollagePicture
//
//  Created by 朱新明 on 2019/10/24.
//  Copyright © 2019 simon. All rights reserved.
//

#import "SearchCollectionViewCell.h"
#import "SearchTitleModel.h"
@implementation SearchCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor zx_colorWithHexString:@"F5F6F7"];
    self.titleLab.textColor = [UIColor zx_colorWithHexString:@"34373A"];
}

- (CGSize)sizeForCell
{
    CGFloat width = [self.titleLab sizeThatFits:CGSizeMake(LCDW, MAXFLOAT)].width+ 12*2;
    return CGSizeMake(ceilf(width)<=(LCDW-15*2)?ceilf(width):(LCDW-15*2), 30);
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
    self.contentView.backgroundColor =[NSString zhIsBlankString:titleModelSub.bgColor]? [UIColor zx_colorWithHexString:@"F5F6F7"]: [UIColor zx_colorWithHexString:titleModelSub.bgColor];
    self.titleLab.textColor = [NSString zhIsBlankString:titleModelSub.labelColor]? [UIColor zx_colorWithHexString:@"34373A"]: [UIColor zx_colorWithHexString:titleModelSub.labelColor];
}
@end
