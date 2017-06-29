//
//  ZXBadgeIconButton.h
//  YiShangbao
//
//  Created by simon on 17/6/19.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXBadgeIconButton : UIControl

//设置badgeValue值
@property (nonatomic, assign)NSInteger badgeValue;

//角标label对象
@property (nonatomic, readonly)UILabel *badgeLabel;

/**
 设置角标的外观静态设置

 @param aMaginY 数字的上下边距
 @param font 角标字体大小
 @param aTitleColor 角标的数字颜色
 @param aBgColor 角标的背景颜色
 */
- (void)maginY:(CGFloat)aMaginY badgeFont:(nullable UIFont *)font badgeTitleColor:(nullable UIColor *)aTitleColor badgeBackgroundColor:(nullable UIColor*)aBgColor;


//设置图标的静态图片
- (void)setImage:(UIImage *)image;

@end


NS_ASSUME_NONNULL_END


////使用
/*
@property (weak, nonatomic) IBOutlet ZXBadgeIconButton *messageBadgeButton;


- (void)setUI{
    
    [_messageBadgeButton setImage:[UIImage imageNamed:@"icon_meassage_white"]];
    [_messageBadgeButton maginY:2.5f badgeFont:[UIFont systemFontOfSize:12] badgeTitleColor:[UIColor orangeColor] badgeBackgroundColor:[UIColor whiteColor]];
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
