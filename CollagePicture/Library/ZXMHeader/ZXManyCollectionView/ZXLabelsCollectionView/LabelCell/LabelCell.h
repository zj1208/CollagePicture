//
//  LabelCell.h
//  YiShangbao
//
//  Created by simon on 17/2/19.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  2018.2.11，修改cell高度；增加字体大小适配；

#import <UIKit/UIKit.h>

#ifndef SCREEN_WIDTH
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#endif

#ifndef SCREEN_MAX_LENGTH
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#endif

//设置iphone6尺寸比例/竖屏,UI所有设备等比例缩放
#ifndef LCDScale_iPhone6_Width
#define LCDScale_iPhone6_Width(X)    ((X)*SCREEN_MIN_LENGTH/375)
#endif

NS_ASSUME_NONNULL_BEGIN

@interface LabelCell : UICollectionViewCell

@property (nonatomic, copy) NSString *title;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (nonatomic, assign)CGFloat height;


- (CGSize)sizeForCell;

@end


NS_ASSUME_NONNULL_END
