//
//  BaseCollectionViewCell.m
//  Baby
//
//  Created by simon on 16/1/18.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "BaseCollectionViewCell.h"

@implementation BaseCollectionViewCell

// 重写方法，继承它的子类调用super方法执行才会调用父类的方法；
- (void)awakeFromNib
{
    [super awakeFromNib];
}
 - (void)setData:(id)data
{
    
}

- (void)setData:(id)data withIndexPath:(NSIndexPath *)indexPath
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
