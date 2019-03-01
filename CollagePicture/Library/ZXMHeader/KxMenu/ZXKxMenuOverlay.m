//
//  ZXKxMenuOverlay.m
//  CollagePicture
//
//  Created by simon on 2019/2/27.
//  Copyright © 2019 simon. All rights reserved.
//

#import "ZXKxMenuOverlay.h"

#ifndef UIColorFromRGBA_HexValue
#define UIColorFromRGBA_HexValue(rgbValue,A) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbValue & 0xFF))/255.0f alpha:A]
#endif

@implementation ZXKxMenuOverlay

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor =UIColorFromRGBA_HexValue(000000, 0.4);
    }
    return self;
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(zxKxMenuOverlaydissmissAction)])
    {
        [self.delegate zxKxMenuOverlaydissmissAction];
    }
}


@end
