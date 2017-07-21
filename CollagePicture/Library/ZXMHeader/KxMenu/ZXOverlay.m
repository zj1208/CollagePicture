//
//  ZXOverlay.m
//  Baby
//
//  Created by simon on 16/1/21.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "ZXOverlay.h"


#define UIColorFromRGBA_HexValue(rgbValue,A) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbValue & 0xFF))/255.0f alpha:A]

@implementation ZXOverlay

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
    if ([self.delegate respondsToSelector:@selector(zxOverlaydissmissAction)])
    {
        [self.delegate zxOverlaydissmissAction];
    }
}


@end
