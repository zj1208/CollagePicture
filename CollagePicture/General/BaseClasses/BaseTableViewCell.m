//
//  BaseTableViewCell.m
//  Baby
//
//  Created by simon on 16/1/22.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(id)data
{
    
}

- (void)setData:(id)data withIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)setTextLab:(id)data1  detailLab:(id)data2
{
    
}
- (CGFloat)getCellHeightWithContentData:(id)data{
    return 0.f;
    
}


/**
 根据indexPath和data 数据（可以是dataArray或model）计算高度
 
 @param indexPath indexPath
 @param data data数据
 @return 计算的高度
 */
- (CGFloat)getCellHeightWithContentIndexPath:(NSIndexPath *)indexPath data:(id)data
{
    return 0.f;
}


@end
