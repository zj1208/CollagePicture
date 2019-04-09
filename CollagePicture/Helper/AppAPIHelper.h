//
//  AppAPIHelper.h
//  SiChunTang
//
//  Created by simon on 15/6/7.
//  Copyright (c) 2015年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModelAPI.h"
//#import "StudioModelAPI.h"
//#import "MakeAlbumModelAPI.h"
//#import "OderModelAPI.h"
//#import "MessageModelAPI.h"

//#import "GrowthModelAPI.h"
//#import "ThemeModelAPI.h"

@interface AppAPIHelper : NSObject

@property (nonatomic, strong) UserModelAPI *userModelAPI;
//
//@property (nonatomic, strong) StudioModelAPI *studioModelAPI;
//
//@property (nonatomic, strong) OderModelAPI * oderModelAPI;
//
//@property (nonatomic, strong) MakeAlbumModelAPI *makeAlbumModelAPI;
//
//@property (nonatomic, strong) MessageModelAPI * messageModelAPI;

//@property (nonatomic, strong) GrowthModelAPI * growthModelAPI;
//@property (nonatomic,strong) ThemeModelAPI *themeModelAPI;


+ (instancetype)shareInstance;

- (UserModelAPI *)getUserModelAPI;
//
//- (StudioModelAPI *)getStudioModelAPI;
//
//- (OderModelAPI *)getoderModelAPI;
//
//- (MakeAlbumModelAPI *)getMakeAlbumModelAPI;
//
//- (MessageModelAPI *)getMessageModelAPI;

//- (GrowthModelAPI *)getGrowthModelAPI;
//
//- (ThemeModelAPI *)getThemeModelAPI;
@end
