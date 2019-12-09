//
//  UIView+ZXAlignmentRectInsets.m
//  YiShangbao
//
//  Created by simon on 2018/6/27.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "UIView+ZXAlignmentRectInsets.h"

static const char *uiView_kRectInsetsChar = "uiView_kRectInsetsChar";

@implementation UIView (ZXAlignmentRectInsets)

//- (void)setRectInsetsBlock:(ZXAlignmentRectInsetsBlock)rectInsetsBlock
//{
//    objc_setAssociatedObject(self, &uiView_kRectInsetsChar, rectInsetsBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
//}

- (void)setRectInsets:(NSString *)rectInsets
{
    objc_setAssociatedObject(self, &uiView_kRectInsetsChar, rectInsets, OBJC_ASSOCIATION_COPY_NONATOMIC);

}
- (NSString *)rectInsets
{
    return objc_getAssociatedObject(self, &uiView_kRectInsetsChar);
}

//- (ZXAlignmentRectInsetsBlock)rectInsetsBlock
//{
//    return objc_getAssociatedObject(self, &uiView_kRectInsetsChar);
//}

//- (void)setZXAlignmentRectInsets:(UIEdgeInsets (^)(UIEdgeInsets))ZXAlignmentRectInsets
//{
//    objc_setAssociatedObject(self, &uiView_kRectInsetsChar, ZXAlignmentRectInsets, OBJC_ASSOCIATION_COPY_NONATOMIC);
//}
//
//- (UIEdgeInsets(^)(UIEdgeInsets))ZXAlignmentRectInsets
//{
//   return  objc_getAssociatedObject(self, &uiView_kRectInsetsChar);
//}

+ (void)load
{
    Method originalMethod = class_getInstanceMethod(self, @selector(alignmentRectInsets));
    Method swizzledMethod = class_getInstanceMethod(self, @selector(zx_alignmentRectInsets));
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (UIEdgeInsets)zx_alignmentRectInsets
{
    if (self.rectInsets)
    {
        return UIEdgeInsetsFromString(self.rectInsets);
    }
//    __block UIEdgeInsets inset = UIEdgeInsetsZero;
//    self.rectInsetsBlock = ^UIEdgeInsets(UIEdgeInsets originInsets) {
//
//        inset = UIEdgeInsetsMake(originInsets.top, originInsets.left, originInsets.bottom, originInsets.right);
//        return originInsets;
//    };
//    if (!UIEdgeInsetsEqualToEdgeInsets(inset, UIEdgeInsetsZero))
//    {
//        return self.rectInsetsBlock(inset);
//    }
    return  [self zx_alignmentRectInsets];
}

@end
