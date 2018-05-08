//
//  CustomAddPicLayoutConfig.m
//  YiShangbao
//
//  Created by simon on 2018/5/3.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "CustomAddPicLayoutConfig.h"

@implementation CustomAddPicLayoutConfig

- (CGSize)contentSize:(ZXPhoto *)model cellWidth:(CGFloat)width
{
     return CGSizeMake(80, 80);
}

- (NSString *)cellContent:(ZXPhoto *)model
{
//    if (model.type == ZXAssetModelMediaTypeVideo || model.type == ZXAssetModelMediaTypeCustom)
//    {
        return @"CustomCoverView";
//    }
//    return [super cellContent:model];
}
@end
