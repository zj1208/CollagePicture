//
//  LabelCell.m
//  YiShangbao
//
//  Created by simon on 17/2/19.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "LabelCell.h"

static CGFloat heightForCell = 24;

#ifndef UIColorFromRGB
#define UIColorFromRGB(R,G,B)  [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f]
#endif

#ifndef UIColorFromRGB_HexValue
#define UIColorFromRGB_HexValue(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbValue & 0xFF))/255.0f alpha:1.f]
#endif

@interface LabelCell ()

@end

@implementation LabelCell


//设置圆角
- (void)setCornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
    self.layer.borderWidth = width;
    
    self.layer.borderColor =color?[color CGColor]:[UIColor clearColor].CGColor;
}


- (void)awakeFromNib {
    // Initialization code

    [self setCornerRadius:heightForCell/2 borderWidth:1.f borderColor:UIColorFromRGB_HexValue(0xcccccc)];
    _titleLab.font = [UIFont systemFontOfSize:14];
    _titleLab.textColor = UIColorFromRGB_HexValue(0xcccccc);
    _titleLab.backgroundColor = [UIColor whiteColor];
    _titleLab.numberOfLines = 1;
    [super awakeFromNib];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLab.text = _title;
//    if (title.length>8)
//    {
//        _titleLab.text = [NSString stringWithFormat:@"%@...",[_title substringToIndex:7]];
//    }
    [self layoutIfNeeded];
    
    [self updateConstraintsIfNeeded];
}

- (CGSize)sizeForCell
{
//    if (_titleLab.text.length>8)
//    {
//        NSDictionary *dic = @{NSFontAttributeName:_titleLab.font};
//        CGRect rect = [@"12345678123" boundingRectWithSize:CGSizeMake(LCDW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil];
//        return CGSizeMake(rect.size.width+heightForCell, heightForCell);
//    }
    CGFloat width = [_titleLab sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].width+ heightForCell;
    return CGSizeMake(floorf(width), heightForCell);
}
@end
