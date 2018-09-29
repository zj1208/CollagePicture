//
//  LabelCell.m
//  YiShangbao
//
//  Created by simon on 17/2/19.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "LabelCell.h"


#ifndef UIColorFromRGB
#define UIColorFromRGB(R,G,B)  [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f]
#endif

#ifndef UIColorFromRGB_HexValue
#define UIColorFromRGB_HexValue(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbValue & 0xFF))/255.0f alpha:1.f]
#endif

#ifndef SCREEN_WIDTH
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#endif

#ifndef SCREEN_MAX_LENGTH
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#endif

//设置iphone6尺寸比例/竖屏,UI所有设备等比例缩放
#ifndef LCDScale_iPhone6_Width
#define LCDScale_iPhone6_Width(X)    ((X)*SCREEN_MIN_LENGTH/375)
#endif

@interface LabelCell ()

@end

@implementation LabelCell


//设置圆角
- (void)setCornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color
{
    self.titleLab.layer.masksToBounds = YES;
    self.titleLab.layer.cornerRadius = radius;
    self.titleLab.layer.borderWidth = width;
    
    self.titleLab.layer.borderColor =color?[color CGColor]:[UIColor clearColor].CGColor;
}

//- (void)setSelected:(BOOL)selected
//{
//    [super setSelected:selected];
//
//    if (selected)
//    {
//        self.backgroundColor = [UIColor redColor];
//    }
//    else
//    {
//        self.backgroundColor = [UIColor whiteColor];
//    }
//}

- (void)awakeFromNib {
    // Initialization code

    [super awakeFromNib];
    _titleLab.font = [UIFont systemFontOfSize:LCDScale_iPhone6_Width(14)];
    self.height = _titleLab.font.lineHeight+10;
    _titleLab.textColor = UIColorFromRGB_HexValue(0xcccccc);
    _titleLab.backgroundColor = [UIColor whiteColor];
    _titleLab.numberOfLines = 1;

}

- (void)setHeight:(CGFloat)height
{
    _height = height;
    [self setCornerRadius:height/2 borderWidth:0.5f borderColor:UIColorFromRGB_HexValue(0xcccccc)];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLab.text = _title;
}

- (CGSize)sizeForCell
{
    CGFloat width = [_titleLab sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].width+ self.height;
    return CGSizeMake(floorf(width), self.height);
}
@end
