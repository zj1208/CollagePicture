//
//  BadgeMarkItemModel.h
//  YiShangbao
//
//  Created by simon on 2018/1/31.
//  Copyright © 2018年 com.Microants. All rights reserved.
//
//  2019.10.26 解除BaseModel绑定，增加Mantle

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN


//标记
typedef NS_ENUM(NSInteger, SideMarkType){
    
    //    无
    SideMarkType_none = 0,
    //    红点
    SideMarkType_redDot = 1,
    //    数字
    SideMarkType_number = 2,
    //    图片
    SideMarkType_image = 3,
    
};
@interface BadgeMarkItemModel : MTLModel<MTLJSONSerializing>

// 图片地址
@property (nonatomic, copy) NSString *icon;

// 模块名称，标题展示
@property (nonatomic, copy) NSString *desc;

// 角标类型0-无，1-红点，2-数字，3-图片
@property (nonatomic, assign) SideMarkType sideMarkType;

// 当sideMarkType为数字或者图片的时候读取
@property (nonatomic, copy) NSString *sideMarkValue;

// 是否展示底部角标：展示“V”，标识该服务用户已订购
@property (nonatomic, assign) BOOL vbrands;


@end

NS_ASSUME_NONNULL_END
