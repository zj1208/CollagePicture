//
//  HZAreaPickerView.m
//  areapicker
//
//  Created by simon on 14-9-9.
//  Copyright (c) 2014年 simon.com. All rights reserved.
//

#import "HZAreaPickerView.h"
#import <QuartzCore/QuartzCore.h>

#define kDuration 0.3

@interface HZAreaPickerView ()

@property(nonatomic,strong) NSArray *provinces;//35个字典省份组合的数组
@property(nonatomic,strong) NSArray *cities;
@property(nonatomic,strong) NSArray *areas;

@property (nonatomic,strong)UITextField *inputTextField;
@end

@implementation HZAreaPickerView

@synthesize delegate=_delegate;
@synthesize pickerStyle=_pickerStyle;
@synthesize locate=_locate;
@synthesize locatePicker = _locatePicker;


@synthesize provinces;
@synthesize cities;
@synthesize areas;


-(HZLocation *)locate
{
    if (_locate == nil) {
        _locate = [[HZLocation alloc] init];
    }
    
    return _locate;
}

#pragma mark - Lifecycle

- (instancetype)initWithStyle:(HZAreaPickerStyle)pickerStyle delegate:(id<HZAreaPickerDelegate>)delegate
{
    
    self = [[[NSBundle mainBundle] loadNibNamed:@"HZAreaPickerView" owner:self options:nil] objectAtIndex:0] ;
    if (self)
    {
        self.delegate = delegate;
        self.pickerStyle = pickerStyle;
        [self initData];
    }

    return self;
    
}
- (instancetype)initTextFieldOfInputViewWithStyle:(HZAreaPickerStyle)pickerStyle
                               delegate:(id <HZAreaPickerDelegate>)delegate
                              textField:(UITextField*)textField
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"HZAreaPickerView" owner:self options:nil] objectAtIndex:0] ;
    if (self)
    {
        self.delegate = delegate;
        self.pickerStyle = pickerStyle;
        self.inputTextField = textField;
        [self initData];
        textField.inputView = self;
        textField.inputAccessoryView = [self getToolBar];

    }
    return self;
}


- (void)initData
{
   
    self.locatePicker.dataSource = self;
    self.locatePicker.delegate = self;
    //加载数据
    if (self.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict)
    {
        //35个字典组合的数组，更细分一点，先地级市，后面还有县城
        self.provinces = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.json" ofType:nil]];
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
        self.provinces = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city.plist" ofType:nil]];//城市，地级市
        self.cities = [[self.provinces objectAtIndex:0] objectForKey:@"cities"];
        self.locate.state = [[self.provinces objectAtIndex:0] objectForKey:@"state"];
        self.locate.city = [self.cities objectAtIndex:0];
    }

  
}

#pragma mark - 


-(UIToolbar *)getToolBar
{
    UIToolbar *toolbar=[[UIToolbar alloc] init];
    
    toolbar.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,40);
    
    UIBarButtonItem *lefttem=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick)];
    lefttem.tintColor =[UIColor blackColor];
    UIBarButtonItem *borderSpace=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    borderSpace.width = 5;
    
    UIBarButtonItem *centerSpace=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doneClick)];
    right.tintColor =[UIColor blackColor];
    NSArray *items = @[borderSpace,lefttem,centerSpace,right,borderSpace];
    toolbar.items= items;
    return toolbar;
}

- (void)doneClick
{
    
    [self cancelClick];
    if([self.delegate respondsToSelector:@selector(pickerDidChaneStatus:)]) {
        [self.delegate pickerDidChaneStatus:self];
    }
}

// 取消按钮action
- (void)cancelClick
{
    if (self.inputTextField)
    {
        [self.inputTextField resignFirstResponder];
    }
    else
    {
        [self cancelPicker];
    }
}


#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict)
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
            if (self.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict)
            {
                return [self.areas count];
                break;
            }
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict)
    {
        switch (component)
        {
            case 0:
                return [[self.provinces objectAtIndex:row] objectForKey:@"state"];//省
                break;
            case 1:
                return [[self.cities objectAtIndex:row] objectForKey:@"city"];//市
                break;
            case 2:
                if ([self.areas count] > 0) {
                    return [self.areas objectAtIndex:row];//县级市或直辖市的区
                    break;
                }
            default:
                return  @"";
                break;
        }
    }
    else{
        switch (component)
        {
            case 0:
                return [[self.provinces objectAtIndex:row] objectForKey:@"state"];
                break;
            case 1:
                return [self.cities objectAtIndex:row];
                break;
            default:
                return @"";
                break;
        }
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
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
    
    if([self.delegate respondsToSelector:@selector(pickerDidChaneStatus:)]) {
        [self.delegate pickerDidChaneStatus:self];
    }

}

#pragma mark - animation

- (void)showInView:(UIView *) view
{
    self.frame = CGRectMake(0, view.frame.size.height, self.frame.size.width, self.frame.size.height);
    [view addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }];
    
}

- (void)cancelPicker
{
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         
                     }];
    
}

@end
