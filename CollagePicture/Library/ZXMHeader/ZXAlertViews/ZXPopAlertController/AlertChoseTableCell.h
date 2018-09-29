//
//  AlertChoseTableCell.h
//  YiShangbao
//
//  Created by simon on 2017/9/21.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *nibName_AlertChoseTableCell = @"AlertChoseTableCell";

@interface AlertChoseTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *accessoryBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

//Accessory
@end
