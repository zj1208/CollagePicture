//
//  ZXNotiAlertViewController.h
//  YiShangbao
//
//  Created by simon on 2017/8/5.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXNotiAlertViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *containerView;
//void(^photoModelItemViewBlock)(UIView* itemView);
@property (nonatomic, copy) void (^cancleActionHandleBlock)(void);
@property (nonatomic, copy) void (^doActionHandleBlock)(void);


- (IBAction)cancleBtnAction:(UIButton *)sender;

- (IBAction)doBtnAction:(UIButton *)sender;

@end
