//
//  ZXDatePickerTextField.m
//  wqk8
//
//  Created by zhuxinming on 15/10/29.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "ZXDatePickerTextField.h"
#import <objc/runtime.h>


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

static const NSString *selName = @"valueChange";

@interface ZXDatePickerTextField ()

@property(nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, strong) UIToolbar *toolbar;

@end


@implementation ZXDatePickerTextField
@synthesize zxDelegate = _zxDelegate;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initDatePickerTextField];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initDatePickerTextField];
    }
    return self;
}

- (void)initDatePickerTextField
{
    self.tintColor = [UIColor clearColor];//hide 
 
    self.inputView = self.datePicker;
    
//    [self addConstraint:self.datePicker toItem:self.datePicker.superview];
   
    self.inputAccessoryView = self.toolbar;
    
}

#pragma mark -pickerView

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
        picker.minuteInterval = 1.f;
        picker.maximumDate = [NSDate date];//最大时间为当前时间
        picker.date = [NSDate date];
        _datePicker = picker;
    }
    return  _datePicker;
}


#pragma mark -toolbar

- (UIToolbar *)toolbar
{
    if (!_toolbar)
    {
        UIToolbar *toolbar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 44)];
        
        UIBarButtonItem *leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBarButtonAction:)];
        leftBarButtonItem.tintColor =[UIColor blackColor];
        
        UIBarButtonItem *borderSpaceBarItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
        borderSpaceBarItem.width = LCDScale_iPhone6_Width(12);
        
        UIBarButtonItem *centerSpaceBarItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        UIBarButtonItem *rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishBarButtonAction:)];
        rightBarButtonItem.tintColor =[UIColor blackColor];
        toolbar.items =@[borderSpaceBarItem,leftBarButtonItem,centerSpaceBarItem,rightBarButtonItem,borderSpaceBarItem];;
        _toolbar = toolbar;
    }
    return _toolbar;
}

- (void)addConstraint:(UIView *)item toItem:(UIView *)superView
{
    self.datePicker.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    constraint1.active = YES;

    NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    constraint2.active = YES;

    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    constraint3.active = YES;

    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    constraint4.active = YES;

}

#pragma mark - barButtonItemAction


- (void)finishBarButtonAction:(id)sender
{
     [self valueChange];
    [self resignFirstResponder];
}

- (void)cancelBarButtonAction:(id)sender
{
    [self resignFirstResponder];
}

- (void)showTextFieldHadDate:(NSString *)dateFormat
{
    UIDatePicker* picker = (UIDatePicker*)self.inputView;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = dateFormat?dateFormat:@"yyyy年-MM月-dd日";
    NSDate *date = [format dateFromString:self.text];
//    NSLog(@"%@,%@",date,self.text);
    [picker setDate:date animated:NO];
}


- (void)setBeingValueChange:(BOOL)beingValueChange
{
    beingValueChange =beingValueChange;
    if (beingValueChange)
    {
        [self.datePicker addTarget:self action:sel_registerName(selName.UTF8String) forControlEvents:UIControlEventValueChanged];
    }
}


- (void)valueChange
{
    
    Class class = object_getClass(self.zxDelegate);
    if (class_respondsToSelector(class, @selector(zx_datePickerValueChangedFinished:date:))||[self.datePicker respondsToSelector:@selector(zx_datePickerValueChangedFinished:date:)])
    {
        UIDatePicker* control = (UIDatePicker*)self.inputView;
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"yyyy年-MM月-dd日";
        NSString *dateStr = [format stringFromDate:control.date];
        
        [self.zxDelegate zx_datePickerValueChangedFinished:dateStr date:control.date];
    }
}


- (NSString *)dateFormat
{
    UIDatePicker* control = (UIDatePicker*)self.inputView;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd";
   return  [format stringFromDate:control.date];
}
@end

/*
     IMP imp = class_getMethodImplementation(self.class, @selector(valueChange));
     Method method = class_getInstanceMethod(self.class, @selector(valueChange));
     const char *selName= sel_getName(method_getName(method));
     NSLog(@"%s",selName);
     BOOL addBool = class_addMethod([target class], sel_registerName("valueChange1"), imp, method_getTypeEncoding(method));
 
     if (addBool)
     {
         if ([target respondsToSelector:@selector(valueChange1)])
         {
             [target valueChange1];
         }
          [self addTarget:target action:@selector(valueChange) forControlEvents:UIControlEventValueChanged];
     }
*/
