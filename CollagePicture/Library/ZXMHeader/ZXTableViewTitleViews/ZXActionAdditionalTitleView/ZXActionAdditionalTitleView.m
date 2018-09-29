//
//  ZXActionAdditionalTitleView.m
//  YiShangbao
//
//  Created by simon on 2017/10/13.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXActionAdditionalTitleView.h"

@implementation ZXActionAdditionalTitleView

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
     self.accessoryType = ZXActionViewAccessoryTypeDisclosureIndicator;
    self.backgroundColor = [UIColor whiteColor];
    self.bottomLine.hidden = YES;
}

- (void)setAccessoryType:(ZXActionAdditionalViewAccessoryType)accessoryType
{
    if (accessoryType == ZXActionViewAccessoryTypeNone)
    {
//        [self.accessoryImageView removeFromSuperview];
//         NSLog(@"%@",self.constraints);
        //修改优先级
        [self.constraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj.firstItem isEqual:self.accessoryImageView]
                &&obj.firstAttribute == NSLayoutAttributeLeading
                &&[obj.secondItem isEqual:self.detailTitleLab]
                &&obj.secondAttribute ==NSLayoutAttributeTrailing)
            {
//                NSLog(@"%@",obj);
                obj.priority = UILayoutPriorityDefaultHigh;
            }
            if ([obj.firstItem isEqual:self]
                &&obj.firstAttribute == NSLayoutAttributeTrailing
                &&[obj.secondItem isEqual:self.detailTitleLab]
                &&obj.secondAttribute ==NSLayoutAttributeTrailing)
            {
                obj.priority = UILayoutPriorityRequired;
            }
        }];
    }
    else if (accessoryType == ZXActionViewAccessoryTypeDisclosureIndicator)
    {
        
    }
}

+ (id)viewFromNib
{
    NSArray *arr =[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil];
    return [arr firstObject];
}
@end
