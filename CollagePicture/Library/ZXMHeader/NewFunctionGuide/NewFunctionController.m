//
//  NewFunctionController.m
//  lovebaby
//
//  Created by simon on 16/6/12.
//  Copyright © 2016年 厦门致上信息科技有限公司. All rights reserved.
//

#import "NewFunctionController.h"
#import "DrawRectView.h"

NSString *const kNewFunctionGuide = @"kNewFunctionGuide";
@interface NewFunctionController ()

@end

@implementation NewFunctionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //先设置全透明
    [self.view setBackgroundColor:[UIColor clearColor]];

    //添加只全透明某一部分的view，其余半透明；
    DrawRectView *drawView = [[DrawRectView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:drawView];
    
    [self.view sendSubviewToBack:drawView];
    
    self.promptBtn.layer.masksToBounds = YES;
    self.promptBtn.layer.cornerRadius = 5.f;
    
    self.uploadBtn.layer.masksToBounds = YES;
    self.uploadBtn.layer.cornerRadius = 5.f;
    
 
    
}

- (void)firstLaunchApp
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNewFunctionGuide];
    [[NSUserDefaults standardUserDefaults] synchronize];
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

- (IBAction)noPromptAction:(UIButton *)sender {
    
    //统计
//    [MobClick event:kUM_guide_not_show];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        [self firstLaunchApp];
    }];
}


- (IBAction)uploadBtnAction:(UIButton *)sender {
    
//    //统计
//    [MobClick event:kUM_guide_import_pic];
    
    [self dismissViewControllerAnimated:YES completion:^{
       
         [self firstLaunchApp];
        if ([_delegate respondsToSelector:@selector(zxNewFuntionGuideControllerAction)])
        {
            [_delegate zxNewFuntionGuideControllerAction];
        }
       
    }];
}
@end
