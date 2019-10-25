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

@property (nonatomic, copy) NSString *groupCode;

@property (nonatomic, copy) NSString *groupName;

@property (nonatomic, copy) NSString *groupType;

@property (nonatomic, assign) BOOL pageEnable;

@property (nonatomic, copy) NSArray *worlds;

@end

@interface SearchTitleModelSub : BaseModel
@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *preIcon;
@property (nonatomic, copy) NSString *suffIcon;
@property (nonatomic, copy) NSString *bgColor;
@property (nonatomic, copy) NSString *labelColor;
@property (nonatomic, copy) NSString *activityId;
@property (nonatomic, copy) NSString *linkUrl;
@end

NS_ASSUME_NONNULL_END
