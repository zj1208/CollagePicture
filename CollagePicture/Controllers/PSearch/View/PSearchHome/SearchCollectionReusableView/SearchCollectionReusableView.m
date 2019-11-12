//
//  SearchCollectionReusableView.m
//  CollagePicture
//
//  Created by 朱新明 on 2019/10/24.
//  Copyright © 2019 simon. All rights reserved.
//

#import "SearchCollectionReusableView.h"

@implementation SearchCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLab.textColor = [UIColor zx_colorWithHexString:@"34373A"];
}

@end
