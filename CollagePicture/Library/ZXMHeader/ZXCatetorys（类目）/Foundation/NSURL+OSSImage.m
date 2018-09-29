//
//  NSURL+OSSImage.m
//  CollagePicture
//
//  Created by 朱新明 on 16/10/21.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "NSURL+OSSImage.h"

@implementation NSURL (OSSImage)

//+ (NSURL *)ossImageWithStyleType:(OSSImageStyle)style relativeToImgPath:(NSString *)baseString
//{
////    NSString * imgString = [baseString stringByReplacingOccurrencesOfString:host withString:imageHost];
//    NSString *processStr =[baseString stringByAppendingString:@"?x-oss-process=style/"];
//    switch (style)
//    {
//        case OSSImageStyle_w600_hX:
//            return [NSURL URLWithString:[processStr stringByAppendingString:@"w600_hX"]];
//            break;
//            
//        default:
//            break;
//    }
//    return [NSURL URLWithString:baseString];
//}


+ (NSURL *)ossImageWithResizeType:(OSSImageResizeType)resizeType relativeToImgPath:(id)baseURL
{
    NSString *baseString = nil;
    if ([baseURL isKindOfClass:[NSURL class]])
    {
        baseString = [[baseURL absoluteString] copy];
    }
    else
    {
        baseString = [baseURL copy];
    }
    NSString *processStr =[baseString stringByAppendingString:@"?x-oss-process=image/resize,"];
    switch (resizeType)
    {


        case OSSImageResizeType_w600_hX:
            return [NSURL URLWithString:[processStr stringByAppendingString:@"w_600"]];
            break;

        case OSSImageResizeType_w700_hX:
            return [NSURL URLWithString:[processStr stringByAppendingString:@"w_700"]];
            break;
        case OSSImageResizeType_w414_hX:
            return  [NSURL URLWithString:[processStr stringByAppendingString:@"w_414"]];
            break;
        case OSSImageResizeType_w828_hX:
            return [NSURL URLWithString:[processStr stringByAppendingString:@"w_828"]];
            break;
        case OSSImageResizeType_w100_hX:
            return [NSURL URLWithString:[processStr stringByAppendingString:@"w_100"]];
            break;
        case OSSImageResizeType_w200_hX:
            return [NSURL URLWithString:[processStr stringByAppendingString:@"w_200"]];
            break;
        case OSSImageResizeType_w300_hX:
            return [NSURL URLWithString:[processStr stringByAppendingString:@"w_300"]];
            break;
        default:
            break;
    }
    return [NSURL URLWithString:baseString];
}
@end
