//
//  ZXAddPicCollectionConst.h
//  YZL
//
//  Created by simon on 2019/1/23.
//  Copyright © 2019 YZL. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXAddPicCollectionConst : NSObject

@end

#ifndef Device_SYSTEMVERSION
#define Device_SYSTEMVERSION    [[UIDevice currentDevice] systemVersion]
#endif

#ifndef AppPlaceholderImage
#define AppPlaceholderImage [UIImage imageNamed:@"默认图正方形"]
#endif

/**
 * @brief 16进制的字符串颜色转RGB.把＃变为0x，如果没有则加上。 eg:#333333--ZX_RGBHexString(0X333333)
 */
#ifndef UIColorFromRGB_HexValue
#define UIColorFromRGB_HexValue(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbValue & 0xFF))/255.0f alpha:1.f]

#define UIColorFromRGBA_HexValue(rgbValue,A) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbValue & 0xFF))/255.0f alpha:A]
#endif

// 可以自定义，外面有开放添加按钮UIImage属性
static NSString *const AppPlaceholderAddButtonImageName = @"zxPhoto_addImage";


// 用于ZXAddPicCollectionView.m

static NSInteger const ZXMaxItemCount = 3;

static float const ZXMinimumInteritemSpacing = 12.f;//item之间最小间隔
static float const ZXMinimumLineSpacing = 12.f; //最小行间距
static float const ZXAddPicItemWidth = 60.f;
static float const ZXAddPicItemHeight = 60.f;

static NSInteger const ZXAddPicMaxColoum = 3;  // 图片每行默认最多个数

//设置的时候，xib也要同时调整；与删除按钮有关；
static float const ZXPicItemLayoutTop =  10.f;
static float const ZXPicItemLayoutRight = 10.f;


NS_ASSUME_NONNULL_END
