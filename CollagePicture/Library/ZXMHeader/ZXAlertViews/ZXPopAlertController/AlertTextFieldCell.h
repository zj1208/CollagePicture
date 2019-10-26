//
//  AlertTextFieldCell.h
//  YiShangbao
//
//  Created by simon on 2017/9/21.
//  Copyright © 2017年 com.Microants. All rights reserved.
//  2019.10.26 去除设置圆角的耦合方法；

#import <UIKit/UIKit.h>
#import "ZXPlaceholdTextView.h"

static NSString *nibName_AlertTextFieldCell = @"AlertTextFieldCell";

@interface AlertTextFieldCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIButton *accessoryBtn;
@property (weak, nonatomic) IBOutlet ZXPlaceholdTextView *textView;


@end
