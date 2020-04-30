//
//  HomeModel.h
//  MobileCaiLocal
//
//  Created by 朱新明 on 2019/10/31.
//  Copyright © 2019 timtian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HomeModel : NSObject

@end


@interface HomePrefectureModel : BaseModel

@property (nonatomic, strong) NSNumber *templateTypeCode;

@property (nonatomic, copy) NSString *specialAreaName;

@property (nonatomic, copy) NSArray *banners;

@end


@interface HomePrefectureModelSubBanner: BaseModel

@property (nonatomic, strong) NSNumber *bannerId;

@property (nonatomic, copy) NSString *backgroundPhoto;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *nameColor;
@property (nonatomic, copy) NSString *descriptionText;
@property (nonatomic, copy) NSString *descriptionColor;
@property (nonatomic, copy) NSString *preIcon;
@property (nonatomic, copy) NSString *suffIcon;

@property (nonatomic, copy) NSString *appUrl;
@property (nonatomic, copy) NSString *htmlUrl;

@property (nonatomic, strong) NSNumber *displayType;

@property (nonatomic, copy) NSArray *goodsList;

@end

@interface HomePrefectureModelSubBannerSub: BaseModel

@property (nonatomic, copy) NSString *photo;

@property (nonatomic, copy) NSString *salePrice;

@property (nonatomic, copy) NSString *referencePrice;

@end
NS_ASSUME_NONNULL_END
