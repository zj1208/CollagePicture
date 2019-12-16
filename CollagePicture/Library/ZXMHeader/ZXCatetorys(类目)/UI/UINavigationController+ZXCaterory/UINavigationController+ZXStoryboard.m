//
//  UINavigationController+ZXStoryboard.m
//  MobileCaiLocal
//
//  Created by simon on 2019/12/12.
//  Copyright © 2019 com.Chs. All rights reserved.
//

#import "UINavigationController+ZXStoryboard.h"



@implementation UINavigationController (ZXStoryboard)


- (void)zx_pushStoryboardViewControllerWithStoryboardName:(NSString *)name identifier:(nullable NSString *)storyboardId withData:(nullable NSDictionary *)data
{
    UIViewController *controller = [self zx_getControllerWithStoryboardName:name controllerWithIdentifier:storyboardId];
    if (controller)
    {
        if (data)
        {
            [data enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                
                [controller setValue:obj forKey:key];
            }];
        }
        controller.hidesBottomBarWhenPushed = YES;
        [self pushViewController:controller animated:YES];
    }
}


- (void)zx_pushStoryboardViewControllerWithStoryboardName:(NSString *)name identifier:(nullable NSString *)storyboardId withData:(NSDictionary *)data toController:(void(^ __nullable)(UIViewController *vc))toControllerBlock
{
    UIViewController *controller = [self zx_getControllerWithStoryboardName:name controllerWithIdentifier:storyboardId];
    if (toControllerBlock)
    {
        toControllerBlock(controller);
    }
    [self zx_pushStoryboardViewControllerWithStoryboardName:name identifier:storyboardId withData:data];
}

@end
