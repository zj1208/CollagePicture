//
//  UIAlertController+ZXCategory.m
//  YiShangbao
//
//  Created by simon on 17/6/27.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "UIAlertController+ZXCategory.h"


static NSInteger const UIAlertControllerBlocksCancelButtonIndex = 0;
static NSInteger const UIAlertControllerBlocksDestructiveButtonIndex = 1;
static NSInteger const UIAlertControllerBlocksFirstOtherButtonIndex = 2;

@implementation UIAlertController (ZXCategory)



+ (instancetype)zx_presentGeneralAlertInViewController:(UIViewController *)viewController
                              withTitle:(nullable NSString *)title
                                message:(nullable NSString *)message
                      cancelButtonTitle:(nullable NSString *)cancelButtonTitle cancleHandler:(void (^ __nullable)(UIAlertAction *action))handler
                          doButtonTitle:(nullable NSString *)doButtonTitle
                              doHandler:(void (^ __nullable)(UIAlertAction *action))doHandler
{
    // 如果key为nil, value为nil，则NSLocalizedString返回一个空字符串@"";<object returned empty description>;
   //  Message：描述语，默认常规大小字体。如果title=nil，则message会变成标题，加粗字体。
   //  如果想让message必须保持常规字体，则title使用字符串空@“”，让message保持副标题。
    if (!title && message) {
        title = NSLocalizedString(title, nil);
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    #if TARGET_OS_IOS || TARGET_OS_WATCH
    #endif
    if (cancelButtonTitle.length >0)
    {
        //UIAlertAction的title参数不能为nil，会奔溃；
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(cancelButtonTitle, @"Cancel") style:UIAlertActionStyleCancel handler:handler];
        [alertController addAction:cancelAction];
    }
    if (doButtonTitle.length>0)
    {
        UIAlertAction *doAction = [UIAlertAction actionWithTitle:NSLocalizedString(doButtonTitle, @"OK") style:UIAlertActionStyleDefault handler:doHandler];
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
//    (1)UIAlertControllerStyleActionSheet样式：如果title，message用@"",则actionSheet会添加各自的label，并且各自会占UI一个有效大小位置，但是内容是@""；
//  (2)如果使用NSLocalizedString(nil, nil),会返回@“”;
    if (preferredStyle == UIAlertControllerStyleAlert) {
        if (!title && message) {
            title = NSLocalizedString(title, nil);
        }
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    
    if (cancelButtonTitle.length>0)
    {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action){
                                                                    if (tapBlock)
                                                                    {
                                                                        tapBlock(alertController,action,UIAlertControllerBlocksCancelButtonIndex);
                                                                    }
                                                             }];
        [alertController addAction:cancelAction];
 
    }
    if (destructiveButtonTitle.length>0)
    {
        UIAlertAction *destructionAction = [UIAlertAction actionWithTitle:destructiveButtonTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
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
            if (otherButtonTitle.length >0) {
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
        __weak __typeof(&*self)weakSelf = self;
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
