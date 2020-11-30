//
//  UserModel.m
//  
//
//  Created by simon on 15/6/25.
//  Copyright (c) 2015年 sina. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"userId" : @"userid",
             @"userName" : @"username",
             @"sex" : @"sex",
             @"phone":@"phone",
             @"headURL":@"headIcon",
             @"province":@"pro",
             @"authStatus":@"authStatus",
             @"city":@"city",
             @"autograph":@"autograph",
             @"bindWechat":@"bindWechat",
             @"needSetPwd":@"needSetPwd",
             @"QQ":@"qq"
             };
}



//- (UIImage *)getSexImageWithBoyImageName:(NSString *)boyImageName girlImageName:(NSString *)girlImageName defaultSexImgName:(NSString *)defultName
//{
//    if ([self.sex integerValue]==1)
//    {
//        return [UIImage imageNamed:boyImageName];
//    }
//    if ([self.sex integerValue]==2)
//    {
//        return [UIImage imageNamed:girlImageName]; 
//    }
//    return [UIImage imageNamed:defultName];
//}
@end

