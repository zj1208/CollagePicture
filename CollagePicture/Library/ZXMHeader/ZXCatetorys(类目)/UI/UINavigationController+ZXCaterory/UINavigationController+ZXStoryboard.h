//
//  UINavigationController+ZXStoryboard.h
//  MobileCaiLocal
//
//  Created by simon on 2019/12/12.
//  Copyright © 2019 com.Chs. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (ZXStoryboard)

/**
 *  storyboard跳转-push
 *
 *  @param name  storyboardName
 *  @param storyboardId  storyboardID
 *  @param data  参数－dictionary格式
 */
- (void)zx_pushStoryboardViewControllerWithStoryboardName:(NSString *)name identifier:(nullable NSString *)storyboardId withData:(nullable NSDictionary *)data;



/**
 同上 storyboard跳转-push；

 @param name storyboardName
 @param storyboardId storyboardID
 @param data 参数－dictionary格式;kvc传值；
 @param toControllerBlock 返回目标controller
 */
- (void)zx_pushStoryboardViewControllerWithStoryboardName:(NSString *)name identifier:(nullable NSString *)storyboardId withData:(nullable NSDictionary *)data toController:(void(^ __nullable)(UIViewController *vc))toControllerBlock;

@end

NS_ASSUME_NONNULL_END
