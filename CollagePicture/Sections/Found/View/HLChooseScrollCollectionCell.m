//
//  HLChooseScrollCollectionCell.m
//  HappyLottery
//
//  Created by 蔡叶超 on 6/27/17.
//  Copyright © 2017 cyc. All rights reserved.
//

#import "HLChooseScrollCollectionCell.h"

@interface HLChooseScrollCollectionCell()


@end

@implementation HLChooseScrollCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        self.textLabel.textColor = [UIColor redColor];
        [UIView animateWithDuration:0.25 animations:^{
            self.textLabel.transform = CGAffineTransformMakeScale(1.3, 1.3);
        }];
    } else {
        self.textLabel.textColor = [UIColor darkGrayColor];
        [UIView animateWithDuration:0.25 animations:^{
            self.textLabel.transform = CGAffineTransformIdentity;
        }];
        
    }
}

@end
