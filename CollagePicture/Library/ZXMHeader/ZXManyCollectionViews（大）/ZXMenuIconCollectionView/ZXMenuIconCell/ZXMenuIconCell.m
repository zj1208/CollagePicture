//
//  ZXMenuIconCell.m
//  YiShangbao
//
//  Created by simon on 2017/10/23.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXMenuIconCell.h"
#import "UILabel+ZXTopBadgeIcon.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ZXMenuIconCell ()

/// 设置中心图标的 大小；默认LCDScale_iPhone6(45.f);
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewLayoutWidth;

/// imageView与cell的top间距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewToSupViewTopLayout;
/// TitleLabel与imageView的间距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabToImageViewSpaceLayout;


@end

@implementation ZXMenuIconCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    self.backgroundColor = [UIColor greenColor];
    self.titleLab.font = [UIFont systemFontOfSize:LCDScale_iPhone6(14)];
    self.imageViewSquareSideLength = LCDScale_iPhone6(45.f);
    self.titleLabToImageViewSpace =  LCDScale_iPhone6(8);
    self.imageViewToSupViewTop = LCDScale_iPhone6(2);
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setImageViewSquareSideLength:(CGFloat)imageViewSquareSideLength
{
    _imageViewSquareSideLength = imageViewSquareSideLength;
    self.imgViewLayoutWidth.constant = imageViewSquareSideLength;
}

- (void)setTitleLabToImageViewSpace:(CGFloat)titleLabToImageViewSpace
{
    _titleLabToImageViewSpace = titleLabToImageViewSpace;
    self.titleLabToImageViewSpaceLayout.constant = titleLabToImageViewSpace;
}

- (void)setImageViewToSupViewTop:(CGFloat)imageViewToSupViewTop
{
    _imageViewToSupViewTop = imageViewToSupViewTop;
    self.imageViewToSupViewTopLayout.constant = imageViewToSupViewTop;
}

 // Configure the cell
- (void)setData:(id)data placeholderImage:(UIImage *)placeholderImage
{
    ZXMenuIconModel *model = (ZXMenuIconModel *)data;
    self.titleLab.text = model.title ;
//    self.iconImageView.backgroundColor = UIColor.redColor;
//    self.iconImageView.image = placeholderImage;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:placeholderImage];
    if (model.sideMarkType ==SideMarkType_number)
    {
        self.badgeLab.hidden = NO;
         [self.badgeLab zx_topBadgeIconWithBadgeValue:[model.sideMarkValue integerValue] maginY:1.f badgeFont:[UIFont systemFontOfSize:LCDScale_iPhone6(12)] titleColor:[UIColor whiteColor] backgroundColor:[UIColor redColor]];
        
        if ([model.sideMarkValue integerValue]>99)
        {
            self.labLayoutLeadingConstraint.constant = -17;
        }
        else
        {
            self.labLayoutLeadingConstraint.constant = -14;
        }
    }
    else
    {
        self.badgeLab.hidden = YES;
    }
}


+ (CGFloat)getTitleLabToImageViewSpace
{
    ZXMenuIconCell *cell = [ZXMenuIconCell zx_viewFromNib];
    return cell.titleLabToImageViewSpace;
}

+ (CGFloat)getImageViewToSupViewTop
{
    ZXMenuIconCell *cell = [ZXMenuIconCell zx_viewFromNib];
    return cell.imageViewToSupViewTop;
}
@end
