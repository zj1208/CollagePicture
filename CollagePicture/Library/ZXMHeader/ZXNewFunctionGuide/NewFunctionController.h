//
//  NewFunctionController.h
//  lovebaby
//
//  Created by simon on 16/6/12.
//  Copyright © 2016年 . All rights reserved.
//
//新功能引导页
#import <UIKit/UIKit.h>

@protocol NewFunctionActionDelegate <NSObject>

@required
//导入照片
- (void)zxNewFuntionGuideControllerAction;

@end



@interface NewFunctionController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *promptBtn;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImgView;
@property (weak, nonatomic) IBOutlet UIImageView *textImgView;

//不再提示
- (IBAction)noPromptAction:(UIButton *)sender;
//上传
- (IBAction)uploadBtnAction:(UIButton *)sender;


@property (nonatomic, weak) id<NewFunctionActionDelegate>delegate;
@end
