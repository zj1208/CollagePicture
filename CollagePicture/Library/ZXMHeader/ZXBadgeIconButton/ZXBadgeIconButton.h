//
//  ZXBadgeIconButton.h
//  YiShangbao
//
//  Created by simon on 17/6/19.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  根据image图片大小，右上角设置badgeLabel；

// 2018.1.23 新增 badgeLabel相对偏移；默认向image大小左偏移12，上对齐；
// 2018.4.19 修改文字绘画选项；

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXBadgeIconButton : UIControl

// 设置badgeValue值
@property (nonatomic, assign) NSInteger badgeValue;

// 角标label对象
@property (nonatomic, readonly) UILabel *badgeLabel;

// 新增 badgeLabel相对偏移；默认向image大小左偏移12，上对齐；
@property (nonatomic, assign) CGPoint badgeLabelContentOffest;

// 设置图标的静态图片
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
@property (weak, nonatomic) IBOutlet ZXBadgeIconButton *messageBadgeButton;


- (void)setUI{
 
    _messageBadgeButton = [[ZXBadgeIconButton alloc] init];
    _messageBadgeButton.frame = CGRectMake(0, 0, 40, 44);
    [_messageBadgeButton setImage:[UIImage imageNamed:@"icon_meassage_white"]];
    [_messageBadgeButton setBadgeContentInsetY:2.f badgeFont:[UIFont systemFontOfSize:11]];
    [_messageBadgeButton addTarget:self action:@selector(messageBtnAction) forControlEvents:UIControlEventTouchUpInside];

}

 #pragma mark - action
 -(void)messageBtnAction{
 
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
        [_messageBadgeButton setBadgeValue:0];
        return;
    }
    [[[AppAPIHelper shareInstance] messageAPI] getshowMsgCountWithsuccess:^(id data) {
        
        NSLog(@"%@",data);
        NSNumber *system = [data objectForKey:@"system"];
        NSNumber *antsteam = [data objectForKey:@"antsteam"];
        NSNumber *market =  [data objectForKey:@"market"];
        if (system.integerValue || antsteam.integerValue || market.integerValue) {
            
            NSInteger total =[system integerValue]+[antsteam integerValue]+[market integerValue];
            NSLog(@"system=%ld,antsteam=%ld,market=%ld,total=%ld",[system integerValue],[antsteam integerValue],[market integerValue],total);
            NSInteger value = [[[NIMSDK sharedSDK]conversationManager]allUnreadCount];
            [_messageBadgeButton setBadgeValue:(value+total)];
            
            
        }else{
            if ([[[NIMSDK sharedSDK]conversationManager]allUnreadCount]>0)
            {
                NSInteger value = [[[NIMSDK sharedSDK]conversationManager]allUnreadCount];
                [_messageBadgeButton setBadgeValue:value];
            }
        }
    } failure:^(NSError *error) {
        
        if ([[[NIMSDK sharedSDK]conversationManager]allUnreadCount]>0)
        {
            NSInteger value = [[[NIMSDK sharedSDK]conversationManager]allUnreadCount];
            [_messageBadgeButton setBadgeValue:value];
        }
        
    }];
    
}

*/
