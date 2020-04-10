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
//#import <Masonry/Masonry.h>
#import "Masonry.h"
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


@property (nonatomic, assign) ZXEmptyViewTouchEventType touchEventType;

/// 是否隐藏中间按钮；默认YES
@property (nonatomic, assign) BOOL centerButtonHide;

@end

@implementation ZXEmptyViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}
#pragma mark -
- (void)initData
{
    self.showErrorCodeOnLabelText = NO;
    self.showErrorCodeOnToastText = YES;
    self.showEmptyViewWithErrorToast = YES;
    self.touchErrorViewIsAction = YES;
    self.emptyViewCenterButtonHide = YES;
    self.actionBtnFont = [UIFont systemFontOfSize:14];
    
    self.actionBtnHeight = LCDScale_iPhone6(30);
    self.actionBtnWidth = LCDScale_iPhone6(120);
    self.actionBtnWidthAutomic = YES;
    self.actionBtnMargin = 30;
}

///调用当前控制器的frame之后就会回调这里;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    //设置默认frame
    self.view.frame =CGRectMake(0, kHEIGHT_SAFEAREA_NAVBAR, LCDW, LCDH-kHEIGHT_SAFEAREA_NAVBAR);
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

    [self.view addSubview:self.imageView];
    [self.view addSubview:self.textLabel];
    [self.view addSubview:self.centerButton];
    
    CGFloat btnHeight = self.actionBtnHeight;
    CGFloat btnWidth = self.actionBtnWidth;
    
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
       
        make.top.mas_equalTo(self.textLabel.mas_bottom).offset(self.actionBtnMargin);
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
        lab.textColor = UIColorFromRGB_HexValue(0x333333);
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


- (void)setUpSubviews
{
    if ([self.centerButton.currentTitle isEqualToString:@"点击加载"]) {
    
        self.actionBtnHeight = LCDScale_iPhone6(30);
        self.actionBtnWidth = LCDScale_iPhone6(120);
        self.actionBtnWidthAutomic = YES;
        self.actionBtnTitleColor = UIColorFromRGB_HexValue(0x666666);
        self.actionBtnCornerRadius = 15;
        self.actionBtnBorderColor = UIColorFromRGB_HexValue(0xCCCCCC);
        self.actionBtnFont = [UIFont systemFontOfSize:14];
        self.actionBtnMargin = 30;
    }
    else if ([self.centerButton.currentTitle isEqualToString:@"查看解决方案"])
    {
        self.actionBtnHeight = LCDScale_iPhone6(30);
        self.actionBtnWidth = LCDScale_iPhone6(120);
        self.actionBtnWidthAutomic = YES;
        self.actionBtnTitleColor = [UIColor colorWithWhite:0.3 alpha:1];
        self.actionBtnBorderColor = [UIColor colorWithWhite:0.8 alpha:1];
        self.actionBtnCornerRadius = 5;
        self.actionBtnFont = [UIFont systemFontOfSize:14];
        self.actionBtnMargin = 30;
    }
}


- (void)setActionBtnTitleColor:(UIColor *)actionBtnTitleColor
{
    _actionBtnTitleColor = actionBtnTitleColor;
    [self.centerButton setTitleColor:actionBtnTitleColor forState:UIControlStateNormal];
}

- (void)setActionBtnFont:(UIFont *)actionBtnFont
{
    _actionBtnFont = actionBtnFont;
    self.centerButton.titleLabel.font = actionBtnFont;
}

- (void)setActionBtnCornerRadius:(CGFloat)actionBtnCornerRadius
{
    _actionBtnCornerRadius = actionBtnCornerRadius;
    self.centerButton.layer.cornerRadius = actionBtnCornerRadius;
}

- (void)setActionBtnBackGroundColor:(UIColor *)actionBtnBackGroundColor
{
    _actionBtnBackGroundColor = actionBtnBackGroundColor;
    self.centerButton.backgroundColor = actionBtnBackGroundColor;
}

- (void)setActionBtnBorderColor:(UIColor *)actionBtnBorderColor
{
    _actionBtnBorderColor = actionBtnBorderColor;
    self.centerButton.layer.borderColor = actionBtnBorderColor.CGColor;
}


- (void)setContentOffest:(CGSize)contentOffest
{
    _contentOffest = contentOffest;
}

