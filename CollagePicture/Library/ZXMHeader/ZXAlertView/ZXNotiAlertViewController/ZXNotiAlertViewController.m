//
//  ZXNotiAlertViewController.m
//  YiShangbao
//
//  Created by simon on 2017/8/5.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXNotiAlertViewController.h"

@interface ZXNotiAlertViewController ()

@end

@implementation ZXNotiAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    
    [self setView:self.containerView cornerRadius:10.f borderWidth:0 borderColor:nil];

}


//设置圆角
- (void)setView:(UIView *)view cornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color
{
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = radius;
    view.layer.borderWidth = width;
    
    view.layer.borderColor =color?[color CGColor]:[UIColor clearColor].CGColor;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancleBtnAction:(UIButton *)sender {
    
    if (self.cancleActionHandleBlock)
    {
        self.cancleActionHandleBlock();
    }
}

- (IBAction)doBtnAction:(UIButton *)sender {
    
    if (self.doActionHandleBlock)
    {
        self.doActionHandleBlock();
    }
}
@end
