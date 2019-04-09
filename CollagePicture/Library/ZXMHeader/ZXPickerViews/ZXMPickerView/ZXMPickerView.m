//
//  ZXMPickerView.m
//  ICBC
//
//  Created by simon on 15/2/11.
//  Copyright (c) 2015年 simon. All rights reserved.
//

#import "ZXMPickerView.h"


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


@interface ZXMPickerView ()

@property (nonatomic, copy) NSArray *dataArray;

@property (nonatomic, strong) UIToolbar *toolbar;

//@property (nonatomic, assign) NSInteger selectedRow;

@end



@implementation ZXMPickerView


@synthesize pickerView = _pickerView;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
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



//216+44
- (void)initData
{
    self.backgroundColor = [UIColor whiteColor];
    NSArray *array = [NSArray array];
    self.dataArray = array;
    
    if (CGRectEqualToRect(self.frame, CGRectZero))
    {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, LCDScale_iPhone6_Width(260.f));
    }
    
    [self addSubview:self.toolbar];
    [self addToolBarConstraintWithItem:self.toolbar];

    [self addSubview:self.pickerView];
    // 添加pickerView的约束
    [self addCustomConstraintWithItem:self.pickerView];
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    self.toolbar.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame),44);
}

#pragma mark -pickerView

- (UIPickerView *)pickerView
{
    if (!_pickerView)
    {
        UIPickerView *picker= [[UIPickerView alloc] init];
//        picker.backgroundColor = [UIColor redColor];
        picker.showsSelectionIndicator = NO;
        picker.delegate = self;
        picker.dataSource =self;
        _pickerView = picker;
    }
    return  _pickerView;
}

#pragma mark -toolbar

- (UIToolbar *)toolbar
{
    if (!_toolbar)
    {
        // 高度固定44，不然barButtonItem文字不居中；不能太高；
        UIToolbar *toolbar=[[UIToolbar alloc] init];
        //          toolbar.barTintColor = [UIColor redColor];

        UIBarButtonItem *leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelBarButtonAction:)];
        leftBarButtonItem.tintColor =[UIColor blackColor];
        
        UIBarButtonItem *borderSpaceBarItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
        borderSpaceBarItem.width = LCDScale_iPhone6_Width(12);
        
        UIBarButtonItem *centerSpaceBarItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        UIBarButtonItem *rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"确定", nil) style:UIBarButtonItemStylePlain target:self action:@selector(finishBarButtonAction:)];
        rightBarButtonItem.tintColor =[UIColor blackColor];
        toolbar.items =@[borderSpaceBarItem,leftBarButtonItem,centerSpaceBarItem,rightBarButtonItem,borderSpaceBarItem];;
        _toolbar = toolbar;
    }
    return _toolbar;
}

#pragma mark - toolBar约束
- (void)addToolBarConstraintWithItem:(UIView *)item
{
    self.toolbar.translatesAutoresizingMaskIntoConstraints = NO;
    //    -layoutMargins从视图边界的边缘返回一组insets，它表示布局内容的默认间隔。{8，8，8，8}
    //    left/leading：view的左边内边距8，即x被增大了，你要设置的pickerViewX就应该在之前的基础下-8，才能同等边距；同理右边；
    if ([[UIDevice currentDevice].systemVersion floatValue]>=9.0)
    {
        UILayoutGuide *layoutGuide_superView = self.layoutMarginsGuide;
        NSLayoutConstraint *constraint_top = [item.topAnchor constraintEqualToAnchor:layoutGuide_superView.topAnchor constant:-8];
        NSLayoutConstraint *constraint_height = [item.heightAnchor constraintEqualToConstant:44];
        NSLayoutConstraint *constraint_leading = [item.leadingAnchor constraintEqualToAnchor:layoutGuide_superView.leadingAnchor constant:-8];
        NSLayoutConstraint *constraint_trailing = [item.trailingAnchor constraintEqualToAnchor:layoutGuide_superView.trailingAnchor constant:8];
        [NSLayoutConstraint activateConstraints:@[constraint_top,constraint_height,constraint_leading,constraint_trailing]];
    }
    else
    {
        NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:item.superview attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        constraint1.active = YES;
        
        NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:44];
        constraint2.active = YES;
        
        NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:item.superview attribute:NSLayoutAttributeRight multiplier:1 constant:0];
        constraint3.active = YES;
        
        NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:item.superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        constraint4.active = YES;
    }
    
}
#pragma mark - 添加pickView的约束

