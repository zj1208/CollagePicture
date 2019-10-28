//
//  SearchTitleModel.h
//  CollagePicture
//
//  Created by 朱新明 on 2019/10/24.
//  Copyright © 2019 simon. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SearchTitleModel : BaseModel

@property (nonatomic, strong) NSNumber *groupCode;

@property (nonatomic, copy) NSString *groupName;

@property (nonatomic, copy) NSString *groupType;

@property (nonatomic, assign) BOOL ifPaging;

@property (nonatomic, copy) NSArray *worlds;

@end

@interface SearchTitleModelSub : BaseModel
@property (nonatomic, strong) NSNumber *code;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *preIcon;
@property (nonatomic, copy) NSString *suffIcon;
@property (nonatomic, copy) NSString *bgColor;
@property (nonatomic, copy) NSString *labelColor;
//APP 跳转地址（该字段不为空或空字符串，则表示活动跳转，跳转规则同 APP Banner 跳转）
@property (nonatomic, copy) NSString *appUrl;
//H5 跳转地址（该字段不为空或空字符串，则表示活动跳转，跳转规则同 H5 Banner 跳转）
@property (nonatomic, copy) NSString *httpUrl;
@end

NS_ASSUME_NONNULL_END
