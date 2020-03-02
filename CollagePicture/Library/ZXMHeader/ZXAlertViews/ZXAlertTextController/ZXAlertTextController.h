//
//  ZXAlertTextController.h
//  MobileCaiLocal
//
//  Created by 朱新明 on 2020/2/17.
//  Copyright © 2020 com.Chs. All rights reserved.
//
//  简介：仿造系统类，做自定义一个警告框；待扩展；依赖约束布局类Masonary；

//  2020.2.18 简化代码；

#import <UIKit/UIKit.h>
#import "Masonry.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ZXAlertTextActionStyle) {
    ZXAlertTextActionStyleDefault = 0,
    ZXAlertTextActionStyleCancel,
} API_AVAILABLE(ios(8.0));

NS_CLASS_AVAILABLE_IOS(8_0) @interface ZXAlertTextAction : NSObject 

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(ZXAlertTextActionStyle)style handler:(void (^ __nullable)(ZXAlertTextAction *action))handler;

@end


@interface ZXAlertTextController : UIViewController

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message;

- (void)addAction:(ZXAlertTextAction *)action;

@property (nonatomic, readonly) NSArray<ZXAlertTextAction *> *actions;

@property (nullable, nonatomic, readonly) NSArray<UITextField *> *textFields;
@end

NS_ASSUME_NONNULL_END


///*例子*//////////////
/*
- (void)goodNumBtnAction:(UIButton *)sender
{
    ZXAlertTextController *alertVC = [ZXAlertTextController alertControllerWithTitle:@"请输入所需数量" message:nil];
    ZXAlertTextController * __weak SELF = alertVC;
    ZXAlertTextAction *action1 = [ZXAlertTextAction actionWithTitle:@"取消" style:ZXAlertTextActionStyleCancel handler:nil];
    WS(weakSelf);
    ZXAlertTextAction *action2 = [ZXAlertTextAction actionWithTitle:@"确定" style:ZXAlertTextActionStyleDefault handler:^(ZXAlertTextAction * _Nonnull action) {
        UITextField *textField = [SELF.textFields firstObject];
        if ([NSString zhIsBlankString:textField.text]) {
            return ;
        }
        NSIndexPath *indexPath = [weakSelf.tableView zx_getIndexPathForRowFromConvertCellSubView:sender];
        CHSShopCartModel_ListModel *model = [self.shopCartModel.list safeObjectAtIndex:indexPath.row];
        if ([textField.text isEqualToString:@"0"]) {
            
            [weakSelf alertshowTitle:@"您确认删除该商品吗？" andMessage:nil andCancelbtn:@"取消" andSureBtn:@"确认" CancelBlock:^{
            } sureBlock:^{

                [weakSelf requestReduceGoodsNum:model.skuId andIndexPath:indexPath];
             }];
        }
        else
        {
            NSString *text = [NSString zhFilterInputTextWithWittespaceAndLine:textField.text];
            [weakSelf dismissAlertViewWithSkuId:model.skuId indexPath:indexPath inputText:text];
        }

    }];
    [alertVC addAction:action1];
    [alertVC addAction:action2];
    [self.tabBarController addChildViewController:alertVC];
    alertVC.view.frame = self.tabBarController.view.frame;
    [self.tabBarController.view addSubview:alertVC.view];
    [[alertVC.textFields firstObject]becomeFirstResponder];
}
*/
