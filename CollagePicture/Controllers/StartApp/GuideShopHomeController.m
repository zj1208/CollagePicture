//
//  GuideShopHomeController.m
//  YiShangbao
//
//  Created by simon on 2018/2/7.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "GuideShopHomeController.h"

@interface GuideShopHomeController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation GuideShopHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (IS_IPHONE_XX)
    {
        self.imageView.image = [UIImage imageNamed:@"shop_mainGuideX"];
    }
    else
    {
        self.imageView.image = [UIImage imageNamed:@"shop_mainGuide"];
    }
}
- (IBAction)dissmissAction:(UIButton *)sender {
    
    if (self.parentViewController) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        
        [WYUserDefaultManager setNewFunctionGuide_ShopHomeV1];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"NewFunctionGuide_ShopHomeV1_Dismiss" object:nil];;
    }
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

@end
