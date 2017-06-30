//
//  UIView+UIViewCategoty.m
//  CollagePicture
//
//  Created by 蔡叶超 on 6/30/17.
//  Copyright © 2017 simon. All rights reserved.
//

#import "UIView+UIViewCategoty.h"

@implementation UIView (UIViewCategoty)



- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = TRUE;
}
@end
