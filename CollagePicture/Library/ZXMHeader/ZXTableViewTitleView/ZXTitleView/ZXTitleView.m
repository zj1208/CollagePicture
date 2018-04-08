//
//  ZXTitleView.m
//  YiShangbao
//
//  Created by simon on 16/12/8.
//  Copyright © 2016年 com.Microants. All rights reserved.
//

#import "ZXTitleView.h"

@implementation ZXTitleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.bottomLine.hidden = YES;
    self.backgroundColor =[UIColor whiteColor];
}

+ (id)viewFromNib
{
    NSArray *arr =[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil];
    return [arr firstObject];
}


@end
