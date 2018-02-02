//
//  ZXDatePickerTextField.h
//
//
//  Created by zhuxinming on 15/10/29.
//  Copyright © 2015年 mac. All rights reserved.
//  可以参考网易云信的生日选择优化；这个暂时使用，待优化；

//  2018.1.16 优化ZXDatePickerTextField；

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZXDatePickerTDelegate <NSObject>

/**
 *  datePicker值变化时的返回值;
 *
 *  @param dateString  返回NSDate日期的字符串格式yyyy年-MM月-dd日
 *  @param aDate  返回date日期
 *
 *
 */

- (void)zx_datePickerValueChangedFinished:(NSString *)dateString date:(NSDate *)aDate;


- (void)zx_datePickerFinish:(NSString *)dateString date:(NSDate *)aDate;

@end


@interface ZXDatePickerTextField : UITextField

@property(nonatomic,weak) id<ZXDatePickerTDelegate>zxDelegate;

//开启实时改变ui时间显示;
@property(nonatomic) BOOL beingValueChange;

//让picker显示当前dateFormat的时间,根据dateFormat把text字符串转换为date;

- (void)showTextFieldHadDate:(NSString *)dateFormat;

@end

NS_ASSUME_NONNULL_END


/*
 <ZXDatePickerTDelegate>
 self.dateField.zxDelegate = self;
 self.dateField.beingValueChange = YES;
 //self.dateField.delegate = self;
 [self.dateField showTextFieldHadDate];

 - (void)datePickerValueChangedFinished:(NSString *)dateString
 {
     self.textField.text = dateString;
 }

 - (void)textFieldDidBeginEditing:(UITextField *)textField
 {
    if (self.dateField.text.length>0)
    {
        [self.dateField showTextFieldHadDate];
    }
 }

 */
