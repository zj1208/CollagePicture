//
//  UIButton+ZXHelper.m
//  MusiceFate
//
//  Created by simon on 13/3/21.
//  Copyright © 2013年 yinyuetai.com. All rights reserved.
//

#import "UIButton+ZXHelper.h"

@implementation UIButton (ZXHelper)

- (void)zx_centerVerticalImageAndTitleDefault
{
    const int DEFAULT_SPACING =6.0f;
    [self zx_centerVerticalImageAndTitleWithSpace:DEFAULT_SPACING];
}

- (void)zx_centerVerticalImageAndTitleWithSpace:(float)spacing
{
    if (CGRectIsEmpty(self.bounds)) {
        return;
    }
    CGSize layoutSize = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
//    这个一定要是image 和 title ／sizeToThat 下的最小尺寸；
//    如果你设置btn的width比较小，这里的self.imageView和self.titleLabel就会被压缩变小；所以假定设定最大的宽高来计算;
    CGSize size = [self sizeThatFits:CGSizeMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    //原始设置的宽度
    CGFloat originalWidth  = CGRectGetWidth(self.frame);
    //设置要显示的最小宽度，为了调整inset，必须设置一个大的width;
    if (CGRectGetWidth(self.frame) < size.width || CGRectGetWidth(self.frame) < layoutSize.width)
    {
        CGRect rect = self.frame;
        rect.size.width = size.width;
        self.frame = rect;
    }
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    
    //修改高度-frame及真实约束
    if (CGRectGetHeight(self.frame) < totalHeight)
    {
        CGRect rect = self.frame;
        rect.size.height = totalHeight;
        self.frame = rect;
        NSLayoutConstraint *constraint_height = [self.heightAnchor constraintEqualToConstant:totalHeight];
        constraint_height.active = YES;
    }
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (totalHeight - titleSize.height),0.0);
    
    // 如果外部设置了固定的width且比自适应的小，则在最后重新设置回来；
    if (CGRectGetWidth(self.frame) != originalWidth)
    {
        CGRect rect = self.frame;
        rect.size.width = originalWidth;
        self.frame = rect;
    }
    // 在layoutSubview执行完后，会回调约束方法 改变回原始设置的width/height,或原始自适应的宽高；
}


- (void)zx_setImagePositionWithType:(ZXButtonContentType)type spacing:(CGFloat)spacing
{
    switch (type) {
        case ZXButtonContentTypeImageLeftTitleRight:{
            [self zx_centerXLeftImageAndRightTitleWithSpace:spacing];
            break;
        }
        case ZXButtonContentTypeImageRightTitleLeft:
            [self zx_centerXRightImageAndLeftTitleWithSpace:spacing];
        default:
            break;
    }
}


