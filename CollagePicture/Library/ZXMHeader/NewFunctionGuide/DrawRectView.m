//
//  DrawRectView.m
//  lovebaby
//
//  Created by simon on 16/6/12.
//  Copyright © 2016年 . All rights reserved.
//

#import "DrawRectView.h"

@implementation DrawRectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.1];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineWidth = 2.f;
    bezierPath.lineCapStyle = kCGLineCapSquare;//端点形式直角
    bezierPath.lineJoinStyle = kCGLineJoinMiter;//直角连接
    bezierPath.miterLimit = 20;
    [bezierPath moveToPoint:CGPointMake(0, 0)];
    [bezierPath addLineToPoint:CGPointMake(LCDW, 0)];
    [bezierPath addLineToPoint:CGPointMake(LCDW, 64)];
    [bezierPath addLineToPoint:CGPointMake(LCDW/2, 64)];
    [bezierPath addLineToPoint:CGPointMake(LCDW/2, 64+120)];
    [bezierPath addLineToPoint:CGPointMake(LCDW, 64+120)];
    [bezierPath addLineToPoint:CGPointMake(LCDW, LCDH)];
    [bezierPath addLineToPoint:CGPointMake(0, LCDH)];
    [bezierPath closePath];
    [bezierPath fillWithBlendMode:kCGBlendModeNormal alpha:0.7];
    
}


@end
