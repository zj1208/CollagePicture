//
//  MBProgressHUD+ZXExtension.h
//  YiShangbao
//
//  Created by simon on 17/6/22.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (ZXExtension)

//支持window显示和自定义view显示，当view＝nil，显示在window上；
//在上传，正在干什么这种，要在window上提示；
//在UITabelViewController，UICollectionViewController，也要在window上提示；

//正在加载提示
+ (void)zx_showLoadingWithStatus:(nullable NSString *)aText toView:(nullable UIView *)view;

//成功提示；会自动隐藏
+ (void)zx_showSuccess:(nullable NSString *)success toView:(nullable UIView *)view;

//失败提示；会自动隐藏
+ (void)zx_showError:(nullable NSString *)error toView:(nullable UIView *)view;


//gif图提示:@"litteMoney"
+ (void)zx_showGifWithGifName:(NSString *)gifName toView:(nullable UIView *)view;

//隐藏hud
+ (BOOL)zx_hideHUDForView:(nullable UIView *)view;

@end


NS_ASSUME_NONNULL_END
