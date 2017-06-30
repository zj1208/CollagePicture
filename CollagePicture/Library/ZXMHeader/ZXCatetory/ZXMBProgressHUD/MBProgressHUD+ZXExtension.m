//
//  MBProgressHUD+ZXExtension.m
//  YiShangbao
//
//  Created by simon on 17/6/22.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "MBProgressHUD+ZXExtension.h"

@implementation MBProgressHUD (ZXExtension)


+ (void)zx_showLoadingWithStatus:(nullable NSString *)aText toView:(nullable UIView *)view
{
    if (view == nil) {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (!hud)
    {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.75f];
        hud.contentColor = UIColorFromRGB_HexValue(0xffffff);
    }
    hud.label.text= NSLocalizedString(aText, nil);
}

+ (void)zx_showSuccess:(nullable NSString *)success toView:(nullable UIView *)view
{
    if (view == nil) {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    [MBProgressHUD zx_showText:success customIcon:nil view:view];
}


+ (void)zx_showError:(nullable NSString *)error toView:(nullable UIView *)view
{
    if (view == nil) {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    [MBProgressHUD zx_showText:error customIcon:nil view:view];
}



+ (MBProgressHUD *)zx_showText:(nullable NSString *)aText customIcon:(nullable NSString *)imageName view:(UIView *)view
{
    [MBProgressHUD hideHUDForView:view animated:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.75f];
    hud.contentColor = UIColorFromRGB_HexValue(0xffffff);

    if (aText.length>12)
    {
        hud.detailsLabel.text= NSLocalizedString(aText, nil);
        hud.detailsLabel.font = [UIFont systemFontOfSize:15];
    }
    else
    {
        hud.label.text= NSLocalizedString(aText, nil);
    }
    
    if (imageName)
    {
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    }
    else
    {
        hud.mode = MBProgressHUDModeText;
    }
    [hud hideAnimated:YES afterDelay:1.f];
    return hud;
}

//@"litteMoney"
+ (void)zx_showGifWithGifName:(NSString *)gifName toView:(nullable UIView *)view
{
    if (view == nil) {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    UIImage *image = [UIImage zx_animatedGIFNamed:gifName];
    UIImageView *gifView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,image.size.width/2, image.size.height/2)];
    gifView.image = image;
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (!hud)
    {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    //    hud.bezelView.backgroundColor = [UIColor clearColor];
    //    hud.backgroundView.backgroundColor =[UIColor clearColor];
    hud.square = NO;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor clearColor];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = gifView;
}


+ (BOOL)zx_hideHUDForView:(nullable UIView *)view
{
    if (view == nil) {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
   return [MBProgressHUD hideHUDForView:view animated:NO];
}

@end
