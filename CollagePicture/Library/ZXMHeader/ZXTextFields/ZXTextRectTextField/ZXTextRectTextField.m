//
//  ZXTextRectTextField.m
//  YiShangbao
//
//  Created by simon on 2018/6/5.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "ZXTextRectTextField.h"

@implementation ZXTextRectTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect rect = [super textRectForBounds:bounds];
    if (!self.leftView)
    {
        rect = CGRectInset(rect, 8, 0);
    }
    return rect;
}
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect rect = [super editingRectForBounds:bounds];
    if (!self.leftView)
    {
         rect = CGRectInset(rect, 8, 0);
    }
    return rect;
}

@end
