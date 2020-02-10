//
//  ZXEmptyViewController.m
//  YiShangbao
//
//  Created by simon on 17/3/9.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXEmptyViewController.h"
#import "MBProgressHUD+ZXCategory.h"
#import "AFNetworkReachabilityManager.h"
#import <Masonry/Masonry.h>

#import "ZXWKWebViewController.h"

// 注意： beginAppearanceTransition: /endAppearanceTransition 方法没必要写，自定义显示回调机制的时候才使用，系统默认也会回调viewWillAppear等方法的

//static NSInteger  kAPPErrorCode_Token2 = 5001;
#ifndef IS_IPHONE_XX
#define IS_IPHONE_XX ({\
int tmp = 0;\
if (@available(iOS 11.0, *)) { \
    UIEdgeInsets areaInset = [UIApplication sharedApplication].delegate.window.safeAreaInsets;\
    if (areaInset.bottom >0) { \
        tmp = 1;\
    }\
}\
else{\
    tmp = 0;\
}\
tmp;\
})
#endif

#ifndef  kHEIGHT_SAFEAREA_STATUSBAR
#define  kHEIGHT_SAFEAREA_STATUSBAR   (IS_IPHONE_XX ? (20.f+24.f) : (20.f))
#endif

#ifndef  kHEIGHT_SAFEAREA_NAVBAR
#define  kHEIGHT_SAFEAREA_NAVBAR      (kHEIGHT_SAFEAREA_STATUSBAR+44.f)
#endif

#ifndef TEXT_ERROR_NETWORK
#define TEXT_ERROR_NETWORK @"哎呀！网路粗问题了，请稍后再试！"
#define TEXT_ERROR_SERVER @"哎呀！粗问题了，请稍后再试！"
#endif

@interface ZXEmptyViewController ()
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIButton *centerButton;

@property (nonatomic, assign) ZXEmptyViewTouchEventType touchEventType;

@end

@implementation ZXEmptyViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    //设置默认frame
    self.view.frame =CGRectMake(0, kHEIGHT_SAFEAREA_NAVBAR, LCDW, LCDH-kHEIGHT_SAFEAREA_NAVBAR);
    [self setUI];
    [self setData];
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

    [self.view addSubview:self.imageView];
    [self.view addSubview:self.textLabel];
    [self.view addSubview:self.centerButton];
    
    CGFloat btnHeight = LCDScale_iPhone6(30);
    CGFloat btnWidth = LCDScale_iPhone6(120);
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(self.imageView.image.size);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo (self.view.mas_centerY).offset(-64+self.contentOffest.height);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(12);
        make.left.mas_equalTo(self.view.mas_left).offset(12);
        make.centerX.mas_equalTo(self.view.mas_centerX);

    }];
    
    [self.centerButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.textLabel.mas_bottom).offset(40);
        make.width.mas_equalTo(btnWidth);
        make.height.mas_equalTo(btnHeight);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        
    }];
}



- (UIImageView *)imageView
{
    if (!_imageView) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.contentMode = UIViewContentModeScaleToFill;
        _imageView = imgView;
    }
    return _imageView;
}

- (UILabel *)textLabel
{
    if (!_textLabel) {
        UILabel *lab = [[UILabel alloc] init];
        lab.numberOfLines = 0;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = UIColorFromRGB_HexValue(0x34373A);
        lab.font = [UIFont systemFontOfSize:14];
        _textLabel = lab;
    }
    return _textLabel;
}

- (UIButton *)centerButton
{
    if (!_centerButton) {

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"点击加载" forState:UIControlStateNormal];
        [self setView:btn cornerRadius:5.f borderWidth:1.f borderColor:[UIColor colorWithWhite:0.8 alpha:1]];
        [btn setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(updateNewData:) forControlEvents:UIControlEventTouchUpInside];
        _centerButton = btn;
    }
    return _centerButton;
}


- (void)setView:(UIView *)view cornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color
{
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = radius;
    view.layer.borderWidth = width;
    
    view.layer.borderColor =color?[color CGColor]:[UIColor clearColor].CGColor;
}

#pragma mark -
- (void)setData
{
    self.showErrorCodeOnLabelText = NO;
    self.showErrorCodeOnToatText = YES;
    self.showErrorToastViewTogather = YES;
}


