//
//  ZXKeyboardManager.h
//  YiShangbao
//
//  Created by simon on 2018/4/25.
//  Copyright © 2018年 com.Microants. All rights reserved.
//
//  简介：针对tableView/collectionView/scrollView /self.view上某个层级的子视图为UITextField，或textView的时候，弹出键盘，让输入控件区域滚动到可见区域；
//  待优化：没有对self.view不是滚动视图做处理；交互效果待更好优化；

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXKeyboardManager : NSObject


// tableView/collectionView/scrollView /self.view
@property (nonatomic, strong) UIView *superView;

- (void)registerForKeyboardNotifications;

- (void)removeObserverForKeyboardNotifications;

//
//- (instancetype)initWithSuperView:(UIView *)superView;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END

// 举例：
/*
- (void)addKeyboardManager
{
    ZXKeyboardManager *keyboardManager = [ZXKeyboardManager sharedInstance];
    keyboardManager.superView = self.tableView;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager]setEnable:NO] ;
    [[ZXKeyboardManager sharedInstance]registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [[ZXKeyboardManager sharedInstance]removeObserverForKeyboardNotifications];
}
*/
