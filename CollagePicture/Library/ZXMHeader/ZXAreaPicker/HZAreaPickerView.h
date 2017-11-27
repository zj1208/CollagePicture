//
//  ZXAreaPickerView.h
//  areapicker
//
//  Created by simon on 14-9-9.
//  Copyright (c) 2014年 simon.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZLocation.h"

typedef enum {
    HZAreaPickerWithStateAndCity,   //省和地级市市
    HZAreaPickerWithStateAndCityAndDistrict //省，地级市，县城／区
} HZAreaPickerStyle;


@class HZAreaPickerView;

@protocol HZAreaPickerDelegate <NSObject>

/**
 *  @brief 代理回调
 */
@optional
- (void)pickerDidChaneStatus:(HZAreaPickerView *)picker;

@end




@interface HZAreaPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (assign, nonatomic) id <HZAreaPickerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIPickerView *locatePicker;
@property (strong, nonatomic) HZLocation *locate;
@property (nonatomic) HZAreaPickerStyle pickerStyle;



/**
 *  第一种展现方式：textField显示方式；如果是点击textField来弹出地址选择器；显示会根据第一响应者自己替代键盘显示；
 *  点击取消按钮，会响应resignFirstResponder;
 *
 *  @param pickerStyle 选择显示数据样式;
 *  @param textField   第一响应者textField;
 *
 */
- (instancetype)initTextFieldOfInputViewWithStyle:(HZAreaPickerStyle)pickerStyle
                               delegate:(id <HZAreaPickerDelegate>)delegate
                              textField:(UITextField*)textField;



// 第二种展现形式：用showInView:(UIView *)view;和cancelPicker实例方法关闭显示pickerView；
/**
 *  @brief 初始化地区选折
 *  @param delegate   代理者
 *  @param pickerStyle  选择显示数据样式
 */

- (instancetype)initWithStyle:(HZAreaPickerStyle)pickerStyle delegate:(id <HZAreaPickerDelegate>)delegate;

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
 
 
 <HZAreaPickerDelegate>
 
 @property(nonatomic,strong)HZAreaPickerView *areaPickerView;

 
self.areaPickerView = [[HZAreaPickerView alloc] initTextFieldOfInputViewWithStyle:HZAreaPickerWithStateAndCityAndDistrict delegate:self textField:_txtArea ];

 
 #pragma mark - HZAreaPicker delegate
 -(void)pickerDidChaneStatus:(HZAreaPickerView *)picker
 {
     NSString *string = [NSString stringWithFormat:@"%@ %@ %@", picker.locate.state, picker.locate.city, picker.locate.district];
 
 //    NSLog(@"%@",string);
     [self.textField3 setTitle:string forState:UIControlStateNormal];
 
 
 //    if (picker.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict)
 //    {
 //        self.textField3.text = [NSString stringWithFormat:@"%@ %@ %@", picker.locate.state, picker.locate.city, picker.locate.district];
 //    }
 //    else{
 //        self.textField3.text= [NSString stringWithFormat:@"%@ %@", picker.locate.state, picker.locate.city];
 //    }
 
 }
 

 */
