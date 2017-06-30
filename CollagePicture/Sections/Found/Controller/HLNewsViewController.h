//
//  HLNewsViewController.h
//  HappyLottery
//
//  Created by 蔡叶超 on 6/27/17.
//  Copyright © 2017 cyc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLNewsViewController : UIViewController


@property (copy, nonatomic) void (^selectedBlock) (HLNewsViewController *vc, NSInteger selectIndex);


@property (copy, nonatomic) NSString *newsName;

@end
