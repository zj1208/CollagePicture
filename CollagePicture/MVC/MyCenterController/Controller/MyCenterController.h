//
//  MyCenterController.h
//  Baby
//
//  Created by simon on 16/1/14.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCenterController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;

@property (weak, nonatomic) IBOutlet UILabel *signatureLab;

@property (weak, nonatomic) IBOutlet UIButton *loginInBtn;

//@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
//@property (weak, nonatomic) IBOutlet UIButton *orderIconBtn;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)pushMyInfomation:(UIButton *)sender;

//@property (weak, nonatomic) IBOutlet HeaderView *headerView;

- (IBAction)loginInActioin:(UIButton *)sender;


@end
