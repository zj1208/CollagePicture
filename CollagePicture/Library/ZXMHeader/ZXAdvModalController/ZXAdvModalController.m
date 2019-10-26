//
//  ZXAdvModalController.m
//  YiShangbao
//
//  Created by simon on 17/3/24.
//  Copyright © 2017年 com.Microants. All rights reserved.
//  

#import "ZXAdvModalController.h"

#import "NSURL+OSSImage.h"
#import "UIButton+WebCache.h"
#import "UIView+ZXAnimation.h"

#ifndef LCDScale_iPhone6_Width
#define LCDScale_iPhone6_Width(X)    ((X)*([[UIScreen mainScreen] bounds].size.width)/375)
#endif


@interface ZXAdvModalController ()
@property (nonatomic, strong) UIVisualEffectView *effectView;

@end

@implementation ZXAdvModalController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setUI];

}

- (void)setUI
{
    self.view.backgroundColor = [UIColor clearColor];
    self.advPicBtn.backgroundColor = [UIColor clearColor];
    self.advPicBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.advPicBtn.contentHorizontalAlignment= UIControlContentHorizontalAlignmentFill;
    self.advPicBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    
    [self setView:self.advPicBtn cornerRadius:8.f borderWidth:1.f borderColor:nil];
    [self.advPicBtn zx_addMotionEffectXAxisWithValue:20 YAxisWithValue:20];

//    [self.view addSubview:self.effectView];
//    [self.view bringSubviewToFront: self.advPicBtn];
//    [self.view bringSubviewToFront: self.dismissBtn];
//    
    
    NSURL *url = [NSURL ossImageWithResizeType:OSSImageResizeType_w600_hX relativeToImgPath:self.advModel.pic];
//    NSURL *url = [NSURL URLWithString:@"http://macdn.microants.cn/2/sh/eb738b0ea44830fba171707d3481a7eb1530582553695.jpg"];
    [self.advPicBtn sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

//        self.effectView.effect = nil;
//        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//        [UIView animateWithDuration:1.5 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//
//            self.effectView.effect = blur;
//        } completion:nil];
    }];
    
}
//设置圆角
- (void)setView:(UIView *)view cornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color
{
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = radius;
    view.layer.borderWidth = width;
    
    view.layer.borderColor =color?[color CGColor]:[UIColor clearColor].CGColor;
}

- (UIVisualEffectView *)effectView
{
    if (!_effectView)
    {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectview.alpha = 0.3;
        _effectView = effectview;
    }
    return _effectView;
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.dismissBtnLayoutWidth.constant = LCDScale_iPhone6_Width(44.f);
    self.leftMaginLayout.constant = LCDScale_iPhone6_Width(35.f);
//    self.effectView.frame = self.view.frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)advPicBtnAction:(UIButton *)sender {
    
    __weak __typeof(self)weakSelf = self;
    if (self.presentingViewController)
    {
        [self dismissViewControllerAnimated:NO completion:^{
            
            [weakSelf clickAction];
            
        }];
    }
}

- (void)clickAction
{
    if ([self.btnActionDelegate respondsToSelector:@selector(zx_advModalController:advItem:)])
    {
        [self.btnActionDelegate zx_advModalController:self advItem:_advModel];
    }

}

- (IBAction)dismissBtnAction:(id)sender {
    
    if (self.presentingViewController)
    {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
