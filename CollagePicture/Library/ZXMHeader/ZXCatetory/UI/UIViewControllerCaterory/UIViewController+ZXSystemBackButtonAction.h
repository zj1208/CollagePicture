//
//  UIViewController+ZXSystemBackButtonAction.h
//  YiShangbao
//
//  Created by simon on 2017/7/13.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//设置系统返回按钮自定义事件，如果实现这个协议，则进入自定义事件；没有实现就默认返回；

@protocol ZXSystemBackButtonActionDelegate <NSObject>

@optional

- (BOOL)navigationShouldPopOnBackButton;

@end



@interface UIViewController (ZXSystemBackButtonAction)<ZXSystemBackButtonActionDelegate>

@end


NS_ASSUME_NONNULL_END

/*
- (BOOL)navigationShouldPopOnBackButton
{
    NSString *message = self.controllerDoingType == ControllerDoingType_AddProduct?@"确定放弃新增产品?":@"确定放弃编辑产品?";
    WS(weakSelf);
    [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:nil message:message cancelButtonTitle:@"放弃" cancleHandler:^(UIAlertAction * _Nonnull action) {
        
        [self.diskManager removeData];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } doButtonTitle:@"继续" doHandler:nil];
    return NO;
}
 */