- (void)setContentOffest:(CGSize)contentOffest
{
    _contentOffest = contentOffest;
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat btnHeight = LCDScale_iPhone6(30);
    CGFloat imageWithTitleLayoutConstant = 12;
    CGFloat titleWithButtonLayoutConstant = 40;
    CGFloat imageWithButtonLayoutConstant = 30;
    

    //   imageView调整
    
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(self.imageView.image.size);
    }];
    
    if (self.textLabel.text.length>0 )
    {
        CGRect titleLabRect = [self.textLabel.text boundingRectWithSize:CGSizeMake(LCDW-24, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.textLabel.font} context:nil];

        CGFloat otherContentHeight = 0.f;
        //有点击加载按钮；
        if (!self.centerButton.hidden)
        {
            otherContentHeight = imageWithTitleLayoutConstant+titleLabRect.size.height+titleWithButtonLayoutConstant+btnHeight;
        }
        //无点击加载按钮
        else
        {
            otherContentHeight = imageWithTitleLayoutConstant+titleLabRect.size.height;
        }
        
        [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.mas_equalTo (self.view.mas_centerY).offset(-otherContentHeight/2-64+self.contentOffest.height);
        }];
    }
    //无提示语，有加载按钮；
    else if (self.textLabel.text.length==0 && !self.centerButton.hidden)
    {
        CGFloat otherContentHeight =imageWithTitleLayoutConstant+ titleWithButtonLayoutConstant+btnHeight;
        [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.mas_equalTo (self.view.mas_centerY).offset(-otherContentHeight/2-64+self.contentOffest.height);
        }];
    }
    //无提示语，无加载按钮；
    else if (self.textLabel.text.length==0 && self.centerButton.hidden)
    {
        [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.mas_equalTo (self.view.mas_centerY).offset(-64+self.contentOffest.height);
        }];
    }

    
    // centerButton调整
    if (!self.centerButton.hidden)
    {
        //宽度
        CGRect titleLabRect = [self.centerButton.currentTitle boundingRectWithSize:CGSizeMake(LCDW-24, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.centerButton.titleLabel.font} context:nil];
        //偏移
        CGFloat centerButtonToTitleLabelOffest = titleWithButtonLayoutConstant;
        if (self.textLabel.text.length==0) {
            centerButtonToTitleLabelOffest = imageWithButtonLayoutConstant-imageWithTitleLayoutConstant;
        }
        [self.centerButton mas_updateConstraints:^(MASConstraintMaker *make) {

            make.width.mas_equalTo(titleLabRect.size.width + btnHeight);
            make.top.mas_equalTo(self.textLabel.mas_bottom).offset(centerButtonToTitleLabelOffest);
        }];
    }
}


#pragma mark -

- (void)zx_addEmptyViewWithUpdateBtnInController:(UIViewController *)viewController hasLocalData:(BOOL)flag error:(nullable NSError *)error emptyImage:(nullable UIImage *)emptyImage emptyTitle:(nullable NSString *)title updateBtnHide:(BOOL)hide
{
    [self addEmptyViewInController:viewController hasLocalData:flag error:error image:emptyImage title:title centerButtonHide:hide];
}



- (void)zx_addEmptyViewInController:(UIViewController *)viewController hasLocalData:(BOOL)flag error:(nullable NSError *)error emptyImage:(nullable UIImage *)emptyImage emptyTitle:(nullable NSString *)title
{
    BOOL hide = YES;
    if (error)
    {
        if (error.code == -1005 || error.code == -1009 || error.code == -1001) {
            hide = NO;
        }
        self.touchEventType = ZXEmptyViewTouchEventTypeUpdate;
    }else
    {
        self.touchEventType = ZXEmptyViewTouchEventTypeNoUpdate;
    }

    [self.centerButton setTitle:@"查看解决方案" forState:UIControlStateNormal];
    [self.centerButton setTitleColor:UIColorFromRGB_HexValue(0x595E66) forState:UIControlStateNormal];
    [self setView:self.centerButton cornerRadius:15.f borderWidth:0.5f borderColor:UIColorFromRGB_HexValue(0xCCCCCC)];
    [self addEmptyViewInController:viewController hasLocalData:flag error:error image:emptyImage title:title centerButtonHide:hide];
}

// 网络问题-“查看解决方案”按钮，服务器问题--"点击加载"按钮
- (void)zx_addEmptyView2InController:(UIViewController *)viewController hasLocalData:(BOOL)flag error:(nullable NSError *)error emptyImage:(nullable UIImage *)emptyImage emptyTitle:(nullable NSString *)title
{
    if (error) {
        if (error.code == -1005 || error.code == -1009 || error.code == -1001) {
            [self addErrorViewWithSolutionButtonInController:viewController hasLocalData:flag error:error errorImage:emptyImage errorTitle:title centerButtonHide:NO];
        }else
        {
            [self addErrorViewWithUpdateButtonInController:viewController hasLocalData:flag error:error errorImage:emptyImage errorTitle:title centerButtonHide:NO];
        }
    }else
    {
        [self addEmptyViewWithNOButtonInController:viewController hasLocalData:flag error:error emptyImage:emptyImage emptyTitle:title centerButtonHide:YES];
    }
}

