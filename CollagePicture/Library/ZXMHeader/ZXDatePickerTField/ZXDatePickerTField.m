//
//  ZXDatePickerTField.m
//  wqk8
//
//  Created by zhuxinming on 15/10/29.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "ZXDatePickerTField.h"
#import <objc/runtime.h>
static const NSString *selName = @"valueChange";

@interface ZXDatePickerTField ()

@property(nonatomic,strong) UIDatePicker *datePicker;

@end


@implementation ZXDatePickerTField
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
    
    UIDatePicker *date=[[UIDatePicker alloc]init];
    date.datePickerMode = UIDatePickerModeDate;
    date.locale = [NSLocale currentLocale];
    date.minuteInterval = 1.f;
//---设置最大最小值,但是整个日历还是可以看到旋转的,只是会自动回到最大值;
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyy-MM-dd";
//    NSDate *maxDate = [formatter dateFromString:@"2006-12-31"];
    date.maximumDate = [NSDate date];//最大时间为当前时间
    date.date = [NSDate date];
    self.inputView = date;
    self.datePicker = date;
    
    [self addConstraint:self.datePicker toItem:self.datePicker.superview];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 44)];
    
    UIBarButtonItem * btn1 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(finish)];
    toolbar.items=@[btn1,btn];
    self.inputAccessoryView = toolbar;
    
}



- (void)addConstraint:(UIView *)item toItem:(UIView *)superView
{
    self.datePicker.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [self addConstraint:constraint1];
    
    NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [self addConstraint:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    [self addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    [self addConstraint:constraint4];

}



- (void)finish
{
     [self valueChange];
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
    if (class_respondsToSelector(class, @selector(datePickerValueChangedFinished:date:))||[self.datePicker respondsToSelector:@selector(datePickerValueChangedFinished:date:)])
    {
        UIDatePicker* control = (UIDatePicker*)self.inputView;
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"yyyy年-MM月-dd日";
        NSString *dateStr = [format stringFromDate:control.date];
        
        [self.zxDelegate datePickerValueChangedFinished:dateStr date:control.date];
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
