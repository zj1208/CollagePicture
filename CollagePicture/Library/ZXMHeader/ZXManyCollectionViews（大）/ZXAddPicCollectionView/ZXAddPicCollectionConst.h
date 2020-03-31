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
 * @brief 16进制的字符串颜色转RGB.把＃变为0x，如果没有则加上。 eg:#34373A--ZX_RGBHexString(0X34373A)
 */
#ifndef UIColorFromRGB_HexValue
#define UIColorFromRGB_HexValue(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbValue & 0xFF))/255.0f alpha:1.f]

#define UIColorFromRGBA_HexValue(rgbValue,A) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbValue & 0xFF))/255.0f alpha:A]
#endif

// 可以自定义，外面有开放添加按钮UIImage属性
static NSString *const AppPlaceholderAddButtonImageName = @"zxPhoto_addImage";


// 用于ZXAddPicCollectionView.m

static NSInteger const ZXMaxItemCount = 3;

///item之间最小间隔
static float const ZXMinimumInteritemSpacing = 12.f;
///最小行间距
static float const ZXMinimumLineSpacing = 12.f;
static float const ZXAddPicItemWidth = 60.f;
static float const ZXAddPicItemHeight = 60.f;

/// 图片每行默认最多个数
static NSInteger const ZXAddPicMaxColoum = 3;

///设置的时候，xib也要同时调整；与删除按钮有关；
static float const ZXPicItemLayoutTop =  10.f;
static float const ZXPicItemLayoutRight = 10.f;


/// ZXAddPicCollectionView_SYSTEMVERSION以上用iOS9移动方法（collectionView上添加手势），以下用iOS8可以用的通用方法(cell上添加手势)；
static CGFloat ZXAddPicCollectionView_SYSTEMVERSION = 12.0;

NS_ASSUME_NONNULL_END