#pragma mark 最终方法
- (void)addEmptyViewInController:(UIViewController *)viewController hasLocalData:(BOOL)flag error:(nullable NSError *)error image:(nullable UIImage *)image title:(nullable NSString *)title centerButtonHide:(BOOL)hide
{
    //->请求错误或成功
    if (flag)
    {
        if (error)
        {
            //加在已显示页面上；
            [self zx_makeToastInViewController:viewController withError:error];
        }
        //success
        else
        {
            [self zx_hideEmptyViewInContainerViewConroller];
        }
    }
    //->请求错误或成功或空数据
    else
    {
        if (![viewController.childViewControllers containsObject:self])
        {
            [self zx_addChildViewControllerInController:viewController];
        }
        self.imageView.image = image;
        self.textLabel.text = [self zx_finallyTextLabelTitle:title withError:error];
        self.centerButton.hidden = hide;
        //加在当前viewController上
        if (error)
        {
            [self zx_makeToastInViewController:self withError:error];
        }
    }
}





#pragma mark-
// 函数一：请求失败的时候调用；先失败-添加；二次失败-添加；先成功有数据后失败-不添加，toast提示
- (void)zx_showErrorWithEmptyViewInController:(UIViewController *)viewController error:(nullable NSError *)error errorImage:(nullable UIImage *)errorImage errorTitle:(nullable NSString *)title updateBtnHide:(BOOL)hide hasLocalData:(BOOL)flag
{
    if (flag) {
        //toast提示
        return;
    }
    if (![viewController.childViewControllers containsObject:self])
    {
        [self zx_addChildViewControllerInController:viewController];
    }
    self.textLabel.text = [self zx_finallyTextLabelTitle:title withError:error];
    self.centerButton.hidden = hide;
    self.imageView.image = errorImage;
}

// 函数三：请求成功的时候添加空视图；先失败后成功-添加；先成功且没数据显示-添加； 先成功且有数据显示情况下-不执行；
- (void)zx_showSccessWithEmptyViewInController:(UIViewController *)viewController emptyImage:(nullable UIImage *)emptyImage emptyTitle:(nullable NSString *)title hasLocalData:(BOOL)flag
{
    if (flag) {
        return;
    }
    self.touchEventType = ZXEmptyViewTouchEventTypeNoUpdate;
    if (![viewController.childViewControllers containsObject:self])
    {
        [self zx_addChildViewControllerInController:viewController];
    }
    self.textLabel.text = [self zx_finallyTextLabelTitle:title withError:nil];
    self.centerButton.hidden = YES;
    self.imageView.image = emptyImage;
}

#pragma mark-

// 无按钮 空氛围视图
- (void)addEmptyViewWithNOButtonInController:(UIViewController *)viewController hasLocalData:(BOOL)flag error:(nullable NSError *)error emptyImage:(nullable UIImage *)emptyImage emptyTitle:(nullable NSString *)title centerButtonHide:(BOOL)hide
{
    self.touchEventType = ZXEmptyViewTouchEventTypeNoUpdate;
    [self addEmptyViewInController:viewController hasLocalData:flag error:error image:emptyImage title:title centerButtonHide:hide];
}
// error-重新请求按钮
- (void)addErrorViewWithUpdateButtonInController:(UIViewController *)viewController hasLocalData:(BOOL)flag error:(nullable NSError *)error errorImage:(nullable UIImage *)image errorTitle:(nullable NSString *)title centerButtonHide:(BOOL)hide
{
    self.touchEventType = ZXEmptyViewTouchEventTypeNoUpdate;
    [self addEmptyViewInController:viewController hasLocalData:flag error:error image:image title:title centerButtonHide:hide];
}
// error-解决方案按钮
- (void)addErrorViewWithSolutionButtonInController:(UIViewController *)viewController hasLocalData:(BOOL)flag error:(nullable NSError *)error errorImage:(nullable UIImage *)image errorTitle:(nullable NSString *)title centerButtonHide:(BOOL)hide
{
    self.touchEventType = ZXEmptyViewTouchEventTypeUpdate;
    [self.centerButton setTitle:@"查看解决方案" forState:UIControlStateNormal];
    [self.centerButton setTitleColor:UIColorFromRGB_HexValue(0x595E66) forState:UIControlStateNormal];
    [self setView:self.centerButton cornerRadius:15.f borderWidth:0.5f borderColor:UIColorFromRGB_HexValue(0xCCCCCC)];
    
    [self addEmptyViewInController:viewController hasLocalData:flag error:error image:image title:title centerButtonHide:hide];
}


