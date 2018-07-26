//
//  ZXAddPicBaseContentView.m
//  YiShangbao
//
//  Created by simon on 2018/4/18.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "ZXAddPicBaseContentView.h"

@implementation ZXAddPicBaseContentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initContentView
{
    self =[super initWithFrame:CGRectZero];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)refresh:(ZXPhoto *)data
{
    
}

- (void)refresh:(ZXPhoto *)data indexPath:(NSIndexPath *)indexPath isContainVideo:(BOOL)flag
{
    
}
@end
