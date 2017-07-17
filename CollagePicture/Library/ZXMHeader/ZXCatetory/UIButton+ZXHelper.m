//
//  UIButton+ZXHelper.m
//  SiChunTang
//
//  Created by simon on 15/11/21.
//  Copyright © 2015年 simon. All rights reserved.
//

#import "UIButton+ZXHelper.h"
#import"APPCommonDef.h"
#import "UIImage+ZXHelper.h"

@implementation UIButton (ZXHelper)

- (void)zh_centerVerticalImageAndTitle_titleFontOfSize:(CGFloat)fontSize
{
    const int DEFAULT_SPACING =6.0f;
    [self zh_centerVerticalImageAndTitleWithSpace:DEFAULT_SPACING titleFontOfSize:fontSize];
}



- (void)zh_centerVerticalImageAndTitleWithSpace:(float)spacing titleFontOfSize:(CGFloat)fontSize
{
    self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    
    //    这个一定要是image 和 title ／sizeToThat 下的最小尺寸；如果你设置btn的width比较小，这里的self.imageView和self.titleLabel就会被压缩变小；因为高度只能取到最大的高度，所以没法取；
    CGSize size = [self sizeThatFits:CGSizeMake(LCDW, LCDH)];
    CGFloat tenmpt  = CGRectGetWidth(self.frame);
    if (CGRectGetWidth(self.frame)<size.width)
    {
        self.frame = ZX_FRAME_W(self,size.width);
    }
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    
    if (CGRectGetHeight(self.frame)<totalHeight)
    {
        self.frame = ZX_FRAME_H(self,totalHeight);
    }
    
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (totalHeight - titleSize.height),0.0);
    
    //    如果设置所要求的btnframe的width是固定的比较小，可以先设置中间，然后再设置回原来的width；
    self.frame = ZX_FRAME_W(self, tenmpt);
}


/*
 
 for(int i = 0;i<3;i++)
 {
 UIButton *btn = [self.view zhuButton_orginalFrame:CGRectMake(0, CGRectGetMaxY(titBtn2.frame)+10, 0, 0) imageName:@"placeholder_small" backgroundImageName:nil title:@"热门分类" edegeSpace:0 titleColor:[UIColor blackColor] titleFont:15 backgroundColor:nil];
 btn.tag = 200+i;
 [btn zhuCenterImageAndTitle_titleFont:15];
 btn.frame = [self.view zhuContainSize_LCDWHaveNumItem_MarginX:10 MaginXBool:YES width:0 widthBool:NO numItems:i totalItems:3 orginY:CGRectGetMaxY(titBtn2.frame)+10 height:1];
 [self.headerView addSubview:btn];
 }
 UIButton *bt = (UIButton*)[self.headerView viewWithTag:200];
 
 */


- (void)zh_centerHorizontalImageAndTitleWithTheirSpace:(float)spacing
{
    self.imageEdgeInsets= UIEdgeInsetsMake(0, 0, 0,floorf(spacing/2));
    self.titleEdgeInsets= UIEdgeInsetsMake(0, floorf(spacing/2), 0, 0);
}


- (void)zh_buttonExclusiveTouch
{
    self.exclusiveTouch = YES;
}



- (NSIndexPath *)zh_getIndexPathWithBtnInCellFromTableViewOrCollectionView:(UIScrollView *)view
{
    CGPoint point = self.center;
    point = [view convertPoint:point fromView:self.superview];
    if ([view isKindOfClass:[UITableView class]])
    {
        UITableView *tableView = (UITableView *)view;
        NSIndexPath* indexPath = [tableView indexPathForRowAtPoint:point];
        return indexPath;
    }
    if ([view isKindOfClass:[UICollectionView class]])
    {
        UICollectionView *tableView = (UICollectionView *)view;
        NSIndexPath* indexPath = [tableView indexPathForItemAtPoint:point];
        return indexPath;
    }
    return nil;
}




