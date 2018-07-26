//
//  ZXAreaPickerView.h
//  ZXAreaPickerView
//
//  Created by simon on 14-9-9.
//  Copyright (c) 2014年 simon.com. All rights reserved.
//
//  7.11 修改plist本地文件名,方法修改

#import <UIKit/UIKit.h>
#import "ZXLocation.h"

typedef enum {
    ZXAreaPickerWithStateAndCity,   //省和地级市市
    ZXAreaPickerWithStateAndCityAndDistrict //省，地级市，县城／区
} ZXAreaPickerStyle;


@class ZXAreaPickerView;

@protocol ZXAreaPickerDelegate <NSObject>

/**
 *  @brief 代理回调
 */
@optional
- (void)zx_pickerDidChaneStatus:(ZXAreaPickerView *)picker;

@end




@interface ZXAreaPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (assign, nonatomic) id <ZXAreaPickerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIPickerView *locatePicker;
@property (strong, nonatomic) ZXLocation *locate;
@property (nonatomic) ZXAreaPickerStyle pickerStyle;



/**
 *  第一种展现方式：textField显示方式；如果是点击textField来弹出地址选择器；显示会根据第一响应者自己替代键盘显示；
 *  点击取消按钮，会响应resignFirstResponder;
 *
 *  @param pickerStyle 选择显示数据样式;
 *  @param textField   第一响应者textField;
 *
 */
- (instancetype)initTextFieldOfInputViewWithStyle:(ZXAreaPickerStyle)pickerStyle
                               delegate:(id <ZXAreaPickerDelegate>)delegate
                              textField:(UITextField*)textField;



// 第二种展现形式：用showInView:(UIView *)view;和cancelPicker实例方法关闭显示pickerView；
/**
 *  @brief 初始化地区选折
 *  @param delegate   代理者
 *  @param pickerStyle  选择显示数据样式
 */

- (instancetype)initWithStyle:(ZXAreaPickerStyle)pickerStyle delegate:(id <ZXAreaPickerDelegate>)delegate;

/**
 *  @brief 在view试图中弹出显示pickerView
 *  @param view   显示试图
 */

- (void)showInView:(UIView *)view;


/**
 *  @brief 关闭消失pickerView
 */

- (void)cancelPicker;

@end


//使用案例
/* 
 
 
 <ZXAreaPickerDelegate>
 
 @property(nonatomic,strong)ZXAreaPickerView *areaPickerView;

 
self.areaPickerView = [[ZXAreaPickerView alloc] initTextFieldOfInputViewWithStyle:ZXAreaPickerWithStateAndCityAndDistrict delegate:self textField:_txtArea ];

 
 #pragma mark - HZAreaPicker delegate
 -(void)zx_pickerDidChaneStatus:(ZXAreaPickerView *)picker
 {
     NSString *string = [NSString stringWithFormat:@"%@ %@ %@", picker.locate.state, picker.locate.city, picker.locate.district];
 
 //    NSLog(@"%@",string);
     [self.textField3 setTitle:string forState:UIControlStateNormal];
 
 
 //    if (picker.pickerStyle == ZXAreaPickerWithStateAndCityAndDistrict)
 //    {
 //        self.textField3.text = [NSString stringWithFormat:@"%@ %@ %@", picker.locate.state, picker.locate.city, picker.locate.district];
 //    }
 //    else{
 //        self.textField3.text= [NSString stringWithFormat:@"%@ %@", picker.locate.state, picker.locate.city];
 //    }
 
 }
 

 */
