//
//  ZXCollectionReusableTitleView.m
//  MobileCaiLocal
//
//  Created by 朱新明 on 2019/11/4.
//  Copyright © 2019 timtian. All rights reserved.
//

#import "ZXCollectionReusableTitleView.h"

@implementation ZXCollectionReusableTitleView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
    self.titleLabel.textColor = [UIColor colorWithRed:52.f/255 green:52.f/255 blue:58.f/255 alpha:1];
    
}

@end
