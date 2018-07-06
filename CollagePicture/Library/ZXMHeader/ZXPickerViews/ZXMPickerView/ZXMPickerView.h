//
//  ZXMPickerView.h
//  ICBC
//
//  Created by 朱新明 on 15/2/11.
//  Copyright (c) 2015年 朱新明. All rights reserved.
//
// 注释： showInView:方法如果传tableView，弹窗在window会有bug；同ZXDatePickerView.h；ZXDatePickerTextField都有这个bug问题；

// 2017.12.25
// 优化组件，顶部toolbar高度固定优化； pickerView高度约束修改优化；优化代码；
// 2018.1.12 优化代码；
// 2018.6.14 优化移除覆盖遮图动画过渡效果；

#import <UIKit/UIKit.h>
#import "ZXOverlay.h"


NS_ASSUME_NONNULL_BEGIN

@class ZXMPickerView;
@protocol ZXMPickerViewDelegate <NSObject>

/**
 *  @brief 代理回调
 */
@optional

/**
 *  pickerView在改变的时候，回调选择的title；
 *
 *  @param picker picker description
 *  @param title  title description
 */
- (void)zx_pickerDidChangeStatus:(ZXMPickerView*)picker itemTitle:(NSString *)title;

/**
 *  点击toolbar上的确定按钮的代理回调
 *
 *  @param picker picker description
 *  @param title  pickerView选择的title
 */

- (void)zx_pickerDidDoneStatus:(ZXMPickerView *)picker index:(NSUInteger)index itemTitle:(NSString *)title;

/**
 *  点击取消的代理回调
 */
- (void)pickerCancel;
@end





@interface ZXMPickerView : UIView<UIPickerViewDataSource,UIPickerViewDelegate,ZXOverlayDelegate>

@property(nonatomic, weak) id<ZXMPickerViewDelegate>delegate;

@property(nonatomic, strong) UIPickerView *pickerView;

/**
 *  @brief 设置数据源
 */
- (void)reloadDataWithDataArray:(NSArray *)dataArray;

//默认选中哪行
// selection. in this case, it means showing the appropriate row in the middle
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;  // scrolls the specified row to center.

/**
 用于刚开始默认选中数组中的指定对象，这样出现这个picker的时候，就已经滚动到选中了的指定对象；

 @param object 需要选中的对象
 @param animated animated description
 */
- (void)selectObject:(NSString *)object animated:(BOOL)animated;


@property (nonatomic , assign) NSInteger selectedRow;

- (void)showInTabBarView:(UIView *) view;
- (void)showInView:(UIView *)view;
- (void)cancelPicker;

@end

NS_ASSUME_NONNULL_END

#pragma mark - 例子
//////////////--例子－－－－////////////////////

/*
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ZXMPickerView *picker = [[ZXMPickerView alloc] initWithFrame:CGRectMake(0, 0, 0, LCDScale_iPhone6_Width(230.f))];
    picker.delegate = self;
    self.pickerView = picker;
 
    NSArray *array = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10+"];
    [self.pickerView reloadDataWithDataArray:array];
}

//在请求页面数据成功的时候，刷新数据；
- (void)reloadAllData
{
    if ([self.yearBtn currentTitle].length ==0)
    {
        if ([[model.mgrPeriod stringValue] isEqualToString:@"11"])
        {
            [self.yearBtn setTitle:@"10+" forState:UIControlStateNormal];
            [self.pickerView selectObject:@"10+" animated:YES];
        }
        else
        {
            [self.yearBtn setTitle:model.mgrPeriod.description forState:UIControlStateNormal];
            [self.pickerView selectObject:[model.mgrPeriod stringValue] animated:YES];
        }
    }
}
 
//响应弹出事件
- (IBAction)yearBtnChangeAction:(UIButton *)sender {
 
  [self.pickerView showInView:self.tableView];
 
 }

#pragma mark - pieckerViewDelegate
 
- (void)zx_pickerDidDoneStatus:(ZXMPickerView *)picker itemTitle:(NSString *)title
{
    [self.yearBtn setTitle:title forState:UIControlStateNormal];
}

*/
