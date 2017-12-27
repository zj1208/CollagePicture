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

@property (nonatomic, copy) NSArray *dataArray;

//@property (nonatomic, strong) ZXOverlay *overlay;

@property (nonatomic, strong) UIToolbar *toolbar;
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
    NSArray *array = [NSArray array];
    self.dataArray = array;
    
    _selectedRow =0;
    [self addSubview:self.toolbar];
    
    [self addSubview:self.pickerView];
    // 添加pickerView的约束
    [self addCustomConstraintWithItem:self.pickerView];
    
//    ZXOverlay *overlay = [[ZXOverlay alloc] init];
//    overlay.delegate = self;
//    [overlay addSubview:self];
//    self.overlay = overlay;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.toolbar.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame),44);
}

#pragma mark -pickerView

- (UIPickerView *)pickerView
{
    if (!_pickerView)
    {
        UIPickerView *pickerView= [[UIPickerView alloc] init];
        pickerView.showsSelectionIndicator = YES;
        pickerView.delegate = self;
        pickerView.dataSource =self;
        _pickerView = pickerView;
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
//        toolbar.barTintColor = [UIColor blueColor];
        
        UIBarButtonItem *leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPicker)];
        leftBarButtonItem.tintColor =[UIColor blackColor];
        
        UIBarButtonItem *borderSpaceBarItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
        borderSpaceBarItem.width = LCDScale_iphone6_Width(12);
        
        UIBarButtonItem *centerSpaceBarItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        UIBarButtonItem *rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(toolBarDoneClick:)];
        rightBarButtonItem.tintColor =[UIColor blackColor];
        toolbar.items =@[borderSpaceBarItem,leftBarButtonItem,centerSpaceBarItem,rightBarButtonItem,borderSpaceBarItem];;
        _toolbar = toolbar;
    }
    return _toolbar;
}

#pragma mark - 添加pickView的约束

- (void)addCustomConstraintWithItem:(UIView *)item
{
    self.pickerView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.toolbar attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    constraint1.active = YES;
    
    NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:item.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    constraint2.active = YES;

    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:item.superview attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    constraint3.active = YES;

    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:item.superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    constraint4.active = YES;

}

- (void)reloadDataWithDataArray:(NSArray *)dataArray;
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
    return LCDScale_iphone6_Width(48.f);
}

//-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
//{
//    return 100;
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
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

- (void)showInTabBarView:(UIView *)view
{
    ZXOverlay *overlay = [[ZXOverlay alloc] init];
    overlay.delegate = self;
    [overlay addSubview:self];
    [view addSubview:overlay];
    overlay.frame = CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame)-49);
    
    self.frame = CGRectMake(0, CGRectGetHeight(view.frame), CGRectGetWidth(view.frame), CGRectGetHeight(self.frame));
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.frame = CGRectMake(0, CGRectGetHeight(view.frame) - CGRectGetHeight(self.frame)-49, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    }];
    
    [self.pickerView selectRow:_selectedRow inComponent:0 animated:YES];
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
//    [self layoutIfNeeded];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.3 animations:^{

        self.frame = CGRectMake(0, CGRectGetHeight(view.bounds) - CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));

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
//                         self.superview.alpha = 0.1;

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


