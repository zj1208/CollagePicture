//
//  UserModelHttp.m
//  douniwan
//
//  Created by lin guohua on 15/6/26.
//  Copyright (c) 2015年 遥望. All rights reserved.
//


#import "UserModelAPI.h"




@implementation UserModelAPI

-(void)getUserBaseInfosuccess:(CompleteBlock)success failure:(ErrorBlock)failure
{
    [self getRequest:kUser_getUserBaseInfo parameters:nil success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
}
//1.1获取手机验证码
- (void)getSendVerifyCodeMobile:(NSString *)mobile countryCode:(NSString *)countryCode type:(NSString *)type success:(CompleteBlock)success failure:(ErrorBlock)failure
{
//    NSDictionary *dict = @{
//                                 kPhone_KEY:mobile,
//                                 kCOUNTRYCODE_KEY:countryCode,
//                                 @"type":type
//                                 };
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (mobile)
    {
        [parameters setObject:mobile forKey:kPhone_KEY];
    }
    if (countryCode)
    {
        [parameters setObject:countryCode forKey:kCOUNTRYCODE_KEY];
    }
    if (type)
    {
        [parameters setObject:type forKey:@"type"];
    }
    [self getRequest:kUSER_VERIFYCODE_URL parameters:parameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];

}
//v2.0.0获取手机验证码
-(void)getSendVerifyCodeMobileVTWO:(NSString *)mobile countryCode:(NSString *)countryCode type:(NSInteger)type success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary *dict = @{
                                 @"type":@(type)
                                 };
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dict];
    if (mobile)
    {
        [parameters setObject:mobile forKey:kPhone_KEY];
    }
    if (countryCode)
    {
        [parameters setObject:countryCode forKey:kCOUNTRYCODE_KEY];
    }
    [self getRequest:kUSER_VERIFYCODE_URL parameters:parameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
    
}