/// 调整imageView，button按钮的位置和大小；
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat btnHeight = self.actionBtnHeight;
    CGFloat titleLabTopToImageConstant = 12;
    CGFloat buttonTopToTitleLabConstant = self.actionBtnMargin;
    CGFloat buttonTopToImageConstant = self.actionBtnMargin;
    
    // imageView调整
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(self.imageView.image.size);
    }];
    /// 确立imageView的中心点
    /// 有提示语
    if (self.textLabel.text.length>0 )
    {
        CGRect titleLabRect = [self.textLabel.text boundingRectWithSize:CGSizeMake(LCDW-24, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.textLabel.font} context:nil];

        CGFloat otherContentHeight = 0.f;
        //有点击加载按钮；
        if (!self.centerButton.hidden)
        {
            otherContentHeight = titleLabTopToImageConstant+titleLabRect.size.height + buttonTopToTitleLabConstant + btnHeight;
        }
        //无点击加载按钮
        else
        {
            otherContentHeight = titleLabTopToImageConstant+titleLabRect.size.height;
        }
        
        [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.mas_equalTo (self.view.mas_centerY).offset(-otherContentHeight/2-64+self.contentOffest.height);
        }];
    }
    //无提示语，有加载按钮；
    else if (self.textLabel.text.length==0 && !self.centerButton.hidden)
    {
        CGFloat otherContentHeight = titleLabTopToImageConstant + buttonTopToTitleLabConstant + btnHeight;
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
        CGFloat centerButtonToTitleLabelOffest = buttonTopToTitleLabConstant;
        if (self.textLabel.text.length==0) {
            centerButtonToTitleLabelOffest = buttonTopToImageConstant - titleLabTopToImageConstant;
        }
        [self.centerButton mas_updateConstraints:^(MASConstraintMaker *make) {

            if (self.actionBtnWidthAutomic) {
                make.width.mas_equalTo(titleLabRect.size.width + btnHeight);
            }else
            {
                make.width.mas_equalTo(self.actionBtnWidth);
            }
            make.top.mas_equalTo(self.textLabel.mas_bottom).offset(centerButtonToTitleLabelOffest);
        }];
    }
}


#pragma mark -

- (void)zx_addEmptyViewWithUpdateBtnInController:(UIViewController *)viewController hasLocalData:(BOOL)flag error:(nullable NSError *)error emptyImage:(nullable UIImage *)emptyImage emptyTitle:(nullable NSString *)title centerButtonHide:(BOOL)hide
{
    if (error) {
          self.touchEventType = self.touchErrorViewIsAction ? ZXEmptyViewTouchEventTypeUpdate :
                  ZXEmptyViewTouchEventTypeNoUpdate;
    }else
    {
        self.touchEventType = ZXEmptyViewTouchEventTypeNoUpdate;
    }
    [self addEmptyViewInController:viewController hasLocalData:flag error:error image:emptyImage title:title centerButtonHide:hide];
}

// 网络问题-“查看解决方案”按钮，服务器问题--"点击加载"按钮-
- (void)zx_addEmptyViewInController:(UIViewController *)viewController hasLocalData:(BOOL)flag error:(nullable NSError *)error emptyImage:(nullable UIImage *)emptyImage emptyTitle:(nullable NSString *)title
{
    if (error)
    {
        if (error.code == -1005 || error.code == -1009 || error.code == -1001)
        {
            [self setErrorViewWithSolutionButtonInController];
        }
        else
        {
            [self setErrorViewWithUpdateButtonInController];
        }
    }
    else
    {
        [self setEmptyViewInController];
    }
    [self addEmptyViewInController:viewController hasLocalData:flag error:error image:emptyImage title:title centerButtonHide:self.centerButtonHide];
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
    //->请求错误或成功或空数据;本地还没有数据;
    else
    {
        [self zx_addChildViewControllerInController:viewController];
        self.imageView.image = image;
        self.textLabel.text = [self zx_finallyTextLabelTitle:title withError:error];
        self.centerButton.hidden = hide;
        //加在当前viewController上
        if (error && self.showEmptyViewWithErrorToast)
        {
            [self zx_makeToastInViewController:self withError:error];
        }
    }
}




