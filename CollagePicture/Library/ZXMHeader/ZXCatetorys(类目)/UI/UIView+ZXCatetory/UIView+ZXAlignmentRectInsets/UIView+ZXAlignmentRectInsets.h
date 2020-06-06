//
//  UIView+ZXAlignmentRectInsets.h
//  YiShangbao
//
//  Created by simon on 2018/6/27.
//  Copyright © 2018年 com.Microants. All rights reserved.
//
//  2018.6.27 新增

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

//typedef UIEdgeInsets(^ZXAlignmentRectInsetsBlock)(UIEdgeInsets originInsets);

@interface UIView (ZXAlignmentRectInsets)

//@property (nonatomic, copy) UIEdgeInsets (^ZXAlignmentRectInsets) (UIEdgeInsets originInsets);

//@property (nonatomic, copy) ZXAlignmentRectInsetsBlock rectInsetsBlock;

@property (nonatomic, copy) NSString* rectInsets;

@end

/*
self.contentLab.rectInsets = NSStringFromUIEdgeInsets(UIEdgeInsetsMake(0, 0, -10, 0));
*/
