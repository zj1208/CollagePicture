//
//  ZXCenterTitleView.m
//  YiShangbao
//
//  Created by simon on 17/4/13.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXCenterTitleView.h"

@implementation ZXCenterTitleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setHideLineView:(BOOL)hideLineView
{
    _hideLineView = hideLineView;
    
    self.leftLine.hidden = hideLineView;
    self.rightLine.hidden = hideLineView;
}
@end
