//
//  ZXMPickerView.m
//  ICBC
//
//  Created by 朱新明 on 15/2/11.
//  Copyright (c) 2015年 朱新明. All rights reserved.
//

#import "ZXMPickerView.h"


#ifndef LCDW
#define LCDW ([[UIScreen mainScreen] bounds].size.width)
#define LCDH ([[UIScreen mainScreen] bounds].size.height)
//设置iphone6尺寸比例/竖屏,UI所有设备等比例缩放
#define LCDScale_iphone6_Width(X)    ((X)*LCDW/375)
#endif


@interface ZXMPickerView ()
@property (nonatomic , assign) int row;

@property(nonatomic,copy)NSArray *dataArray;
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



- (void)initData
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.pickerView= [[UIPickerView alloc] init];
    self.pickerView.showsSelectionIndicator = YES;
    self.pickerView.delegate = self;
    self.pickerView.dataSource =self;
    [self addSubview:self.pickerView];
    
    [self addConstraint:self.pickerView toItem:self.pickerView.superview];
   
    NSArray *array = [NSArray array];
    self.dataArray = array;
    
    _selectedRow =0;
    
    UIToolbar *toolbar=[[UIToolbar alloc] init];
//    toolbar.barTintColor = [UIColor blueColor];
    toolbar.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,LCDScale_iphone6_Width(48));
    [self addSubview:toolbar];
    
    UIBarButtonItem *lefttem=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPicker)];
    lefttem.tintColor =[UIColor blackColor];
    UIBarButtonItem *borderSpace=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    borderSpace.width = LCDScale_iphone6_Width(9);
    
    UIBarButtonItem *centerSpace=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(toolBarDoneClick:)];
    right.tintColor =[UIColor blackColor];
    toolbar.items=@[borderSpace,lefttem,centerSpace,right,borderSpace];
    
}


- (void)addConstraint:(UIView *)item toItem:(UIView *)superView
{
    self.pickerView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [self addConstraint:constraint1];
    
    NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [self addConstraint:constraint2];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    [self addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    [self addConstraint:constraint4];
    
}

-(void)reloadDataWithDataArray:(NSArray *)dataArray;
{
    _dataArray =[dataArray copy];
    [self.pickerView reloadAllComponents];
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated
{
    [self.pickerView selectRow:row inComponent:component animated:animated];
}

- (void)selectObject:(NSString *)object animated:(BOOL)animated
{
    if ([self.dataArray containsObject:object])
    {
        NSInteger index = [self.dataArray indexOfObject:object];
        [self.pickerView selectRow:index inComponent:0 animated:YES];
    }

}

#pragma mark-dataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
//    NSLog(@"%d",self.dataArray.count);
    return self.dataArray.count;
}

#pragma mark-Delegate
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row>=self.dataArray.count) {
        return [self.dataArray lastObject];
    }
    return [self.dataArray objectAtIndex:row];
}

#pragma mark - PickerViewDelegate
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return LCDScale_iphone6_Width(48.f);
}

//-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
//{
//    return 100;
//}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _row =(int)row;
}

- (void)toolBarDoneClick:(UIBarButtonItem *)sender
{
    NSString *tit = [self.dataArray objectAtIndex:_row];
    
    if ([self.delegate respondsToSelector:@selector(zx_pickerDidDoneStatus:index:itemTitle:)])
    {
        [self.delegate zx_pickerDidDoneStatus:self index:_row itemTitle:tit];
    }
    [self cancelPicker];
}

- (void)showInTabBarView:(UIView *) view
{
    ZXOverlay *overlay = [[ZXOverlay alloc] initWithFrame:CGRectMake(0, 0, LCDW, LCDH-49)];
    overlay.delegate = self;
    [overlay addSubview:self];
    [view addSubview:overlay];
    
    
    self.frame = CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds), CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight(self.frame));
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.frame = CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds) - CGRectGetHeight(self.frame)-49, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight(self.frame));
    }];
    
    [self.pickerView selectRow:_selectedRow inComponent:0 animated:YES];
}


- (void)showInView:(UIView *) view
{
    if ([view isKindOfClass:[UITableView class]] ||[view isKindOfClass:[UICollectionView class]])
    {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    ZXOverlay *overlay = [[ZXOverlay alloc] initWithFrame:[UIScreen mainScreen].bounds];
    overlay.delegate = self;
    [overlay addSubview:self];
    [view addSubview:overlay];
    
    
    self.frame = CGRectMake(0, CGRectGetHeight(view.bounds), CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight(self.frame));

    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.3 animations:^{
        
        self.frame = CGRectMake(0, CGRectGetHeight(view.bounds) - CGRectGetHeight(self.frame), CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight(self.frame));

    } completion:^(BOOL finished) {
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
}


- (void)zxOverlaydissmissAction
{
    [self cancelPicker];
}


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




@end


