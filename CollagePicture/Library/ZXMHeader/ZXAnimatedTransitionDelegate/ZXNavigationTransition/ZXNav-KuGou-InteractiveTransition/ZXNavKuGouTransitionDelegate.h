//
//  ZXNavKuGouTransitionDelegate.h
//  YiShangbao
//
//  Created by simon on 2018/8/14.
//  Copyright © 2018年 com.Microants. All rights reserved.
//
//  简介：系统UINavigationControllerDelegate的转场，如果使用这个，那么导航条必然存在，所以遇到要展现没有导航条的toViewController的view，则不能使用，使用    [self.navigationController setNavigationBarHidden:YES];会有过渡效果问题
//  注意：一旦用了自定义转场，设置了新的navigationControllerDelegate，UINavigationController原先的push，pop的效果需要被动画协议替换；
//  原先的左侧返回手势被交互式转场协议替换，如果不实现，就没有手势返回；在NavgationController的交互式返回效果非常不好，fromViewController的导航条不会移动切换，没有整体区域切换的效果；


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXNavKuGouTransitionDelegate : NSObject<UINavigationControllerDelegate>

@property (nonatomic, strong, nullable) UIPanGestureRecognizer *customInteractivePopGestureRecognizer;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END

/*
@property (nonatomic, strong) ZXNavKuGouTransitionDelegate * navKuGouTransitionDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self setData];
 }

 - (void)setData
 {
    self.navigationController.delegate = self.navKuGouTransitionDelegate;
 }
 
- (ZXNavKuGouTransitionDelegate *)navKuGouTransitionDelegate
{
    if (!_navKuGouTransitionDelegate) {
        _navKuGouTransitionDelegate = [[ZXNavKuGouTransitionDelegate alloc] init];
    }
    return _navKuGouTransitionDelegate;
}
*/
