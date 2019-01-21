//
//  ZXEmptyViewController.m
//  YiShangbao
//
//  Created by simon on 17/3/9.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXEmptyViewController.h"
#import "MBProgressHUD+ZXCategory.h"

// 注意： beginAppearanceTransition: /endAppearanceTransition 方法没必要写，自定义显示回调机制的时候才使用，系统默认也会回调viewWillAppear等方法的

static NSInteger  kAPPErrorCode_Token2 = 5001;


@interface ZXEmptyViewController ()
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIButton *updateBtn;

//@property(nonatomic,assign)BOOL OnlyImage;
@end

@implementation ZXEmptyViewController

//+ (instancetype)sharedInstance
//{
//    @synchronized(self)
//    {
//        static ZXEmptyViewController *obj = nil;
//        if (obj == nil)
//        {
//            obj = [[self alloc] init];
//        }
//        return obj;
//    }
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)setUI
{
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
    [self setView:btn cornerRadius:5.f borderWidth:1.f borderColor:[UIColor colorWithWhite:0.8 alpha:1]];
    [btn setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(updateNewData:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    self.updateBtn = btn;
 
}


//设置圆角
- (void)setView:(UIView *)view cornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color
{
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = radius;
    view.layer.borderWidth = width;
    
    view.layer.borderColor =color?[color CGColor]:[UIColor clearColor].CGColor;
}


- (void)updateNewData:(id)sender
{
    [self hideEmptyViewInController:self.parentViewController hasLocalData:YES];

    if ([self.delegate respondsToSelector:@selector(zxEmptyViewUpdateAction)])
    {
        [self.delegate zxEmptyViewUpdateAction];
    }
}

- (void)setContentOffest:(CGSize)contentOffest
{
    _contentOffest = contentOffest;
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
    
    //先设置图片居中显示
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.size.mas_equalTo(_imageView.image.size);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    //有提示语的时候， 有按钮，无按钮；
    if (self.label.text.length>0 )
    {
        CGRect rect = [self.label.text boundingRectWithSize:CGSizeMake(LCDW-24, LCDH) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.label.font} context:nil];

        CGFloat otherContentHeight = 0.f;
        //有点击加载按钮；
        if (!self.updateBtn.hidden)
        {
            otherContentHeight = 12+rect.size.height+40+LCDScale_iPhone6_Width(30);
        }
        //无点击加载按钮
        else
        {
            otherContentHeight = 12+rect.size.height;
        }
        
        [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.mas_equalTo (self.view.mas_centerY).offset(-otherContentHeight/2-64+_contentOffest.height);
        }];

    }
    //无提示语，有加载按钮；
    else if (self.label.text.length==0 && !self.updateBtn.hidden)
    {
        CGFloat otherContentHeight = 12+40+LCDScale_iPhone6_Width(30);
        [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.mas_equalTo (self.view.mas_centerY).offset(-otherContentHeight/2-64+_contentOffest.height);
        }];

    }
    //无提示语，无加载按钮；
    else if (self.label.text.length==0 && self.updateBtn.hidden)
    {
        [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.mas_equalTo (self.view.mas_centerY).offset(-64+_contentOffest.height);
        }];
        
    }

    
    [self.label mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(_imageView.mas_bottom).offset(12);
        make.left.mas_equalTo(self.view.mas_left).offset(12);
        make.centerX.mas_equalTo(self.view.mas_centerX);

    }];
    
    [self.updateBtn mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(_label.mas_bottom).offset(40);
        make.width.mas_equalTo(LCDScale_iPhone6_Width(120));
        make.height.mas_equalTo(LCDScale_iPhone6_Width(30));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        
    }];
    

}

- (void)addEmptyViewInController:(UIViewController *)viewController hasLocalData:(BOOL)flag error:(nullable NSError *)error emptyImage:(nullable UIImage *)emptyImage emptyTitle:(nullable NSString *)title updateBtnHide:(BOOL)hide
{
    
    if (error)
    {
        NSLog(@"%@",error);
        if (error.code ==kAPPErrorCode_Token2)
        {
            [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
            return;
        }
    }

    //如果有数据的
    if (flag)
    {
        [self localHasDataInController:viewController error:error];
    }
    //如果是没有数据的
    else
    {
        //有不足的地方，没法更灵活添加到某区域；是直接加入到控制器的view上，导致tabViewController，或者隐藏导航条等地方，不能正常显示；
        if (![viewController.childViewControllers containsObject:self])
        {
            
            [viewController addChildViewController:self];
            [viewController.view addSubview:self.view];
            self.view.alpha = 0;
            [self beginAppearanceTransition:YES animated:YES];
            
            __weak __typeof(self) weakSelf = self;
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.view.alpha = 1;
            } completion:^(BOOL finished) {
                
                [weakSelf endAppearanceTransition];
                [weakSelf didMoveToParentViewController:viewController];
                
            }];

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
        if ([viewController isKindOfClass:[UITableViewController class]] ||[viewController isKindOfClass:[UICollectionViewController class]])
        {
            [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
        }
        else
        {
            [MBProgressHUD zx_showError:[error localizedDescription] toView:viewController.view];
        }
    }
    //如果没有错误，则隐藏
    else
    {
  
        if ([viewController.childViewControllers containsObject:self])
        {
            [self willMoveToParentViewController:nil];
            [self beginAppearanceTransition:NO animated:YES];
            
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
            [self endAppearanceTransition];
        }
    }
}

- (void)hideEmptyViewInController:(UIViewController *)viewController
{
    if ([viewController.childViewControllers containsObject:self])
    {
        [self willMoveToParentViewController:nil];
        [self beginAppearanceTransition:NO animated:YES];
        
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        [self endAppearanceTransition];
    }
}


- (void)hideEmptyViewInController:(UIViewController *)viewController  hasLocalData:(BOOL)flag
{
//    [MBProgressHUD zx_hideHUDForView:nil];
    if (flag)
    {
        
        if ([viewController.childViewControllers containsObject:self])
        {
            [self willMoveToParentViewController:nil];
            [self beginAppearanceTransition:NO animated:YES];
            
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
            [self endAppearanceTransition];
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
