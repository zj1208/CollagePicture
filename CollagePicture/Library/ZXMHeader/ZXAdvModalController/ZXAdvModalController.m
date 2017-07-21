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

#ifndef LCDScale_iphone6_Width
#define LCDScale_iphone6_Width(X)    ((X)*([[UIScreen mainScreen] bounds].size.width)/375)
#endif


@interface ZXAdvModalController ()

@end

@implementation ZXAdvModalController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSURL *url = [NSURL ossImageWithResizeType:OSSImageResizeType_w600_hX relativeToImgPath:self.advModel.pic];
    [self.advPicBtn sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:nil];
    self.advPicBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.advPicBtn.contentHorizontalAlignment= UIControlContentHorizontalAlignmentFill;
    self.advPicBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    
    [self setView:self.advPicBtn cornerRadius:8.f borderWidth:1.f borderColor:nil];
}


//设置圆角
- (void)setView:(UIView *)view cornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color
{
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = radius;
    view.layer.borderWidth = width;
    
    view.layer.borderColor =color?[color CGColor]:[UIColor clearColor].CGColor;
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.dismissBtnLayoutWidth.constant = LCDScale_iphone6_Width(44.f);
    self.leftMaginLayout.constant = LCDScale_iphone6_Width(35.f);
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
