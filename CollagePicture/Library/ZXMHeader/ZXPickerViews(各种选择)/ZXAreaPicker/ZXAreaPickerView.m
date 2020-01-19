//
//  ZXAreaPickerView.m
//  ZXAreaPickerView
//
//  Created by simon on 14-9-9.
//  Copyright (c) 2014年 simon.com. All rights reserved.
//

#import "ZXAreaPickerView.h"
#import "ZXOverlay.h"

#ifndef LCDScale_iPhone6_Width
#define LCDScale_iPhone6_Width(X)    ((X)*([[UIScreen mainScreen] bounds].size.width)/375)
#endif

@interface ZXAreaPickerView ()<ZXOverlayDelegate>

@property (nonatomic, copy) NSArray *provinces;//35个字典省份组合的数组
@property (nonatomic, copy) NSArray *cities;
@property (nonatomic, copy) NSArray *areas;

@property (nonatomic, strong) UITextField *inputTextField;

@property (nonatomic, strong) UIToolbar *toolbar;

@end

@implementation ZXAreaPickerView

//@synthesize delegate=_delegate;
//@synthesize pickerStyle=_pickerStyle;
//@synthesize locate=_locate;
//@synthesize locatePicker = _locatePicker;


@synthesize provinces;
@synthesize cities;
@synthesize areas;


-(ZXLocation *)locate
{
    if (_locate == nil) {
        _locate = [[ZXLocation alloc] init];
    }
    
    return _locate;
}

#pragma mark - Lifecycle

- (instancetype)initWithStyle:(ZXAreaPickerStyle)pickerStyle delegate:(id<ZXAreaPickerDelegate>)delegate
{
    
//    self = [[[NSBundle mainBundle] loadNibNamed:@"ZXAreaPickerView" owner:self options:nil] objectAtIndex:0] ;
    self = [super init];
    if (self)
    {
        self.delegate = delegate;
        self.pickerStyle = pickerStyle;
        [self initData];
    }

    return self;
    
}
//- (instancetype)initTextFieldOfInputViewWithStyle:(ZXAreaPickerStyle)pickerStyle
//                               delegate:(id <ZXAreaPickerDelegate>)delegate
//                              textField:(UITextField*)textField
//{
//    self = [[[NSBundle mainBundle] loadNibNamed:@"ZXAreaPickerView" owner:self options:nil] objectAtIndex:0] ;
//    if (self)
//    {
//        self.delegate = delegate;
//        self.pickerStyle = pickerStyle;
//        self.inputTextField = textField;
//        [self initData];
//        textField.inputView = self;
//        textField.inputAccessoryView = self.toolbar;
//
//    }
//    return self;
//}


- (void)initData
{
    self.backgroundColor = [UIColor whiteColor];
    self.locatePicker.dataSource = self;
    self.locatePicker.delegate = self;
    //加载数据
    if (self.pickerStyle == ZXAreaPickerWithStateAndCityAndDistrict)
    {
        //35个字典组合的数组，更细分一点，先地级市，后面还有县城
        self.provinces = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ZXarea.plist" ofType:nil]];
        //得到index相对应的cities－－n个字典的组合
        self.cities = [[self.provinces objectAtIndex:0] objectForKey:@"cities"];//n个城市字典组合， 以cities为key。
        //得到相对应的state省份，城市city，
        self.locate.state = [[self.provinces objectAtIndex:0] objectForKey:@"state"];
        self.locate.city = [[self.cities objectAtIndex:0] objectForKey:@"city"];
        
        
        //根据城市得到相对应的 县城或直辖市的区数组
        self.areas = [[self.cities objectAtIndex:0] objectForKey:@"areas"];
        if (self.areas.count > 0)
        {
            self.locate.district = [self.areas objectAtIndex:0];
        }
        else
        {
            self.locate.district = @"";
        }
    }
    else
    {
        self.provinces = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ZXcity.plist" ofType:nil]];//城市，地级市
        self.cities = [[self.provinces objectAtIndex:0] objectForKey:@"cities"];
        self.locate.state = [[self.provinces objectAtIndex:0] objectForKey:@"state"];
        self.locate.city = [self.cities objectAtIndex:0];
    }

    if (CGRectEqualToRect(self.frame, CGRectZero))
    {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, LCDScale_iPhone6_Width(260.f));
    }
    [self addSubview:self.toolbar];
    [self addToolBarConstraintWithItem:self.toolbar];
    
    [self addSubview:self.locatePicker];
    // 添加pickerView的约束
    [self addCustomConstraintWithItem:self.locatePicker];
    
}

#pragma mark -pickerView

- (UIPickerView *)locatePicker
{
    if (!_locatePicker)
    {
        UIPickerView *picker= [[UIPickerView alloc] init];
        //        picker.backgroundColor = [UIColor redColor];
        picker.showsSelectionIndicator = NO;
        picker.delegate = self;
        picker.dataSource =self;
        _locatePicker = picker;
    }
    return  _locatePicker;
}

