//
//  UIBarButtonItem+ZXCaterory.m
//  MobileCaiLocal
//
//  Created by simon on 2019/11/26.
//  Copyright © 2019 com.Chs. All rights reserved.
//

#import "UIBarButtonItem+ZXCaterory.h"



@implementation UIBarButtonItem (ZXCaterory)

- (void)zx_adjustCustomViewItemsToSuperViewSpacingMagin:(CGFloat)magin withCustomItemView:(UIView *)customView
{
    CGRect frame = customView.frame;
    frame.origin.x = magin;
    customView.frame = frame;
}


@end
