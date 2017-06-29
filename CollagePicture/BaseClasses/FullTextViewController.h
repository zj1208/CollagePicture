//
//  FullTextViewController.h
//  CollagePicture
//
//  Created by 朱新明 on 16/12/20.
//  Copyright © 2016年 simon. All rights reserved.
//

//主要用于显示用户协议等本地文件文本用的
#import <UIKit/UIKit.h>

@interface FullTextViewController : UIViewController

- (instancetype)initWithBarTitle:(NSString *)aTitle;


//@"test.wps" :@"application/msword"
- (void)loadTextPathOfResource:(NSString *)name ofType:(NSString *)ext;

//加载用户服务协议  资源名， 公司名，app名
- (void)loadUserServiceAgreementPathOfResource:(NSString *)name ofType:(NSString *)ext company:(NSString *)company appName:(NSString *)aAppName;
@end



/**

 - (IBAction)userAgreementAction:(UIButton *)sender {
 
 FullTextViewController *textViewVC = [[FullTextViewController alloc] initWithBarTitle:@"用户服务协议"];
 [textViewVC loadTextPathOfResource:@"UserServiceAgreement" ofType:@"txt"];
 [self.navigationController pushViewController:textViewVC animated:YES];
 }
*/
