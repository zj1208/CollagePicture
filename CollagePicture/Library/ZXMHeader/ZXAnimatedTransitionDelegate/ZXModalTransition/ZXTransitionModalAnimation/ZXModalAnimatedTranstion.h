//
//  ZXModalAnimatedTranstion.h
//  ZXControllerTransition
//
//  Created by simon on 15/11/10.
//  Copyright © 2015年 zhuxinming. All rights reserved.
//
//  简介：出现动画：从上往下移动的弹簧动画出现；消失动画：alpha=0，scale=0过渡 ；
//  2018.8.07  优化代码；

#import "ZXBaseAnimator.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXModalAnimatedTranstion : ZXBaseAnimator

// 设置整个控制器view的大小；比如弹框中整个就是controller的view；
@property (nonatomic, assign) CGSize contentSize;


@end

NS_ASSUME_NONNULL_END

/*
- (void)requestFirstLogin
{
    self.ZXModalAnimatedTranstion = [[ZXModalAnimatedTranstion alloc] init];
    
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
    self.ZXModalAnimatedTranstion.type = ZXAnimationTypePresent;
    return self.ZXModalAnimatedTranstion;
}

- (nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.ZXModalAnimatedTranstion.type = ZXAnimationTypeDismiss;
    return self.ZXModalAnimatedTranstion;
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