#pragma mark - add添加

- (void)zx_addChildViewControllerInController:(UIViewController *)viewController
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


#pragma mark - 内部方法

// 获取最终的提示文本；
- (NSString *)zx_finallyTextLabelTitle:(NSString *)title withError:(NSError *)error
{
    if (error && self.showErrorCodeOnLabelText)
    {
        NSString *titleWithErrorCode = [NSString stringWithFormat:@"%@(%@)",title,@(error.code)];
        return titleWithErrorCode;
    }
    return title;
}

- (NSString *)zx_finallyToastTitle:(NSString *)title withError:(NSError *)error
{
    if (error && self.showErrorCodeOnToatText)
    {
        NSString *titleWithErrorCode = [NSString stringWithFormat:@"%@(%@)",title,@(error.code)];
        return titleWithErrorCode;
    }
    return title;
}

- (void)zx_makeToastInViewController:(UIViewController *)viewController withError:(NSError *)error
{
    NSString * eTitle = nil;
    if (error.code == -1005 || error.code == -1009 || error.code == -1001) {
         eTitle = TEXT_ERROR_NETWORK;
     }else
     {
         eTitle = TEXT_ERROR_SERVER;
     }
    NSString *errorTitle = [self zx_finallyToastTitle:eTitle withError:error];
//    NSString *errorTitle = [self zx_finallyToastTitle:[error localizedDescription] withError:error];
    if ([viewController isKindOfClass:[UITableViewController class]] ||[viewController isKindOfClass:[UICollectionViewController class]])
     {
         [MBProgressHUD zx_showError:errorTitle toView:nil hideAfterDelay:2.0];
     }
     else
     {
         [MBProgressHUD zx_showError:errorTitle toView:viewController.view hideAfterDelay:2.0];
     }
}

#pragma mark -hide
// 函数二：
- (void)zx_hideEmptyViewInContainerViewConroller
{
    if (self.parentViewController)
    {
        [self willMoveToParentViewController:nil];
        [self beginAppearanceTransition:NO animated:YES];
        
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        [self endAppearanceTransition];
    }
}


#pragma mark - button selector

- (void)updateNewData:(UIButton *)sender
{
    if ([sender.currentTitle isEqualToString:@"点击加载"]) {
        
        [self updateNewDataAction];
    }
    else if ([sender.currentTitle isEqualToString:@"查看解决方案"])
    {

        ZXWKWebViewController *vc = [[ZXWKWebViewController alloc] init];
        [vc loadWebHTMLSringWithFileResource:@"networkErrorHelp"];
        if (self.parentViewController.navigationController) {
            vc.hidesBottomBarWhenPushed = YES;
            [self.parentViewController.navigationController pushViewController:vc animated:NO];
        }
    }
}


#pragma mark - touchBegan

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    // MBBackgroundView,UIView
    UIView *view = [[[touches allObjects] firstObject] view];
    if ([view isEqual:self.view]) {
        if (self.touchEventType == ZXEmptyViewTouchEventTypeUpdate) {
            
            if ([self canPerformAction:@selector(updateNewDataAction) withSender:self]) {
                
                [self updateNewDataAction];
            }
        }
    }
}


#pragma mark - action

- (void)updateNewDataAction
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    if (![[AFNetworkReachabilityManager sharedManager]isReachable]) {
        
//        [self.view makeToast:NSLocalizedString(@"网络未连接,请检查后重试", nil)];
        [MBProgressHUD zx_showError:NSLocalizedString(@"网络未连接,请检查后重试", nil) toView:self.view];
        return;
    }
    [self zx_hideEmptyViewInContainerViewConroller];
    if ([self.delegate respondsToSelector:@selector(zxEmptyViewUpdateAction)])
    {
        [self.delegate zxEmptyViewUpdateAction];
    }
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

#pragma mark -

+ (void)zx_makeToastInViewController:(UIViewController *)viewController withError:(NSError *)error
{
    [[self alloc]zx_makeToastInViewController:viewController withError:error];
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
