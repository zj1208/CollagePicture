//
//  ZXAreaPickerView.h
//  ZXAreaPickerView
//
//  Created by simon on 14-9-9.
//  Copyright (c) 2014年 simon.com. All rights reserved.
//
//  简介：地址选择器，根据不同样式显示二级地级城市列表或三级县级城市列表；

//  7.11 修改plist本地文件名,方法修改
//  2019.05.25 删除xib文件，重大修改代码；增加overlay底视图，兼容iPhoneX系列；
//  2019.11.12 Dark Mode 下文字颜色适配为黑色；
//  2019.11.28 修改iPhoneX系列判断

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

/**
 *  点击toolbar上的确定按钮的代理回调
 *
 *  @param picker picker description
 */

- (void)zx_pickerDidDoneStatus:(ZXAreaPickerView *)picker;


/**
 *  点击取消的代理回调
 */
- (void)pickerCancel;

@end



@interface ZXAreaPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *locatePicker;
@property (weak, nonatomic) id <ZXAreaPickerDelegate> delegate;
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
//- (instancetype)initTextFieldOfInputViewWithStyle:(ZXAreaPickerStyle)pickerStyle
//                               delegate:(id <ZXAreaPickerDelegate>)delegate
//                              textField:(UITextField*)textField;



// 第二种展现形式：用showInView:(UIView *)view显示;cancelPicker实例方法关闭pickerView；
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
 @interface SearchVideoViewController () <ZXAreaPickerDelegate>
 
 @property(nonatomic,strong)ZXAreaPickerView *areaPickerView;
 
 @end
 
 - (void)setUI
 {
    self.areaPickerView = [[ZXAreaPickerView alloc] initWithStyle:ZXAreaPickerWithStateAndCity delegate:self];
 }


 #pragma mark - HZAreaPicker delegate
  
 - (void)zx_pickerDidDoneStatus:(ZXAreaPickerView *)picker
 {
    if (picker.pickerStyle == ZXAreaPickerWithStateAndCityAndDistrict)
    {
        NSString *str = [NSString stringWithFormat:@"%@ %@ %@", picker.locate.state, picker.locate.city, picker.locate.district];
    }
    else{
        NSString *str = [NSString stringWithFormat:@"%@ %@", picker.locate.state, picker.locate.city];
    }
}

// 或者
- (void)zx_pickerDidDoneStatus:(ZXAreaPickerView *)picker
{
    self.cityDetailLab.text= [NSString stringWithFormat:@"%@ %@", picker.locate.state, picker.locate.city];
    self.cityDetailLab.textColor = [UIColor colorWithWhite:0.2 alpha:1];
}
 */
