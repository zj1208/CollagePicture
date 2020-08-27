//
//  MBProgressHUD+ZXCategory.m
//  YiShangbao
//
//  Created by simon on 17/6/22.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "MBProgressHUD+ZXCategory.h"
#import "UIImage+ZXGIF.h"

#ifndef UIColorFromRGB_HexValue
#define UIColorFromRGB_HexValue(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbValue & 0xFF))/255.0f alpha:1.f]
#endif


static  NSString *const ERROR_NETWORK = @"哎呀！网路粗问题了，请稍后再试！";
static  NSString *const ERROR_SERVER  = @"哎呀！粗问题了，请稍后再试！";


@implementation MBProgressHUD (ZXCategory)


+ (void)zx_showLoadingWithStatus:(nullable NSString *)aText toView:(nullable UIView *)view
{
    if (!view)
    {
        view = [MBProgressHUD getCurrentWindow];
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
 
    [MBProgressHUD zx_showText:success customIcon:nil view:view hideAfterDelay:0];
}

+ (void)zx_showSuccess:(nullable NSString *)success toView:(nullable UIView *)view hideAfterDelay:(NSTimeInterval)delay
{
    [MBProgressHUD zx_showText:success customIcon:nil view:view hideAfterDelay:delay];
}

+ (void)zx_showError:(nullable NSString *)error toView:(nullable UIView *)view
{
    [MBProgressHUD zx_showText:error customIcon:nil view:view hideAfterDelay:0];
}

+ (void)zx_showError:(nullable NSString *)error toView:(nullable UIView *)view hideAfterDelay:(NSTimeInterval)delay
{
    [MBProgressHUD zx_showText:error customIcon:nil view:view hideAfterDelay:delay];
}

+ (void)zx_showErrorContainsCodeWithTitle:(nullable NSString *)title error:(NSError *)error toView:(nullable UIView *)view
{
    [MBProgressHUD zx_showErrorContainsCodeWithTitle:title error:error toView:view hideAfterDelay:0];
}

+ (void)zx_showErrorContainsCodeWithTitle:(nullable NSString *)title error:(NSError *)error toView:(nullable UIView *)view hideAfterDelay:(NSTimeInterval)delay
{
    NSString *errorTitle = nil;
    //自定义错误文本
    if(error.code<-990)
    {
        NSString *eTitle = nil;
        if (error.code == -1005 || error.code == -1009 || error.code == -1001) {
             eTitle = ERROR_NETWORK;
         }else{
             eTitle = ERROR_SERVER;
         }
        errorTitle = [NSString stringWithFormat:@"%@(%@)",eTitle,@(error.code)];
    }
    //添加购物车时候有关的code码-菜划算进货绑定业务
    else if (error.code == 4403 || error.code == 7010 || error.code == 4027 || error.code == 4244 || error.code == 4032 || error.code == 4035 || error.code == 4034 || error.code ==4033 || error.code == 4021)
    {
        errorTitle = title;
    }
    else
    {
        errorTitle = [NSString stringWithFormat:@"%@(%@)",title,@(error.code)];
    }
    [MBProgressHUD zx_showText:errorTitle customIcon:nil view:view hideAfterDelay:delay];
}

+ (MBProgressHUD *)zx_showText:(nullable NSString *)aText customIcon:(nullable NSString *)imageName view:(nullable UIView *)view
{
    return  [MBProgressHUD zx_showText:aText customIcon:imageName view:view hideAfterDelay:0];
}

+ (MBProgressHUD *)zx_showText:(nullable NSString *)aText customIcon:(nullable NSString *)imageName view:(nullable UIView *)view hideAfterDelay:(NSTimeInterval)delay
{
    if (!view)
    {
        view = [MBProgressHUD getCurrentWindow];
    }
    [MBProgressHUD hideHUDForView:view animated:YES];
    

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    //默认白色
    hud.contentColor = [UIColor whiteColor];
    hud.opaque = YES;
    hud.backgroundColor = [UIColor clearColor];
    //默认是模糊样式
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.75f];
    
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.backgroundColor = [UIColor clearColor];
    NSTimeInterval delayTime = delay;
    if (aText.length>12)
    {
        hud.detailsLabel.text= aText?NSLocalizedString(aText, nil):nil;
        hud.detailsLabel.font = [UIFont systemFontOfSize:15];
        delayTime = delay>0?delay:(1.f+hud.detailsLabel.text.length*0.05);
    }
    else
    {
        hud.label.text= aText?NSLocalizedString(aText, nil):nil;
        delayTime = delay>0?delay:(1.f+hud.label.text.length*0.05);
    }
    
    if (imageName)
    {
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        //放图片时去背景色
        hud.bezelView.color = [UIColor clearColor];
    }
    else
    {
        hud.mode = MBProgressHUDModeText;
    }
  
    [hud hideAnimated:YES afterDelay:delayTime];
    return hud;
}



