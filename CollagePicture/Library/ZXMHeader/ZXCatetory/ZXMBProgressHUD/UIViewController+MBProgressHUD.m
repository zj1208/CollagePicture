//
//  UIViewController+MBProgressHUD.m
//  ICBC
//
//  Created by 朱新明 on 15/2/5.
//  Copyright (c) 2015年 朱新明. All rights reserved.
//

#import "UIViewController+MBProgressHUD.h"

#import "UIImage+ZXGIF.h"

#ifndef UIColorFromRGB_HexValue
#define UIColorFromRGB_HexValue(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbValue & 0xFF))/255.0f alpha:1.f]
#endif

@implementation UIViewController (MBProgressHUD)

//UIView *  aView = [[[UIApplication sharedApplication]delegate]window];


- (void)zhHUD_showWithStatus:(NSString*)aText
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud)
    {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        //默认白色
        hud.contentColor = [UIColor whiteColor];
        hud.opaque = YES;
        hud.backgroundColor = [UIColor clearColor];
        //默认是模糊样式
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.75f];
        
        hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.backgroundView.backgroundColor = [UIColor clearColor];
    }
    hud.label.text= aText;
    
}

//不用了；
- (void)zhHUD_showHUDAddedTo:(UIView*)view labelText:(NSString *)aText{
    

    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (![MBProgressHUD HUDForView:view])
    {
       hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        //默认白色
        hud.contentColor = [UIColor whiteColor];
        hud.opaque = YES;
        hud.backgroundColor = [UIColor clearColor];
        //默认是模糊样式
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.75f];
        
        hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.backgroundView.backgroundColor = [UIColor clearColor];
    }
    hud.label.text= aText;
}



- (MBProgressHUD *)zhHUD_showErrorWithStatus:(NSString *)aText
{
    return [self zhHUD_showText:aText customIcon:nil afterDelay:1.f];
}


- (void)zhHUD_showSuccessWithStatus:(NSString *)aText
{
    [self zhHUD_showSuccessWithStatus:aText afterDelay:1.f];
}


- (void)zhHUD_showSuccessWithStatus:(NSString *)aText afterDelay:(CGFloat)delay
{
    [self zhHUD_showText:aText customIcon:nil afterDelay:delay];
}


- (MBProgressHUD *)zhHUD_showText:(NSString *)aText customIcon:(NSString *)imageName afterDelay:(CGFloat)delay
{
    [self zhHUD_hideHUD];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //默认白色
    hud.contentColor = [UIColor whiteColor];
    hud.opaque = YES;
    hud.backgroundColor = [UIColor clearColor];
    //默认是模糊样式
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.75f];
    
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.backgroundColor = [UIColor clearColor];
    
   
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
    [hud hideAnimated:YES afterDelay:delay];
    return hud;
}



- (void)zhHUD_hideHUD
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


//不用了
- (void)zhHUD_hideHUDForView:(UIView *)view
{
    [MBProgressHUD hideHUDForView:view animated:YES];
}


- (void)zhHUD_showGifPlay
{
    UIImage *image = [UIImage zx_animatedGIFNamed:@"loading"];
    UIImageView *gifView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,image.size.width/2, image.size.height/2)];
    gifView.image = image;
    MBProgressHUD *hud = nil;
    if (![MBProgressHUD HUDForView:self.view])
    {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
//    hud.bezelView.backgroundColor = [UIColor clearColor];
//    hud.backgroundView.backgroundColor =[UIColor clearColor];
    hud.square = NO;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor clearColor];

    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = gifView;
}


//- (MBProgressHUD *)progressHUD {
//    if (!_progressHUD) {
//        _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
//        _progressHUD.minSize = CGSizeMake(120, 120);
//        _progressHUD.minShowTime = 1;
//        [self.view addSubview:_progressHUD];
//    }
//    return _progressHUD;
//}
//
//- (void)showProgressHUDWithMessage:(NSString *)message {
//    self.progressHUD.labelText = message;
//    self.progressHUD.mode = MBProgressHUDModeIndeterminate;
//    [self.progressHUD show:YES];
//    self.navigationController.navigationBar.userInteractionEnabled = NO;
//}
//
//- (void)hideProgressHUD:(BOOL)animated {
//    [self.progressHUD hide:animated];
//    self.navigationController.navigationBar.userInteractionEnabled = YES;
//}
//
//- (void)showProgressHUDCompleteMessage:(NSString *)message {
//    if (message) {
//        if (self.progressHUD.isHidden) [self.progressHUD show:YES];
//        self.progressHUD.labelText = message;
//        self.progressHUD.mode = MBProgressHUDModeCustomView;
//        [self.progressHUD hide:YES afterDelay:1.5];
//    } else {
//        [self.progressHUD hide:YES];
//    }
//    self.navigationController.navigationBar.userInteractionEnabled = YES;
//}



//- (void)zhHUD_showHUDAddedToEffectsWindowWithlabelText:(NSString *)aText
//{
//    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:1];
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
//    hud.labelText= aText;
//
//}

//- (void)zhHUD_showHUDAddToEffectsWindowWithModeText:(NSString *)aText
//{
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    
//    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:1];
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
//    hud.labelText= NSLocalizedString(aText, nil);
//    hud.mode = MBProgressHUDModeText;
//    [hud hide:YES afterDelay:2.f];
//    
//}
//
//- (void)zhHUD_showHUDWithEmojiModeText:(NSString *)aText EffectsWindow:(BOOL)on
//{
//    UIView *view = self.view;
//    if (on)
//    {
//        view = (UIView*)[[UIApplication sharedApplication].windows objectAtIndex:1];
//        
//    }
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    
//    NSString *string = [NSString stringWithFormat:@"\ue058%@",aText];
//    hud.labelText= NSLocalizedString(string, nil);
//    hud.mode = MBProgressHUDModeText;
//    if (on)
//    {
//        hud.window.windowLevel = UIWindowLevelAlert+1;
//        
//    }
//    [hud hide:YES afterDelay:2.f];
//    
//    
//}
//
//
//- (void)zhHUD_hideHUDEffectsWindowAnimated:(BOOL)animated
//{
//    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:1];
//    [MBProgressHUD hideHUDForView:window animated:YES];
//}
//

@end
