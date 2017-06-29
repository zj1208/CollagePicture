//
//  GrowthDataManager.m
//  Baby
//
//  Created by simon on 16/4/27.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "GrowthDataManager.h"

@implementation GrowthDataManager
+ (instancetype)getInstance
{
    static GrowthDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[GrowthDataManager alloc] init];
        
    });
    return manager;
}

+ (NSString *)getSDImageCacheSmallImgKey:(NSNumber *)albumId sortId:(NSNumber *)sortId
{
    if (!albumId ||!sortId)
    {
        return nil;
    }
    return [NSString stringWithFormat:@"Growth_small_%@_uploadId%@_sortId%@",
            [UserInfoUDManager getUserId],albumId,sortId];

}

+ (NSString *)getPhotoImageKey:(NSNumber *)albumId sortId:(NSNumber *)sortId
{
    if (!albumId ||!sortId)
    {
        return nil;
    }
    return [NSString stringWithFormat:@"Growth_%@_uploadId%@_sortId%@",
            [UserInfoUDManager getUserId],albumId,sortId];
}


- (NSString *)getKey:(NSNumber *)albumId
{
    if (!albumId)
    {
        return nil;
    }
    return [NSString stringWithFormat:@"Growth_%@_uploadId%@",[UserInfoUDManager getUserId],albumId];
}



- (id)getData:(NSNumber *)albumId
{
    return [[TMDiskCache sharedCache]objectForKey:[self getKey:albumId]];
}



-(BOOL)isCreatTableWithAlbumId:(NSNumber *)albumId
{
    
    //    NSLog(@"%@",self.dbPath);
    if ([[TMDiskCache sharedCache]objectForKey:[self getKey:albumId]])
    {
        return YES;
    }
    return NO;
}


- (void)insertData:(NSArray*)data withAlbumId:(NSNumber *)albumId;
{
//    NSLog(@"%@",NSHomeDirectory());
//    NSLog(@"%@",data);
    NSString *key = [self getKey:albumId];
    
    [[TMDiskCache sharedCache]setObject:data forKey:key];
}


- (void)removePhotoModel:(GrowthSavePhotoModel*)model withAlbumId:(NSNumber *)albumId
{
    if (!model ||!albumId)
    {
        return;
    }
    NSString *key = [self getKey:albumId];
    id value = [[TMDiskCache sharedCache]objectForKey:key];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:value];
    if (array.count==1)
    {
        [[TMDiskCache sharedCache]removeObjectForKey:key];
    }
    else
    {
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            GrowthSavePhotoModel *mod = (GrowthSavePhotoModel *)obj;
            if ([mod.sort integerValue]==[model.sort integerValue])
            {
                [array removeObject:mod];
                [[TMDiskCache sharedCache]removeObjectForKey:key];
                [[TMDiskCache sharedCache]setObject:array forKey:key];
                *stop = YES;
            }
        }];
        
    }
    
}

- (void)removeAlbumWithAlbumId:(NSNumber *)albumId
{
    NSString *key = [self getKey:albumId];
    
    if ([[TMDiskCache sharedCache]objectForKey:key])
    {
        [[TMDiskCache sharedCache]removeObjectForKey:key];
    }
}

@end
