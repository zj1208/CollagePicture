//
//  ZXDatePickerView.h
//  YiShangbao
//
//  Created by simon on 2018/1/12.
//  Copyright © 2018年 com.Microants. All rights reserved.
//
//  注释：根据UIDatePicker，二次封装成一个带toolBar的弹框；可以使用block方法回调，也可以使用代理方法回调；

// 2018.1.18  目前showInView:方法，如果传tableView，在转换window的时候，有时候会出问题；

#import <UIKit/UIKit.h>
#import "ZXOverlay.h"

NS_ASSUME_NONNULL_BEGIN

//typedef NS_ENUM(NSInteger, ZXDateFormatType)
//{
////    @"2018-01-12 10:36:11 +0000"
//    ZXDateFormatModeDate_Default = 0,
////    @"yyyy年-MM月-dd日"
//    ZXDateFormatType_YYYY_MMMM_DD = 1,
////    @"yyyy年-MM月"
//    ZXDateFormatType_YYYY_MMMM = 2,
//};

@class ZXDatePickerView;
@protocol ZXDatePickerViewDelegate <NSObject>

/**
 *  @brief 代理回调
 */
@optional

/**
 *  datePicker值变化时的返回值;
 *
 *  @param dateString  根据设置的returnDateFormat格式返回
 *  @param aDate  返回date日期
 *
 *
 */
- (void)zx_datePickerValueChanged:(ZXDatePickerView *)picker date:(NSDate *)aDate dateString:(NSString *)dateString;

/**
 点击完成按钮

 @param picker ZXDatePickerView
 @param aDate 日期
 */
- (void)zx_datePickerDidDoneStatus:(ZXDatePickerView *)picker date:(NSDate *)aDate dateString:(NSString *)dateString;;

/**
 *  点击取消的代理回调
 */
- (void)pickerCancel;

@end


@interface ZXDatePickerView : UIView<ZXOverlayDelegate>

// 自己利用datePicker设置最大时间，最小时间；默认当前时间为最大时间；
// datePickerMode默认是UIDatePickerModeDate，calender日历等属性；
@property (nonatomic, strong) UIDatePicker *datePicker;


/**
 设置toolBar上通用按钮颜色
 */
@property (nonatomic, null_resettable, strong) UIColor *toolBarTintColor;


/**
 设置中间title按钮的 title，titleColor
 */
@property (nonatomic, strong) UIBarButtonItem *toolBarTitleBarButtonItem;

/**
 默认“选择日期”
 */
@property (nonatomic, copy, nullable) NSString *toolBarTitleBarItemTitle;

/**
 默认blackColor
 */
@property (nonatomic, strong) UIColor *toolBarTitleBarItemColor;

@property (nonatomic, weak) id<ZXDatePickerViewDelegate>delegate;

// 设置返回日期格式；等同于NSDateFormatter的dateFormat
// 例如：returnDateFormat = @"yyyy年-MM月-dd日";
// returnDateFormat = @"yyyy.MM.dd"; 等
@property (nonatomic, copy) NSString *returnDateFormat;

@property (nonatomic, copy) void(^cancleActionHandleBlock)(void);
@property (nonatomic, copy) void(^valueChangeBlock)(NSDate *date,NSString *dateString);
@property (nonatomic, copy) void(^doActionHandleBlock)(NSDate *date,NSString *dateString);



// block形式返回
- (void)showInView:(UIView *)view cancleHander:(void(^ __nullable)(void))cancleHander doneHander:(void(^__nullable)(NSDate *date,NSString *dateString))doneHander;

// block形式返回，值改变的时候也返回；
- (void)showInView:(UIView *)view valueChange:(void(^)(NSDate *date,NSString *dateString))valueChange cancleHander:(void(^ __nullable)(void))cancleHander doneHander:(void(^__nullable)(NSDate *date,NSString *dateString))doneHander;


- (void)showInTabBarView:(UIView *)view;

- (void)showInView:(UIView *)view;

- (void)cancelPicker;
@end

NS_ASSUME_NONNULL_END

/*
- (void)setUI
{
     ZXDatePickerView *picker = [[ZXDatePickerView alloc] init];
     picker.toolBarTintColor = UIColorFromRGB_HexValue(0x45A4E8);
     picker.toolBarTitleBarItemTitle = @"选择日期";
     picker.returnDateFormat = @"yyyy年MM月";
 
     self.datePicker = picker;
}
- (IBAction)choseDateButtonAction:(id)sender
{
    [self.datePicker showInView:self.view cancleHander:^{
        
    } doneHander:^(NSDate * _Nonnull date, NSString * _Nonnull dateString) {
        
        NSLog(@"%@",dateString);
        _year = [dateString substringToIndex:4];
        _month = [dateString substringWithRange:NSMakeRange(5, 2)];
        _dateLab.text = dateString;
        [_tableView.mj_header beginRefreshing];
        
    }];
}
*/
