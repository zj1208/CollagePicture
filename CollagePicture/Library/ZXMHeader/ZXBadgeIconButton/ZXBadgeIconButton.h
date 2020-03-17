//
//  ZXBadgeIconButton.h
//  YiShangbao
//
//  Created by simon on 17/6/19.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  简介：根据image图片大小，右上角设置badgeLabel；父类必须是UIButton，不然会有问题；
//  注意：目前待优化，无法用系统UIButton的方法设置图片；

// 2018.1.23  新增 badgeLabel相对偏移；默认向image大小左偏移12，上对齐；
// 2018.4.19  修改文字绘画选项；
// 2019.10.29 适配Xcode11，父类一定要UIButton才能在sb上的button修改父类；
// 2020.03.06 新增设置角标边框宽度，边框颜色；

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXBadgeIconButton : UIButton

// 设置badgeValue值
@property (nonatomic, assign) NSInteger badgeValue;



/// badgeLabel相对偏移,默认CGPointMake(0, 0)，表示向image图标左偏移12,上对齐；图标显示不同，偏移量调整是不同的，所以这个值是根据图标调整的；
@property (nonatomic, assign) CGPoint badgeLabelContentOffest;

/// 角标边框宽度
@property (nonatomic, assign) CGFloat badgeBorderWidth;

/// 角标边框颜色
@property (nonatomic, strong) UIColor *badgeBorderColor;

/// 设置图标的静态图片
- (void)setImage:(UIImage *)image;

/**
 设置角标的外观静态设置
 
 @param aTitleColor 角标的数字颜色
 @param aBgColor 角标的背景颜色
 */
- (void)setBadgeTitleColor:(nullable UIColor *)aTitleColor badgeBackgroundColor:(nullable UIColor*)aBgColor;

/**
 设置角标间距，字体大小

 @param aMaginY 间距
 @param font 字体大小
 */
- (void)setBadgeContentInsetY:(CGFloat)aMaginY badgeFont:(nullable UIFont *)font;


@end


NS_ASSUME_NONNULL_END


////使用
/*
  //方式一：Storyboard
@property (weak, nonatomic) IBOutlet ZXBadgeIconButton *messageBadgeButton;


- (void)setBadgeButton{
 
    [self.carBtn setImage:[UIImage imageNamed:@"icon_car"]];
    [self.carBtn setBadgeContentInsetY:2.f badgeFont:[UIFont systemFontOfSize:11]];
    self.carBtn.badgeLabelContentOffest = CGPointMake(0, -5);
}
 //方式二：纯代码
 - (ZXBadgeIconButton *)messageBadgeButton
 {
     if (!_messageBadgeButton) {
          _messageBadgeButton = [[ZXBadgeIconButton alloc] init];
          _messageBadgeButton.frame = CGRectMake(0, 0, 40, 44);
          [_messageBadgeButton setImage:[UIImage imageNamed:@"icon_meassage_white"]];
          [_messageBadgeButton setBadgeContentInsetY:2.f badgeFont:[UIFont systemFontOfSize:11]];
         [_messageBadgeButton addTarget:self action:@selector(messageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
     }
     return _messageBadgeButton
 }

 #pragma mark - action
 -(void)messageBtnAction:(UIButton *)sender{
 
    if ([self zh_performIsLoginActionWithPopAlertView:NO])
    {
        [MobClick event:kUM_message];
 
        WYMessageListViewController * messageList =[[WYMessageListViewController alloc]init];
        messageList.hidesBottomBarWhenPushed= YES;
        [self.navigationController pushViewController:messageList animated:YES];
    }
}

#pragma mark - 消息请求
//每次出现页面都得去请求检查

- (void)requestMessageInfo
{
    
    if (![UserInfoUDManager isLogin])
    {
        [self.messageBadgeButton setBadgeValue:0];
        return;
    }
    WS(weakSelf);
    [[[AppAPIHelper shareInstance] messageAPI] getshowMsgCountWithsuccess:^(id data) {
        
        NSNumber *system = [data objectForKey:@"system"];
        NSNumber *antsteam = [data objectForKey:@"antsteam"];
        NSNumber *market =  [data objectForKey:@"market"];
        if (system.integerValue || antsteam.integerValue || market.integerValue) {
            
            NSInteger total =[system integerValue]+[antsteam integerValue]+[market integerValue];
            NSInteger value = [[[NIMSDK sharedSDK]conversationManager]allUnreadCount];
            [weakSelf.messageBadgeButton setBadgeValue:(value+total)];
            
            
        }else{
            if ([[[NIMSDK sharedSDK]conversationManager]allUnreadCount]>0)
            {
                NSInteger value = [[[NIMSDK sharedSDK]conversationManager]allUnreadCount];
                [weakSelf.messageBadgeButton setBadgeValue:value];
            }
        }
    } failure:^(NSError *error) {
        
        if ([[[NIMSDK sharedSDK]conversationManager]allUnreadCount]>0)
        {
            NSInteger value = [[[NIMSDK sharedSDK]conversationManager]allUnreadCount];
            [weakSelf.messageBadgeButton setBadgeValue:value];
        }
        
    }];
    
}

*/