- (void)addCustomConstraintWithItem:(UIView *)item
{
    self.pickerView.translatesAutoresizingMaskIntoConstraints = NO;

    //    -layoutMargins从视图边界的边缘返回一组insets，它表示布局内容的默认间隔。{8，8，8，8}
    //    left/leading：view的左边内边距8，即x被增大了，你要设置的pickerViewX就应该在之前的基础下-8，才能同等边距；同理右边；
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)
    {
        UILayoutGuide *layoutGuide_superView = self.layoutMarginsGuide;

        //   “thisAnchor = otherAnchor+constant”
        NSLayoutConstraint *constraint_top = [self.pickerView.topAnchor constraintEqualToAnchor:layoutGuide_superView.topAnchor constant:44-8];
        NSLayoutConstraint *constraint_bottom = [self.pickerView.bottomAnchor constraintEqualToAnchor:layoutGuide_superView.bottomAnchor constant:8];
        NSLayoutConstraint *constraint_leading = [self.pickerView.leadingAnchor constraintEqualToAnchor:layoutGuide_superView.leadingAnchor constant:-8];
        //   “thisAnchor = otherAnchor”
        NSLayoutConstraint *constraint_centerX = [self.pickerView.centerXAnchor constraintEqualToAnchor:layoutGuide_superView.centerXAnchor];
        [NSLayoutConstraint activateConstraints:@[constraint_top,constraint_bottom,constraint_leading,constraint_centerX]];
    }
    else
    {
        NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.toolbar attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        constraint1.active = YES;
        
        NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:item.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        constraint2.active = YES;
        
        NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:item.superview attribute:NSLayoutAttributeRight multiplier:1 constant:0];
        constraint3.active = YES;
        
        NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:item.superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        constraint4.active = YES;
    }
}


- (void)reloadDataWithDataArray:(NSArray *)dataArray;
{
    _dataArray =[dataArray copy];
//     可以不写刷新，由于本身就会刷新好几次
    [self.pickerView reloadAllComponents];
}

- (void)reloadConstellationData
{
    _dataArray =@[@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座",@"水瓶座",@"双鱼座"];
}

- (void)selectRow:(NSInteger)row animated:(BOOL)animated
{
    [self.pickerView selectRow:row inComponent:0 animated:animated];
}

- (void)selectObject:(nullable NSString *)object animated:(BOOL)animated
{
    if ([self.dataArray containsObject:object])
    {
        NSInteger index = [self.dataArray indexOfObject:object];
        [self.pickerView selectRow:index inComponent:0 animated:YES];
    }

}

#pragma mark-dataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
//    NSLog(@"%d",self.dataArray.count);
    return self.dataArray.count;
}

#pragma mark-Delegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row>=self.dataArray.count) {
        return [self.dataArray lastObject];
    }
    return [self.dataArray objectAtIndex:row];
}

#pragma mark - PickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return LCDScale_iPhone6_Width(48.f);
}

//-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
//{
//    return 100;
//}

//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    UIView* selectView = [pickerView viewForRow:row forComponent:component];
//}
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
//{
//    UILabel* pickerLabel = (UILabel*)view;
//    if (!pickerLabel) {
//        pickerLabel = [[UILabel alloc] init];
//        pickerLabel.font = [UIFont systemFontOfSize:15];
//        pickerLabel.textAlignment = NSTextAlignmentCenter;
//        pickerLabel.textColor = [UIColor blueColor];
//    }
//    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
//    return pickerLabel;
//}

