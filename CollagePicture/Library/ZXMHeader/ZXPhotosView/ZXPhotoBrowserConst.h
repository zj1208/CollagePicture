//
//  ZXPhotoBrowserConst.h
//  YiShangbao
//
//  Created by simon on 17/2/14.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <Foundation/Foundation.h>




FOUNDATION_EXPORT CGFloat const ZXPhotoMargin;   // 图片之间的默认间距
FOUNDATION_EXPORT CGFloat const  ZXPhotoWidth;    // 图片的默认宽度
FOUNDATION_EXPORT CGFloat const  ZXPhotoHeight;   // 图片的默认高度
FOUNDATION_EXPORT NSInteger const  ZXPhotosMaxColoum;  // 图片每行默认最多个数
FOUNDATION_EXPORT NSInteger const  ZXPhotoMaxCount; //默认最多显示9张
FOUNDATION_EXPORT NSInteger const  ZXImagesMaxCountWhenWillCompose; // 在发布的时候，设置最多可以上传的图片张数

static NSString *const ZXAddImageName = @"zxPhoto_addImage";
static NSString *const ZXDeleteImageName = @"zxPhoto_deleteimage";



#ifndef UIColorFromRGB
#define UIColorFromRGB(R,G,B)  [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f]
#define UIColorFromRGBA(R,G,B,A)  [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]
#endif

#ifndef LCDW
#define LCDW [[UIScreen mainScreen]bounds].size.width
#define LCDScale_iphone6_Width(X)    X*LCDW/375
#endif

#ifndef AppPlaceholderImage
#define AppPlaceholderImage [UIImage imageNamed:@"默认图正方形"]
#endif

