//
//  ZXNoMenuTextView.m
//  CollagePicture
//
//  Created by simon on 2020/11/30.
//  Copyright © 2020 zxm. All rights reserved.
//

#import "ZXNoMenuTextView.h"

@implementation ZXNoMenuTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if ([UIMenuController sharedMenuController])
    {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

@end
