//
//  UINavigationBar+ShadeColor.h
//  CollagePicture
//
//  Created by simon on 16/1/14.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (ShadeColor)
@property(nonatomic,strong) UIView *overlay;

- (void)zh_setBackgroundColor:(UIColor *)backgroundColor;
- (void)zh_reset;

@end
