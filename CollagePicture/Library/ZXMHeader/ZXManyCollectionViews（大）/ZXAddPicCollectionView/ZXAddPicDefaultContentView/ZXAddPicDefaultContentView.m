//
//  ZXAddPicDefaultContentView.m
//  YiShangbao
//
//  Created by simon on 2017/12/1.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXAddPicDefaultContentView.h"
#import "ZXAddPicCollectionConst.h"

@interface ZXAddPicDefaultContentView ()

/// imageView与父视图右间距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addButtonToSupTopSpaceLayout;
/// imageView与父视图左间距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addButtonToSupLeadingLayout;

/// titleLab的左边间距约束设置
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabLeadingLayout;
@end


@implementation ZXAddPicDefaultContentView

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
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    // 默认文案提示
    self.titleLabel.text = [NSString stringWithFormat:@"添加图片或视频\n(最多9个，视频时长不能超过10秒)"];
    self.titleLabel.textColor = UIColorFromRGB_HexValue(0x9D9D9D);
    [self zh_setButtonImageViewScaleAspectFillWithButton:self.addButton];
    self.titleLabToAddButtonLeading = 15.f;
    self.addButtonToSupTopSpace = 15.f;
    self.addButtonToSupLeftSpace = 15.f;
}

- (void)setAddButtonToSupTopSpace:(CGFloat)addButtonToSupTopSpace
{
    _addButtonToSupTopSpace = addButtonToSupTopSpace;
    self.addButtonToSupTopSpaceLayout.constant = addButtonToSupTopSpace;
}

- (void)setAddButtonToSupLeftSpace:(CGFloat)addButtonToSupLeftSpace
{
    _addButtonToSupLeftSpace = addButtonToSupLeftSpace;
    self.addButtonToSupLeadingLayout.constant = addButtonToSupLeftSpace;
}

- (void)setTitleLabToAddButtonLeading:(CGFloat)titleLabToAddButtonLeading
{
    _titleLabToAddButtonLeading = titleLabToAddButtonLeading;
    self.titleLabLeadingLayout.constant = titleLabToAddButtonLeading;
}


- (void)zh_setButtonImageViewScaleAspectFillWithButton:(UIButton *)button
{
    button.imageView.contentMode = UIViewContentModeScaleAspectFill;
    button.contentHorizontalAlignment= UIControlContentHorizontalAlignmentFill;
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
}

+ (id)viewFromNib
{
    NSArray *arr =[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil];
    return [arr firstObject];
}
@end
