//
//  ZXLeftFirstLevelTableCell.m
//  MobileCaiLocal
//
//  Created by simon on 2019/11/27.
//  Copyright © 2019 timtian. All rights reserved.
//

#import "ZXLeftFirstLevelTableCell.h"
#import "UIColor+ZXHex.h"

@implementation ZXLeftFirstLevelTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    CGFloat fontSize = (13*[[UIScreen mainScreen] bounds].size.width)/375 ;
    if (selected) {
        self.leftTagView.hidden = NO;
        self.titleLabel.textColor = [UIColor zx_colorWithHexString:@"333333"];
        self.titleLabel.font = [UIFont systemFontOfSize:fontSize weight:UIFontWeightSemibold];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        self.leftTagView.hidden = YES;
        self.titleLabel.textColor = [UIColor zx_colorWithHexString:@"#595E66"];
        self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        self.contentView.backgroundColor = [UIColor colorWithRed:245.f/255.0 green:246.f/255.0 blue:247.f/255.0 alpha:1.0];
    }
}

@end
