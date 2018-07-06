//
//  ZXDatePickerView.m
//  YiShangbao
//
//  Created by simon on 2018/1/12.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "ZXDatePickerView.h"

#ifndef SCREEN_WIDTH
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#endif

#ifndef SCREEN_MAX_LENGTH
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#endif

//设置iphone6尺寸比例/竖屏,UI所有设备等比例缩放
#ifndef LCDScale_iPhone6_Width
#define LCDScale_iPhone6_Width(X)    ((X)*SCREEN_MIN_LENGTH/375)
#endif


@interface ZXDatePickerView ()

@property (nonatomic, strong) UIToolbar *toolbar;
@end

@implementation ZXDatePickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initData];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initData];
    }
    return self;
}



- (void)layoutSubviews
{
    [super layoutSubviews];
}


- (void)initData
{
    if (CGRectEqualToRect(self.frame, CGRectZero))
    {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, LCDScale_iPhone6_Width(260.f));
    }
    [self addSubview:self.toolbar];
    self.backgroundColor = [UIColor whiteColor];
    self.toolBarTintColor = [UIColor blackColor];
    self.toolBarTitleBarItemTitle = @"选择日期";
    self.returnDateFormat = @"yyyy年-MM月-dd日";
    self.toolBarTitleBarItemColor = [UIColor blackColor];
    
    [self addSubview:self.datePicker];
    [self addToolBarConstraintWithItem:self.toolbar];
//     添加pickerView的约束
    [self addCustomConstraintWithItem:self.datePicker];
}

#pragma mark -datePicker

//---设置最大最小值,但是整个日历还是可以看到旋转的,只是会自动回到最大值;
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyy-MM-dd";
//    NSDate *maxDate = [formatter dateFromString:@"2006-12-31"];

- (UIDatePicker *)datePicker
{
    if (!_datePicker)
    {
        UIDatePicker *picker=[[UIDatePicker alloc]init];
        picker.datePickerMode = UIDatePickerModeDate;
        picker.locale = [NSLocale currentLocale];
        picker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        picker.calendar = [NSCalendar currentCalendar];
        picker.minuteInterval = 1.f;
        picker.maximumDate = [NSDate date];//最大时间为当前时间
        picker.date = [NSDate date];
        [picker addTarget:self action:@selector(valueChange) forControlEvents:UIControlEventValueChanged];
        _datePicker = picker;
    }
    return  _datePicker;
}

#pragma mark -toolbar

- (UIToolbar *)toolbar
{
    if (!_toolbar)
    {
        // 高度固定44，不然barButtonItem文字不居中；不能太高；
        UIToolbar *toolbar=[[UIToolbar alloc] init];
        UIBarButtonItem *leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelBarButtonAction:)];
        
        UIBarButtonItem *borderSpaceBarItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
        borderSpaceBarItem.width = LCDScale_iPhone6_Width(12);
        
        UIBarButtonItem *flexibleSpaceItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *centerTitleBarItem=[[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:nil action:nil];
        self.toolBarTitleBarButtonItem = centerTitleBarItem;
        
        UIBarButtonItem *rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"确定", nil) style:UIBarButtonItemStylePlain target:self action:@selector(finishBarButtonAction:)];
        toolbar.items =@[borderSpaceBarItem,leftBarButtonItem,flexibleSpaceItem,centerTitleBarItem,flexibleSpaceItem,rightBarButtonItem,borderSpaceBarItem];;
        _toolbar = toolbar;
    }
    return _toolbar;
}

- (void)setToolBarTintColor:(UIColor *)toolBarTintColor
{
    _toolBarTintColor = toolBarTintColor;
    self.toolbar.tintColor = self.toolBarTintColor;
}

- (void)setToolBarTitleBarItemTitle:(NSString *)toolBarTitleBarItemTitle
{
    _toolBarTitleBarItemTitle = toolBarTitleBarItemTitle;
    
    self.toolBarTitleBarButtonItem.title = toolBarTitleBarItemTitle;
}

- (void)setToolBarTitleBarItemColor:(UIColor *)toolBarTitleBarItemColor
{
    _toolBarTitleBarItemColor = toolBarTitleBarItemColor;
    self.toolBarTitleBarButtonItem.tintColor = toolBarTitleBarItemColor;
}

