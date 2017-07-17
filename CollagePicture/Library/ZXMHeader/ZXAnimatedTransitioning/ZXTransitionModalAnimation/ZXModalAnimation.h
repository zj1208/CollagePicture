//
//  ZXModalAnimation.h
//  ZXControllerTransition
//
//  Created by simon on 15/11/10.
//  Copyright © 2015年 zhuxinming. All rights reserved.
//

#import "ZXBaseAnimation.h"

@interface ZXModalAnimation : ZXBaseAnimation

@end



/*
- (void)requestFirstLogin
{
    self.ZXModalAnimation = [[ZXModalAnimation alloc] init];
    
    UserModel *model1 = [[UserModel alloc] init];
    [model1 getFirstLoginResourceWithSuccess:^(id object) {
        
        BOOL isFirst4day = [[object objectForKey:@"isFirst4day"]boolValue];
        //        if (isFirst4day)
        //        {
        [self firstLogin];
        //        }
        
    } faile:^(id object) {
        
        [SVProgressHUD showErrorWithStatus:[object localizedDescription]];
    }];
    
}


#pragma mark-UIViewControllerTransitionDelegate

- (nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.ZXModalAnimation.type = ZXAnimationTypePresent;
    return self.ZXModalAnimation;
}

- (nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.ZXModalAnimation.type = ZXAnimationTypeDismiss;
    return self.ZXModalAnimation;
}

- (void)firstLogin
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"RegisterLogin" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ModalControllerID"];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.transitioningDelegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

*/