/*
#pragma mark-
// 函数一：请求失败的时候调用；先失败-添加；二次失败-添加；先成功有数据后失败-不添加，toast提示
- (void)zx_showErrorWithErrorViewInController:(UIViewController *)viewController error:(nullable NSError *)error errorImage:(nullable UIImage *)errorImage errorTitle:(nullable NSString *)title buttonHide:(BOOL)hide hasLocalData:(BOOL)flag
{
    if (flag && error)
    {
        //加在已显示页面上；
        [self zx_makeToastInViewController:viewController withError:error];
        return;
    }
    [self zx_addChildViewControllerInController:viewController];
    self.textLabel.text = [self zx_finallyTextLabelTitle:title withError:error];
    self.centerButton.hidden = hide;
    self.imageView.image = errorImage;
}

// 函数三：请求返回添加空数据氛围视图；先失败后成功-添加；先成功且没数据显示-添加； 先成功且有数据显示情况下-不执行；
- (void)zx_showEmptyWithEmptyViewInController:(UIViewController *)viewController imageStr:(nullable NSString *)emptyImageStr emptyTitle:(nullable NSString *)title hasLocalData:(BOOL)flag
{
    if (flag) {
        return;
    }
    self.touchEventType = ZXEmptyViewTouchEventTypeNoUpdate;
    [self zx_addChildViewControllerInController:viewController];
    self.textLabel.text = [self zx_finallyTextLabelTitle:title withError:nil];
    self.centerButton.hidden = self.emptyViewCenterButtonHide;;
    self.imageView.image = [UIImage imageNamed:emptyImageStr];
}
*/
#pragma mark-

// 空数据氛围视图,按钮有可能出现或不出现；
- (void)setEmptyViewInController
{
    self.touchEventType = ZXEmptyViewTouchEventTypeNoUpdate;
    self.centerButtonHide = self.emptyViewCenterButtonHide;
    self.buttonActionType = ZXEmptyViewButtonActionType_Custom;
}

// error-解决方案按钮。
- (void)setErrorViewWithSolutionButtonInController
{
    self.centerButtonHide = NO;
    self.touchEventType = ZXEmptyViewTouchEventTypeUpdate;
    [self.centerButton setTitle:@"查看解决方案" forState:UIControlStateNormal];
    [self setUpSubviews];
    self.buttonActionType = ZXEmptyViewButtonActionType_ErrorSolution;
}

// error-重新请求按钮是否展示；点击错误视图是否事件回调；
- (void)setErrorViewWithUpdateButtonInController
{
    self.centerButtonHide = self.touchErrorViewIsAction;
    self.touchEventType = self.touchErrorViewIsAction ? ZXEmptyViewTouchEventTypeUpdate :
    ZXEmptyViewTouchEventTypeNoUpdate;
    [self.centerButton setTitle:@"点击加载" forState:UIControlStateNormal];
    [self setUpSubviews];
    self.buttonActionType = ZXEmptyViewButtonActionType_ReRequest;
}

#pragma mark - add添加

- (void)zx_addChildViewControllerInController:(UIViewController *)viewController
{
    if ([viewController.childViewControllers containsObject:self])
    {
        return;
    }
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
    if (title.length>0 && error && self.showErrorCodeOnLabelText)
    {
        NSString *titleWithErrorCode = [NSString stringWithFormat:@"%@(%@)",title,@(error.code)];
        return titleWithErrorCode;
    }
    return title;
}

- (NSString *)zx_finallyToastTitle:(NSString *)title withError:(NSError *)error
{
    if (error && self.showErrorCodeOnToastText)
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
    if (self.buttonActionType == ZXEmptyViewButtonActionType_ErrorSolution)
    {
        ZXWKWebViewController *vc = [[ZXWKWebViewController alloc] init];
        [vc loadWebHTMLSringWithFileResource:@"networkErrorHelp"];
        if (self.parentViewController.navigationController) {
            vc.hidesBottomBarWhenPushed = YES;
            [self.parentViewController.navigationController pushViewController:vc animated:NO];
        }
    }
    else if (self.buttonActionType == ZXEmptyViewButtonActionType_ReRequest)
    {
         [self btnAndEventActionWithNetworkReachable];
    }
    else
    {
        [self btnAndEventAction];
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
            
            if ([self canPerformAction:@selector(btnAndEventActionWithNetworkReachable) withSender:self]) {
                
                self.buttonActionType = ZXEmptyViewButtonActionType_ReRequest;
                [self btnAndEventActionWithNetworkReachable];
            }
        }
    }
}


#pragma mark - action

- (void)btnAndEventActionWithNetworkReachable
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    if (![[AFNetworkReachabilityManager sharedManager]isReachable]) {
        
//        [self.view makeToast:NSLocalizedString(@"网络未连接,请检查后重试", nil)];
        [MBProgressHUD zx_showError:NSLocalizedString(@"网络未连接,请检查后重试", nil) toView:self.view];
        return;
    }
    [self zx_hideEmptyViewInContainerViewConroller];
    [self btnAndEventAction];
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

- (void)btnAndEventAction
{
    if ([self.delegate respondsToSelector:@selector(zxEmptyViewUpdateAction)])
    {
        [self.delegate zxEmptyViewUpdateAction];
    }
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
