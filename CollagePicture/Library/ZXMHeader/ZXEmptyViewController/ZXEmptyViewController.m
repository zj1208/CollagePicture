//
//  ZXEmptyViewController.m
//  YiShangbao
//
//  Created by simon on 17/3/9.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXEmptyViewController.h"

@interface ZXEmptyViewController ()
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong)UIButton *updateBtn;

@property(nonatomic,assign)BOOL OnlyImage;
@end

@implementation ZXEmptyViewController

+ (instancetype)getInstance
{
    @synchronized(self)
    {
        static ZXEmptyViewController *obj = nil;
        if (obj == nil)
        {
            obj = [[self alloc] init];
        }
        return obj;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.contentMode = UIViewContentModeScaleToFill;
    
    [self.view addSubview:imgView];
    self.imageView = imgView;
    
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.numberOfLines = 0;
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = UIColorFromRGB_HexValue(0x666666);
    label1.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:label1];
    self.label = label1;
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"点击加载" forState:UIControlStateNormal];
    [btn setCornerRadius:5.f borderWidth:1.f borderColor:[UIColor colorWithWhite:0.8 alpha:1]];
    [btn setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(updateNewData:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:btn];
    self.updateBtn = btn;
}


- (void)updateNewData:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(zxEmptyViewUpdateAction)])
    {
        [self.delegate zxEmptyViewUpdateAction];
    }
}

- (void)viewDidLayoutSubviews
{
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
    //海狮解决办法：
//    ZXEmptyViewController *emptyVC =[[ZXEmptyViewController alloc] init];
//    emptyVC.delegate = self;
//    emptyVC.view.frame = CGRectMake(0, 64, LCDW, LCDH);
    

    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.size.mas_equalTo(_imageView.image.size);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo (self.view.mas_centerY).offset(-_imageView.image.size.height);
    }];
    if (self.OnlyImage) {
        [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.size.mas_equalTo(_imageView.image.size);
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.centerY.mas_equalTo (self.view.mas_centerY).offset(-_imageView.image.size.height*0.3);
        }];
    }
    
    [self.label mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(_imageView.mas_bottom).offset(12);
        make.centerX.mas_equalTo(self.view.mas_centerX);

    }];
    
    [self.updateBtn mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(_label.mas_bottom).offset(40);
        make.width.mas_equalTo(LCDScale_iphone6_Width(120));
        make.height.mas_equalTo(LCDScale_iphone6_Width(30));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        
    }];
    
    [super viewDidLayoutSubviews];

}

- (void)addEmptyViewInController:(UIViewController *)viewController hasLocalData:(BOOL)flag error:(nullable NSError *)error emptyImage:(nullable UIImage *)emptyImage emptyTitle:(nullable NSString *)title updateBtnHide:(BOOL)hide
{
    if ([NSString zhIsBlankString:title]) { 
        self.OnlyImage = YES;
    }else{
        self.OnlyImage = NO; //接生意与我相关切换时没数据的氛围图有文字
    }
    
    if (error)
    {
        NSLog(@"%@",error);
        if (error.code ==kAPPErrorCode_Token)
        {
            [MBProgressHUD zx_showError:[error localizedDescription] toView:self.view];
            return;
        }
    }

    //如果本来是有数据的
    if (flag)
    {
        [self localHasDataInController:viewController error:error];
    }
    //如果是没有数据的
    else
    {
        if (![viewController.childViewControllers containsObject:self])
        {
            [viewController addChildViewController:self];
            [viewController.view addSubview:self.view];
        }
        self.label.text = title;
        self.updateBtn.hidden = hide;
        self.imageView.image = emptyImage;
    }

}



- (void)localHasDataInController:(UIViewController *)viewController error:(NSError *)error
{
    if (error)
    {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:self.view];
    }
    //如果没有错误，则隐藏
    else
    {
        if ([viewController.childViewControllers containsObject:self])
        {
            [self removeFromParentViewController];
            [self.view removeFromSuperview];
        }
    }
}


- (void)hideEmptyViewInController:(UIViewController *)viewController  hasLocalData:(BOOL)flag
{
    if (flag)
    {
        if ([viewController.childViewControllers containsObject:self])
        {
            [self removeFromParentViewController];
            [self.view removeFromSuperview];
        }
 
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
