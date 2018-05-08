//
//  UIAlertController+ZXExtension.m
//  YiShangbao
//
//  Created by simon on 17/6/27.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "UIAlertController+ZXExtension.h"


static NSInteger const UIAlertControllerBlocksCancelButtonIndex = 0;
static NSInteger const UIAlertControllerBlocksDestructiveButtonIndex = 1;
static NSInteger const UIAlertControllerBlocksFirstOtherButtonIndex = 2;

@implementation UIAlertController (ZXExtension)


//+ (void)zx_presentGeneralAlertInViewController:(UIViewController *)viewController
//                                     withTitle:(nullable NSString *)title
//                                       message:(nullable NSString *)message
//                             cancelButtonTitle:(nullable NSString *)cancelButtonTitle cancleHandler:(void (^ __nullable)(UIAlertAction *action))handler
//                                 doButtonTitle:(nullable NSString *)doButtonTitle
//                                     doHandler:(void (^ __nullable)(UIAlertAction *action))doHandler
//                           preferredActionTitle:(nullable NSString *)preferredTitle
//{
//    
//}

+ (instancetype)zx_presentGeneralAlertInViewController:(UIViewController *)viewController
                              withTitle:(nullable NSString *)title
                                message:(nullable NSString *)message
                      cancelButtonTitle:(nullable NSString *)cancelButtonTitle cancleHandler:(void (^ __nullable)(UIAlertAction *action))handler
                          doButtonTitle:(nullable NSString *)doButtonTitle
                              doHandler:(void (^ __nullable)(UIAlertAction *action))doHandler
{
//    NSString *aTitle = title?NSLocalizedString(title, nil):nil;
//    NSString *aMessage = message?NSLocalizedString(message, nil):nil;
//    NSString *aCancelButtonTitle = cancelButtonTitle?NSLocalizedString(cancelButtonTitle, nil):nil;
//    NSString *aDoButtonTitle =doButtonTitle?NSLocalizedString(doButtonTitle, nil):nil;
    
    NSString *aTitle = title;
    NSString *aMessage = message;
    NSString *aCancelButtonTitle = cancelButtonTitle;
    NSString *aDoButtonTitle =doButtonTitle;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:aTitle message:aMessage preferredStyle:UIAlertControllerStyleAlert];
    
    if (cancelButtonTitle.length >0)
    {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:aCancelButtonTitle style:UIAlertActionStyleCancel handler:handler];
        [alertController addAction:cancelAction];
    }
    if (doButtonTitle.length>0)
    {
        UIAlertAction *doAction = [UIAlertAction actionWithTitle:aDoButtonTitle style:UIAlertActionStyleDefault handler:doHandler];
        [alertController addAction:doAction];
    }
    [viewController presentViewController:alertController animated:YES completion:nil];
    return alertController;
}






