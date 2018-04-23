//
//  ZXCellLayoutConfig.m
//  YiShangbao
//
//  Created by simon on 2018/4/18.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "ZXCellLayoutConfig.h"
@implementation ZXCellLayoutConfig

- (CGSize)contentSize:(id)model cellWidth:(CGFloat)cellWidth{
    
    return CGSizeMake(80, 80);
//    id<NIMSessionContentConfig>config = [[NIMSessionContentConfigFactory sharedFacotry] configBy:model.message];
//    return [config contentSize:cellWidth message:model.message];
}

- (NSString *)cellContent:(id)model
{
    return @"ZXAddPicViewContentView";
//    id<ZXCellLayoutConfigSource>config =self;
//    NSString *cellContent = [config cellContent:model];
//    return cellContent.length ? cellContent : @"UnknowContentView";
}
@end
