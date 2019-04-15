//
//  UILabel+ZXTopBadgeIcon.h
//  FunLive
//
//  Created by simon on 2019/2/26.
//  Copyright © 2019 qq. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (ZXTopBadgeIcon)

- (void)zx_topBadgeIconWithBadgeValue:(NSInteger)aBadgeValue maginY:(CGFloat)aMaginY badgeFont:(nullable UIFont *)font titleColor:(nullable UIColor *)aTitleColor backgroundColor:(nullable UIColor*)aBgColor;

@end

NS_ASSUME_NONNULL_END
