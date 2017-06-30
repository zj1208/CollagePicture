//
//  HLIssueSelectedViewController.h
//  HappyLottery
//
//  Created by 蔡叶超 on 6/28/17.
//  Copyright © 2017 cyc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLIssueSelectedViewController : UIViewController

@property (copy, nonatomic) void (^selectedBlock)(NSInteger index);
@end