//1.2验证手机验证码
- (void)checkVerifyCodephone:(NSString *)phone verificationCode:(NSString *)code countryCode:(NSString *)countryCode type:(NSString *)type success:(CompleteBlock)success failure:(ErrorBlock)failure{
//    NSDictionary *parameters = @{
//                                 kPhone_KEY:phone,
//                                 kVERIFY_CODE_KEY:code,
//                                 kCOUNTRYCODE_KEY:countryCode,
//                                 @"type":type
//                                 };
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (phone)
    {
        [parameters setObject:phone forKey:kPhone_KEY];
    }
    if (countryCode)
    {
        [parameters setObject:countryCode forKey:kCOUNTRYCODE_KEY];
    }
    if (code)
    {
        [parameters setObject:code forKey:kVERIFY_CODE_KEY];
    }
    if (type)
    {
        [parameters setObject:type forKey:@"type"];
    }

    [self getRequest:kUSER_CHECKVERIFYCODE_URL parameters:parameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
//v2.0.0验证手机验证码
- (void)checkVerifyCodephoneVTWO:(NSString *)phone verificationCode:(NSString *)code countryCode:(NSString *)countryCode type:(NSInteger )type success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary *dict = @{
                         @"type":@(type)
                         };
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dict];
    if (phone)
    {
        [parameters setObject:phone forKey:kPhone_KEY];
    }
    if (countryCode)
    {
        [parameters setObject:countryCode forKey:kCOUNTRYCODE_KEY];
    }
    if (code)
    {
        [parameters setObject:code forKey:kVERIFY_CODE_KEY];
    }
    
    [self getRequest:kUSER_CHECKVERIFYCODE_URL parameters:parameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


//2.注册
- (void)getRegisterWithUserName:(NSString *)userName password:(NSString *)password countryCode:(NSString *)countryCode name:(NSString *)name verifyCode:(NSString*)verifyCode invitationCode:(NSString *)invitationCode success:(CompleteBlock)success failure:(ErrorBlock)failure{
    
    NSDictionary *parameters = @{
                                 kUSERNAME_KEY:userName,
                                 kPASSWORD_KEY:password,
                                 kVERIFY_CODE_KEY:verifyCode,
                                 kInvitationCode_KEY:invitationCode,
                                 kCOUNTRYCODE_KEY:countryCode,
                                 @"nickname":name,
                                 kROLETYPE_KEY:@([WYUserDefaultManager getUserTargetRoleType]),
                                 @"v":@"2.0"
                                 };
    NSMutableDictionary *mParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if (invitationCode)
    {
        [mParameters setValue:invitationCode forKey:kInvitationCode_KEY];
    }
    [self postRequest:kUSER_REGISTER_URL parameters:mParameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
}



//3.1登录 用户名密码方式
- (void)getLoginWithUserName:(NSString *)userName password:(NSString *)password countryCode:(NSString *)countryCode success:(CompleteBlock)success failure:(ErrorBlock)failure{
    
    
    NSDictionary *dict = @{kUSERNAME_KEY:userName,
                                 kPASSWORD_KEY:password,
                                 kCOUNTRYCODE_KEY:countryCode,
//                                 kClientId_KEY:[UserInfoUDManager getClientId],
                                 kROLETYPE_KEY:@([WYUserDefaultManager getUserTargetRoleType])
                                 };
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dict];
    if ([UserInfoUDManager getClientId])
    {
        [parameters setObject:[UserInfoUDManager getClientId] forKey:kClientId_KEY];
    }
    [self postRequest:kUSER_LOGIN_URL parameters:parameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
    
}

//3.2登录 手机号快捷登录
- (void)getFastLoginWithMobile:(NSString *)mobile verificationCode:(NSString *)verifyCode countryCode:(NSString *)countryCode success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *dict = @{
                                 kUSERNAME_KEY:mobile,
                                 kVERIFY_CODE_KEY:verifyCode,
                                 @"type":@"3",
                                 kCOUNTRYCODE_KEY:countryCode,
//                                 kClientId_KEY:[UserInfoUDManager getClientId],
                                 kROLETYPE_KEY:@([WYUserDefaultManager getUserTargetRoleType])
                                 };
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dict];
    if ([UserInfoUDManager getClientId])
    {
        [parameters setObject:[UserInfoUDManager getClientId] forKey:kClientId_KEY];
    }
    [self postRequest:kFASTUSER_LOGIN_URL parameters:parameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
//3.3.1登录 微信快捷登录
- (void)geWXLoginWithCODE:(NSString *)code success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *dict = @{
                                 @"CODE":code,
//                                 kClientId_KEY:[UserInfoUDManager getClientId],
                                 kROLETYPE_KEY:@([WYUserDefaultManager getUserTargetRoleType])
                                 };
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dict];
    if ([UserInfoUDManager getClientId])
    {
        [parameters setObject:[UserInfoUDManager getClientId] forKey:kClientId_KEY];
    }
    [self postRequest:kWXUSER_LOGIN_URL parameters:parameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


//3.3.2微信绑定手机号
-(void)bindWXWithMobile:(NSString *)mobile password:(NSString *)password countryCode:(NSString *)countryCode name:(NSString *)name verifyCode:(NSString *)verifyCode invitationCode:(NSString *)invitationCode unionidUUID:(NSString *)unionidUUID success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{
                                 kUSERNAME_KEY:mobile,
                                 kPASSWORD_KEY:password,
                                 kVERIFY_CODE_KEY:verifyCode,
                                 kInvitationCode_KEY:invitationCode,
                                 kCOUNTRYCODE_KEY:countryCode,
                                 @"nickname":name,
                                 @"unionidUUID":unionidUUID,
                                 @"v":@"2.0",
                                 kROLETYPE_KEY:@([WYUserDefaultManager getUserTargetRoleType]),
                                 };
    NSMutableDictionary *mParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if (invitationCode)
    {
        [mParameters setValue:invitationCode forKey:kInvitationCode_KEY];
    }
    [self postRequest:kUSER_BIND_URL parameters:mParameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
}


//4.忘记密码
-(void)resetPasswordWithMobile:(NSString *)mobile code:(NSString *)code newPwd:(NSString *)newPwd countryCode:(NSString *)countryCode success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{
                                 kUSERNAME_KEY:mobile,
                                 kCOUNTRYCODE_KEY:countryCode,
                                 @"verificationCode":code,
                                 @"newPwd":newPwd
                                 };
    [self postRequest:kUSER_UPDATE_URL parameters:parameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//4.手机设置密码
-(void)phoneSetPasswordWithMobile:(NSString *)mobile pwd:(NSString *)pwd success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{kUSERNAME_KEY:mobile, @"pwd":pwd};
    [self postRequest:kUSER_SETPWD_URL parameters:parameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//修改密码
-(void)changePasswordWithOldpswd:(NSString *)oldpwd newPwd:(NSString *)newPwd success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{@"oldPwd":oldpwd, @"newPwd":newPwd};
    [self postRequest:kUSER_UPDATEPSWD_URL parameters:parameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//5.获取用户信息
- (void)getMyInfomationWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary *parameters = @{@"v":@"2.0"};
    [self getRequest:kUSER_MYUSERINFO_URL parameters:parameters success:^(id data) {
        
        NSError *__autoreleasing *error = nil;
        UserModel *model = [MTLJSONAdapter modelOfClass:[UserModel class] fromJSONDictionary:data error:error];
        if (error)
        {
            if (failure) failure(*error);
        }
        else
        {
            if (success) {
                success(model);
            }
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
}

//修改昵称
-(void)editNicknameWith:(NSString *)nickname success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{@"newNickname":nickname};
    [self postRequest:kNICK_UPDATE_URL parameters:parameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//保存头像
- (void)updateHeadIcon:(NSString *)headIconNewUrl success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{@"headIconNewUrl":headIconNewUrl};
    [self postRequest:kHEADICON_UPDATE_URL parameters:parameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
//用户登出
-(void)UserLoginOutWithClientId:(NSString *)clientId success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (clientId){
        [parameters setObject:clientId forKey:kClientId_KEY];
    }
    [self postRequest:kUSER_LOGOUT_URL parameters:parameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


//4.找回密码并修改/ 没有token设计

- (void)getRetrieveChangePasswordWithMobile:(NSString *)mobile password:(NSString *)password verifyCode:(NSString *)verifyCode success:(CompleteBlock)success failure:(ErrorBlock)failure {
    
    NSDictionary *parameters = @{kUSERNAME_KEY:mobile, kPASSWORD_KEY:password, kVERIFY_CODE_KEY:verifyCode};
    
    [self postRequest:kUSER_UPDATE_URL  parameters:parameters success:^(id data) {
        if (success) {
//            NSError *__autoreleasing *error = nil;
//            UserModel *user = [MTLJSONAdapter modelOfClass:[UserModel class] fromJSONDictionary:data error:error];
//            success(user);
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
}

//5.找回密码并修改／有token设计
- (void)getRetrieveChangePassword:(NSString *)password success:(CompleteBlock)success failure:(ErrorBlock)failure {
    
//        NSDictionary *parameters = @{TOKEN_KEY:USER_TOKEN, kPASSWORD_KEY:password};
//        [self postRequest:KUSER_FIND_CHANGE_PWD_URL parameters:parameters success:^(id data) {
//            if (success != nil) {
//                success(data);
//            }
//        } failure:^(NSError *error) {
//            if (failure)
//            {
//                failure(error);
//            }
//        }];
}

- (void)getChangePassword:(NSString *)password1 password2:(NSString *)password2 success:(CompleteBlock)success failure:(ErrorBlock)failure {
    
    //    NSDictionary *parameters = @{TOKEN_KEY:USER_TOKEN, kPASSWORD_KEY:password1, @"npwd":password2};
    //    [self postRequest:KUSER_CHANGE_PWD_URL parameters:parameters success:^(id data) {
    //        if (success != nil) {
    //            success(data);
    //        }
    //    } failure:errorBlock];
}



- (void)getCheckTokenWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure {
    //    NSDictionary *parameters = @{TOKEN_KEY:USER_TOKEN};
    //    [self postRequest:KUSER_CHECK_TOKEN_URL parameters:parameters success:^(id data) {
    //        if (complete != nil) {
    //            complete(data);
    //        }
    //    } failure:errorBlock];
}








//9.上传头像
- (void)uploadAvatar:(NSData *)dataAvatar success:(CompleteBlock)success failure:(ErrorBlock)failure {
    if (dataAvatar == nil)
        return;
//        NSDictionary *parameters = @{TOKEN_KEY:USER_TOKEN};
//        NSMutableArray *fileDataArray = [NSMutableArray arrayWithCapacity:1];
//        [fileDataArray addObject:dataAvatar];
//        [self uploadFiles:KUSER_UPLOAD_URL parameters:parameters fileDataArray:fileDataArray success:^(id data) {
//            if (success != nil) {
//                success(data);
//            }
    //        } failure:^(NSError *error) {
//    if (failure)
//    {
//        failure(error);
//    }
//}];
}

//10.上传第三发平台（阿里云／七牛）头像url地址到公司服务器

- (void)uploadThirdAvatar:(NSString *)urlString success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary *parameters = @{@"image":urlString};
    
    [self postRequest:kUSER_UPDATE_USER_INFO_URL parameters:parameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];

}

//11.获取七牛云的token
- (void)getQiniuTokenWithUserId:(NSString *)userId success:(CompleteBlock)success failure:(ErrorBlock)failure
{
//    NSDictionary *parameters = @{kHTTP_USERID_KEY:userId};
    
//    [self postRequest:kUSER_QINIU_TOKEN_URL parameters:parameters success:^(id data) {
//        if (success) {
//            success(data);
//        }
//    }
//    failure:^(NSError *error) {
//        if (failure)
//        {
//            failure(error);
//        }
//
//    }];

}

//12.保存（提交更改）用户信息
//- (void)saveInfo:(UserModel *)user success:(CompleteBlock)success failure:(ErrorBlock)failure {
//    
//    NSDictionary *parameters = @{
//                                 @"usersignature":user.userName?user.userName:@"1",
//                                 @"pro":user.province?user.province:@"",
//                                 @"sex":user.sex?user.sex:@(0),
//                                 @"city":user.city?user.city:@"",
//                                 @"autograph":user.autograph?user.autograph:@""
//                                 };
//    
//    
//    [self postRequest:kUSER_UPDATE_USER_INFO_URL parameters:parameters success:^(id data) {
//        if (success) {
//            success(data);
//        }
//    } failure:^(NSError *error) {
//        if (failure)
//        {
//            failure(error);
//        }
//    }];

//}



- (void)getMyCenterInfoWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure
{
    
}



/*************************测试接口***************************************************/

- (void)success:(CompleteBlock)success failure:(ErrorBlock)failure {
    
    NSDictionary *parameters = @{kHTTP_USERID_KEY:@"你好",
                                 @"username":@"",
                                 @"pro":@(0),
                                 @"DSS":@"DKHDFJKHFJD"
                                 };
    
    
    NSLog(@"%@",parameters);
    
    [self postRequest:@"photo/user/saveUserInfo.do" parameters:parameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
    
}

//修改
- (void)getStudioPhotosInfo:(NSDictionary *)dic success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSMutableDictionary * parameter = [[NSMutableDictionary alloc] init];
    NSDictionary * Dic = @{};
    [parameter addEntriesFromDictionary:Dic];
    [parameter addEntriesFromDictionary:dic];
    
//    [self postRequest:kSTUDIO_MY_STUDIOLIST_URL parameters:parameter success:^(id data) {
//        if (complete) {
//            NSError *__autoreleasing *error = nil;
//            UserModel *user = [MTLJSONAdapter modelOfClass:[UserModel class] fromJSONDictionary:data error:error];
//            complete(user);
//        }
    //    } failure:^(NSError *error) {
//    if (errorBlock)
//    {
//        errorBlock(error);
//    }
//}];

}


//问题反馈
- (void)uploadProblemWithContent:(NSString *)content  success:(CompleteBlock)success failure:(ErrorBlock)failure
{
//    NSDictionary * parameters = @{
//                                  @"content":content?content:@""
//                                  };
    
//    [self postRequest:kSETUP_UPDATETEXT_URL parameters:parameters success:^(id data) {
//        if (complete) {
//            complete(data);
//        }
//    } failure:errorBlock];
}

//关于我们
- (void)getThisAppInformationWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure
{
}






#pragma mark - 2.0版本

//100019_获取用户个人资料接口
//-(void)getUserPersonalDataWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure{
//    NSDictionary *parameters = @{};
//    [self getRequest:kUSER_getUserPersonalData_URL parameters:parameters success:^(id data) {
//        if (success) {
//            NSError *__autoreleasing *error = nil;
//            UserModel *user = [MTLJSONAdapter modelOfClass:[UserModel class] fromJSONDictionary:data error:error];
//            success(user);
//            
//        }
//    } failure:^(NSError *error) {
//        if (failure)
//        {
//            failure(error);
//        }
//    }];
//}


-(void)getCountryCodesWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{};
    [self getRequest:kBase_GetCountryCodes_URL parameters:parameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
}



-(void)postAppBindWechatWithCode:(NSString *)code Success:(CompleteBlock)success failure:(ErrorBlock)failure{
        NSDictionary *parameters = @{
                                     @"CODE":code,
                                     kROLETYPE_KEY:@([WYUserDefaultManager getUserTargetRoleType])
                                     };
        NSMutableDictionary *mParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
        [self postRequest:kUSER_postAppBindWechat_URL parameters:mParameters success:^(id data) {
            if (success) {
                success(data);
            }
        } failure:^(NSError *error) {
            if (failure)
            {
                failure(error);
            }
        }];
    
}


-(void)postAppUnbindWechatWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{};
    NSMutableDictionary *mParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [self postRequest:kUSER_postAppUnbindWechat_URL parameters:mParameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
}



- (void)postChangeUserRoleWithClientId:(NSString *)clientId source:(WYTargetRoleSource)source targetRole:(WYTargetRoleType)targetRole success:(nullable CompleteBlock)success failure:(nullable ErrorBlock)failure
{
    NSDictionary * dic = @{
                           @"source":@(source),
                           kTargetRole_KEY:@(targetRole),
                           @"type":@"0",
                           @"systemVersion":[[UIDevice currentDevice] systemVersion],
                           @"appVersion":APP_Version,
                           @"mobileBrand":[UIDevice zx_getDeviceName]};
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dic];
    [parameters setObject:clientId?clientId:@"" forKey:kClientId_KEY];
    [self postRequest:kUser_changeUserRole parameters:parameters success:^(id data) {
        
        if (success) {
            
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];

}


- (void)updateSex:(NSString *)sex success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary * dic = @{@"sex":sex};
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dic];
    [self postRequest:kSEX_UPDATE_URL parameters:parameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];

}


//更换手机号第二步
- (void)postupdateUserPhone:(NSString *)newPhone countryCode:(NSString *)countryCode verificationCode:(NSString *)verificationCode success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary * dic = @{
                           @"countryCode":countryCode,
                           @"newPhone":newPhone,
                           @"verificationCode":verificationCode
                           };
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dic];
    [self postRequest:kUSER_postupdateUserPhone_URL parameters:parameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
}




// 100023_第一步更换手机号时获取验证码
- (void)getVeriCodeByUpdateOldPhone:(NSString *)phone countryCode:(NSString *)countryCode success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary * dic = @{
                           @"countryCode":countryCode,
                           @"phone":phone
                           };
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dic];
    [self getRequest:kUSER_getVeriCodeByUpdatePhone_URL parameters:parameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
}


// 100024_第一步更换手机号时校验验证码
- (void)checkVeriCodeByUpdateOldPhone:(NSString *)phone countryCode:(NSString *)countryCode verificationCode:(NSString *)verificationCode success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary * dic = @{
                           @"countryCode":countryCode,
                           @"phone":phone,
                           @"verificationCode":verificationCode
                           };
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dic];
    [self getRequest:kUSER_checkVeriCodeByUpdatePhone_URL parameters:parameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
    
}


// 100025_app获取用户市场认证情况
- (void)getMarketQualiInfoWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary * dic = @{};
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dic];
    [self getRequest:kUSER_GetMarketQualiInfo_URL   parameters:parameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
}
@end
