//
//  NoMenuTextField.m
//  CollagePicture
//
//  Created by 朱新明 on 16/12/21.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "NoMenuTextField.h"

@implementation NoMenuTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if ([UIMenuController sharedMenuController])
    {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

@end
