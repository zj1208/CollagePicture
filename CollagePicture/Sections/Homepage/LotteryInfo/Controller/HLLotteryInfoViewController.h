//
//  HLLotteryInfoViewController.h
//  CollagePicture
//
//  Created by 蔡叶超 on 6/29/17.
//  Copyright © 2017 simon. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    _3D,
    _11xuan5,
    _daletou,
    _shuangseqiu
} LotteryCategory;


@interface HLLotteryInfoViewController : UIViewController

@property (assign, nonatomic) LotteryCategory category;

@end