+ (instancetype)showInViewController:(UIViewController *)viewController
                                withTitle:(nullable NSString *)title
                                  message:(nullable NSString *)message
                           preferredStyle:(UIAlertControllerStyle)preferredStyle
                        cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                   destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                        otherButtonTitles:(nullable NSArray *)otherButtonTitles
       popoverPresentationControllerBlock:(nullable UIAlertControllerPopoverPresentationControllerBlock)popoverPresentationControllerBlock
                                 tapBlock:(nullable UIAlertControllerCompletionBlock)tapBlock
{
    // 注意：如果错误使用NSLocalizedString(nil, nil),UI会展示错误，title以@“”处理，顶部留空白；
//    NSString *aTitle = title?NSLocalizedString(title, nil):nil;
//    NSString *aMessage = message?NSLocalizedString(message, nil):nil;
//    NSString *aCancelButtonTitle = cancelButtonTitle?NSLocalizedString(cancelButtonTitle, nil):nil;
//    NSString *aDestructiveButtonTitle = destructiveButtonTitle?NSLocalizedString(destructiveButtonTitle, nil):nil;
    
    NSString *aTitle = title;
    NSString *aMessage = message;
    NSString *aCancelButtonTitle = cancelButtonTitle;
    NSString *aDestructiveButtonTitle = destructiveButtonTitle;

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:aTitle message:aMessage preferredStyle:preferredStyle];
    
    if (aCancelButtonTitle.length>0)
    {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:aCancelButtonTitle
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action){
                                                                    if (tapBlock)
                                                                    {
                                                                        tapBlock(alertController,action,UIAlertControllerBlocksCancelButtonIndex);
                                                                    }
                                                             }];
        [alertController addAction:cancelAction];
 
    }
    if (aDestructiveButtonTitle.length>0)
    {
        UIAlertAction *destructionAction = [UIAlertAction actionWithTitle:aDestructiveButtonTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            if (tapBlock) {
                tapBlock(alertController,action,UIAlertControllerBlocksDestructiveButtonIndex);
            }
        }];
        [alertController addAction:destructionAction];
    }
    if (otherButtonTitles.count>0)
    {
        for(NSUInteger i=0; i<otherButtonTitles.count;i++)
        {
            NSString *otherButtonTitle = otherButtonTitles[i];
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction *action){
                                                                    if (tapBlock) {
                                                                        tapBlock(alertController, action, UIAlertControllerBlocksFirstOtherButtonIndex + i);
                                                                    }
                                                                }];
            [alertController addAction:otherAction];

        }
    }
    
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(queue, ^{
//        
//        dispatch_apply(otherButtonTitles.count, queue, ^(size_t size) {
//            
//            
//            NSString *otherButtonTitle = otherButtonTitles[size];
//            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle
//                                                                  style:UIAlertActionStyleDefault
//                                                                handler:^(UIAlertAction *action){
//                                                                    if (tapBlock) {
//                                                                        tapBlock(alertController, action, UIAlertControllerBlocksFirstOtherButtonIndex + size);
//                                                                    }
//                                                                }];
//            [alertController addAction:otherAction];
//        });
//        
//    });

    if (popoverPresentationControllerBlock) {
        popoverPresentationControllerBlock(alertController.popoverPresentationController);
    }

    [viewController presentViewController:alertController animated:YES completion:nil];

    return alertController;

}





+ (instancetype)zx_presentCustomAlertInViewController:(UIViewController *)viewController
                                      withTitle:(nullable NSString *)title
                                        message:(nullable NSString *)message
                              cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                         destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                              otherButtonTitles:(nullable NSArray *)otherButtonTitles
                                       tapBlock:(nullable UIAlertControllerCompletionBlock)tapBlock
{
    return [self showInViewController:viewController
                            withTitle:title
                              message:message
                       preferredStyle:UIAlertControllerStyleAlert
                    cancelButtonTitle:cancelButtonTitle
               destructiveButtonTitle:destructiveButtonTitle
                    otherButtonTitles:otherButtonTitles
   popoverPresentationControllerBlock:nil
                             tapBlock:tapBlock];
}




+ (instancetype)zx_presentActionSheetInViewController:(UIViewController *)viewController
                                            withTitle:(nullable NSString *)title
                                              message:(nullable NSString *)message
                                    cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                               destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                    otherButtonTitles:(nullable NSArray *)otherButtonTitles
                                             tapBlock:(nullable UIAlertControllerCompletionBlock)tapBlock
{
    return [self zx_presentActionSheetInViewController:viewController
                                       withTitle:title
                                         message:message
                               cancelButtonTitle:cancelButtonTitle
                          destructiveButtonTitle:destructiveButtonTitle
                               otherButtonTitles:otherButtonTitles
              popoverPresentationControllerBlock:nil
                                        tapBlock:tapBlock];
}


+ (instancetype)zx_presentActionSheetInViewController:(UIViewController *)viewController
                                      withTitle:(nullable NSString *)title
                                        message:(nullable NSString *)message
                              cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                         destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                              otherButtonTitles:(nullable NSArray *)otherButtonTitles
             popoverPresentationControllerBlock:(void(^)(UIPopoverPresentationController *popover))popoverPresentationControllerBlock
                                       tapBlock:(nullable UIAlertControllerCompletionBlock)tapBlock
{
    return [self showInViewController:viewController
                            withTitle:title
                              message:message
                       preferredStyle:UIAlertControllerStyleActionSheet
                    cancelButtonTitle:cancelButtonTitle
               destructiveButtonTitle:destructiveButtonTitle
                    otherButtonTitles:otherButtonTitles
   popoverPresentationControllerBlock:popoverPresentationControllerBlock
                             tapBlock:tapBlock];
}

- (void)setAlertViewPreferredActionWithTitle:(NSString *)prefreredTitle
{
    if (self.preferredStyle == UIAlertControllerStyleAlert)
    {
        WS(weakSelf);
        [self.actions enumerateObjectsUsingBlock:^(UIAlertAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj.title isEqualToString:prefreredTitle])
            {
                weakSelf.preferredAction = obj;
            }
        }];
    }
  
}

#pragma mark - 属性

- (NSInteger)cancelButtonIndex
{
    return UIAlertControllerBlocksCancelButtonIndex;
}

- (NSInteger)firstOtherButtonIndex
{
    return UIAlertControllerBlocksFirstOtherButtonIndex;
}

- (NSInteger)destructiveButtonIndex
{
    return UIAlertControllerBlocksDestructiveButtonIndex;
}

@end
