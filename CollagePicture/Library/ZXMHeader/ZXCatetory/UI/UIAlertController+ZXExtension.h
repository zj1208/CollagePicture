//
//  UIAlertController+ZXExtension.h
//  YiShangbao
//
//  Created by simon on 17/6/27.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  待优化：如果没有用NSLocalizedString传值过来，则使用NSLocalizedString(x, nil)；如果已经用了，则不使用；

// 2018.2.12； 新增预选按钮事件 设置；
// 2018.3.28； 优化代码；
// 2018.4.26 , 修改国际本地化问题，去除NSLocalizedString(x, nil)；



#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN


typedef void (^UIAlertControllerPopoverPresentationControllerBlock) (UIPopoverPresentationController * __nonnull popover);


/**
 点击各种按钮的block；根据index索引来指定点击了哪个按钮：
 cancelButton＝0，destructiveButton＝1，otherButton＝2++；

 @param alertController self
 @param action 点击按钮的事件
 @param buttonIndex 点击按钮的索引
 */
typedef void (^UIAlertControllerCompletionBlock) (UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex);


@interface UIAlertController (ZXExtension)


#pragma mark - AlertControllerAlertStyle
/**
 弹出可以设置最多2个按钮的警告框；－最常见的提示框
 
 @param viewController 从viewController当前控制器页面弹出
 @param title 警告框标题
 @param message 警告框内容
 @param cancelButtonTitle 取消按钮文本，加粗；
 @param handler 取消按钮点击事件回调；默认取消事件－dismiss；
 @param doButtonTitle 另外一个按钮文本
 @param doHandler 另外一个按钮的点击事件回调；默认取消事件－dismiss；
 */
+ (instancetype)zx_presentGeneralAlertInViewController:(UIViewController *)viewController
                              withTitle:(nullable NSString *)title
                                message:(nullable NSString *)message
                      cancelButtonTitle:(nullable NSString *)cancelButtonTitle cancleHandler:(void (^ __nullable)(UIAlertAction *action))handler
                          doButtonTitle:(nullable NSString *)doButtonTitle
                              doHandler:(void (^ __nullable)(UIAlertAction *action))doHandler NS_AVAILABLE_IOS(8_0);








/**
 弹出可以设置多个按钮的警告框；可以设置取消按钮，红色销毁警告按钮，另外的按钮数组；

 @param viewController 要弹出的控制器页面
 @param title 标题
 @param message 警告框内容
 @param cancelButtonTitle 取消按钮文本（加粗）
 @param destructiveButtonTitle 红色销毁按钮文本
 @param otherButtonTitles 另外按钮数组
 @param tapBlock 点击各种按钮的block；根据index索引来指定点击了哪个按钮：cancelButton＝0，destructiveButton＝1，otherButton＝2+；
 @return 返回AlertController
 */
+ (instancetype)zx_presentCustomAlertInViewController:(UIViewController *)viewController
                                      withTitle:(nullable NSString *)title
                                        message:(nullable NSString *)message
                              cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                         destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                              otherButtonTitles:(nullable NSArray *)otherButtonTitles
                                       tapBlock:(nullable UIAlertControllerCompletionBlock)tapBlock
                                    NS_AVAILABLE_IOS(8_0);



#pragma mark - ActionSheet
/**
 弹出ActionSheet

 @param viewController 当前控制器
 @param title 标题
 @param message 内容
 @param cancelButtonTitle 取消按钮文本，加粗；
 @param destructiveButtonTitle 销毁警告按钮文本，红色
 @param otherButtonTitles 另外的按钮数组文本
 @param tapBlock 点击各种按钮的block；根据index索引来指定点击了哪个按钮：cancelButton＝0，destructiveButton＝1，otherButton＝2+；
 @return 返回AlertController对象；
 */
+ (instancetype)zx_presentActionSheetInViewController:(UIViewController *)viewController
                                            withTitle:(nullable NSString *)title
                                              message:(nullable NSString *)message
                                    cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                               destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                    otherButtonTitles:(nullable NSArray *)otherButtonTitles
                                             tapBlock:(nullable UIAlertControllerCompletionBlock)tapBlock NS_AVAILABLE_IOS(8_0);

//除了第一个类方法以外，全部的基本方法； 
+ (instancetype)showInViewController:(nonnull UIViewController *)viewController
                           withTitle:(nullable NSString *)title
                             message:(nullable NSString *)message
                      preferredStyle:(UIAlertControllerStyle)preferredStyle
                   cancelButtonTitle:(nullable NSString *)cancelButtonTitle
              destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                   otherButtonTitles:(nullable NSArray *)otherButtonTitles
  popoverPresentationControllerBlock:(nullable UIAlertControllerPopoverPresentationControllerBlock)popoverPresentationControllerBlock
                            tapBlock:(nullable UIAlertControllerCompletionBlock)tapBlock  NS_AVAILABLE_IOS(8_0);



// 2.12设置某个UIAlertAction为优先提示事件；即文字加粗高亮；默认cancle事件按钮；
// [alert setAlertViewPreferredActionWithTitle:@"继续"];

- (void)setAlertViewPreferredActionWithTitle:(NSString *)prefreredTitle;

@property (readonly, nonatomic) NSInteger cancelButtonIndex;
@property (readonly, nonatomic) NSInteger destructiveButtonIndex;
@property (readonly, nonatomic) NSInteger firstOtherButtonIndex;


@end


NS_ASSUME_NONNULL_END

/*
- (void)putawayAction:(UIButton *)sender
{
    
    [MobClick event:kUM_b_PMaddpublicity];
    NSIndexPath *indexPath = [sender zh_getIndexPathWithBtnInCellFromTableViewOrCollectionView:self.tableView];
    ShopMyProductModel *model = [self.dataMArray objectAtIndex:indexPath.section];
    NSString *productId = model.productId;
    
 
    WS(weakSelf);
    [UIAlertController zx_presentCustomAlertInViewController:self withTitle:@"确认产品转移为公开上架吗？" message:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"公开上架"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex ==controller.firstOtherButtonIndex)
        {
            [ProductMdoleAPI postMyProductToPublicWithProductId:productId Success:^(id data) {
                
                [weakSelf deleteDataInTableViewWithIndexPath:indexPath];
                
            } failure:^(NSError *error) {
                
                [weakSelf.tableView.mj_header endRefreshing];
                [weakSelf zhHUD_showErrorWithStatus:[error localizedDescription]];
            }];
            
        }
        
    }];
}
*/