#pragma mark - toolBar约束
- (void)addToolBarConstraintWithItem:(UIView *)item
{
    self.toolbar.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:item.superview attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    constraint1.active = YES;
    
    NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:44];
    constraint2.active = YES;
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:item.superview attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    constraint3.active = YES;
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:item.superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    constraint4.active = YES;
}
#pragma mark - 添加pickView的约束

- (void)addCustomConstraintWithItem:(UIView *)item
{
    self.datePicker.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.toolbar attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    constraint1.active = YES;
    
    NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:item.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    constraint2.active = YES;
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:item.superview attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    constraint3.active = YES;
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:item.superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    constraint4.active = YES;
}


- (void)valueChange
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = self.returnDateFormat;
    NSString *dateStr = [format stringFromDate:self.datePicker.date];
    
    if ([self.delegate respondsToSelector:@selector(zx_datePickerValueChanged:date:dateString:)])
    {
        [self.delegate zx_datePickerValueChanged:self date:self.datePicker.date dateString:dateStr];
    }
    if (self.valueChangeBlock)
    {
        self.valueChangeBlock(self.datePicker.date,dateStr);
    }
}



#pragma mark - barButtonItemAction

- (void)finishBarButtonAction:(UIBarButtonItem *)sender
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = self.returnDateFormat;
    NSString *dateStr = [format stringFromDate:self.datePicker.date];
    
    [self cancelPicker];
    
    if ([self.delegate respondsToSelector:@selector(zx_datePickerDidDoneStatus:date:dateString:)])
    {
        [self.delegate zx_datePickerDidDoneStatus:self date:self.datePicker.date dateString:dateStr];
    }
    if (_doActionHandleBlock)
    {
        _doActionHandleBlock(self.datePicker.date,dateStr);
    }
}

- (void)cancelBarButtonAction:(id)sender
{
    [self cancelPicker];
    if (_cancleActionHandleBlock)
    {
        _cancleActionHandleBlock();
    }
}


#pragma mark -cancle，show

- (void)cancelPicker
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.3
                     animations:^{
                         
                         self.frame = CGRectMake(0,CGRectGetMinY(self.frame)+CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
                         
                     }
                     completion:^(BOOL finished){
                         if ([self.superview isKindOfClass:[ZXOverlay class]])
                             [self.superview removeFromSuperview];
                         [self removeFromSuperview];
                         [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                     }];
    if ([_delegate respondsToSelector:@selector(pickerCancel)]) {
        [_delegate pickerCancel];
    }
}
// 这样写代码有什么问题吗？ 发现SE机器上有时候 不会弹出框
- (void)showInView:(UIView *)view cancleHander:(void(^ __nullable)(void))cancleHander doneHander:(void(^__nullable)(NSDate *date,NSString *dateString))doneHander
{
    [self showInView:view];
    if (cancleHander)
    {
        _cancleActionHandleBlock = cancleHander;
    }
    if (doneHander)
    {
        _doActionHandleBlock = doneHander;
    }
}


- (void)showInView:(UIView *) view
{
    if ([view isKindOfClass:[UITableView class]] ||[view isKindOfClass:[UICollectionView class]])
    {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    if ([view isKindOfClass:NSClassFromString(@"_UIInteractiveHighlightEffectWindow")])
    {
        view = [[UIApplication sharedApplication].windows objectAtIndex:[UIApplication sharedApplication].windows.count-2];
    }
    ZXOverlay *overlay = [[ZXOverlay alloc] init];
    overlay.delegate = self;
    [overlay addSubview:self];
    [view addSubview:overlay];
    overlay.frame = CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame));
    self.frame = CGRectMake(0, CGRectGetHeight(view.bounds), CGRectGetWidth(view.frame), CGRectGetHeight(self.frame));
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.3 animations:^{
        
        self.frame = CGRectMake(0, CGRectGetHeight(view.bounds) - CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        
    } completion:^(BOOL finished) {
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
}

- (void)setDate:(NSDate *)date animated:(BOOL)animated
{
    [self.datePicker setDate:date animated:animated];
}

#pragma mark -zxOverlayDelegate

- (void)zxOverlaydissmissAction
{
    [self cancelPicker];
    if (_cancleActionHandleBlock)
    {
        _cancleActionHandleBlock();
    }
}
@end
