//
//  FullTextViewController.h
//  CollagePicture
//
//  Created by 朱新明 on 16/12/20.
//  Copyright © 2016年 simon. All rights reserved.
//

//主要用于显示用户协议等本地文件文本用的
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface FullTextViewController : UIViewController


- (instancetype)initWithBarTitle:(nullable NSString *)aTitle;


//@"test.wps" :@"application/msword"
- (void)loadTextPathOfResource:(nullable NSString *)name ofType:(nullable NSString *)ext;



/**
 加载本地指定用户服务协议文件：UserServiceAgreement.txt;可以替换公司名，app名字；

 @param company 公司名
 @param aAppName app名
 */
- (void)loadLocalUserServiceAgreementOfFixResourceWithCompany:(nullable NSString *)company appName:(nullable NSString *)aAppName;


@end

NS_ASSUME_NONNULL_END

/**

 - (IBAction)userAgreementAction:(UIButton *)sender {
 
 FullTextViewController *textViewVC = [[FullTextViewController alloc] initWithBarTitle:@"用户服务协议"];
 [textViewVC loadTextPathOfResource:@"UserServiceAgreement" ofType:@"txt"];
 [self.navigationController pushViewController:textViewVC animated:YES];
 }
*/