#pragma mark - show
// 这里待优化测试
- (void)showInTabBarView:(UIView *)view
{
    [self showInTabBarViewOrView:view isTabBarView:YES];
//    [self.pickerView selectRow:_selectedRow inComponent:0 animated:YES];
}

- (void)showInView:(UIView *)view
{
//    NSLog(@"windows:%@",[UIApplication sharedApplication].windows);
    [self showInTabBarViewOrView:view isTabBarView:NO];
}


- (void)showInTabBarViewOrView:(UIView *)view isTabBarView:(BOOL)flag
{
    if ([view isKindOfClass:[UITableView class]] ||[view isKindOfClass:[UICollectionView class]])
    {
        view = [[[UIApplication sharedApplication] delegate] window];
    }
    ZXOverlay *overlay = [[ZXOverlay alloc] init];
    overlay.delegate = self;
    [overlay addSubview:self];
    [view addSubview:overlay];
    
    CGFloat safeAreaBottom = 0.f;
    if (@available(iOS 11.0, *))
    {
        UIEdgeInsets areaInset = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
        if(!UIEdgeInsetsEqualToEdgeInsets(areaInset, UIEdgeInsetsZero)){
            safeAreaBottom = areaInset.bottom;
        }else{
        }
    }

    if (flag)
    {
        overlay.frame = CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame)-safeAreaBottom-49);
    }
    else
    {
        overlay.frame = CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame));
//      设置增加安全区域显示；
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            self.frame = CGRectMake(0, CGRectGetHeight(view.bounds), CGRectGetWidth(view.frame), CGRectGetHeight(self.frame)+safeAreaBottom);
        });
    }
    self.frame = CGRectMake(0, CGRectGetHeight(view.bounds), CGRectGetWidth(view.frame), CGRectGetHeight(self.frame));
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.3 animations:^{
        
        if (flag)
        {
            self.frame = CGRectMake(0, CGRectGetHeight(view.frame) - CGRectGetHeight(self.frame)-safeAreaBottom-49, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        }
        else
        {
            self.frame = CGRectMake(0, CGRectGetHeight(view.bounds) - CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        }
        
    } completion:^(BOOL finished) {
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
}



#pragma mark - barButtonItemAction


- (void)cancelBarButtonAction:(id)sender
{
    [self cancelPicker];
}

- (void)cancelPicker
{
    [[UIApplication sharedApplication]beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.3
                     animations:^{

                         self.frame = CGRectMake(0,CGRectGetMinY(self.frame)+CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));

                     }
                     completion:^(BOOL finished){
                         
                         
                         [UIView animateWithDuration:0.1 animations:^{
                             
                             self.superview.alpha = 0;
                             
                         } completion:^(BOOL finished) {
                             
                             if ([self.superview isKindOfClass:[ZXOverlay class]])
                                 [self.superview removeFromSuperview];
                             [self removeFromSuperview];
                             [[UIApplication sharedApplication]endIgnoringInteractionEvents];
                         }];
                     }];
 
    
    if ([_delegate respondsToSelector:@selector(pickerCancel)]) {
        [_delegate pickerCancel];
    }
}

- (void)finishBarButtonAction:(UIBarButtonItem *)sender
{
    NSInteger selectedRow = [self.pickerView selectedRowInComponent:0]<0?0:[self.pickerView selectedRowInComponent:0];
    NSString *tit = [self.dataArray objectAtIndex:selectedRow];
    [self cancelPicker];

    if ([self.delegate respondsToSelector:@selector(zx_pickerDidDoneStatus:index:itemTitle:)])
    {
        [self.delegate zx_pickerDidDoneStatus:self index:selectedRow itemTitle:tit];
    }
}

#pragma mark -zxOverlayDelegate

- (void)zxOverlaydissmissAction
{
    [self cancelPicker];
}
@end