//@"litteMoney"
+ (void)zx_showGifWithGifName:(NSString *)gifName toView:(nullable UIView *)view
{
    if (!view)
    {
        view = [MBProgressHUD getCurrentWindow];
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

//自定义加载动画
+ (void)zx_showGifWithGifName:(NSString *)gifName Text:(nullable NSString *)aText toView:(nullable UIView *)view{
    [MBProgressHUD zx_showGifWithGifName:gifName Text:aText time:0 toView:view];
}

//自定义加载动画 显示时间
+ (void)zx_showGifWithGifName:(NSString *)gifName Text:(nullable NSString *)aText time:(CGFloat)time toView:(nullable UIView *)view{
    if (!view)
    {
        view = [MBProgressHUD getCurrentWindow];
    }
    UIImage *image = [UIImage zx_animatedGIFNamed:gifName];
    UIImageView *gifView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,image.size.width/2, image.size.height/2)];
    gifView.image = image;
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (!hud){
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    
    if (aText.length>12){
        hud.detailsLabel.text= NSLocalizedString(aText, nil);
        hud.detailsLabel.font = [UIFont systemFontOfSize:15];
    }else{
        hud.label.text= NSLocalizedString(aText, nil);
    }
    hud.square = NO;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.5f];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = gifView;
    if (time){
        [hud hideAnimated:YES afterDelay:time];
    }
}

+ (BOOL)zx_hideHUDForView:(nullable UIView *)view
{
    if (!view)
    {
        view = [MBProgressHUD getCurrentWindow];
    }
   return [MBProgressHUD hideHUDForView:view animated:NO];
}


+ (nullable UIWindow *)getCurrentWindow
{
    UIWindow *view  = nil;
    view = [self getFrontWindow];
//    #ifdef DEBUG
//    view = [self getFrontWindow];
//    #else
//    view = [[UIApplication sharedApplication].windows lastObject];
//    if ([view isKindOfClass:NSClassFromString(@"_UIInteractiveHighlightEffectWindow")])
//    {
//        view = [[UIApplication sharedApplication].windows objectAtIndex:[UIApplication sharedApplication].windows.count-2];
//    }
//    #endif
    return view;
}

+ (NSArray *)getWindows
{
    NSArray *windows = nil;
    if (@available(iOS 13.0,*)) {
        NSSet *set = [UIApplication sharedApplication].connectedScenes;
        UIWindowScene *scene = (UIWindowScene *)[[set allObjects] firstObject];
        id sceneDelegate = scene.delegate;
        if (!sceneDelegate){
            windows = UIApplication.sharedApplication.windows;
        }
        else
        {
            windows = scene.windows;
        }
    }else{
        windows = UIApplication.sharedApplication.windows;
    }
    
    return windows;
}

+ (nullable UIWindow *)getFrontWindow
{
    NSEnumerator *frontToBackWindows = [[self getWindows] reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows)
    {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal);
        if(windowOnMainScreen && windowIsVisible && windowLevelSupported) {
            return window;
            break;
        }
    }
    return nil;
}



//
+ (void)jl_showGifWithGifName:(NSString *)gifName imagesCount:(NSInteger )imgCount toView:(nullable UIView *)view
{
    if (!view)
    {
        view = [MBProgressHUD getCurrentWindow];
    }
    
    NSMutableArray *arrayM = [NSMutableArray array];
    for (int i=1; i<=imgCount; ++i) {
        NSString *strImg = [NSString stringWithFormat:@"%@%d",gifName,i];
        UIImage *image = [UIImage imageNamed:strImg];
        if (image) {
            [arrayM addObject:image];
        }
    }
    UIImage *image = arrayM.firstObject;
    UIImageView *gifView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,image.size.width/2, image.size.height/2)];
    gifView.animationImages = arrayM;
    gifView.animationDuration = 0.05*arrayM.count;
    gifView.animationRepeatCount = 0;//播放次数（一直循环播放）
    [gifView startAnimating];//开始播放
    
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (!hud)
    {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    hud.square = NO;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor clearColor];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = gifView;
}

@end
