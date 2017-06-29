//
//  BaseCollectionViewCell.m
//  Baby
//
//  Created by simon on 16/1/18.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "BaseCollectionViewCell.h"

@implementation BaseCollectionViewCell

 - (void)setData:(id)data
{
    
}

- (CGFloat)getCellHeightWithContentData:(id)data{
    return 0.f;
    
}

- (void)setTextLab:(id)data1  detailLab:(id)data2
{
    
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