/**
设置button按钮默认左边图标+右边文字，设置间距；
@param spacing image和title的间距；
*/
- (void)zx_centerXLeftImageAndRightTitleWithSpace:(CGFloat)spacing
{
    // 如果当前button的frame比实际计算的小，一定要重新设置frame；
    // 不然动态改变title的时候，当前frame的size和内部控件布局无法及时改变；造成bug;
    CGSize size = [self sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    if (CGRectGetWidth(self.frame)< (size.width+spacing))
    {
        self.frame = CGRectMake(CGRectGetMinX(self.frame),CGRectGetMinY(self.frame), size.width+spacing,CGRectGetHeight(self.frame));
        [self layoutIfNeeded];//必须
    }
    self.imageEdgeInsets= UIEdgeInsetsMake(0, 0, 0,floorf(spacing/2));
    self.titleEdgeInsets= UIEdgeInsetsMake(0, floorf(spacing/2), 0, 0);
}

/**
设置button按钮左边文字+右边图标，设置间距；
@param spacing image和title的间距；
*/
- (void)zx_centerXRightImageAndLeftTitleWithSpace:(CGFloat)spacing
{
// 如果当前button的frame比实际计算的小，一定要重新设置frame；
// 不然动态改变title的时候，当前frame的size和内部控件布局无法及时改变；造成bug;
// 红包可用商品-不用的时候会bug ;  但是即使用了，在其他场景目前依然有bug；在约束不设置宽度,或者设置宽度约束小的时候，首页：“查看更多+图标”
    CGSize size = [self sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    if (CGRectGetWidth(self.frame)< (size.width+spacing))
    {
        self.frame = CGRectMake(CGRectGetMinX(self.frame),CGRectGetMinY(self.frame), size.width+spacing,CGRectGetHeight(self.frame));
    }
    UIImage *currentImage = [self imageForState:UIControlStateNormal];
    CGSize imageSize = currentImage.size;
    NSString *currentTitle = [self titleForState:UIControlStateNormal];
    CGSize titleSize = [NSString zx_boundingSizeOfString:currentTitle WithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) font:self.titleLabel.font mode:self.titleLabel.lineBreakMode];
    if (!CGRectEqualToRect(self.frame, CGRectZero))
    {
        CGFloat titleMaxHeight;
        NSLineBreakMode lineBreakMode = self.titleLabel.lineBreakMode;
        if (lineBreakMode == NSLineBreakByWordWrapping || lineBreakMode == NSLineBreakByCharWrapping) {
            titleMaxHeight = HUGE;
        } else {
            titleMaxHeight = self.titleLabel.font.pointSize;
        }

        CGSize titleMaxSize = CGSizeMake(CGRectGetWidth(self.frame) - (imageSize.width + spacing), titleMaxHeight);
        titleSize =  [NSString zx_boundingSizeOfString:currentTitle WithSize:titleMaxSize font:self.titleLabel.font mode:self.titleLabel.lineBreakMode];
    }
    self.imageEdgeInsets = UIEdgeInsetsMake(0, titleSize.width + spacing, 0, - titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, 0, imageSize.width + spacing);
     
//这个自动计算的方案有问题，在用约束布局,不设置控件宽度(1.包括只设置了left，right约束位置，优先级约束之后的实际宽度比较大的；2.只设置left或right约束，且不知道实际宽度)的时候，默认获取CGRectGetWidth(self.titleLabel.bounds) == 0，导致无法调整，如：购物车tip条；
//    self.imageEdgeInsets = UIEdgeInsetsMake(0, CGRectGetWidth(self.titleLabel.bounds) + spacing, 0, - CGRectGetWidth(self.titleLabel.bounds));
//    self.titleEdgeInsets = UIEdgeInsetsMake(0, - CGRectGetWidth(self.imageView.bounds), 0, CGRectGetWidth(self.imageView.bounds) + spacing);
}


- (void)zx_buttonExclusiveTouch
{
    self.exclusiveTouch = YES;
}



- (NSIndexPath *)zx_getIndexPathWithBtnInCellFromTableViewOrCollectionView:(UIScrollView *)view
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


- (void)zx_changeAlphaWithCurrentUserInteractionEnabled:(BOOL)enabled
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


- (void)zx_changeEnableWithCurrentUserInteractionEnabled:(BOOL)enabled enableTitleColor:(UIColor *)color1 enableBgColor:(UIColor *)color2 noableTitleColor:(UIColor *)color3 noableBgColor:(UIColor *)color4
{
    self.userInteractionEnabled = enabled;
    if (enabled)
    {
        [self setTitleColor:color1 forState:UIControlStateNormal];
        [self setBackgroundColor:color2];
    }
    else
    {
        [self setTitleColor:color3 forState:UIControlStateNormal];
        [self setBackgroundColor:color4];
    }
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



- (void)zh_userSelectedEnabled:(BOOL)enabled boardColor:(UIColor*)boardColor
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = CGRectGetHeight(self.bounds)/2;
    self.layer.borderColor = [boardColor CGColor];
    self.layer.borderWidth = 1;
    
    self.selected = enabled;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self setTitleColor:boardColor forState:UIControlStateNormal];
    UIImage *img = [self imageWithColor:boardColor andSize:self.frame.size opaque:NO];
    [self setBackgroundImage:img forState:UIControlStateSelected];
    [self setBackgroundImage:nil forState:UIControlStateNormal];
}

- (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size opaque:(BOOL)opaque
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, opaque, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
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



