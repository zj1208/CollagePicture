//
//  ZXAddPicViewCell.m
//  YiShangbao
//
//  Created by simon on 17/3/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXAddPicViewCell.h"

#ifndef UIColorFromRGB_HexValue
/**
 * @brief 16进制的字符串颜色转RGB.把＃变为0x，如果没有则加上。 eg:#333333--ZX_RGBHexString(0X333333)
 */
#define UIColorFromRGB_HexValue(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbValue & 0xFF))/255.0f alpha:1.f]

#define UIColorFromRGBA_HexValue(rgbValue,A) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbValue & 0xFF))/255.0f alpha:A]
#endif


@implementation ZXAddPicViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.deleteBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
//    [self.deleteBtn setBackgroundColor:[UIColor blueColor]];
    
    self.imageView.contentMode =UIViewContentModeScaleAspectFill;
    self.imageViewCornerRadius = 5.f;
    [self setView:self.imageView cornerRadius:self.imageViewCornerRadius borderWidth:0.5f borderColor:UIColorFromRGB_HexValue(0xE8E8E8)];
    self.videoCoverView.hidden = YES;
    
//    self.backgroundColor = [UIColor greenColor];
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDidClicked:)];
//    [self.imageView addGestureRecognizer:singleTap];

}


//// 单击手势
//- (void)imageDidClicked:(UITapGestureRecognizer *)sender
//{
//    if ([self.delegate respondsToSelector:@selector(zxDidSingleImageClick:)]) { // 自定义 自己管理点击事件
//        [self.delegate zxDidSingleImageClick:self];
//        return;
//    }
//}



- (void)setView:(UIView *)view cornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color
{
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = radius;
    view.layer.borderWidth = width;
    
    view.layer.borderColor =color?[color CGColor]:[UIColor clearColor].CGColor;
}

// 一旦执行这个，视频图片就有可能加载有问题；
- (void)setData:(ZXPhoto *)data
{
    self.model = data;
    if ([self.model isKindOfClass:[ZXPhoto class]])
    {
        [self refresh];
    }
}


- (void)refresh
{
    [self addContentViewIfNotExist];
    
    [_customContentView refresh:self.model];
    [_customContentView setNeedsLayout];
}

- (void)addContentViewIfNotExist
{
    if (_customContentView == nil)
    {
        id<ZXAddPicCellLayoutConfigSource> layoutConfig = [[ZXAddPicViewKit sharedKit] cellLayoutConfig];
        NSString *contentStr = [layoutConfig cellContent:self.model];
        NSAssert([contentStr length] > 0, @"should offer cell content class name");
        Class clazz = NSClassFromString(contentStr);
        ZXAddPicBaseContentView *contentView = [[clazz alloc] initContentView];
        NSAssert(contentView, @"can not init content view");
        _customContentView = contentView;

//        _customContentView.backgroundColor = [UIColor orangeColor];
        [self setView:_customContentView cornerRadius:self.imageViewCornerRadius borderWidth:0.5f borderColor:nil];
        [self.contentView addSubview:_customContentView];
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutBubbleView];

}

- (void)layoutBubbleView
{
    self.customContentView.frame = CGRectMake(0, CGRectGetHeight(self.deleteBtn.frame), CGRectGetWidth(self.contentView.frame)-10, CGRectGetHeight(self.contentView.frame)-CGRectGetHeight(self.deleteBtn.frame));
}

@end
