//
//  ZXAddPicCoverView.m
//  YiShangbao
//
//  Created by simon on 2017/12/1.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXAddPicCoverView.h"

@implementation ZXAddPicCoverView

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
    self.titleLabel.textColor = [UIColor colorWithHexString:@"9D9D9D"];
    [self zh_setButtonImageViewScaleAspectFillWithButton:self.addButton];

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
