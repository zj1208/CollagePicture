//
//  NSURL+ZXAppLinks.m
//  YiShangbao
//
//  Created by simon on 2018/3/16.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "NSURL+ZXAppLinks.h"

@implementation NSURL (ZXAppLinks)

//+ (NSURL *)appStoreURLforApplicationIdentifier:(NSString *)identifier
//{
//    NSString *link = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%@?mt=8", identifier];
//    
//    return [NSURL URLWithString:link];
//}

+ (NSURL *)appStoreURLForApplicationIdentifier:(NSString *)appId
{
    NSString *link = [NSString stringWithFormat:@"http://itunes.apple.com/cn/app/id%@",appId];
    return [NSURL URLWithString:link];
}


+ (NSURL *)appStoreAppInfomationURLForApplicationIdentifier:(NSString *)appId
{
    NSString *lookup = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",appId];
    return [NSURL URLWithString:lookup];
}
@end
