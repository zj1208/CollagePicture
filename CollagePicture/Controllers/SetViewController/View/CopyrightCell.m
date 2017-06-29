//
//  CopyrightCell.m
//  CollagePicture
//
//  Created by 朱新明 on 16/12/2.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "CopyrightCell.h"

@implementation CopyrightCell

- (void)prepareForReuse
{
    [super prepareForReuse];
}

- (void)awakeFromNib
{
    [self.nameBtn setBackgroundColor:[UIColor clearColor]];
    self.nameBtn.titleLabel.numberOfLines = 0;
    self.licenseBtn.titleLabel.numberOfLines = 0;
    [super awakeFromNib];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setData:(id)data
{
    NSString *name = [data objectForKey:@"name"];
    [self.nameBtn setTitle:name forState:UIControlStateNormal];
    
    NSString *license = [data objectForKey:@"license"];
    [self.licenseBtn setTitle:license forState:UIControlStateNormal];
}
@end
