//
//  HKVersionAlertView.h
//  测试demo
//
//  Created by 何可 on 2017/4/12.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ButtonBlock)(void);

@interface HKVersionAlertView : UIView
{
    UIView *_coverView;                 //覆盖背景
    UIView *_alertView;                 //提醒背景视图
    UIImageView *_imageView;            //版本更新视图
    UILabel *_labelVersion;             //版本号视图
    UILabel *_labelMessage;             //内容
    
    UIButton *_confirmButton;           //确认按钮
    UIButton *_closeButton;             //关闭按钮
    
    NSString *_version;                 //版本号
    NSString *_message;                 //内容
    BOOL _closeBool;
}

-(instancetype)initWithMessage:(NSString *)message version:(NSString *)version closeButton:(BOOL)close;//判断有无关闭按钮
-(void)addConfirmButton:(ButtonBlock)buttonAction;
-(void)addCloseButton:(ButtonBlock)buttonAction;

-(void)show;
-(void)dismiss;
@end
