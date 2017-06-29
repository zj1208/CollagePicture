//
//  GrowthDataManager.h
//  Baby
//
//  Created by simon on 16/4/27.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UploadOperationModel.h"
#import "UserInfoUDManager.h"
@interface GrowthDataManager : NSObject

+(instancetype)getInstance;

/**
 *  用于显示用的本地小图
 *
 *  @param albumId albumId description
 *  @param sortId  sortId description
 *
 *  @return 返回 SDImageCache中的key
 */
+ (NSString *)getSDImageCacheSmallImgKey:(NSNumber *)albumId sortId:(NSNumber *)sortId;


//获取和设置 SDImageCache中的key
+ (NSString *)getPhotoImageKey:(NSNumber *)albumId sortId:(NSNumber *)sortId;


- (NSString *)getKey:(NSNumber *)albumId;
/**
 *  获取相册数组
 *
 *  @param albumId albumId description
 *
 *  @return return value description
 */
- (id)getData:(NSNumber *)albumId;
/**
 *  判断是否有这个相册表
 *
 *  @param albumId albumId description
 *
 *  @return return value description
 */
-(BOOL)isCreatTableWithAlbumId:(NSNumber *)albumId;


- (void)insertData:(NSArray*)data withAlbumId:(NSNumber *)albumId;


- (void)removePhotoModel:(GrowthSavePhotoModel*)model withAlbumId:(NSNumber *)albumId;

/**
 *  根据albumId删除相册
 *
 *  @param albumId 集合id
 */
- (void)removeAlbumWithAlbumId:(NSNumber *)albumId;


@end
