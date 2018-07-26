//
//  UserModel.h
//  
//
//  Created by simon on 15/6/25.
//  Copyright (c) 2015年 sina. All rights reserved.
//

#import "BaseModel.h"
@interface UserModel : BaseModel

/**
 *  用户ID
 */
@property(nonatomic,strong) NSNumber * userId;
/**
 *  昵称
 */
@property(nonatomic, copy) NSString *username;
/**
 *  头像url
 */
@property(nonatomic, copy) NSString *headURL;
/**
 手机号
 */
@property(nonatomic, copy) NSString *phone;

/**
 是否绑定微信 1是0否
 */
@property(nonatomic, strong)  NSNumber *bindWechat;
/**
 是否设置密码 1是0否
 */
@property(nonatomic, strong)  NSNumber *needSetPwd;

/**
 实体认证状态 0-未认证 1-认证通过
 */
@property(nonatomic, strong) NSNumber *authStatus;


/**
 *  性别
 */
@property(nonatomic, strong) NSNumber *sex;

//
///**
// *  令牌
// */
//@property(nonatomic, copy) NSString *token;
//



///**
// *  地区
// */
//@property(nonatomic, copy) NSString *address;

/**
 *  省份
 */
@property(nonatomic,copy)NSString *province;

/**
 *  城市
 */
@property(nonatomic,copy)NSString *city;

///**
// *  生日
// */
//@property(nonatomic, copy) NSString *birthday;
//
///**
// *  邮箱
// */
//@property(nonatomic, copy) NSString *email;
//
///**
// *  QQ
// */
//@property(nonatomic, copy) NSString *qq;

/**
 *  签名
 */
@property(nonatomic, copy) NSString *autograph;

/**
 * 身高(cm)
 */

@property(nonatomic,strong)NSNumber * height;
/**
 * 城市编码
 */
@property(nonatomic,copy)NSString *cityCode;

/**
 * 省份编码
 */
@property(nonatomic,copy)NSString *provinceCode;

/**
 * 行业@
 */
@property(nonatomic,strong)NSNumber *vocation;

/**
 * 公司名称
 */
@property(nonatomic,copy)NSString *corpName;
/**
 * 学校
 */
@property(nonatomic,copy)NSString *school;
///**
// * @brief 获取按照性别得到image
// */
//- (UIImage *)getSexImageWithBoyImageName:(NSString *)boyImageName girlImageName:(NSString *)girlImageName defaultSexImgName:(NSString *)defultName;
//

//微信是否需要绑定手机号
@property(nonatomic, strong)NSNumber *isNeedBindPhone;

//客服qq
@property(nonatomic, copy)NSString *QQ;

@end




