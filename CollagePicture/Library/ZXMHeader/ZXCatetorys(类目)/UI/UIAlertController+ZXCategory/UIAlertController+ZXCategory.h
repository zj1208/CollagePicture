//
//  UIAlertController+ZXCategory.h
//  YiShangbao
//
//  Created by simon on 17/6/27.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  简介：在超过2个按钮的时候，布局中cancel按钮始终在底部；destructiveButton销毁按钮始终在第一个；其余按钮在中间依次从上往下排列；
//  UIAlertController：
//  (1)UIAlertControllerStyleAlert样式：Title是标题，加粗字体；Message：描述语，默认常规大小字体。如果title=nil，则message会变成标题，加粗字体。
//     如果想让message必须保持常规字体，则title使用字符串空@“”，让message保持副标题。例title=@"",message=@"***"
//  (2)UIAlertControllerStyleActionSheet样式：如果title，message用@"",则actionSheet会添加各自的label，并且各自会占UI一个有效大小位置，但是内容是@""；
//  (3)如果使用NSLocalizedString(nil, nil),会返回@“”;

//  注意：UIAlertAction的回调：点击各种按钮后在当前UIAlertController执行dismiss完成后，且在栈区移除了UIAlertController才会回调block；


// 2018.2.12； 新增预选按钮事件 设置；
// 2018.3.28； 优化代码；
// 2018.4.26 , 修改国际本地化问题，去除NSLocalizedString(x, nil)；
// 2019.06.11 , 优化otherButtonTitles数组只有title不是nil的情况才添加事件；
// 2020.03.30   优化title，message等内容；
// 2020.06.06   优化文字颜色，字体等注释；

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


@interface UIAlertController (ZXCategory)


#pragma mark - AlertControllerAlertStyle

/*
 UIAlertControllerStyleAlert样式的时候，当title为字符串空时，例title=@"",message=@"***"，message字体为小字体；当title=nil，message字体为大字体；
 */

/**
 弹出可以设置最多2个按钮的警告框；－最常见的提示框，蓝色按钮字体；
 
 @param viewController 从viewController当前控制器页面弹出
 @param title 标题；黑色，加粗字体；
 @param message 描述内容；默认是黑色，常规字体，如果title=nil，则message会变成标题，变成加粗字体；
 @param cancelButtonTitle 取消按钮文本，蓝色，加粗；
 @param handler 取消按钮的点击事件在当前UIAlertController执行dismiss完成后才回调block；
 @param doButtonTitle 另外一个按钮文本；蓝色，常规字体；
 @param doHandler 另外一个按钮的点击事件回调；默认取消事件－dismiss；
 */
+ (instancetype)zx_presentGeneralAlertInViewController:(UIViewController *)viewController
                              withTitle:(nullable NSString *)title
                                message:(nullable NSString *)message
                      cancelButtonTitle:(nullable NSString *)cancelButtonTitle cancleHandler:(void (^ __nullable)(UIAlertAction *action))handler
                          doButtonTitle:(nullable NSString *)doButtonTitle
                              doHandler:(void (^ __nullable)(UIAlertAction *action))doHandler NS_AVAILABLE_IOS(8_0);








/**
 弹出可以设置多个按钮的警告框；可以设置蓝色取消按钮，红色销毁警告按钮，另外的常规蓝色按钮数组；

 @param viewController 要弹出的控制器页面
 @param title 标题；黑色，加粗字体；
 @param message 描述内容；默认是黑色，常规字体，如果title=nil，则message会变成标题，变成加粗字体；
 @param cancelButtonTitle 取消按钮文本，蓝色，加粗；
 @param destructiveButtonTitle 红色销毁按钮文本,红色，常规字体；主要用于删除，清空等事件的时候；
 @param otherButtonTitles 另外按钮数组；蓝色，常规字体；
 @param tapBlock 点击各种按钮后在当前UIAlertController执行dismiss完成后才回调block；根据index索引来指定点击了哪个按钮：cancelButton＝0，destructiveButton＝1，otherButton＝2+；
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
/*
 UIAlertControllerStyleActionSheet样式：如果title，message用@"",则actionSheet会添加各自的label，并且各自会占UI一个有效大小位置，但是内容是@""；如果是nil，则不会添加label控件。
 */


/**
 弹出ActionSheet

 @param viewController 当前控制器
 @param title 标题
 @param message 内容
 @param cancelButtonTitle 取消按钮文本，加粗；
 @param destructiveButtonTitle 销毁警告按钮文本，红色
 @param otherButtonTitles 另外的按钮数组文本
 @param tapBlock 点击各种按钮后在当前UIAlertController执行dismiss完成后回调block；根据index索引来指定点击了哪个按钮：cancelButton＝0，destructiveButton＝1，otherButton＝2+；
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
