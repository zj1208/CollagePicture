//
//  ZXAddPicCellLayoutConfig.m
//  YiShangbao
//
//  Created by simon on 2018/4/18.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "ZXAddPicCellLayoutConfig.h"
@implementation ZXAddPicCellLayoutConfig

- (CGSize)contentSize:(ZXPhoto *)model cellWidth:(CGFloat)cellWidth{
    
    return CGSizeMake(80, 80);
//    id<NIMSessionContentConfig>config = [[NIMSessionContentConfigFactory sharedFacotry] configBy:model.message];
//    return [config contentSize:cellWidth message:model.message];
}

- (NSString *)cellContent:(ZXPhoto *)model
{
    return @"ZXAddPicBaseContentView";
//    id<ZXAddPicCellLayoutConfigSource>config =self;
//    NSString *cellContent = [config cellContent:model];
//    return cellContent.length ? cellContent : @"UnknowContentView";
}
@end