#pragma mark - 添加pickView的约束

- (void)addCustomConstraintWithItem:(UIView *)item
{
    self.locatePicker.translatesAutoresizingMaskIntoConstraints = NO;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)
    {
        UILayoutGuide *layoutGuide_superView = self.layoutMarginsGuide;
        
        //   “thisAnchor = otherAnchor+constant”
        NSLayoutConstraint *constraint_top = [item.topAnchor constraintEqualToAnchor:layoutGuide_superView.topAnchor constant:44-8];
        NSLayoutConstraint *constraint_bottom = [item.bottomAnchor constraintEqualToAnchor:layoutGuide_superView.bottomAnchor constant:8];
        NSLayoutConstraint *constraint_leading = [item.leadingAnchor constraintEqualToAnchor:layoutGuide_superView.leadingAnchor constant:-8];
        //   “thisAnchor = otherAnchor”
        NSLayoutConstraint *constraint_centerX = [item.centerXAnchor constraintEqualToAnchor:layoutGuide_superView.centerXAnchor];
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
/*
 注意：
 iOS9-iOS11以下用layoutMarginsGuide,需要考虑margin，【普通view{8，8，8，8}】，【viewController的rootView：iphone5尺寸屏幕:{0，16，0，16},iphone6及以上屏幕:{0，20，0，20}】
 iOS11及以上用safeAreaLayoutGuide，不需要考虑margin；
 */
- (void)addToolBarConstraintWithItem:(UIView *)item
{
    self.toolbar.translatesAutoresizingMaskIntoConstraints = NO;
    //    -layoutMarginsGuide从视图边界的边缘返回一组insets，它表示布局内容的默认间隔。{8，8，8，8}
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


#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.pickerStyle == ZXAreaPickerWithStateAndCityAndDistrict)
    {
        return 3;
    }
    else
    {
        return 2;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [self.provinces count];
            break;
        case 1:
            return [self.cities count];
            break;
        case 2:
            if (self.pickerStyle == ZXAreaPickerWithStateAndCityAndDistrict)
            {
                return [self.areas count];
                break;
            }
        default:
            return 0;
            break;
    }
}

//Dark Mode 下文字颜色适配为黑色；
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = nil;
    if (self.pickerStyle == ZXAreaPickerWithStateAndCityAndDistrict)
     {
         switch (component)
         {
             case 0:
                 title = [[self.provinces objectAtIndex:row] objectForKey:@"state"];//省
                 break;
             case 1:
                 title =[[self.cities objectAtIndex:row] objectForKey:@"city"];//市
                 break;
             case 2:
                 if ([self.areas count] > 0) {
                     title =[self.areas objectAtIndex:row];//县级市或直辖市的区
                 }
                 break;
             default:
                 title = @"";
                 break;
         }
     }
     else{
         switch (component)
         {
             case 0:
                 title = [[self.provinces objectAtIndex:row] objectForKey:@"state"];
                 break;
             case 1:
                 title =  [self.cities objectAtIndex:row];
                 break;
             default:
                 title =  @"";
                 break;
         }
     }
    return [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    if (self.pickerStyle == ZXAreaPickerWithStateAndCityAndDistrict)
//    {
//        switch (component)
//        {
//            case 0:
//                return [[self.provinces objectAtIndex:row] objectForKey:@"state"];//省
//                break;
//            case 1:
//                return [[self.cities objectAtIndex:row] objectForKey:@"city"];//市
//                break;
//            case 2:
//                if ([self.areas count] > 0) {
//                    return [self.areas objectAtIndex:row];//县级市或直辖市的区
//                    break;
//                }
//            default:
//                return  @"";
//                break;
//        }
//    }
//    else{
//        switch (component)
//        {
//            case 0:
//                return [[self.provinces objectAtIndex:row] objectForKey:@"state"];
//                break;
//            case 1:
//                return [self.cities objectAtIndex:row];
//                break;
//            default:
//                return @"";
//                break;
//        }
//    }
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.pickerStyle == ZXAreaPickerWithStateAndCityAndDistrict) {
        switch (component) {
            case 0:
                //如果选择改变了第一列省份，则需要重新赋值第二列的城市，第三列的县级市数组
                self.cities = [[self.provinces objectAtIndex:row] objectForKey:@"cities"];
                
                
                [self.locatePicker selectRow:0 inComponent:1 animated:YES];
                [self.locatePicker reloadComponent:1];
                
                self.areas = [[self.cities objectAtIndex:0] objectForKey:@"areas"];
                [self.locatePicker selectRow:0 inComponent:2 animated:YES];
                [self.locatePicker reloadComponent:2];
                
                self.locate.state = [[self.provinces objectAtIndex:row] objectForKey:@"state"];
                self.locate.city = [[self.cities objectAtIndex:0] objectForKey:@"city"];
                if ([self.areas count] > 0) {
                    self.locate.district = [self.areas objectAtIndex:0];
                } else{
                    self.locate.district = @"";
                }
                break;
            case 1:
                //如果选择改变了第二列 ，则第三列的县级市数组需要重新赋值
                self.areas = [[self.cities objectAtIndex:row] objectForKey:@"areas"];
                [self.locatePicker selectRow:0 inComponent:2 animated:YES];
                [self.locatePicker reloadComponent:2];
                
                self.locate.city = [[cities objectAtIndex:row] objectForKey:@"city"];
                if ([areas count] > 0) {
                    self.locate.district = [areas objectAtIndex:0];
                } else{
                    self.locate.district = @"";
                }
                break;
            case 2:
                if ([areas count] > 0) {
                    self.locate.district = [areas objectAtIndex:row];
                } else{
                    self.locate.district = @"";
                }
                break;
            default:
                break;
        }
    } else{
        switch (component) {
            case 0:
                cities = [[provinces objectAtIndex:row] objectForKey:@"cities"];
                [self.locatePicker selectRow:0 inComponent:1 animated:YES];
                [self.locatePicker reloadComponent:1];
                
                self.locate.state = [[provinces objectAtIndex:row] objectForKey:@"state"];
                self.locate.city = [cities objectAtIndex:0];
                break;
            case 1:
                self.locate.city = [cities objectAtIndex:row];
                break;
            default:
                break;
        }
    }
    
    if([self.delegate respondsToSelector:@selector(zx_pickerDidChaneStatus:)]) {
        [self.delegate zx_pickerDidChaneStatus:self];
    }

}