- (void)zh_userInteractionEnabled:(BOOL)enabled switchEnableTitleColor:(UIColor *)color1 enableBgColor:(UIColor *)color2
{
    self.userInteractionEnabled = enabled;
    if (enabled)
    {
        self.layer.borderColor = [color1 CGColor];
        self.layer.borderWidth = 1;
        [self setBackgroundColor:color2];
        [self setTitleColor:color1 forState:UIControlStateNormal];
    }
    else
    {
        self.layer.borderColor = [[UIColor clearColor]CGColor];
        [self setBackgroundColor:color1];
        [self setTitleColor:color2 forState:UIControlStateNormal];
    }
}

- (void)zh_userInteractionEnabled:(BOOL)enabled titleColor:(UIColor *)color1 bgColor:(UIColor *)color2
{
    self.userInteractionEnabled = enabled;
    self.layer.borderColor = [color1 CGColor];
    self.layer.borderWidth = 1;
    [self setBackgroundColor:color2];
    [self setTitleColor:color1 forState:UIControlStateNormal];

}

- (void)zh_userSwitchWhiteAndLightGrayColorWithInteractionEnabled:(BOOL)enabled;
{
//    self.layer.masksToBounds = YES;
//    self.layer.cornerRadius = CGRectGetHeight(self.frame)/2;
    self.userInteractionEnabled = enabled;
    if (enabled)
    {
        self.layer.borderColor = [[UIColor blackColor]CGColor];
        self.layer.borderWidth = 1;
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    else
    {
        self.layer.borderColor = [[UIColor clearColor]CGColor];
        [self setBackgroundColor:[UIColor lightGrayColor]];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
}

- (void)zh_userInteractionEnabledWithAlpha:(BOOL)enabled
{
    self.userInteractionEnabled = enabled;
    if (enabled)
    {
        self.alpha = 1;
    }
    else
    {
        self.alpha = 0.5;
    }

}
- (void)zh_userSelectedEnabled:(BOOL)enabled boardColor:(UIColor*)boardColor
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = CGRectGetHeight(self.bounds)/2;
    self.layer.borderColor = [boardColor CGColor];
    self.layer.borderWidth = 1;
    
    self.selected = enabled;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self setTitleColor:boardColor forState:UIControlStateNormal];
    UIImage *img = [UIImage zh_imageWithColor:boardColor andSize:self.frame.size];
    [self setBackgroundImage:img forState:UIControlStateSelected];
    [self setBackgroundImage:nil forState:UIControlStateNormal];
}



- (void)zh_setImage:(UIImage *)image1 selectImage:(UIImage *)image2  titleColor:(UIColor *)color1 selectTitleColor:(UIColor *)color2
{
    [self setImage:image1 forState:UIControlStateNormal];
    [self setImage:image2 forState:UIControlStateSelected];
    [self setTitleColor:color2 forState:UIControlStateSelected];
    [self setTitleColor:color1 forState:UIControlStateNormal];

}

- (void)zh_setTowOfLinesStringWithLineSpace:(CGFloat)space firstLineWithAttributedTitle:(nullable NSAttributedString *)attributed1 secondLineWithAttributedTitle:(nullable NSAttributedString *)attributed2
{
    self.titleLabel.numberOfLines = 0;

    NSMutableAttributedString *mAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:attributed1];
//    [mAttributedString appendAttributedString:attributed1];
    NSAttributedString *lineAttri = [[NSAttributedString alloc] initWithString:@"\n"];
    [mAttributedString appendAttributedString:lineAttri];
    [mAttributedString appendAttributedString:attributed2];
        
    NSMutableParagraphStyle *paragraph = [[NSParagraphStyle defaultParagraphStyle]mutableCopy];
    paragraph.lineSpacing = space;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraph};
    
    [mAttributedString addAttributes:attributes range:NSMakeRange(0, mAttributedString.mutableString.length)];
    
     [self setAttributedTitle:mAttributedString forState:UIControlStateNormal];
}


- (void)zh_setButtonImageViewScaleAspectFill
{
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.contentHorizontalAlignment= UIControlContentHorizontalAlignmentFill;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
}
@end



