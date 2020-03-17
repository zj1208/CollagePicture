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
#ifndef LCDScale_iPhone6
#define LCDScale_iPhone6(X)    ((X)*SCREEN_MIN_LENGTH/375)
#endif

@interface LabelCell ()

@end

@implementation LabelCell



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
    self.titleLab.font = [UIFont systemFontOfSize:LCDScale_iPhone6(14)];
    self.titleLab.textColor = UIColorFromRGB_HexValue(0xcccccc);
    self.titleLab.backgroundColor = [UIColor whiteColor];
    self.titleLab.numberOfLines = 1;
    self.itemContentInset = UIEdgeInsetsMake(5, 0, 5, 0);
}

- (void)setItemContentInset:(UIEdgeInsets)itemContentInset
{
    _itemContentInset = itemContentInset;
}



- (CGFloat)contentAdaptiveHeight
{
    return  self.titleLab.font.lineHeight + self.itemContentInset.top + self.itemContentInset.bottom;
}

- (CGFloat)height
{
    return _height >0 ? _height:[self contentAdaptiveHeight];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLab.text = title;
}

- (CGSize)sizeForCellThatWidthFits:(CGFloat)maxWidth
{
    
    if (self.labelsViewBorderStyle == ZXLabelsViewBorderStyle_Semicircle)
    {
        CGFloat width = [self.titleLab sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].width + self.height + self.itemContentInset.left + self.itemContentInset.right;
        return CGSizeMake(ceilf(width)<maxWidth?ceilf(width):maxWidth, self.height);
    }
    CGFloat width = [self.titleLab sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].width + self.itemContentInset.left + self.itemContentInset.right;
    return CGSizeMake(ceilf(width)<maxWidth?ceilf(width):maxWidth, self.height);
}


- (void)setData:(id)data
{
    if([data isKindOfClass:[NSString class]])
    {
        self.title = data;
    }
    else if([data isKindOfClass:[ZXLabelsTitleColorModel class]])
    {
        ZXLabelsTitleColorModel *model = (ZXLabelsTitleColorModel *)data;
        self.title = model.text;
    }
}

- (void)labelsTagsViewWillDisplayCellWithData:(id)data
{
    self.layer.borderWidth = 0.5;
    if (self.labelsViewBorderStyle == ZXLabelsViewBorderStyle_Semicircle)
    {
        self.layer.cornerRadius = self.height/2;
    }
    else
    {
        self.layer.cornerRadius = 3;
    }
    // 默认设置
    if (self.selected && self.cellSelectedStyle)
    {
        self.titleLab.backgroundColor = self.selectedLabelBackgroudColor?self.selectedLabelBackgroudColor: [UIColor colorWithRed:255.f/255 green:245.f/255 blue:241.f/255 alpha:1];
        if([data isKindOfClass:[ZXLabelsTitleColorModel class]])
        {
            ZXLabelsTitleColorModel *model = (ZXLabelsTitleColorModel *)data;
            UIColor *color = [self colorWithHexString:model.selectedHexColor alpha:1];
            self.titleLab.textColor = color;
            self.layer.borderColor = color.CGColor;
        }else
        {
            UIColor *color =  [UIColor colorWithRed:255.f/255 green:84.f/255 blue:52.f/255 alpha:1];
            self.titleLab.textColor = color;
            self.layer.borderColor = color.CGColor;
        }
    }
    else
    {
        self.titleLab.backgroundColor = self.labelBackgroudColor?self.labelBackgroudColor:[UIColor whiteColor];
        
        if([data isKindOfClass:[ZXLabelsTitleColorModel class]])
        {
            ZXLabelsTitleColorModel *model = (ZXLabelsTitleColorModel *)data;
            UIColor *color = [self colorWithHexString:model.hexColor alpha:1];
            self.titleLab.textColor = color;
            self.layer.borderColor = color.CGColor;
        }else
        {
            UIColor *color = [UIColor redColor];
            self.titleLab.textColor = color;
            self.layer.borderColor = color.CGColor;
        }
    }
}


- (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    CGFloat red = (float)r / 255.0f ;
    CGFloat green = (float)g / 255.0f;
    CGFloat blue = (float)b / 255.0f;
    if (@available(iOS 10.0, *))
    {
        return [UIColor colorWithDisplayP3Red:red green:green blue:blue alpha:alpha];
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