#pragma mark - animation

#pragma mark - show
//// 这里待优化测试,效果不好；也没有这种需求；
//- (void)showInTabBarView:(UIView *)view
//{
//    [self showInTabBarViewOrView:view isTabBarView:YES];
//    //    [self.pickerView selectRow:_selectedRow inComponent:0 animated:YES];
//}

- (void)showInView:(UIView *)view
{
    [self showInTabBarViewOrView:view isTabBarView:NO];
}

- (void)showInTabBarViewOrView:(UIView *)view isTabBarView:(BOOL)flag
{
    if ([view isKindOfClass:[UITableView class]] ||[view isKindOfClass:[UICollectionView class]])
    {
        view = [[[UIApplication sharedApplication] delegate] window];
    }
    ZXOverlay *overlay = [[ZXOverlay alloc] init];
    overlay.backgroundColor = [UIColor clearColor];
    overlay.delegate = self;
    [overlay addSubview:self];
    [view addSubview:overlay];
    
    CGFloat safeAreaBottom = 0.f;
    if (@available(iOS 11.0, *))
    {
        UIEdgeInsets areaInset = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
        safeAreaBottom = areaInset.bottom;
    }
    
    overlay.frame = CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame));
    //  设置增加安全区域显示 view高度 = 当前view高度+底部安全区域距离
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        CGRect rect = self.frame;
        rect.size.height = CGRectGetHeight(self.frame)+safeAreaBottom;
        self.frame = rect;
    });
    
    self.frame = CGRectMake(0, CGRectGetHeight(view.bounds), CGRectGetWidth(view.frame), CGRectGetHeight(self.frame));
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect rect = self.frame;
        rect.origin.y = CGRectGetHeight(view.bounds) - CGRectGetHeight(self.frame);
        self.frame = rect;
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - barButtonItemAction

// 取消按钮action
- (void)cancelBarButtonAction:(id)sender
{
//    if (self.inputTextField)
//    {
//        [self.inputTextField resignFirstResponder];
//    }else{
    
        [self cancelPicker];
//    }
}

- (void)cancelPicker
{
    [[UIApplication sharedApplication]beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.2
                     animations:^{
                         
                         CGRect rect = self.frame;
                         rect.origin.y = CGRectGetMinY(self.frame)+CGRectGetHeight(self.frame);
                         self.frame = rect;
                     }
                     completion:^(BOOL finished){
                         
                         
                         [UIView animateWithDuration:0.1 animations:^{
                             
                             self.superview.alpha = 0;
                             
                         } completion:^(BOOL finished) {
                             
                             if ([self.superview isKindOfClass:[ZXOverlay class]])
                             {
                                 [self.superview removeFromSuperview];
                             }
                             [self removeFromSuperview];
                             [[UIApplication sharedApplication]endIgnoringInteractionEvents];
                         }];
                     }];
    
    
    if ([self.delegate respondsToSelector:@selector(pickerCancel)]) {
        [self.delegate pickerCancel];
    }
}

- (void)finishBarButtonAction:(UIBarButtonItem *)sender
{
    [self cancelPicker];
    if([self.delegate respondsToSelector:@selector(zx_pickerDidDoneStatus:)]) {
        [self.delegate zx_pickerDidDoneStatus:self];
    }
}



#pragma mark -zxOverlayDelegate

- (void)zxOverlaydissmissAction
{
    [self cancelPicker];
}
@end
